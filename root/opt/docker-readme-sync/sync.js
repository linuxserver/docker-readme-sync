var https = require('https');


var get_github_readme = function(repo, branch, callback) {
	var repo_parts = repo.split('/');

	var readme;
	var url = 'https://raw.githubusercontent.com/' + repo_parts[0] + '/' + repo_parts[1] + '/' + branch + '/README.md'
	var request = https.get(url, function(response) {
	    response.on('data', function(chunk) {
	        readme += chunk;
	    });
	    response.on('end', function() {
	    	callback(readme);
	    });
	});
};


var get_dockerhub_readme = function (repo, callback) {
	const dockerHubAPI = require('docker-hub-api');

	var repo_parts = repo.split('/');

	var repo = dockerHubAPI.repository(repo_parts[0], repo_parts[1]).then(function(info) {
		callback(info['full_description']);
	});
};

var update_dockerhub_readme = function(user, pass, repo, full_desc, callback) {
	const dockerHubAPI = require('docker-hub-api');

	
	var repo_parts = repo.split('/');

	dockerHubAPI.login(user, pass).then(function(info) {
		var descriptions = {
		    full: full_desc
		};
		
		dockerHubAPI.setRepositoryDescription(repo_parts[0], repo_parts[1], descriptions);

		callback();
	});
};

function run() {
	const fs = require('fs')

	var dockerhub_username = process.env.DOCKERHUB_USERNAME
	var dockerhub_password = process.env.DOCKERHUB_PASSWORD

	var github_repo = process.env.GIT_REPOSITORY;
	var dockerhub_repo = process.env.DOCKER_REPOSITORY;

	var branch = typeof process.env.GIT_BRANCH !== 'undefined' ?  process.env.GIT_BRANCH  : 'master';

	// Get github readme
	console.log('Getting github readme for ' + github_repo);
	get_github_readme(github_repo, branch, function(github_readme) {

		// Get dockerhub full description
		console.log('Getting dockerhub full description for ' + dockerhub_repo);
		get_dockerhub_readme(dockerhub_repo, function(dockerhub_readme) {
			
			// determine if /mnt/README.lite exists
			var readme_lite_file = '/mnt/README.lite'
			var readme_lite_exists = false
			try {
				if (fs.existsSync(readme_lite_file)) {
				  readme_lite_exists = true
				}
			} catch(err) {
				console.log(err)
			}
			console.log(`File ${readme_lite_file} exists?: ${readme_lite_exists}.`)

			// if README.lite exists and github readme is too large, then use README.lite contents
			if (readme_lite_exists == true && github_readme.length > 25000) {
				console.log(`Github readme length is larger than 25000, README.lite found, using README.lite`)
				github_readme = fs.readFileSync(readme_lite_file).toString()
			}

			var skip_replace =  /^true$/i.test(process.env.SKIP_REPLACE);
			if (skip_replace == undefined) {
				skip_replace = false;
			}

			if (skip_replace == false) {
				// replace <,> with nothing
				github_readme = github_readme.replace(/<(.+?)>/g, "$1");
			}

			console.log(`Github readme length: ${github_readme.length}.`)
			console.log(`Dockerhub readme length: ${dockerhub_readme.length}.`)

			if (readme_lite_exists == false && github_readme.length > 25000) {
				throw new Error(`Github readme is longer than 25,000 characters (length ${github_readme.length}).`)
			}

			// If they dont match, update it, else, just notify console it's doing nothing.
			if (github_readme != dockerhub_readme) {
				console.log('Github readme and dockerhub full description do not match, updating...')
				update_dockerhub_readme(dockerhub_username, dockerhub_password, dockerhub_repo, github_readme, function() {
					console.log('Dockerhub updated.');					
				});
			} else {
				console.log('Github readme and dockerhub full description match.')
			};
		});
	});
};

run();

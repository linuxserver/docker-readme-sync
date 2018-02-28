
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

var update_dockerhob_readme = function(user, pass, repo, full_desc, callback) {
	const dockerHubAPI = require('docker-hub-api');

	var repo_parts = repo.split('/');

	dockerHubAPI.login(user, pass).then(function(info) {
		const descriptions = {
		    full: full_desc
		};

		dockerHubAPI.setRepositoryDescription(repo_parts[0], repo_parts[1], descriptions);

		callback();
	});
};

function run() {
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
			
			// If they dont match, update it, else, just notify console it's doing nothing.
			if (github_readme != dockerhub_readme) {
				console.log('Github readme and dockerhub full description do not match, updating...')
				update_dockerhob_readme(dockerhub_username, dockerhub_password, dockerhub_repo, github_readme, function() {
					console.log('Dockerhub updated.');					
				});
			} else {
				console.log('Github readme and dockerhub full description match.')
			};
		});
	});
};

run();

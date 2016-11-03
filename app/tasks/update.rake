require "./app"

desc "Updata a Dockerhub repo's full descrption"
task :update, [:github_repo, :dockerhub_repo] do |t, args|
  unless ENV["GIT_REPOSITORY"].nil? || ENV["GIT_REPOSITORY"].empty?
    github_repo = ENV["GIT_REPOSITORY"]
  end

  unless ENV["DOCKER_REPOSITORY"].nil? || ENV["DOCKER_REPOSITORY"].empty?
    dockerhub_repo = ENV["DOCKER_REPOSITORY"]
  end

  gh = Github.new
  unless gh.repo_exists?(github_repo)
    puts "Github Repo Not Found"
    exit 1
  end

  unless gh.readme_exists(github_repo)
    puts "Github README.md Not Found"
    exit 1
  end

  dh = Dockerhub.new
  unless dh.repo_exists?(dockerhub_repo)
    puts "Dockerhub Repo Not Found"
    exit 1
  end

  # This version is for the nodejs install of phantomjs, which seems to keep
  # phantomjs alive?
  cmd = "rake phantomjs_shell[#{github_repo},#{dockerhub_repo}]  2>&1"
  output = `#{cmd}`
  
  if output.include?("Login Failed")
    puts "Dockerhub login failed."
    exit 1
  elsif output.include?("Dockerhub update successful.")
    puts "OK"
  else
    puts "Dockerhub update failed. Command output:\n\n#{output}"
    exit 1
  end
end

require "./app"

desc "PhantomJS shell to update a Dockerhub repo description. Don't use this. Instead call update, as it does validation."
task :phantomjs_shell, [:github_repo, :dockerhub_repo, :github_branch] do |t, args|

  github_repo = args[:github_repo]
  dockerhub_repo = args[:dockerhub_repo]
  github_branch = args[:github_branch]

  SyncService.update(github_repo, dockerhub_repo, github_branch)
end

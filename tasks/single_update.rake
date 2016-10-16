require "./app"

desc "Updata a Dockerhub repo's full descrption"
task :update, [:github_repo, :dockerhub_repo] do |t, args|

  github_repo = args[:github_repo]
  dockerhub_repo = args[:dockerhub_repo]

  SyncService.update(github_repo, dockerhub_repo)
end

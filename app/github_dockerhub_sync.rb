require 'sinatra'

module GithubDockerhubSync

  class App < Sinatra::Base
    
    get '/description/update' do
      github_repo = params[:github_repo]
      dockerhub_repo = params[:dockerhub_repo]

      gh = Github.new
      halt 404, "Github Repo Not Found" unless gh.repo_exists?(github_repo)
      halt 404, "Github README.md Not Found" unless gh.readme_exists(github_repo)

      dh = Dockerhub.new
      halt 404, "Dockerhub Repo Not Found" unless dh.repo_exists?(dockerhub_repo)

      # This version is for the nodejs install of phantomjs, which seems to keep
      # phantomjs alive?
      cmd = "rake update[#{github_repo},#{dockerhub_repo}]  2>&1"
      output = `#{cmd}`

      if output.include?("Login Failed")
        halt 404, 'Dockerhub login failed.'
      elsif output.include?("Dockerhub update successful.")
        body "OK"
      else
        halt 500, "Dockerhub update failed. Command output:\n\n#{output}"
      end

      # This version is for when ubuntu fixes the phantomjs in their repo
      # begin
      #   SyncService.update(params[:github_repo], params[:dockerhub_repo])
      #
      #   body "OK"
      # rescue Exception => e
      #   if e.message.include?("githubusercontent")
      #     halt 404, 'Github repo not found.'
      #   elsif e.message.include?("Unable to find xpath")
      #     halt 404, 'Dockerhub repo not found.'
      #   else
      #     raise e
      #   end
      # end

    end

  end

end

require 'sinatra'

module GithubDockerhubSync

  class App < Sinatra::Base
    
    get '/description/update' do

      # This version is for the nodejs install of phantomjs, which seems to keep
      # phantomjs alive?
      cmd = "rake update[#{params[:github_repo]},#{params[:dockerhub_repo]}]"
      output = `#{cmd}`

      if output.include?("githubusercontent")
         halt 404, 'Github repo not found.'
      elsif output.include?("Unable to find xpath")
        halt 404, 'Dockerhub repo not found.'
      else
        body "OK"
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

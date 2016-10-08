require 'sinatra'

module GithubDockerhubSync

  class App < Sinatra::Base
    
    get '/description/update' do

      begin
        SyncService.update(params[:github_repo], params[:dockerhub_repo])

        body "OK"
      rescue Exception => e
        if e.message.include?("githubusercontent")
          halt 404, 'Github repo not found.'
        elsif e.message.include?("Unable to find xpath")
          halt 404, 'Dockerhub repo not found.'
        else
          raise e
        end


      end
    end

  end

end

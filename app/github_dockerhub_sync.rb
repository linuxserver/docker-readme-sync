require 'sinatra'

module GithubDockerhubSync

  class App < Sinatra::Base

    get '/foo' do
      body({ status: 'success', redirect: "asdf" }.to_json)
    end

    # get '/admin/redirect/:id' do
    #   r = Redirect[params['id']]
    #   halt 404, 'Error: Redirect does not exist.' if r.nil?
    #   body({ status: 'success', redirect: r }.to_json)
    # end

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
          halt 500, e.message, e.backtrace
        end


      end
    end

  end

end

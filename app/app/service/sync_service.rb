require 'yaml'

class SyncService

  def self.update(github_repo, dockerhub_repo, branch = 'master')
    if ENV['USE_ENV_CREDENTIALS'] == "true"
      if ENV['DOCKERHUB_USERNAME'].nil? || ENV['DOCKERHUB_USERNAME'].empty? ||
        ENV['DOCKERHUB_PASSWORD'].nil? || ENV['DOCKERHUB_PASSWORD'].empty?
        raise "USE_ENV_CREDENTIALS is set to true, but DOCKERHUB_USERNAME or DOCKERHUB_PASSWORD was not specified."
      end

      username = ENV['DOCKERHUB_USERNAME']
      password = ENV['DOCKERHUB_PASSWORD']
    else
      config_file = File.expand_path("../../../config", __FILE__) + "/settings.yml"
      settings = YAML.load_file(config_file)

      username = settings["dockerhub"]["email"]
      password = settings["dockerhub"]["password"]
    end

    branch = 'master' if branch.nil? || branch.empty?

    gh = Github.new
    dh = Dockerhub.new(username, password)

    gh_content = nil
    begin
      gh_content = gh.get_raw_readme(github_repo, branch)
    rescue Mechanize::ResponseCodeError => e
      if e.response_code == "404"
        raise "Github Repo Not Found"
      end
    end

    if dh.update_full_desc(dockerhub_repo, gh_content)
      puts "Dockerhub update successful."
    else
      puts "Dockerhub update failed."
    end

  end
end

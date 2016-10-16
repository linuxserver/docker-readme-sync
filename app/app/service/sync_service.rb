require 'yaml'

class SyncService

  def self.update(github_repo, dockerhub_repo)
    config_file = File.expand_path("../../../config", __FILE__) + "/settings.yml"
    settings = YAML.load_file(config_file)

    username = settings["dockerhub"]["email"]
    password = settings["dockerhub"]["password"]

    gh = Github.new
    dh = Dockerhub.new(username, password)

    gh_content = nil
    begin
      gh_content = gh.get_raw_readme(github_repo)
    rescue Mechanize::ResponseCodeError => e
      if e.response_code == "404"
        raise "Github Repo Not FOund"
      end
    end

    if dh.update_full_desc(dockerhub_repo, gh_content)
      puts "Dockerhub update successful."
    else
      puts "Dockerhub update failed."
    end

  end
end

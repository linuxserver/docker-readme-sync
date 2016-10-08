require 'yaml'

class SyncService

  def self.update(github_repo, dockerhub_repo)
    config_file = File.expand_path("../../../config", __FILE__) + "/settings.yml"
    settings = YAML.load_file(config_file)

    username = settings["dockerhub"]["email"]
    password = settings["dockerhub"]["password"]

    gh = Github.new
    dh = Dockerhub.new(username, password)

    gh_content = gh.get_raw_readme(github_repo)

    dh.get_full_desc(dockerhub_repo)

    dh.update_full_desc(dockerhub_repo, gh_content)
  end
end

require 'rubygems'
require 'mechanize'
require 'logger'

class Github

  def get_full_desc(repository)
    mech = Mechanize.new
    page = mech.get("https://github.com/#{repository}")
    page.search('.markdown-body').inner_html
  end

  def readme_exists(repository)
    begin
      mech = Mechanize.new
      mech.get("https://raw.githubusercontent.com/#{repository}/master/README.md")
      return true
    rescue Mechanize::ResponseCodeError => e
      return false if e.response_code == "404"
    end

    return false
  end

  def repo_exists?(repository)
    begin
      mech = Mechanize.new
      mech.get("https://github.com/#{repository}")
      return true
    rescue Mechanize::ResponseCodeError => e
      return false if e.response_code == "404"
    end

    return false
  end

  def get_raw_readme(repository)
    mech = Mechanize.new
    page = mech.get("https://raw.githubusercontent.com/#{repository}/master/README.md")
    page.body
  end

end

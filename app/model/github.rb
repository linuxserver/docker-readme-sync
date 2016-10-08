require 'rubygems'
require 'mechanize'
require 'logger'

class Github

  def get_full_desc(repository)
    mech = Mechanize.new
    page = mech.get("https://github.com/#{repository}")
    page.search('.markdown-body').inner_html
  end

  def get_raw_readme(repository)
    mech = Mechanize.new
    page = mech.get("https://raw.githubusercontent.com/#{repository}/master/README.md")
    page.body
  end

end

require 'rubygems'
require 'mechanize'
require 'logger'
require 'awesome_print'
require 'capybara'
require 'capybara/poltergeist'
require 'capybara/dsl'
require 'escape_utils'

class Dockerhub
  include Capybara::DSL

  def initialize(username = nil, password = nil)
    @username = username
    @password = password
    @logged_in = false
  end

  def repo_exists?(repository)
    begin
      mech = Mechanize.new
      page = mech.get("https://hub.docker.com/r/#{repository}/")
      return page.body.include?("Repo Info")
    rescue Mechanize::ResponseCodeError => e
      return false if e.response_code == "404"
    end

    return false
  end

  def get_full_desc(repository)
    # Login, goto repo page, click edit
    get_edit_mode(repository)
    find(:xpath, '//span[text()="Full Description (Optional, Limit 25,000 Characters)"]/../../div[2]/form/div/textarea').text
  end

  def update_full_desc(repository, content)
    begin
      # Force encoding
      content = content.force_encoding('iso-8859-1').encode('utf-8')

      # Escape for javascript placement
      cleaned_content = EscapeUtils.escape_javascript(content)

      # Login, goto repo page, click edit
      get_edit_mode(repository)

      # Click the edit icon
      puts "Clicking edit icon..."
      find(:xpath, '//span[text()="Full Description"]/../span[2]').click

      # Update the description with javascript
      puts "Using javascript to populate textarea..."
      js = "var content = \"#{cleaned_content}\"; document.evaluate( '//span[text()=\"Full Description (Optional, Limit 25,000 Characters)\"]/../../div[2]/form/div/textarea' ,document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue.value = content;"
      page.execute_script(js)

      # Send an extra space to activate character length checking on Dockerhub
      puts "Sending a 'keyboard space' to the textarea to activate Dockerhub's length check..."
      ta = find(:xpath, '//span[text()="Full Description (Optional, Limit 25,000 Characters)"]/../../div[2]/form/div/textarea')
      ta.send_keys(" ")

      # Click save button
      puts "Clicking Save button..."
      find(:xpath, '//span[text()="Full Description (Optional, Limit 25,000 Characters)"]/../../div[2]/form/div/div/ul/li[2]/button').click

      # Wait until the page updates
      puts "Successfully saved."
      find(:xpath, '//span[text()="Full Description"]')

      return true
    rescue
      return false
    end

    return false
  end

  private

  def get_edit_mode(repository)
    unless @logged_in
      puts "Logging into Dockerhub..."

      # Goto Dockerhub login page
      visit "https://hub.docker.com/login"

      # Login
      puts "Entering credentials..."
      find(:xpath, "//input[contains(@placeholder,'Username')]").set(@username)
      find(:xpath, "//input[contains(@placeholder,'Password')]").set(@password)

      puts "Clicking login..."
      find(:xpath, "//button[text()=\"Log In\"]").click

      # Wait for login to finish
      begin
        puts "Looking for profile link..."
        find(:xpath, "//nav/section/ul[3]/li[2]/a")
        @logged_in = true
      rescue Capybara::ElementNotFound => e
        raise "Login Failed"
      end

      puts "Sucessfullly logged into Dockerhub..."
    end

    # Load the repo page
    visit "https://hub.docker.com/r/#{repository}"

    puts "Ensuring we are on the right page..."
    find(:xpath, '//span[text()="Full Description"]/../span[2]')

  end

end

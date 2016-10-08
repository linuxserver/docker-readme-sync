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

  def initialize(username, password)
    @username = username
    @password = password
    @logged_in = false
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

      # Update the description with javascript
      js = "var content = \"#{cleaned_content}\"; document.evaluate( '//span[text()=\"Full Description (Optional, Limit 25,000 Characters)\"]/../../div[2]/form/div/textarea' ,document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null ).singleNodeValue.value = content;"
      page.execute_script(js)

      # Send an extra space to activate character length checking on Dockerhub
      ta = find(:xpath, '//span[text()="Full Description (Optional, Limit 25,000 Characters)"]/../../div[2]/form/div/textarea')
      ta.send_keys(" ")

      # Click save button
      find(:xpath, '//span[text()="Full Description (Optional, Limit 25,000 Characters)"]/../../div[2]/form/div/div/ul/li[2]/button').click

      # Wait until the page updates
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
      # Goto Dockerhub login page
      visit "https://hub.docker.com/login"

      # Login
      find(:xpath, "//input[contains(@placeholder,'Username')]").set(@username)
      find(:xpath, "//input[contains(@placeholder,'Password')]").set(@password)
      find(:xpath, "//button[text()=\"Log In\"]").click

      # Wait for login to finish
      find(:xpath, "//nav/section/ul[3]/li[2]/a")

      @logged_in = true
    end

    # Load the repo page
    visit "https://hub.docker.com/r/#{repository}"

    # Click the edit icon
    find(:xpath, '//span[text()="Full Description"]/../span[2]').click
  end

end

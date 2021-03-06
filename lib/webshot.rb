require "mini_magick"
require "capybara/dsl"
require "capybara/poltergeist"
require "active_support"
require "active_support/core_ext"
require "webshot/version"
require "webshot/errors"
require "webshot/screenshot"

module Webshot

  ## Browser settings
  # Width
  mattr_accessor :width
  @@width = 1024

  # Height
  mattr_accessor :height
  @@height = 768

  # User agent
  mattr_accessor :user_agent
  @@user_agent = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/601.3.9 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/601.3.9"

  # Customize settings
  def self.setup
    yield self
  end

  # Capybara setup
  def self.capybara_setup!
    # By default Capybara will try to boot a rack application
    # automatically. You might want to switch off Capybara's
    # rack server if you are running against a remote application
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        # Raise JavaScript errors to Ruby
        js_errors: false,
        timeout: 250,
        # Additional command line options for PhantomJS
        phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=any', '--load-images=yes']
      })
    end
    Capybara.current_driver = :poltergeist
  end
end

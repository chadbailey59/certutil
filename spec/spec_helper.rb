require 'bundler/setup'
require 'methadone'
Bundler.setup

APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(APP_ROOT, 'lib/certutil') # so rspec knows where your file could be

RSpec.configure do |config|
  # some (optional) config here
end

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../test/dummy/config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_paths = [Rails.root.join("spec/fixtures")]
  config.use_transactional_fixtures = true
  config.include ActiveSupport::Testing::TimeHelpers
  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!
end

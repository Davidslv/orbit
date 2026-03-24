require_relative "lib/notifications/version"

Gem::Specification.new do |spec|
  spec.name        = "notifications"
  spec.version     = Notifications::VERSION
  spec.authors     = [ "David Silva" ]
  spec.email       = [ "davidslv@users.noreply.github.com" ]
  spec.homepage    = "https://github.com/davidslv/ruby-architecture"
  spec.summary     = "In-app notification system for the modular Rails application."
  spec.description = "A self-contained notifications engine providing in-app notifications. Subscribes to events from other engines via ActiveSupport::Notifications."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/davidslv/ruby-architecture"
  spec.metadata["changelog_uri"] = "https://github.com/davidslv/ruby-architecture"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
  spec.add_dependency "core"
end

require_relative "lib/billing/version"

Gem::Specification.new do |spec|
  spec.name        = "billing"
  spec.version     = Billing::VERSION
  spec.authors     = ["David Silva"]
  spec.email       = ["davidslv@users.noreply.github.com"]
  spec.homepage    = "https://github.com/davidslv/ruby-architecture"
  spec.summary     = "Invoicing, subscriptions, and plan management for the modular Rails application."
  spec.description = "A self-contained billing engine providing invoices, subscriptions, and plans. Communicates with other engines via ActiveSupport::Notifications events."

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/davidslv/ruby-architecture"
  spec.metadata["changelog_uri"] = "https://github.com/davidslv/ruby-architecture"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
  spec.add_dependency "core"
end

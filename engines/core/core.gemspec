require_relative "lib/core/version"

Gem::Specification.new do |spec|
  spec.name        = "core"
  spec.version     = Core::VERSION
  spec.authors     = ["David Silva"]
  spec.email       = ["davidslv@users.noreply.github.com"]
  spec.homepage    = "https://github.com/davidslv/ruby-architecture"
  spec.summary     = "Shared kernel for the modular Rails application."
  spec.description = "Provides shared concerns and utilities used across all engines."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
end

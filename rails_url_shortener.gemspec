require_relative "lib/rails_url_shortener/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_url_shortener"
  spec.version     = RailsUrlShortener::VERSION
  spec.authors     = ["a-chacon"]
  spec.email       = ["andres.ch@protonmail.com"]
  spec.homepage    = "https://www.github.com"
  spec.summary     = "Summary of RailsUrlShortener."
  spec.description = "Description of RailsUrlShortener."
    spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com"
  spec.metadata["changelog_uri"] = "https://www.github.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2.3"
end

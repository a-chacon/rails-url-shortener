require_relative "lib/rails_url_shortener/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_url_shortener"
  spec.version     = RailsUrlShortener::VERSION
  spec.authors     = ["a-chacon"]
  spec.email       = ["andres.ch@protonmail.com"]
  spec.homepage    = "https://www.github.com/a-chacon/rails_url_shortener"
  spec.summary     = "Rails url shortener engine."
  spec.description = "A little engine for rails application that provide url shortener functions."
    spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://www.github.com/a-chacon/rails_url_shortener"
  spec.metadata["changelog_uri"] = "https://www.github.com/a-chacon/rails_url_shortener"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.2.3"
  spec.add_dependency "browser", ">= 5.3.0"
end

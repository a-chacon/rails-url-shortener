require 'rails/generators'

class InitializerGenerator < Rails::Generators::NamedBase

  source_root File.expand_path("templates", __dir__)
  
  def copy
    copy_file "initializer.rb", "config/initializers/rails_url_shortener.rb"
  end

end

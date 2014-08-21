source 'https://rubygems.org'

ruby '2.1.0'

gem 'nokogiri'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

#for pagination
gem 'kaminari'

# for d3 library
gem 'd3_rails'

# Use postgresql as the database for Active Record
gem 'pg'

# gem "nokogiri", github: "sparklemotion/nokogiri", branch: "libxml2-2.9.1"


# for protecting api keys
gem 'figaro'

# for easier upload of contents to dropbox and elsewhere
gem "paperclip", :git => "git://github.com/thoughtbot/paperclip.git"
gem "paperclip-dropbox", ">= 1.1.7"

# for Dropbox access
gem 'dropbox-sdk'

# Use Boostrap saas
gem 'bootstrap-sass', '~> 3.2.0'

# use a recommended autoprefixer to add browser vendor prefixes automatically
gem 'autoprefixer-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# add jQuery UI components
gem 'jquery-ui-sass-rails'


# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# devise gem for authentication
gem 'devise'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

group :test do
  gem 'cucumber-rails', :require => false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  gem 'selenium-webdriver'
  gem 'capybara' #, :git => "git://github.com/jnicklas/capybara.git"

end

group :development, :test do
    gem 'railroady' # generates model and controller UTML diagrams
    gem 'rspec-rails', '~> 3.0.0'
    gem "factory_girl_rails"
    gem "lol_dba" #for finding missed indices
end

group :production do
    gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]


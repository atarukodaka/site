# If you do not have OpenSSL installed, update
# the following line to use "http://" instead
source 'https://rubygems.org'

################
ext_dir = "../extensions"

## middleman

gem "middleman", "~>3.3.7"
#gem "middleman", "~>3.3.7", :path => File.join(ext_dir, "middleman")
gem 'middleman-blog'
gem 'middleman-deploy'
gem 'middleman-google-analytics'  #, :path => File.join(ext_dir, "middleman-google-analytics")
gem 'middleman-alias'
gem 'middleman-bootstrap-navbar'
gem 'therubyracer'

gem 'nokogiri'   # for middleman-blog summary

gem 'middleman-livereload', "~> 3.1.0"
gem 'middleman-dotenv'

gem 'middleman-disqus'
gem 'middleman-rouge'

## layout engine

gem 'redcarpet'
#gem 'org-ruby'
#gem 'org-ruby', :path =>File.join(ext_dir, "org-ruby")

## sass/compass

gem 'sass'
gem 'compass'

## amazon-link

gem "amazon-ecs"
gem "middleman-amazon-link" # , :path => File.join(ext_dir, "middleman-amazon-link")
#gem 'dotenv'

## debug
gem 'pry-byebug'
gem 'middleman-pry'
gem 'rb-readline'   # for pry

# For faster file watcher updates on Windows:
gem "wdm", "~> 0.1.0", :platforms => [:mswin, :mingw]

# Windows does not come with time zone data
gem "tzinfo-data", platforms: [:mswin, :mingw]

#gem 'twitter'

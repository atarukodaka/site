# -*- coding: utf-8 -*-

################
# load .env for private settings

require 'dotenv'
Dotenv.load

################
## set directories

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

#set :source, 'src-dev'    ## for debug

################
# layout

set :layout, :page

################
# Blog Extensions
activate :blog do |blog|
  blog.layout = "article"
  blog.prefix = "articles"
  blog.sources = "{category}/{title}.html"
  blog.permalink = "{category}/{title}.html"
#  blog.sources = "{category}/{year}-{month}-{day}-{title}.html"
#  blog.permalink = "{category}/{year}-{month}-{day}-{title}.html"
  blog.default_extension = ".md"

  # archives
  #blog.month_template = "archives_monthly.html"
  #blog.calendar_template = "calendar.html"
  blog.month_template = "archive_monthly.html"
  blog.month_link = "../archives/{year}/{month}.html"

  # pagination
  blog.paginate = true
  blog.page_link = "p{num}"
  blog.per_page = 10
end

# categories
ready do
  blog.articles.group_by {|p| p.metadata[:page]["category"]}.each do |category, articles|
    next if category.nil?
    proxy("/categories/#{category}.html", "category_summary.html",
          :locals => { :category => category, :articles => articles, :ignore => true })
  end
  ignore "/category_summary.html"
end
Time.zone = "Tokyo"

################
# Other Extensions

activate :bootstrap_navbar do |bootstrap_navbar|
  bootstrap_navbar.bootstrap_version = '3.0.3'
end

#activate :directory_indexes
activate :google_analytics, :tracking_id => data.config.google_analytics.tracking_id
activate :syntax
activate :alias

require './extensions/middleman-blog-enhanced'
activate :blog_enhanced

require './extensions/amazon-link'
activate :amazon_link do |amazon|
  amazon.associate_tag = data.config.amazon.associate_tag
  amazon.aws_access_key_id = data.config.amazon.aws_access_key_id
  amazon.aws_secret_key = data.config.amazon.aws_secret_id || ENV['AWS_SECRET_KEY']
  amazon.country = data.config.amazon.country

  amazon.use_cache = data.config.amazon.use_cache
  amazon.cache_dir = data.config.amazon.cache_dir
end

#activate :disqus do |d|
#  d.shortname = data.config.disqus.shortname
#end

################
# deploy to github proj-page
activate :deploy do |deploy|
  # deploy.build_before = true
  deploy.method = :git
  deploy.branch = 'gh-pages'
end

configure :build do
  if ah = ENV['ASSET_HOST']
    activate :asset_host, :host => ah
  end
end

set :relative_links, true

################
# Reload the browser automatically whenever files change

configure :development do
  activate :livereload
end

################
# markdown

#set :markdown_engine, :kramdown #:redcarpet
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :autolink => true, :smartypants => true, :tables => true

#set :org, :layout_engine => :org

################
# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

################################################################
###
# Compass
###
# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes


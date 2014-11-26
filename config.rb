# -*- coding: utf-8 -*-

# Extensions
activate :syntax
activate :i18n
activate :google_analytics, :tracking_id => "UA-56531446-2"

#activate :alias
#activate :vcs_time

activate :blog do |blog|
  blog.layout = "blog"
end

require "./page_ext.rb"
activate :mtime
activate :page

# deploy to github proj-page
activate :deploy do |deploy|
  # deploy.build_before = true
  deploy.method = :git
  deploy.branch = 'gh-pages'

#  activate :asset_host, :host => "/site"
end

configure :build do
  if ah = ENV['ASSET_HOST']
    activate :asset_host, :host => ah
  end
end

set :relative_links, true
# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

set :layout, :page

#config[:file_watcher_ignore] += [/^\.extensions\//]
#puts config[:file_watcher_ignore]

###
# Helpers
###

## set directories

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

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

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true,
               :autolink => true, 
               :smartypants => true

set :org, :layout_engine => :org

 
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

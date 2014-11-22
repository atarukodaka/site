# -*- coding: utf-8 -*-

# Extensions
require "./series_ext.rb"
require "./mtime_ext.rb"

#activate :vcs_time
activate :mtime
activate :series
activate :syntax
activate :i18n

# deploy to github proj-page
activate :deploy do |deploy|
  # deploy.build_before = true
  deploy.method = :git
  deploy.branch = 'gh-pages'
end

configure :build do
  activate :asset_host, :host => "/site"  
end

set :relative_links, true
# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

set :layout, :page

###
# Helpers
###


## proxy for category pages

ready do
  sitemap.resources.group_by {|p| p.data["category"] }.each do |category, pages|
    next if category.to_s == ""
    proxy("/categories/#{category}.html", "category.html", ignore: false,
          :locals => { :category => category, :pages => pages })
  end
end

ignore "category.html"


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


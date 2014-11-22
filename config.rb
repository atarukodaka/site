# -*- coding: utf-8 -*-

# Extensions
require "./series_ext.rb"
require "./mtime_ext.rb"

#activate :vcs_time
activate :mtime
activate :series
activate :syntax

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

helpers do
  def h(args)
    ERB::Util::h(args)
  end

  def select_html_pages
    sitemap.resources.select {|p| p.ext == ".html"}
  end

  def summary(data_key, value, opt = {})
    # opt:  :caption_template, :list_type,
    #   yield(page) if block_given?
    list_type = (opt[:list_type] =~ /ol/i) ? "ol" : "ul"
    caption_template = opt[:caption_template] || "%{title}"
    
    pages = sitemap.resources.select {|p| p.data[data_key] == value }.sort {|a, b| a.path <=> b.path }
    
    ar = ["<#{list_type}>"]
    pages.each do |page|
      caption = (block_given?) ? yield(page) : page.data.title
      ar << "<li>" + link_to(h(caption), page) + "</li>"
    end
    ar << "</#{list_type}>"
    return ar.join("\n")
  end

  def list_group(data_key, value, opt = {})
    # opt:  :caption_template, :list_type,
    #   yield(page) if block_given?
    
    pages = sitemap.resources.select {|p| p.data[data_key] == value }.sort {|a, b| a.path <=> b.path }
    
    ar = ['<div class="list-group">']
    pages.each do |page|
      active = (page.path == current_page.path) ? " active disabled" : ""
      caption = (block_given?) ? yield(page) : page.data.title
      ar << link_to(h(caption), page, {:class => "list-group-item" + active})
    end
    ar << "</div>"
    return ar.join("\n")
  end
  
  def category_summary
    categories 
    series = []
    sitemap.resources.group_by {|p| p.data.category }.each do |category, pages|
      
    end
  end
  def recent_pages(opt = {})
    # opt: :date_format, :num_display
    #   yield(page) for title template if block_given?
    hash = {}
    date_format = opt[:date_format] || "%Y/%m/%d"
    num_display = opt[:num_display] || 10

    select_html_pages.sort_by {|p| p.mtime}.reverse.first(num_display).each do |page|
      dt = DateTime.new(page.mtime.year, page.mtime.month, page.mtime.day)
      hash[dt] = [] if hash[dt].nil?
      caption = (block_given?) ? yield(page) : page.combined_title
      hash[dt] << link_to(h(caption), page)
    end

    ["<ul>",
     hash.keys.sort {|a, b| b<=>a}.map {|dt|
       ["<li>" + dt.strftime(date_format),
        "<ul>",
        hash[dt].map {|item|
          "<li>" + h(item)
        }.join("\n"),
        "</ul>"].join("\n")
     },
     "</ul>"].join("\n")
  end
end


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

 
set :site_title, "Site name"
set :site_url, "http://www.domain.com"
set :site_description, "Meta description."
set :site_keywords, "keyword-one, keyword-two"

set :site, {
  title: "Site",
  author: "your name"
}

ready do
#  sitemap.resources.select {|p| p.path =~ /\.html$/}.each do |page|
#    puts page.data.modified_at = modified_at(page).strftime("%Y/%m/%d")
#    puts page.data.modified_at
#  end
end


################################################################
# -*- coding: utf-8 -*-
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


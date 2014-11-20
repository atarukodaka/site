# -*- coding: utf-8 -*-

# activate extensions

require "./series_ext.rb"

activate :vcs_time
activate :series
activate :syntax

set :layout, :page

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

set :combined_title_template, "【%{series}】第%{number}回：%{title}"

###
# Helpers
###

helpers do
  def h(args)
    ERB::Util::h(args)
  end

  def select_html_pages(sort_by = nil, reverse = false)
    pages = sitemap.resources.select {|p| p.ext == ".html"}
    pages = 
      case sort_by
      when nil
        pages
      when :title
        pages.sort {|a, b| a.combined_title <=> b.combined_title }
      when :path
        pages.sort {|a, b| a.path <=> b.path }
      when :mtime
        pages.sort {|a, b| a.mtime <=> b.mtime }
      end
    (reverse) ? pages.reverse : pages
  end

  def summary(data_key, value, opt = {})
    # opt:  :caption_template, :list_type
    pages = sitemap.resources.select {|p| p.data[data_key] == value }.sort {|a, b| a.path <=> b.path }
    list_type = (opt[:list_type] =~ /ol/i) ? "ol" : "ul"
    caption_template = opt[:caption_template] || "%{title}"
    
    template = %(
      <#{list_type}>
      <% pages.each do |page| %>
        <% caption_template = "#{caption_template}" %>
        <% caption = caption_template % {title: page.data.title} %>
        <li><%= link_to(h(caption), page.url) %></li>
      <% end %>
      </#{list_type}>
      )
    ERB.new(template).result(binding)
  end
end

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


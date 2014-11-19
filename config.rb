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

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end
# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def h(args)
    ERB::Util::h(args)
  end

  def get_series_number(page)
    page.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
    return $1.to_i
  end
  def series_summary(series)
    pages = sitemap.resources.select {|p| p.data.series == series && p.data.layout == "series"}
    
    template = %(
<ul>
<% pages.sort {|a, b| a.url <=> b.url}.each do |page| %>
  <% number = get_series_number(page) %>
  <li><%= link_to("[" + number.to_s + "] " + h(page.data.title), h("/" + page.destination_path)) %></li>
<% end %>
</ul>
)
    ERB.new(template).result(binding)
  end

  def modified_at(page)
    filename = page.source_file
    return mtime = File.mtime(filename)
  end
  def created_at(page)
    filename = page.source_file
    return mtime = File.ctime(filename)
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

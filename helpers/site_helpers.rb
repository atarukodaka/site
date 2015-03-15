# -*- coding: utf-8 -*-
module SiteHelpers
  include ERB::Util

  ## sitemap helper
  def top_page
    sitemap.find_resource_by_path("/index.html")    # page
  end
  def link_to_page(page)
    if ! page.is_a?(Middleman::Sitemap::Resource)
      page = sitemap.find_resource_by_path(page) || raise("no such resource: #{page}") # yet
    end
    link_to(h(page.data.title), page)
  end

  def select_html_pages
    sitemap.resources.select {|p| p.ext == ".html"}   # .each {|page|
  end
  def select_resources_by(key, value)
    sitemap.resources.select {|p| p.send(key.to_sym) == value}
  end

  def categories_page
    sitemap.find_resource_by_path("/categories.html")
  end
  def category_summary_page(category)
    sitemap.find_resource_by_path("/categories/#{h(category)}.html")
  end

  ################
  def recent_pages(num_display = 10)
#    binding.pry
    # activate middleman-mtime
    hash = {}
#    select_html_pages.sort_by(&:mtime).reverse.first(num_display).each do |page|
    blog.articles.first(num_display).each do |article|
#      binding.pry
      dt = article.date.to_date
      hash[dt] ||= []
      hash[dt] << article
    end
    return hash.sort {|(dt1, v1), (dt2, v2)| dt2 <=> dt1 } # reverse sorted by date
  end

  ################
  def page_info(page)
    #category = page.metadata[:page]["category"]
    category = page.category
    #category_page = sitemap.find_resource_by_path("categories/#{category}.html")
    
    ["", 
     (category.nil?) ? "-" : link_to(h(category), category_summary_page(category)),
     page.date.strftime("%d %b %Y %Z"),
     link_to("permlink", page),
     ""      # prose_edit_link(page, data.config.site_info.github, "site")
    ].join(" | ")
  end

  def share_sns(page)
    [share_twitter(data.config.site_info.twitter), share_haten_bookmark(page)].join("")
  end

  def prose_edit_link(page, github_username, github_repo, branch="master")
    app_root = Middleman::Application.root
    source_path = page.source_file.sub(/#{app_root}/, "")
    hash = {
      github_username: h(github_username), 
      repo: h(github_repo), 
      source_path: h("#{source_path}"),
      branch: branch
    }
    template = %Q{<span><a href="http://prose.io/#%{github_username}/%{repo}/edit/%{branch}%{source_path}"  target="_blank"><i class="glyphicon glyphicon-edit"></i></a></span>}
    template % hash
  end


  ################################################################
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

  ################
  def img_link(url, alt, width=nil, height=nil)
    
  end


  def begin_fold(id)
    %Q[
<script type="text/javascript">
$(function(){
 $("#box_#{id}").hide();
 $("#btn_toggle_#{id}").click(function(){
  if ($("#box_#{id}").css('display') == 'none'){
   $("#box_#{id}").show();
   $("#btn_toggle_#{id}").html("--");
  } else {
   $("#box_#{id}").hide();
   $("#btn_toggle_#{id}").html("+");
  }
 });
});
</script>
<style type="text/css">
#btn_toggle_#{id} {
  cursor: pointer;
  border: solid 1px;
  padding-left: 0.1em;
}
</style>
<span id="btn_toggle_#{id}">+</span>
<div id="box_#{id}">
]
  end

  def end_fold
    "</div>"
  end


end

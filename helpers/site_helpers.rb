# -*- coding: utf-8 -*-

module SiteHelpers
  module LinktoHelpers
    def link_to_page(page)
      if ! page.is_a?(Middleman::Sitemap::Resource)
        page = sitemap.find_resource_by_path(page) || raise("no such resource: #{page}") # yet
      end
      link_to(h(page.data.title) || "(untitled)", page)
    end
    def link_to_page_formatted(page, format=nil)
      format ||= "%{page_link}...<small>[%{category_summary}] at %{date}</small>"

      hash = {
        page_link: link_to_page(page),
        page_title: h(page.data.title),
        category_summary: link_to(h(page.category), category_summary_page(page.category)) || "-",
        date: page.date.strftime("%d %b %Y")
      }
      format % hash
    end
  end
end

module SiteHelpers
  module SelectPageHelpers
    def top_page
     # binding.pry
      sitemap.find_resource_by_path("/index.html")    # page
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
    def __recent_pages(num_display = 10)
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
  end
end

module SiteHelpers
  module ArticleContentHelpers
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

    def crumbs(page, type=:page)
      #crumb_type:
      #  top: *Home*
      #  page: [Home] / *page*
      #  article: [Home] / [category] / *page*

      #  category: [Home] / Category: *category*
      #  archives: [Home] / Archives in year / *month*

      content_tag(:nav, :class => "crumbs") do
        content_tag(:ol, :class => "breadcrumb") do
          case type
          when :page
            if page == top_page()    ## only if top page
              content_tag(:li, :class => "active") do
                h(page.data.title)
              end
            else                   ## normal pages
              [
               content_tag(:li, link_to_page(top_page())),
               content_tag(:li, h(page.data.title || yield_content(:title)), :class => "active")
              ].join('').html_safe
            end
          when :article
            [content_tag(:li, link_to_page(top_page())),
             content_tag(:li, link_to(h(page.category), category_summary_page(page.category))),
             content_tag(:li, h(page.data.title), :class => "active")].join('').html_safe
          else
            raise "no such crumbs type: #{type}"
          end  ## case
        end
      end
    end

    # pagerhelper
    def short_title(article)  ## yet:: to BlogArticle ??
      num_charactors = 30

      if article.nil?
        ""
      else
        s = h(article.data.title)
        if s.size > num_charactors        
          s[0..num_charactors] + "..."
        else
          s[0..-1]
        end
      end
    end
    def article_pager(direction, nav_article)
      title = (nav_article.nil?) ? "" : h(nav_article.data.title)
      nav_str_w_arr = 
        case direction
        when :previous
          "<span>&larr;</span>" + short_title(nav_article)
        when :next
          short_title(nav_article) + "<span>&rarr;</span>"
        else
          raise "unknown direction: #{direction}"
        end
      css_class = direction.to_s
      css_class += " disabled" if nav_article.nil?

      content_tag(:li, :class => css_class) do 
        link_to(nav_str_w_arr, nav_article, {"data-toggle" => "tooltip", "title" => title})
      end
    end

    def share_sns(page)
      [share_twitter(data.config.site_info.twitter), share_haten_bookmark(page)].join("")
    end

    def copyright
      years = blog.articles.group_by {|a| a.date.year}.map {|year, articles| year}
      start_year = years[-1]
      end_year = years[0]

      years_str = (start_year == end_year) ? start_year.to_s : "%d-%d" % [start_year, end_year]
      "&copy; %s by %s (%s)" % [years_str, h(data.config.site_info.author), h(data.config.site_info.email)]
    end
  end
end

################################################################
module SiteHelpers
  include ERB::Util
  include LinktoHelpers
  include SelectPageHelpers
  include ArticleContentHelpers
  
  ################################################################
  # for summary..but too dirty
  def list_group(data_key, value, opt = {})  # yet...its dirty
    # opt:  :caption_template, :list_type,
    #   yield(page) if block_given?
    
    pages = sitemap.resources.select {|p| p.data[data_key] == value }.sort {|a, b| a.path <=> b.path }
    
    #ar = ['<div class="list-group">']
    content_tag(:div, :class => 'list-group') do
      binding.pry
      pages.map { |page|
        active = (page.path == current_page.path) ? " active disabled" : ""
        caption = (block_given?) ? yield(page) : page.data.title
        link_to(h(caption), page, {:class => "list-group-item" + active})
      }.join("").html_safe
    end
=begin
    pages.each do |page|
      active = (page.path == current_page.path) ? " active disabled" : ""
      caption = (block_given?) ? yield(page) : page.data.title
      ar << link_to(h(caption), page, {:class => "list-group-item" + active})
    end
    ar << "</div>"
    return ar.join("\n")
=end
  end
    ################
end

__END__


  def __summary(data_key, value, opt = {})
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


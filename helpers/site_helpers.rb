module SiteHelpers
  def h(args)
    ERB::Util::h(args)
  end

  ## sitemap helper
  def top_page
    sitemap.find_resource_by_path("/index.html")    # page
  end
  def select_html_pages
    sitemap.resources.select {|p| p.ext == ".html"}   # .each {|page|
  end
  def select_resources_by(key, value)
    sitemap.resources.select {|p| p.send(key.to_sym) == value}
  end
  def categories
    select_html_pages.group_by {|p| p.data.category }   # .reject {|category, pages| category.to_s == "" || pages.count == 0 }  # .each {|category, pages|
  end

  def tags
    hash = {}
    select_html_pages.each do |page|
      next if page.data.tag.to_s == ""

      page.tags.each do |t|
        hash[t] ||= [] 
        hash[t] << page
      end
    end
    hash
  end
  def series
    select_html_pages.reject {|p| p.data.series.nil?}.group_by {|p| p.data.series }
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

  ## youtube
  def youtube(id, width=560, height=420, opt = {})
    opt_str = opt.map {|key, value| h(key.to_s) + "=" + h(value.to_s)}.join("&")
    %Q{<iframe width="%{width}" height="%{height}" src="http://www.youtube.com/embed/%{id}?%{opt_str}"></iframe>} % 
      {height: height.to_i, width: width.to_i, id: h(id), opt_str: opt_str}
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

end

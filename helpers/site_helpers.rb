
module SiteHelpers
  def top_page
    sitemap.find_resource_by_path("/index.html")
  end
  def h(args)
    ERB::Util::h(args)
  end

  def select_html_pages
    sitemap.resources.select {|p| p.ext == ".html"}
  end
  def group_by_category
    sitemap.resources.group_by {|p| p.data.category}
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


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
  def group_by_category
    sitemap.resources.group_by {|p| p.data.category}  # .each {|category, pages|
  end

  def tags
    ar = []
    sitemap.resources.group_by {|p| p.data.tag }.each do |tag, pages|
      puts tag
      next if tag == ""
      ar << tag
    end
    puts ar
    ar
  end

  ## prose.io
  def prose_edit_link(github_username, github_repo)
    hash = {github_username: h(github_username), repo: h(github_repo), page_url: current_page.source_file, branch: "master"}
    template = %Q{<span><a href="http://prose.io/#%{github_username}/%{repo}/edit/%{branch}%{page_url}"  target="_blank"><i class="glyphicon glyphicon-edit"></i></a></span>}
    template % hash
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

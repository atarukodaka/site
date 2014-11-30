module YoutubeHelpers
  ## youtube
  def youtube(id, width=560, height=420, opt = {})
    opt_str = opt.map {|key, value| h(key.to_s) + "=" + h(value.to_s)}.join("&")
    %Q{<iframe width="%{width}" height="%{height}" src="http://www.youtube.com/embed/%{id}?%{opt_str}"></iframe>} % 
      {height: height.to_i, width: width.to_i, id: h(id), opt_str: opt_str}
  end
end


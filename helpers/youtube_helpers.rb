module YoutubeHelpers
  ## youtube
  def youtube(id, width=560, height=315, opt = {})
    opt_str = opt.map {|key, value| h(key.to_s) + "=" + h(value.to_s)}.join("&")
    %Q{<iframe width="%{width}" height="%{height}" src="http://www.youtube.com/embed/%{id}?%{opt_str}"></iframe>} % 
      {height: height.to_i, width: width.to_i, id: h(id), opt_str: opt_str}
  end
end

## see http://www.html5-memo.com/webtips/responsive-movie/

__END__
<style type="text/css">
.movie#youtube_%{id} {
    position:relative;
    width:%{width}%;
    padding-top: %{height}%;
}
.movie#youtube_%{id} iframe{
    position:absolute;
    top:0;
    right:0;
    width:100%;
    height:100%;
}
</style>

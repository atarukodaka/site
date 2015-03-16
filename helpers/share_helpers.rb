# -*- coding: utf-8 -*-
module ShareHelpers

  def share_hatena_bookmark(page)
    description = "このエントリーをはてなブックマークに追加"
    %Q{<a href="http://b.hatena.ne.jp/entry/#{h(page.url)}" class="hatena-bookmark-button" data-hatena-bookmark-title="#{h(page.title)}" data-hatena-bookmark-layout="simple-balloon" title="#{h(description)}">
<img src="https://b.st-hatena.com/images/entry-button/button-only@2x.png" alt="#{(description)}" width="20" height="20" style="border: none;"></a>
<script type="text/javascript" src="https://b.st-hatena.com/js/bookmark_button.js" charset="utf-8" async="async"></script>}
  end

  ## share_twitter
  def share_twitter(username)
    hash = { username: username }
    template = %Q{<span>
	<a href="https://twitter.com/share" class="twitter-share-button" data-via="%{username}">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
      </span>}
    template % hash
  end
end

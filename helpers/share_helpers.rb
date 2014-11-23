module ShareHelpers
  ## share_twitter
  def share_twitter(twitter_account_name)
    hash = { username: h(twitter_account_name) }
    template = %Q{<span>
	<a href="https://twitter.com/share" class="twitter-share-button" data-via="%{username}">Tweet</a>
<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
      </span>}
    template % hash
  end
end

module Middleman
  module ProseEditLink
    module ResourceIncluded
      include ERB::Util
      ## prose.io
      def prose_edit_link(github_username, github_repo, branch="master")
        app_root = Middleman::Application.root
        source_path = self.source_file.sub(/#{app_root}/, "")
        hash = {
          github_username: h(github_username), 
          repo: h(github_repo), 
          source_path: h("#{source_path}"),
          branch: branch
        }
        template = %Q{<span><a href="http://prose.io/#%{github_username}/%{repo}/edit/%{branch}%{source_path}"  target="_blank"><i class="glyphicon glyphicon-edit"></i></a></span>}
        template % hash
      end
    end
    
    ################
    class Extension < Middleman::Extension
      def after_configuration
#        Middleman::Sitemap::Resource.class_eval do
        Middleman::Blog::BlogArticle.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::ProseEditLink::Extension.register :prose_edit_link


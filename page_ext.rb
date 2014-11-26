
module Middleman
  module Series
    module ResourceIncluded
      include ERB::Util
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end
      
      ## prose.io
      def prose_edit_link(github_username, github_repo)
        # http://prose.io/#atarukodaka/site/edit/master/source/sitemap.html.erb
        #  source_file: /vagrant/source/site/source/memo.html.org
        #  path: memo.html

        #  App.root: /vagrant/source/site
        #  source_file: /vagrant/source/site/source/memo.html.org
        #  source_file2: source/memo.html.org
        #  => source/memo.html.org
        app_root = Middleman::Application.root
        source_path = self.source_file.sub(/#{app_root}/, "")
        hash = {github_username: h(github_username), repo: h(github_repo), source_path: h("#{source_path}"), branch: "master"}
        template = %Q{<span><a href="http://prose.io/#%{github_username}/%{repo}/edit/%{branch}%{source_path}"  target="_blank"><i class="glyphicon glyphicon-edit"></i></a></span>}
        template % hash
      end

=begin
      def combined_title
        template = I18n.t("page.title_template")
        title = self.data.title || "untitled"
        if self.data.series
          template % {series: self.data.series, number: self.series_number, title: title}
        else
          title
        end
      end
      def formatted_title(format="%{title}")
        self.data.title % data.to_hash
      end
=end
    end
    
    ################
    class Extension < Middleman::Extension
      def after_configuration
        Middleman::Sitemap::Resource.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::Series::Extension.register :page


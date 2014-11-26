
module Middleman
  module PageAccessor
    module ResourceIncluded
      include ERB::Util
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end

      def category
        return self.data.category if self.data.category.to_s != "" || data.series.to_s != ""
        
        dir, fname = File.split(self.path.to_s)
        return (dir == ".") ? nil : dir
      end
      def tags
        if data.tag.is_a? Array
          data.tag 
        elsif data.tag.is_a? String
          data.tag.split(/\s*,\s/).map(&:strip)
        else
          []
        end
      end
      def title
        return data.title if data.series.to_s == ""
        %Q{[%{series}:\#%{series_number}]%{title}} % {title: data.title, series_number: series_number, series: data.series}
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

Middleman::PageAccessor::Extension.register :page


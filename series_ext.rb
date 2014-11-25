module Middleman
  module Series
    module ResourceIncluded
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
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

Middleman::Series::Extension.register :series


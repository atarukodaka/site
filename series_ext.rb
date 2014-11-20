# -*- coding: utf-8 -*-
module Middleman
  module Series
    module ResourceIncluded
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end

      def combined_title
        templates = {
          en: "[%{series}] #%{number}: %{title}",
          ja: "【%{series}】第%{number}回：%{title}"
        }
        lang = :en
        template = @app.data.config.series.combined_title_template || templates[:en]
        
        title = self.data.title || "untitled"
        if self.data.series
          template % {series: self.data.series, number: self.series_number, title: title}
        else
          title
        end
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

Middleman::Series::Extension.register :series


# -*- coding: utf-8 -*-
module Middleman
  module CombinedTitle
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

        if self.data.series
          #"[%s] #%d: %s" % [page.data.series, get_series_number(page), page.data.title]
          templates[:en] % {series: self.data.series, number: self.series_number, title: self.data.title}
          
        else
          self.data.title
        end
      end
    end

    class Extension < Middleman::Extension
      def after_configuration
        Middleman::Sitemap::Resource.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::CombinedTitle::Extension.register :combined_title

=begin

################################################################
module Middleman
  module Sitemap
    class Resource
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end
      def combined_title
        template_en = "[%{series}] #%{number}: %{title}"
        template_ja = "【%{series}】第%{number}回：%{title}"

        if self.data.series
          #"[%s] #%d: %s" % [page.data.series, get_series_number(page), page.data.title]
          template_en % {series: self.data.series, number: self.series_number, title: self.data.title}
          
        else
          self.data.title
        end
      end
    end
  end
end

=end

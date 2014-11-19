# -*- coding: utf-8 -*-
module Middleman
  module Sitemap
    class Resource

      alias :org_initialize :initialize
      
      
      def initialize(store, path, source_file=nil)
        org_initialize(store, path, source_file)
        @modified_at = File.mtime(self.source_file) if File.exists? @source_file
      end

      def modified_at
        #return mtime = File.mtime(self.source_file)
        @modified_at
      end
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


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
        if self.data.series.to_s != ""
          "【%s】第%d回：%s" % [self.data.series, self.series_number, self.data.title]
        else
          self.data.title
        end
      end
    end
  end
end


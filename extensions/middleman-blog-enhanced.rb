module Middleman
  module BlogEnhanced
    module ResourceIncluded
      def categories
        articles.group_by {|p| p.data.category }
      end

      def articles_with_date
        hash = {}
        articles.each do |article|
          dt = article.date.to_date
          hash[dt] ||= []
          hash[dt] << article
        end
        return hash.sort {|(dt1, v1), (dt2, v2)| dt2 <=> dt1 } # reverse sorted by date
      end

      def recent_articles_with_date(num_display = 10)
        hash = {}
        articles.first(num_display).each do |article|
          dt = article.date.to_date
          hash[dt] ||= []
          hash[dt] << article
        end
        return hash.sort {|(dt1, v1), (dt2, v2)| dt2 <=> dt1 } # reverse sorted by date
      end

      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end
    end  ################

    class Extension < Middleman::Extension
      Middleman::Blog::BlogData.class_eval do 
        include ResourceIncluded
      end
    end
  end
end

Middleman::BlogEnhanced::Extension.register :blog_enhanced

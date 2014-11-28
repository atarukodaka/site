module Middleman
  module BlogEnhanced
    module ResourceIncluded
      def categories
        articles.group_by {|p| p.data.category }
      end

      def recent_articles_date_hash(num_display = 10)
        hash = {}
        articles.first(num_display).each do |article|
          dt = article.date.to_date
          hash[dt] ||= []
          hash[dt] << article
        end
        return hash.sort {|(dt1, v1), (dt2, v2)| dt2 <=> dt1 } # reverse sorted by date
      end
    end

    class Extension < Middleman::Extension
      Middleman::Blog::BlogData.class_eval do 
        include ResourceIncluded
      end
    end
  end
end

Middleman::BlogEnhanced::Extension.register :blog_enhanced

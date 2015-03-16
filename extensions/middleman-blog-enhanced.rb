# -*- coding: utf-8 -*-
module Middleman
  module BlogEnhanced
    ################################################################
    # blog.* へのヘルパーメソッド
    #
    module ResourceIncludedToBlogData
      def categories
        articles.group_by {|p| p.category }
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
    end  
    ################################################################
    # blog.articles.* への追加メソッド
    module ResourceIncludedToBlogArticle
      #  article.category で指定カテゴリを取れるように
      #   - frontmatter で指定：article.data.category
      #   - 配置ディレクトリで暗黙に指定： metadata[:page]["category"]
      #
      # 前者を優先
      #
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
      def summary_text(length = 250, separator = nil, leading_message = "...read more")
        Nokogiri::HTML(self.summary(length, separator)).text + app.link_to(leading_message, self)
      end

      #def series_number
      #  self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
      #  return $1.to_i
      #end
    end
    ################
    class Extension < Middleman::Extension
      Middleman::Blog::BlogData.class_eval do 
        include ResourceIncludedToBlogData
      end
      Middleman::Blog::BlogArticle.class_eval do
        include ResourceIncludedToBlogArticle
      end
    end
  end
end

Middleman::BlogEnhanced::Extension.register :blog_enhanced

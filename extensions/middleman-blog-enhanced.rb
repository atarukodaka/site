# -*- coding: utf-8 -*-
module Middleman
  module BlogEnhanced
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
    # article.category で指定カテゴリを取れるように
    #   - frontmatter で指定：article.data.category
    #   - 配置ディレクトリで暗黙に指定： metadata[:page]["category"]
    #
    # 前者を優先
    #
    module ResourceIncludedToBlogArticle
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
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

__END__
Middleman::BlogEnhanced::Extension.register :blog_enhanced

module Middleman
  module AddCategoryToArticle
    module ResourceIncluded
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
    end

    ################
    class Extension < Middleman::Extension
      def after_configuration
#        Middleman::Sitemap::Resource.class_eval do
        ::Middleman::Blog::BlogArticle.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::AddCategoryToArticle::Extension.register :add_category_to_article

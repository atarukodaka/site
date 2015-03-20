# -*- coding: utf-8 -*-
module Middleman
  module BlogEnhanced
    ################################################################
    # additional helper methods to blog.*
    #
    module ResourceIncludedToBlogData
    end  
    ################################################################
    # additional helper methods to BlogArticle (blog.articles.*)
    module ResourceIncludedToBlogArticle
      #  to get category by 'article.category'
      #   - specify in frontmatter：article.data.category
      #   - specify with directory located： metadata[:page]["category"]
      #
      def title   ### yet: warning: overriding core method which does refer simply data[:title]
        data[:title] || metadata[:page]["title"] || yield_content(:title)
      end
      def summary_text(length = 250, separator = nil, leading_message = "...read more")
        Nokogiri::HTML(self.summary(length, separator)).text + app.link_to(leading_message, self)
      end

      ## yet. considering how to implement this feature.....
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
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

Middleman::BlogEnhanced::Extension.register :blog_enhanced

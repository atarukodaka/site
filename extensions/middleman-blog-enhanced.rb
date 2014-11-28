module Middleman
  module BlogEnhanced
    module ResourceIncluded
      def categories
        articles.group_by {|p| p.data.category }
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

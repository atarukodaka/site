
module Middleman
  module Series
    module ResourceIncluded
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
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

Middleman::Series::Extension.register :series

module Middleman
  module ModifiedTime
    module ResourceIncluded
      def mtime
        @_mtime ||=
          if File.exists?(source_file)
            File.mtime(source_file)
          else
            Time.now
          end
      end
    end
    ################
    class Extension < Middleman::Extension
      def after_configuration
        Middleman::Sitemap::Resource.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::ModifiedTime::Extension.register :mtime


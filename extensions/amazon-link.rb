require 'amazon/ecs'  

## helpers.rb
module Amazon
  class EcsLookupWrapper
    def initialize(ecs_opt, opt={})
      ecs_opt[:country] ||= 'jp'
      ecs_opt[:response_group] = 'Images,ItemAttributes'
      
      Amazon::Ecs.options= ecs_opt
      # required
      #   :AWS_access_key_id
      #   :AWS_secret_key
      # optional
      #   :associate_tag
      #   :country

      @use_cache = opt[:use_cache]
      @cache_dir = opt[:cache_dir] || "./caches/amazon"

      @result_cache = {}
    end
    def item_lookup(asin)
      return @result_cache[asin] if @result_cache.has_key?(asin)
      return @result_cache[asin] = load_cache(asin) if @use_cache && File.exist?(cache_filename(asin))
      
      cnt = 0
      begin
        res = Amazon::Ecs.item_lookup(asin)
      rescue Amazon::RequestError => err
        if /503/ =~ err.message && cnt < 3
          sleep 3
          cnt += 1
          $stderr.puts "  retrying...#{asin}/#{cnt}"
          $stderr.puts "    options: #{Amazon::Ecs.options.inspect}"
          retry
        else
          raise err
        end
      end

      res.items.each do |item|
        hash = {
          asin:        asin,
          title:       item.get('ItemAttributes/Title').to_s,
          author:      item.get('ItemAttributes/Author').to_s,
          publisher:   item.get('ItemAttributes/Manufacturer').to_s,
          date:        item.get('ItemAttributes/PublicationDate').to_s || 
                       item.get('ItemAttributes/ReleaseDate').to_s,
          detail_url:  item.get('DetailPageURL').to_s,

          image_small: item.get('SmallImage/URL').to_s,
          image_medium: item.get('MediumImage/URL').to_s,
          image_large: item.get('LargeImage/URL').to_s,
        }
        @result_cache[asin] = hash
        save_cache(asin, hash) if @use_cache
      end
      return @result_cache[asin]
    end
    ################
    # caching
    def cache_filename(asin)
      File.join(@cache_dir, asin)
    end
    def load_cache(asin)
      Marshal.load(File.read(cache_filename(asin)))
    end
    def save_cache(asin, hash)
      File.open(cache_filename(asin), 'wb'){|f| f.write(Marshal.dump(hash))}
    end
  end  ## class
end
################################################################

module Middleman
  module AmazonLink
    module Helpers
      @@templates = {
        title: %Q{<span><a href="%{title}" target="_blank">%{title}</a></span>},
        detail:
        %(
<div class="amazon_item">
  <a href="%{detail_url}" target="_blank"><img src="%{image_medium}"></a>
  <a href="%{detail_url}" target="_blank">%{title}</a><br/>
  <div class="item_detail">
    %{author} / %{publisher} / %{date}
  </div>
</div>)
      }
      def amazon(asin, type_or_string = :detail)
        #binding.pry

        amazon_opts = amazon_link_settings
        ecs_opt = {
          associate_tag: amazon_opts.associate_tag,
          AWS_access_key_id: amazon_opts.aws_access_key_id,
          AWS_secret_key: amazon_opts.aws_secret_key
        }
        opt = {
          use_cache: amazon_opts.use_cache,
          cache_dir: amazon_opts.cache_dir
        }
        amazon_lookup = Amazon::EcsLookupWrapper.new(ecs_opt, opt)
        hash =  amazon_lookup.item_lookup(asin)
        
        if block_given?
          yield(hash)
        else
          template = (type_or_string.class == Symbol) ? @@templates[type_or_string] : type_or_string
          #or raise "no such template type: '#{type}'"
          template % hash
        end
      end
    end
  end
end
################################################################
module Middleman
  module AmazonLink
    class Extension < Middleman::Extension
      option :aws_access_key_id, nil, 'AWS Access Key ID'
      option :aws_secret_key, nil, 'AWS Secret key'
      option :associate_tag, nil, 'tag: xxx-22'
      option :country, 'jp', 'country'

      option :use_cache, true, 'use cache or not'
      option :cache_dir, './caches/amazon', 'directory for caches'
      
      def initialize(app, options_hash = {}, &block)
        super
        app.set :amazon_link_settings, options
      end
      helpers do
        include Middleman::AmazonLink::Helpers
      end
    end
  end
end

Middleman::AmazonLink::Extension.register :amazon_link

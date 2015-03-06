################################################################
# amazon_helper

require 'amazon/ecs'
require 'pry-byebug'

module AmazonHelper
  @@templates = {
    title: %Q{<span><a href="%{detail_url}" target="_blank">%{title}</a></span>},
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
  def amazon(asin, type = :title)
    amazon_tag = AmazonHelper::AmazonTag.new(data)
    hash =  amazon_tag.item_lookup_caching(asin)
    
    template = @@templates[type] or raise "no such template type: '#{type}'"
    template % hash
  end

  ################
  class AmazonTag
    def initialize(data)
      @data = data
    end
    def item_lookup_caching(asin)
      hash = nil
      if @data.amazon.use_cache
        cache = AmazonHelper::AmazonCache.new(@data.amazon.cache_dir)
        hash = cache.get(asin)
      end
      if hash.nil?
        hash = item_lookup(asin)
        cache.put(asin, hash) if @data.amazon.use_cache
      end
      hash
    end
    def item_lookup(asin)
      Amazon::Ecs.options= {

        associate_tag: @data.amazon.associate_tag,
        AWS_access_key_id: @data.amazon.access_key_id,
        AWS_secret_key: @data.amazon.secret_key,
        country: @data.amazon['country'] || 'jp',
        response_group: 'Images,ItemAttributes'
      }
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

      hash = {}
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
      end
      return hash
    end
  end
  ################################################################
end
module AmazonHelper
  class AmazonCache
    def initialize(cache_dir = "./.caches/amazon")
      @cache_dir = cache_dir
      if File.exists?(@cache_dir) == false
        #dputs "mkpath: #{@cache_dir}"
        FileUtils.mkpath(@cache_dir) 
      end
    end
    def cache_filename(asin)
      File.join(@cache_dir, asin)
    end
    def get(asin)
      if File.exists?(cache_filename(asin))
        $stderr.puts "get cache '#{asin}' from #{cache_filename(asin)}"
        return Marshal.load(File.read(cache_filename(asin)))
      else
        $stderr.puts "no cache for #{asin}"
        return nil
      end
    end
    def put(asin, hash)
      $stderr.puts "saving cache '#{asin}' into #{cache_filename(asin)}"
      File.open(cache_filename(asin), 'wb'){|f|
        f.write(Marshal.dump(hash))
      }
      return hash
    end
  end
end

################################################################
if __FILE__ == $0
  amazon_tag = AmazonHelper::AmazonTag.new
  #puts amazon_tag.item_lookup_caching("B0002IS0HU")
  include AmazonHelper
  puts amazon("B0006BLI1I", :detail)
  puts amazon("B0038L2I3A", :detail)
end

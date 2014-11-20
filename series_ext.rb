# -*- coding: utf-8 -*-
module Middleman
  module Series
    module ResourceIncluded
      def series_number
        self.path =~ Regexp.new("/([0-9]+)\-[^/]+\.html$")
        return $1.to_i
      end

      def combined_title
        templates = {
          en: "[%{series}] #%{number}: %{title}",
          ja: "【%{series}】第%{number}回：%{title}"
        }
        #template = data.config.series.combined_title_template || templates[:en]
        #template = config['combined_title_template']
        lang = :en
        #template = @app.settings.combined_title_template
        template = @app.data.config.series.combined_title_template || templates[:en]
        #puts template = Extension.options.combined_title_template
        #puts @app.settings.combined_title_template
        
        title = self.data.title || "untitled"
        if self.data.series
          #"[%s] #%d: %s" % [page.data.series, get_series_number(page), page.data.title]
          template % {series: self.data.series, number: self.series_number, title: title}
        else
          title
        end
      end
    end
    ################
    class Extension < Middleman::Extension
      # option :combined_title_template, "[%{series}] #%{number}: %{title}"
      
      helpers do
        def series_summary(series)
          pages = sitemap.resources.select {|p| p.data.series == series }.sort {|a, b| a.path <=> b.path }
          template = %(
      <ul>
      <% pages.each do |page| %>
        <li><%= link_to("[" + page.series_number.to_s + "] " + h(page.data.title), "/" + page.destination_path) %></li>
      <% end %>
      </ul>
      )
          ERB.new(template).result(binding)
        end
      end
      def after_configuration
        Middleman::Sitemap::Resource.class_eval do
          include ResourceIncluded
        end
      end
    end
  end
end

Middleman::Series::Extension.register :series


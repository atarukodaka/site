MM = bundle exec middleman
TEMPLATE_DIR = ../middleman-template-aks

bld:
	$(MM) build

serve:
	$(MM) server --force-polling &

deploy:
	ASSET_HOST=/site $(MM) deploy -b

server:
	ruby server.rb >& /dev/null&

kancolle:
	cp source/kancolle.html.md source/articles/game

clean:
	rm -rf build
	rake clean

template-aks:
	cp Gemfile Gemfile.lock config.rb Procfile server.rb $(TEMPLATE_DIR)
	cp -r extensions helpers  $(TEMPLATE_DIR)
	cp -r source/layouts $(TEMPLATE_DIR)/source
	cp -r source/partials $(TEMPLATE_DIR)/source
	cp -r source/stylesheets $(TEMPLATE_DIR)/source
	cp -r source/javascripts $(TEMPLATE_DIR)/source
	cp -r source/images $(TEMPLATE_DIR)/source
	cp source/categories.html.erb source/sitemap.html.erb source/tags.html.erb source/archives.html.erb source/archive_summary.html.erb source/index.html.erb source/category_summary.html.erb $(TEMPLATE_DIR)/source

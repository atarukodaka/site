MM = bundle exec middleman

bld:
	$(MM) build

serve:
	$(MM) server --force-polling &

deploy:
	ASSET_HOST=/site $(MM) deploy -b

server:
	ruby server.rb >& /dev/null&

kancolle:
	cp source/kancolle.html.md source/articles/hobby

clean:
	rm -rf build
	rake clean


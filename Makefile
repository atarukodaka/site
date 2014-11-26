MM = bundle exec middleman

bld:
	$(MM) build

serve:
	$(MM) server --force-polling &

deploy:
	ASSET_HOST=/site $(MM) deploy -b

server:
	ruby server.rb --port 1234 &

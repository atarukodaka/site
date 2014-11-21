MM = "bundle exec middleman"

bld:
	$(MM) build

serve:
	$(MM) server --force-polling &


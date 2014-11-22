MM = bundle exec middleman

all:

build:
	$(MM) build

serve:
	$(MM) server --force-polling &


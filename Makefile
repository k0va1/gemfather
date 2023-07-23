.PHONY: test

install:
	bundle install

install_gem:
	yes | rm -rf pkg/*
	bundle exec rake build
	gem install --local pkg/*.gem

remove_gem:
	yes | gem uninstall gemfather

reinstall_gem: remove_gem install_gem

publish:
	bundle exec rake build
	gem push pkg/*.gem

start:
	exe/gemfather

test:
	bundle exec rspec

lint-fix:
	bundle exec rubocop -A

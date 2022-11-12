.PHONY: test

install:
	bundle install

install_gem:
	yes | rm -rf pkg/*
	bundle exec rake build
	gem install --local pkg/*.gem

start:
	bin/gemfather

cons:
	bin/console

test:
	bundle exec rspec

lint:
	bundle exec rubocop

.PHONY: test

install:
	bundle install

install_gem:
	gem build
	gem install --local ./gemfather-0.1.0.gem

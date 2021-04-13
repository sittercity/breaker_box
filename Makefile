GEM_NAME=breaker_box
GEM_SPEC=breaker_box.gemspec
GEM_VERSION=$(shell ruby -e 'puts Gem::Specification.load("$(GEM_NAME).gemspec").version')
GEM=$(GEM_NAME)-$(GEM_VERSION).gem

test:
	bundle exec rspec

setup:
	bundle install

dist: $(GEM)

$(GEM):
	gem build $(GEM_SPEC)

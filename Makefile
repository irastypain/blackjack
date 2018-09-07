install:
	bin/setup && bundle exec rake install

test:
	bundle exec rake spec

test-coverage:
	bundle exec 'COVERAGE=true rake spec'


source "https://rubygems.org"

gem "utopia", "~> 2.0.2"
# gem "utopia-gallery"
# gem "utopia-google-analytics"

gem "rake"
gem "bundler"

gem "rack-freeze", "~> 1.2"

group :development do
	# For `rake server`:
	gem "puma"
	gem "guard-puma", require: false
	gem 'guard-rspec', require: false
	
	# For `rake console`:
	gem "pry"
	gem "rack-test"
	
	# For `rspec` testing:
	gem "rspec"
	gem "simplecov"
end

group :production do
	# Used for passenger-config to restart server after deployment:
	gem "passenger"
end

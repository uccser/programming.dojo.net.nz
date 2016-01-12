#!/usr/bin/env rackup

# Setup default encoding:
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Setup the server environment:
RACK_ENV = ENV.fetch('RACK_ENV', :development).to_sym unless defined?(RACK_ENV)

# Allow loading library code from lib directory:
$LOAD_PATH << File.expand_path("lib", __dir__)

require 'utopia'
require 'utopia/tags/gallery'
require 'utopia/tags/google-analytics'
require 'utopia/extensions/array'
require 'rack/cache'

if RACK_ENV == :production
	use Utopia::ExceptionHandler, "/errors/exception"
	use Utopia::MailExceptions
elsif RACK_ENV == :development
	use Rack::ShowExceptions
end

use Rack::Sendfile

if RACK_ENV == :production
	use Rack::Cache,
		metastore: "file:#{Utopia::default_root("cache/meta")}",
		entitystore: "file:#{Utopia::default_root("cache/body")}",
		verbose: RACK_ENV == :development
end

use Rack::ContentLength

use Utopia::Redirector,
	patterns: [
		Utopia::Redirector::DIRECTORY_INDEX
	],
	strings: {
		'/' => '/welcome/index',
		# Posters
		"/python" => "/languages/python",
		"/ruby" => "/languages/ruby",
		"/c" => "/languages/c",
		"/c-sharp" => "/languages/c-sharp",
		"/java" => "/languages/java",
		"/scratch" => "/languages/scratch",
		"/scheme" => "/languages/scheme",
		"/basic" => "/languages/basic",
		"/posters-2010" => "/resources/programming-language-posters",
		"/posters-2011" => "/resources/programming-language-posters",
	},
	errors: {
		404 => "/errors/file-not-found"
	}

use Utopia::Controller,
	cache_controllers: (RACK_ENV == :production)

use Utopia::Static

use Utopia::Content,
	cache_templates: (RACK_ENV == :production),
	tags: {
		'deferred' => Utopia::Tags::Deferred,
		'override' => Utopia::Tags::Override,
		'node' => Utopia::Tags::Node,
		'environment' => Utopia::Tags::Environment.for(RACK_ENV),
		'gallery' => Utopia::Tags::Gallery,
		'google-analytics' => Utopia::Tags::GoogleAnalytics,
	}

run lambda { |env| [404, {}, []] }

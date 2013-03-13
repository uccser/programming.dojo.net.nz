#!/usr/bin/env rackup

UTOPIA_ENV = (ENV['UTOPIA_ENV'] || ENV['RACK_ENV'] || :development).to_sym
$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")

# It is recommended that you always explicity specify the version of the gem you are using.
gem 'utopia', "~> 0.12"
require 'utopia/middleware/all'
require 'utopia/tags/all'

# From utopia-extras:
gem 'utopia-extras', "~> 0.12"
require 'utopia/tags/gallery'
require 'utopia/tags/google_analytics'

# Utopia relies heavily on accurately caching resources
gem 'rack-cache'
require 'rack/cache'

if UTOPIA_ENV == :development
	use Rack::ShowExceptions
else
	use Utopia::Middleware::ExceptionHandler, "/errors/exception"
	use Utopia::Middleware::MailExceptions
end

use Rack::ContentLength

use Utopia::Middleware::Logger

use Utopia::Middleware::Redirector, {
	:strings => {
		"/" => "/welcome/index",
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
		"/posters-2011" => "/resources/programming-language-posters"
	},
	:errors => {
		404 => "/errors/file-not-found"
	}
}

use Utopia::Middleware::Requester
use Utopia::Middleware::DirectoryIndex
use Utopia::Middleware::Controller
use Utopia::Middleware::Static

if UTOPIA_ENV == :production
	use Rack::Cache, {
		:metastore   => "file:#{Utopia::Middleware::default_root("cache/meta")}",
		:entitystore => "file:#{Utopia::Middleware::default_root("cache/body")}",
		:verbose => false
	}
end

use Utopia::Middleware::Content

run lambda { |env| [404, {}, []] }

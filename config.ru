#!/usr/bin/env rackup

UTOPIA_ENV = (ENV['UTOPIA_ENV'] || ENV['RAILS_ENV'] || :development).to_sym
$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
$stderr.puts "Running in #{UTOPIA_ENV} mode."

gem 'utopia', '0.9.25'
require 'utopia/middleware/all'
require 'utopia/tags/all'
require 'utopia/session/encrypted_cookie'

gem 'rack-contrib'
require 'rack/contrib'

gem 'rack-cache'
require 'rack/cache'

if UTOPIA_ENV == :development
	use Rack::ShowExceptions
else
	use Utopia::Middleware::ExceptionHandler, "/errors/exception"

	use Rack::MailExceptions do |mail|
		mail.from "websites@oriontransfer.org"
		mail.to "samuel@oriontransfer.org"
		mail.subject "www.oriontransfer.co.nz: %s"
	end
end

use Rack::ContentLength

use Utopia::Middleware::Logger

use Utopia::Middleware::Redirector, {
	:redirects => {
		"/" => "/welcome/index",
		# Posters
		"/java" => "/languages/java/index",
		"/clang" => "/languages/clang",
		"/ruby" => "/languages/ruby",
		"/python" => "/languages/python",
		"/scheme" => "/languages/scheme"
	},
	:errors => {
		404 => "/errors/file-not-found"
	}
}

use Utopia::Middleware::Requester
use Utopia::Middleware::DirectoryIndex

use Utopia::Session::EncryptedCookie, {
	:expire_after => 2592000,
	:secret => '018cc0c375fd4d789e640de988aaeafe'
}

use Utopia::Middleware::Controller

use Utopia::Middleware::Static, :types => Utopia::Middleware::Static::DEFAULT_TYPES + [
	["ogg", "audio/vorbis"]
]

if UTOPIA_ENV == :production
	use Rack::Cache, {
		:metastore   => "file:#{Utopia::Middleware::default_root("cache/meta")}",
		:entitystore => "file:#{Utopia::Middleware::default_root("cache/body")}",
		:verbose => false
	}
else
	#use Rack::Cache, {
	#	:verbose => true
	#}
end

use Utopia::Middleware::Content

run lambda { [404, {}, []] }

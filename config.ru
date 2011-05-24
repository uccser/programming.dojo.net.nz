#!/usr/bin/env rackup

UTOPIA_ENV = (ENV['UTOPIA_ENV'] || ENV['RAILS_ENV'] || :development).to_sym
$stderr.puts "Running in #{UTOPIA_ENV} mode on Ruby #{VERSION}."

gem 'utopia', '0.9.51'
require 'utopia/middleware/all'
require 'utopia/tags/all'

gem 'rack-contrib'
require 'rack/contrib'

gem 'rack-cache'
require 'rack/cache'

gem 'mail'
require 'mail'

Mail.defaults do
  delivery_method :smtp, { :enable_starttls_auto => false }
end

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

run lambda { [404, {}, []] }

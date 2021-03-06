#!/usr/bin/env rackup

require_relative 'config/environment'

require 'rack/freeze'
require 'utopia/analytics'

if RACK_ENV == :production
	# Handle exceptions in production with a error page and send an email notification:
	use Utopia::Exceptions::Handler
	use Utopia::Exceptions::Mailer
else
	# We want to propate exceptions up when running tests:
	use Rack::ShowExceptions unless RACK_ENV == :test
end

use Utopia::Static, root: 'public'

use Utopia::Redirection::Rewrite,
	'/' => '/welcome/index',
	'/python' => '/languages/python',
	'/scratch' => '/languages/scratch',
	'/ruby' => '/languages/ruby',
	'/c' => '/languages/c',
	'/java' => '/languages/java',
	'/c-sharp' => '/languages/c-sharp',
	'/scheme' => '/languages/scheme',
	'/basic' => '/languages/basic',
	'/swift' => '/languages/swift'

use Utopia::Redirection::DirectoryIndex

use Utopia::Redirection::Errors,
	404 => '/errors/file-not-found'

# require 'utopia/localization'
# use Utopia::Localization,
# 	default_locale: 'en',
# 	locales: ['en', 'de', 'ja', 'zh']

# require 'utopia/session'
# use Utopia::Session,
# 	expires_after: 3600 * 24,
# 	secret: ENV['UTOPIA_SESSION_SECRET'],
# 	secure: true

use Utopia::Controller

use Utopia::Static

# Serve dynamic content
use Utopia::Content,
	namespaces: {
		'analytics' => Utopia::Analytics
	}

run lambda { |env| [404, {}, []] }

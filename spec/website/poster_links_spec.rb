
require_relative '../website_context'

# Learn about best practice specs from http://betterspecs.org
RSpec.describe "poster links" do
	include_context "website"
	
	include_examples "valid page", '/python'
	include_examples "valid page", '/scratch'
	include_examples "valid page", '/ruby'
	include_examples "valid page", '/c'
	include_examples "valid page", '/java'
	include_examples "valid page", '/c-sharp'
	include_examples "valid page", '/scheme'
	include_examples "valid page", '/basic'
	include_examples "valid page", '/swift'
end

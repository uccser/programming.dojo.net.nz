
require 'rack/test'

RSpec.shared_context "website" do
	include Rack::Test::Methods
	
	let(:rackup_path) {File.expand_path('../config.ru', __dir__)}
	let(:rackup_directory) {File.dirname(rackup_path)}
	
	let(:app) {Rack::Builder.parse_file(rackup_path).first}
end

RSpec.shared_examples_for "valid page" do |path|
	it "can access #{path}" do
		get path
		
		while last_response.redirect?
			follow_redirect!
		end
		
		expect(last_response.status).to be == 200
	end
end
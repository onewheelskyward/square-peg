require_relative 'spec_helper'
describe "tests" do
	it "will run get_something and return for nothing" do
		get "/v1/i/popular"
		last_response.body.should == "get something"
	end
	it "will request instagram data for a location" do
		get "/v1/i/location", q: [lat => 1, long => 2]
		last_response.body.should == nil
	end
	it "will parse qualifiers" do
		z = "x;eq;z".parse_qualifiers
		puts z.inspect
	end
end

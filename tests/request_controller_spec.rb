require_relative 'spec_helper'
describe "tests" do
	it "will run get_something and return for nothing" do
		get "/popular"
		last_response.body.should == "get something"
	end
end

require 'httparty'

module Sinatra
	module Helpers
		def phone_instagram(endpoint, payload = nil)
			base_uri = "https://api.instagram.com/v1/"
			url = base_uri + endpoint
			request = RawRequest.create(method: 'GET', request_uri: url, payload: payload)
			response = HTTParty.get(base_uri + endpoint)
			request.response = response.to_json
			request.save
		end

		def parse_request_data
			# Todo handle empty request bodies
			request.body.rewind
			begin
				data = ::JSON.parse request.body.read
			rescue ::JSON::ParserError => e
				return false
			end
			data
		end
	end
	helpers Helpers
end

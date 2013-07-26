class RawRequest
	include DataMapper::Resource

	property :id, Serial
	property :method, String, length: 10
	property :request_uri, String
	property :payload, Text
	property :response, Text
	property :created_at, DateTime
end

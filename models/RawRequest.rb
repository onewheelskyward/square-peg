class RawRequest
	include DataMapper::Resource

	property :id, Serial
	property :method, String, length: 50	# GET POST PUT PATCH DELETE ETC
	property :type, Enum[:pubsub, :user]
	property :request_uri, String			# Full path including host, uri and query string.
	property :payload, Text					# The outgoing post payload, if used
	property :response, Text				# The response from Instagram.
	property :created_at, DateTime
end

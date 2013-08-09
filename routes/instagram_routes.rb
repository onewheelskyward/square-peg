
class App < Sinatra::Base
	get '/v1/i/popular' do
		get_popular
		#erb :basic, :locals => {local_erb_var: "xyz"}
	end
	get '/v1/i/location' do
		unless params[:lat] and params[:lng]
			halt 400, "lat and lng are required fields."
		end
		get_location_photos
	end
	get '/v1/i/geographies' do
		puts params.inspect
		puts "Gotta geography"
		params["hub.challenge"]
	end
	post '/v1/i/geographies' do
		puts params.inspect
		puts request.body.read.inspect
		request = parse_request_data
		request.each do |item|
			case item["object"]
				when "geography"
					latest = HTTParty.get("https://api.instagram.com/v1/geographies/#{item["object_id"]}/media/recent?client_id=522266753b364065aefa1fcad1f8c078")
					raw = RawRequest.create(type: :pubsub, method: "geographies", payload: latest.to_json)
					puts raw.valid?
					#puts latest.inspect
				when "tag"
					latest = HTTParty.get("https://api.instagram.com/v1/tags/#{item["object_id"]}/media/recent?client_id=522266753b364065aefa1fcad1f8c078")
					raw = RawRequest.create(type: :pubsub, method: "tags", payload: latest.to_json)
					puts raw.valid?
					#puts latest.inspect
			end
		end
		puts "Gotta geography post"
	end

	def fix_payload(payload)
		payload = payload.gsub /\=\>/, ':'
		payload.gsub /nil/, 'null'
	end

	get '/v1/i/geo' do
		images = []
		if x = RawRequest.all(type: :pubsub, method: 'geographies', order: [:id.desc], limit: 40)
			x.each do |request|
				y = JSON.parse fix_payload(request.payload)
				y['data'].each {|m| images.push m}
			end
		end
		erb :geo, :locals => {instagrams: images[0..100]}
	end

	get '/v1/i/tags/athletepath' do
		images = []
		if x = RawRequest.first(type: :pubsub, method: 'tags', order: [:id.desc])
			y = JSON.parse fix_payload(x.payload)
			images = y['data']
		end
		#urls.to_json
		erb :tags, :locals => {instagrams: images}
	end
end

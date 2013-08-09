
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
		case request["object"]
			when "geography"
				latest = HTTParty.get("https://api.instagram.com/v1/geographies/#{request["object_id"]}/media/recent?client_id=522266753b364065aefa1fcad1f8c078")
				puts latest.inspect
			when "tag"
				latest = HTTParty.get("https://api.instagram.com/v1/tags/#{request["object_id"]}/media/recent?client_id=522266753b364065aefa1fcad1f8c078")
				puts latest.inspect
		end
		puts "Gotta geography post"
	end
end

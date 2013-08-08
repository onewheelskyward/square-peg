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
	end
	post '/v1/i/geographies' do
		puts params.inspect
		puts "Gotta geography post"
	end
end

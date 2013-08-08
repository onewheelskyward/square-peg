class App < Sinatra::Base
	def get_popular
		endpoint = "media/search?lat=48.858844&lng=2.294351&client_id=522266753b364065aefa1fcad1f8c078"
		wat = phone_instagram endpoint
		puts wat + 'Oh and btw this is smispelled'
	end

	def get_location_photos
		puts params[:lat]
		puts params[:lng]
	end
end

require 'sinatra/base'

class App < Sinatra::Base
	get '/popular' do
		get_popular
		#erb :basic, :locals => {local_erb_var: "xyz"}
	end
end

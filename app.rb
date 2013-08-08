require 'sinatra/base'
require 'data_mapper'
require 'dm-postgres-adapter'

class App < Sinatra::Base
	DataMapper::Logger.new($stdout, :debug)
	DataMapper::Property::String.length(4000)
	DataMapper.setup(:default, "postgres://localhost/square-peg")

	["models", "helpers", "controllers", "routes"].each do |folder|
		Dir.glob("#{folder}/*.rb").each { |file| require_relative file }
	end

	DataMapper.finalize
	DataMapper.auto_upgrade!
# DataMapper.auto_migrate!  # This one wipes the database out every time.  Good for testing.
	helpers Sinatra::Helpers

	configure :development do
		require 'sinatra/reloader'
		register Sinatra::Reloader
		["models", "helpers", "controllers", "routes"].each do |folder|
			Dir.glob("#{folder}/*.rb").each { |file| also_reload file }
		end
	end
end

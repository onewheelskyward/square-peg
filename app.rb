require 'sinatra'
require "sinatra/reloader" if development?
require 'data_mapper'
require 'dm-postgres-adapter'
require_relative 'helpers'

DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(4000)
DataMapper.setup(:default, "postgres://localhost/square-peg")

Dir.glob("models/*.rb").each { |file| require_relative file }

DataMapper.finalize
DataMapper.auto_upgrade!
# DataMapper.auto_migrate!  # This one wipes the database out every time.  Good for testing.

class App < Sinatra::Base
	get '/' do
		erb :basic, :locals => {local_erb_var: "xyz"}
	end
end

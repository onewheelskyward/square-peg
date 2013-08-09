require 'sinatra/base'
require 'sinatra/config_file'
require 'data_mapper'
require 'dm-postgres-adapter'
require 'json'

class App < Sinatra::Base
	DataMapper::Property::String.length(4000)
	# Register the config file.
	config_file = File.dirname(__FILE__) + "/config/config.yml"
	unless File.exist? config_file
		puts "Auto-copying config distribution file to active config"
		system "cp #{config_file}.dist #{config_file}"
	end
	register Sinatra::ConfigFile
	config_file config_file

	configure :development do
		require "sinatra/reloader"	# First, a couple of dev-only requires
									  # Automatic reloading of files in the dev environment.  Otherwise, it requires an app restart.
		register Sinatra::Reloader
		["models", "helpers", "controllers", "routes"].each do |folder|
			Dir.glob("#{folder}/*.rb").each { |file| require_relative file }
		end
		#DataMapper::Model.raise_on_save_failure = true
		enable :logging, :dump_errors
	end

	# Database Setup
	server_connection_string = "#{settings.db_server}"
	if settings.db_user
		server_connection_string = "#{settings.db_user}:#{settings.db_password}@#{server_connection_string}"
	end

	if settings.debug
		DataMapper::Logger.new($stdout, :debug)
	end

	DataMapper.setup(:default, "postgres://#{server_connection_string}/#{settings.db}")
	DataMapper.finalize
	DataMapper.auto_upgrade!
# DataMapper.auto_migrate!  # This one wipes the database out every time.  Good for testing.
	helpers Sinatra::Helpers
end

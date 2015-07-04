set :stages, %w(local development staging production)
set :default_stage, 'development'

require 'capistrano/ext/multistage'

app_dir = "~/apps/square-peg"
set :deploy_to,		app_dir
set :application,	"square-peg"
set :repository,	"git@github.com:onewheelskyward/square-peg"
#set :unicorn_pid,	"#{app_dir}/shared/pids/unicorn.pid"
set :ssh_options,	{ forward_agent: true }  # , port: 1227
set :deploy_via,	:remote_cache
set :branch,		'master'
set :user,			'ec2-user'
set :use_sudo,		false

# Rids us of a number of annoying errors.
set :normalize_asset_timestamps, false

# Superceded by capistrano multistage.
#role :web, "server"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

namespace :squarepeg do
	task :create_symlink do
		run "ln -s #{fetch(:deploy_to)}/shared/config.yml #{fetch(:deploy_to)}/current/config/config.yml"
	end
	# task :restart_unicorn do
	# 	run "~/.rbenv/shims/ruby ~/unicorn_graceful.rb"
	# end
	task :bundle_install do
		run "cd #{fetch(:deploy_to)}/current ; ~/.rbenv/shims/gem install bundler ; ~/.rbenv/shims/bundle install ; ~/.rbenv/bin/rbenv rehash"
	end
	task :git_tag do  # Create a nice environment-date-time tag for the release.
		date = nil
		environment = fetch(:stage).to_s

		unless fetch(:stages).include? environment
			raise Exception.new("#{environment} is not a valid environment")
		end

		IO.popen("git log -n 1 --date=iso") do |git_log|
			git_log.each do |line|
				if line =~ /Date:\s+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/
					date = $1.gsub /:/, "-"
					date.gsub! /\s+/, "-"
				end
			end
		end
		tag = "#{environment}-#{date}"

		unless date =~ /^(\d{4}\-\d{2}\-\d{2}-\d{2}\-\d{2}\-\d{2})$/
			raise Exception.new("#{date_str} is an invalid date string.")
		end

		system "git tag #{tag}"
		system "git push origin --tags"
	end
end

after "deploy:restart", "deploy:cleanup"
after "deploy:create_symlink", "squarepeg:create_symlink"
after "squarepeg:create_symlink", "squarepeg:bundle_install"
after "deploy:cleanup", "squarepeg:git_tag"

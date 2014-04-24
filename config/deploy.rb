load 'deploy/assets'
require 'bundler/capistrano' #for bundler support
require 'sidekiq/capistrano'

set(:sidekiq_cmd) { "bundle exec sidekiq" }
set(:sidekiqctl_cmd) { "bundle exec sidekiqctl" }
set(:sidekiq_timeout) { 10 }
set(:sidekiq_role) { :app }
set(:sidekiq_pid) { "#{current_path}/tmp/pids/sidekiq.pid" }
set(:sidekiq_processes) { 1 }

set :application, "gemify-js"
set :repository,  "git@github.com:wontaeyang/ilovejs.git"

set :user, 'gemify'
set :deploy_to, "/home/#{ user }/#{ application }"
set :use_sudo, false
# set :bundle_cmd, 'sudo bundle'

set :scm, :git
set :default_shell, '/bin/bash -l'
default_run_options[:pty] = true
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "107.170.47.187"                          # Your HTTP server, Apache/etc
role :app, "107.170.47.187"                          # This may be the same as your `Web` server
role :db,  "107.170.47.187", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
before "deploy:assets:precompile","deploy:config_symlink"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

   task :config_symlink do
    run "cp #{shared_path}/database.yml #{release_path}/config/database.yml"
    run "cp #{shared_path}/application.yml #{release_path}/config/application.yml"
  end

end



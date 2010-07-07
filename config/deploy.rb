set :stages, %w(jeugdzorg zorgaanbieder)
require 'capistrano/ext/multistage'

set :application, "antorcha"

set :rails_env, 'production'

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:thebeanmachine/antorcha.git"  # Your clone URL
set :scm, "git"
#set :scm_passphrase, "p@ssw0rd"  # The deploy user's password

set :branch, "maint"
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, 'deploy'
set :ssh_options, { :forward_agent => true, :keys => [
  File.join(ENV["HOME"], ".ssh", "deploy_id_rsa"),
  File.join(ENV["HOME"], ".ssh", "antorcha_id_rsa")
]}
set :use_sudo, false

role :web, "thebeanmachine.nl"                          # Your HTTP server, Apache/etc
role :app, "thebeanmachine.nl"                          # This may be the same as your `Web` server
role :db,  "thebeanmachine.nl", :primary => true # This is where Rails migrations will run

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :database do
  desc "copy shared configurations to current"
  task :symlink, :roles => [:app] do
    run "mkdir -p #{shared_path}/databases"
    run "ln -nfs #{shared_path}/databases #{release_path}/db/shared"
  end
end

namespace :rails do

  namespace :db do
    desc "Seed the database"
    task :seed, :roles => :db do
      run "cd #{latest_release} && rake RAILS_ENV=production db:seed"
    end
  end

  namespace :gems do
    desc "Install rails"
    task :rails, :roles => :app do
      run "gem install rails -v 2.3.8"
    end
    
    desc "Install gems"
    task :install, :roles => :app do
      run "cd #{release_path} && rake RAILS_ENV=production gems:install"
    end
  end
end

after "deploy:migrate","rails:db:seed"
after "deploy:setup","rails:gems:rails"
after "deploy:update_code","database:symlink"
after "deploy:update_code","rails:gems:install"



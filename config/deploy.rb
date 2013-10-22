set :application, "test_deploy"
set :repository,  "git@github.com:lnr91/test_deploy.git"
set :deploy_to, "/home/vagrant/test_deploy"
set :scm, :git
set :branch, "master"
set :user, "vagrant"
set :rails_env, "production"
set :deploy_via, :copy
set :ssh_options, {:forward_agent=>true}
default_run_options[:pty] = true
server "10.123.61.15", :app, :web, :db, :primary => true
before "deploy","deploy:checkit"
after "deploy:update_code","deploy:bundle_install"
set :default_environment, {
  'PATH' => "/opt/rbenv/shims:$PATH"
}
set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

=begin
role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
role :db,  "your slave db-server here"
=end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
   task :checkit do
     run "which ruby"
    end

	task :bundle_install do
		run "cd /var/www/test_deploy/current;bundle install"
	end
	task :after_symlink do
		run "cd /var/www/test_deploy/current;bundle install"
	end

end


# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do
      run "cd /home/vagrant/test_deploy/current; bundle exec unicorn_rails -c /tmp/unicorn.pid -D"   
  end
#   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
      run "cd /home/vagrant/test_deploy/current; bundle exec unicorn_rails -c /tmp/unicorn.pid -D"   
   end 
 end

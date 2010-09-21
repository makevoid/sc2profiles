set :application, "sc2profiles"

set :domain,      "sc2profiles.makevoid.com"

#set :repository,  "svn://#{domain}/svn/#{application}"
default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:makevoid/sc2profiles.git"  # Your clone URL
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user,        "www-data"

set :deploy_to,   "/www/#{application}"

set :use_sudo,    false


# set :scm_username, "makevoid"
# set :scm_password, File.read("/home/www-data/.password").strip

role :app, domain
role :web, domain
role :db,  domain, :primary => true




after :deploy, "deploy:cleanup"
#after :deploy, "db:seeds"
#after :deploy, "symlink:munin"
#after :deploy, "symlink:object_cache"
# after :deploy, "chmod:munin"
# after :deploy, "chmod:object_cache"

namespace :deploy do
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
end

namespace :bundle do
  desc "Install gems with bundler"
  task :install do
    run "cd #{current_path}; bundle install --relock"
  end
  
  desc "Commit, deploy and install"
  task :installscom do
    `svn commit -m ''`
    `cap deploy`
    `cap bundle:install`
  end
end

# ...

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end

# HOOKS
after "deploy:update_code" do
  bundler.bundle_new_release
  # ...
end

R_ENV = "RACK_ENV"

namespace :scraper do
  desc "Run the scraper"
  task :scrape do
    run "cd #{current_path}; #{R_ENV}=production bundle exec rake scraper:scrape --trace"
  end
end


namespace :db do
  desc "Create database"
  task :create do
    run "mysql -u root --password=final33man -e 'CREATE DATABASE IF NOT EXISTS #{application}_production;'"
  end
  
  desc "Seed database"
  task :seeds do
    run "cd #{current_path}; #{R_ENV}=production rake db:seeds"
  end
  
  desc "Migrate database"
  task :seeds do
    run "cd #{current_path}; #{R_ENV}=production rake db:automigrate"
  end
  
  desc "Send the local db to production server"
  task :toprod do
    # `rake db:seeds`
    `mysqldump -u root #{application}_development > db/#{application}_development.sql`
    upload "db/#{application}_development.sql", "#{current_path}/db", :via => :scp
    run "mysql -u root --password=final33man #{application}_production < #{current_path}/db/#{application}_development.sql"
  end
  
  desc "Get the remote copy of production db"
  task :todev do
    run "mysqldump -u root --password=final33man #{application}_production > #{current_path}/db/#{application}_production.sql"
    download "#{current_path}/db/#{application}_production.sql", "db/#{application}_production.sql"
    local_path = `pwd`.strip
    `mysql -u root #{application}_development < #{local_path}/db/#{application}_production.sql`
  end
end

namespace :symlink do
  
  desc "create folders in /shared"
  task :create_folders do
    run "mkdir -p #{deploy_to}/shared/object_cache"
    run "mkdir -p #{deploy_to}/shared/munin"
  end
  
  desc "set permissions for munin"
  task :munin do
    run "cd #{current_path}/public; ln -s #{deploy_to}/shared/munin munin"
    #run "/etc/init.d/munin-node restart"
  end
  
  desc "set permissions for object_cache"
  task :object_cache do
    run "cd #{current_path}/tmp/cache; ln -s #{deploy_to}/shared/object_cache object_cache"
  end
end

namespace :chmod do

  
  # desc "set permissions for munin"
  # task :munin do
  #   
  #   # set :use_sudo,    true
  #   #     set :user, "root"
  #   run "cd #{current_path}; chown -R munin:munin public/munin"
  #   run "/etc/init.d/munin-node restart"
  # end
  
  # desc "set permissions for object_cache"
  # task :object_cache do
  #   run "cd #{current_path}; chown -R www-data:www-data tmp/cache/object_cache"
  # end
end
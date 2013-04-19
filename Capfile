load 'deploy'

default_run_options[:pty] = true

set :application, "repara-clujul"
set :repository,  "git@simpson:repara-clujul"
set :user, "anakin"
set :use_sudo, false
set :branch, "staging"
ssh_options[:forward_agent] = true
set :rvm_ruby_string, '1.9.3@repara-clujul2'

server "192.168.0.51", :app, :primary => true
set :deploy_to, '/home/anakin/repara-clujul'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

namespace :repara do
  task :start, :roles => :app do
    run 'cd repara-clujul/current/; bundle install; thin -C thin.yml start'
  end

  task :stop, :roles => :app, :on_error => :continue do
    run 'cd repara-clujul/current/;thin -C thin.yml stop'
  end
end

before 'deploy', 'repara:stop'
after 'deploy', 'repara:start'

require 'rvm/capistrano'

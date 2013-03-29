load 'deploy'

default_run_options[:pty] = true

set :application, "repara-clujul"
set :repository,  "git@simpson:repara-clujul"
set :user, "anakin"
set :use_sudo, false
ssh_options[:forward_agent] = true
set :rvm_ruby_string, '1.9.3@repara-clujul2'

server "192.168.0.51", :app, :primary => true
set :deploy_to, '/home/anakin/repara-clujul'

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

namespace :repara do
  task :test2, :roles => :app do
    run 'whoami'
    run 'pwd'
    run 'cd repara-clujul/current/; gem list'
  end
end

require 'rvm/capistrano'

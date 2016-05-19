role :app, %w{ubuntu@52.17.17.4}
role :web, %w{ubuntu@52.17.17.4}
role :db,  %w{ubuntu@52.17.17.4}

set :deploy_to, '/home/ubuntu/repara-clujul-server-rails'

set :ssh_options, {
  user: "ubuntu",
  keys: %w(./tkw-aws-cityreport.pem),
  forward_agent: false
}

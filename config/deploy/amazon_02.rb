role :app, %w{ubuntu@52.18.14.207}
role :web, %w{ubuntu@52.18.14.207}
role :db,  %w{ubuntu@52.18.14.207}

set :repo_url, 'git@bitbucket.org:cmess110/repara-clujul-server.git'
set :deploy_to, '/home/ubuntu/repara-clujul-server-rails'

set :ssh_options, {
  user: "ubuntu",
  keys: %w(/work/repara-clujul-server/tkw-aws-cityreport.pem),
  forward_agent: false,
}

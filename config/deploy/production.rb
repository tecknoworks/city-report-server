role :app, %w{ubuntu@54.76.56.77}
role :web, %w{ubuntu@54.76.56.77}
role :db,  %w{ubuntu@54.76.56.77}

set :repo_url, 'git@bitbucket.org:cmess110/repara-clujul-server.git'
set :deploy_to, '/home/ubuntu/repara-clujul-server-rails'

set :ssh_options, {
  user: "ubuntu",
  keys: %w(/work/repara/tkw-aws-cityreport.pem),
  forward_agent: false,
}

role :app, %w{croco@192.168.0.15}
role :web, %w{croco@192.168.0.15}
role :db,  %w{croco@192.168.0.15}

set :repo_url, 'git@gitlab.st.st2k.ro:repara/repara-clujul-server.git'
set :deploy_to, '/home/croco/repara-clujul-server-rails'

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'repara-clujul-server-rails'
set :repo_url, 'git@gitlab.st.st2k.ro:repara/repara-clujul-server.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
set :branch, 'rails4'

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/croco/repara-clujul-server-rails'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/images/uploads/thumb public/images/uploads/original}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rvm_ruby_version, `cat .ruby-version`.chomp + '@' + `cat .ruby-gemset`.chomp

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :compile_assets_and_restart_sidekiq do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'assets:precompile'
        execute :rake, 'sidekiq:restart'
      end
    end
  end

end

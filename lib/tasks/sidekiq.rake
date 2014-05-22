namespace :sidekiq do
  desc "restart sidekiq. used for deployment"
  task :restart do
    pid_path = 'tmp/pids/sidekiq.pid'

    FileUtils.touch pid_path
    begin
      Process.kill 'TERM', File.read(pid_path).to_i
    rescue
      puts 'no tears'
    end

    cmd = "bundle exec sidekiq -d -e production -L #{Rails.root}/log/sidekiq.log -P #{Rails.root}/#{pid_path}"
    system cmd
  end
end

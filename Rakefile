require 'rspec/core/rake_task'
require 'coffee-script'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :sidekiq do
  desc "restart sidekiq. used in deployment"
  task :restart do
    pid_path = 'tmp/pids/sidekiq.pid'

    FileUtils.touch pid_path
    begin
      Process.kill 'TERM', File.read(pid_path).to_i
    rescue
      puts 'no tears'
    end

    cmd = "bundle exec sidekiq -d -e production -L #{Dir.pwd}/log/sidekiq.log -P #{Dir.pwd}/#{pid_path} -r #{Dir.pwd}/app/app.rb"
    system cmd
  end
end

namespace :compile do
  desc "compile sass and coffee to css and js for production. used in deployment"
  task :assets do
    `sass "app/assets/sass/style.sass" "public/stylesheets/style.css"`

    ['app/assets/coffee/app.coffee'].each do |filename|
      coffee = CoffeeScript.compile(File.open(filename))
      File.open('public/javascripts/app.js', 'w') {|f| f.write(coffee)}
    end
  end
end

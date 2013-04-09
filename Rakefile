require 'rspec/core/rake_task'

desc "run specs"
RSpec::Core::RakeTask.new

task :default => 'spec'

namespace :db do
  desc "seed data"
  task :seed do
    puts `pwd`
  end
end

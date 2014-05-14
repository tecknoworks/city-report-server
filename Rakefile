require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :compile do
  task :assets do
    `sass "app/assets/sass/style.sass" "public/stylesheets/style.css"`
  end
end

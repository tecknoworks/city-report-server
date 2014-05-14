require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :compile do
  task :assets do
    puts 'Compiling assets'
    `sass "app/assets/sass/style.sass" "public/stylesheets/style.css"`
    `coffee -c --output public/javascripts/ app/assets/coffee/*.coffee`
  end
end

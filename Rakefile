require 'rspec/core/rake_task'
require 'coffee-script'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :compile do
  task :assets do
    `sass "app/assets/sass/style.sass" "public/stylesheets/style.css"`

    Dir['app/assets/coffee/*.coffee'].each do |filename|
      CoffeeScript.compile(File.open(filename), output: 'public/javascripts')
    end
  end
end

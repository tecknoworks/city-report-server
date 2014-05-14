require 'rspec/core/rake_task'
require 'coffee-script'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :compile do
  task :assets do
    `sass "app/assets/sass/style.sass" "public/stylesheets/style.css"`

    ['app/assets/coffee/app.coffee'].each do |filename|
      coffee = CoffeeScript.compile(File.open(filename))
      File.open('public/javascripts/app.js', 'w') {|f| f.write(coffee)}
    end
  end
end

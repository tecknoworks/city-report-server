notification :off

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end

guard 'sass', :input => 'app/assets/sass', :output => 'public/stylesheets'

guard 'coffeescript', :input => 'app/assets/coffee', :output => 'public/javascripts'

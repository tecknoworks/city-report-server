namespace :jenkins do
  desc "run tests + security scan"
  task :acceptance do
    puts 'Running tests'
    `rspec --format h > test_report.html`
    puts 'Generating security report'
    `brakeman -o security_report.html`
    puts 'Done'
  end
end

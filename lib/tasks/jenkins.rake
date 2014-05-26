namespace :jenkins do
  desc "run tests + security scan"
  task :acceptance do
    puts 'Generating code quality report'
    `bundle exec rails_best_practices --output-file code_quality_report.html -f html .`
    puts 'Running tests'
    `bundle exec rspec --format h > test_report.html`
    puts 'Generating security report'
    `bundle exec brakeman -o security_report.html`
    puts 'Done'
  end
end

namespace :jenkins do
  desc "run tests + security scan"
  task :acceptance do
    puts 'Generating code quality report'
    `bundle exec rails_best_practices --output-file code_quality_report.html -f html .`

    puts 'Generating code to test ratio'
    code_2_test_report_name = 'code_to_test_report.html'
    `echo "<pre>" > #{code_2_test_report_name} && rake stats >> #{code_2_test_report_name} && echo "</pre>" >> #{code_2_test_report_name}`

    puts 'Running tests'
    `bundle exec rspec --format h > test_report.html`

    puts 'Generating security report'
    `bundle exec brakeman -o security_report.html`

    puts 'Done'
  end
end

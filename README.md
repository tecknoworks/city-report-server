== README

To get an overview of the system check out the UML diagram.

Daily jobs:

# code to test ratio - http://jenkins.st.st2k.ro/job/test%20repara-clujul-server/ws/code_to_test_report.html
# tests - http://jenkins.st.st2k.ro/job/test%20repara-clujul-server/ws/test_report.html
# code quality - http://jenkins.st.st2k.ro/job/test%20repara-clujul-server/ws/code_quality_report.html
# security report - http://jenkins.st.st2k.ro/job/test%20repara-clujul-server/ws/security_report.html

== Requirements

rvm (recommended but not required)
ruby 2.1.1
graphicsmagic
git
mongodb
redis
apache2
passenger (comes with the code)
sidekiq (comes with the code)

== Deployment

Capistrano is used for deployment.

cap production deploy
cap staging deploy

== Run tests

rake spec

== Services

To start the thumbnail generation service/geocoder

rake sidekiq:restart

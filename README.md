repara-clujul-server
====================

Requirements
------------

* rvm (optional but recommended)
* ruby 2.1.1
* mongodb
* redis-server
* graphicsmagick
* git

Install
-------

  git clone git@gitlab.st.st2k.ro:repara/repara-clujul-server
  cd repara-clujul-server
  bundle install

To start the *development* enviornment run

  foreman start

This will start the webserver, sidekiq and guard. sidekiq uses redis for
background queue processing. guard is used for running the tests and compiling
the assets (sass and coffee)

Assets are compiled with

  rake compile:assets

Deployment
----------

  cap production deploy

This will automcatically compile the assets on the selected enviornment and restart sidekiq.
Passenger is also restarted.

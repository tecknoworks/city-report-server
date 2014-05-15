repara-clujul-server
====================

Requirements
------------

sudo apt-get install mongodb redis-server graphicsmagick

Get started
-----------

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

repara-clujul-server
====================

Requirements
------------

sudo apt-get install mongodb redis-server graphicsmagick

mongodb (data storage)
redis (for queue processing)
micro_magick for thumbnail generation

foreman start

guard -n f

touch tmp/restart.txt

bundle exec sidekiq -e production -r ./app/app.rb

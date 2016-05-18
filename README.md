City Report
===========

An application which allows people to report problems in their city.

To get an overview of the system check out the [UML diagrams](uml/).

Requirements
------------

* rvm (recommended but not required)
* ruby 2.1.1
* graphicsmagic
* git
* mongodb
* redis
* apache2
* passenger (comes with the code)
* sidekiq (comes with the code)

Deployment
----------

Capistrano is used for deployment.

```
cap production deploy
cap staging deploy
```

Run tests
---------

```
rake spec
```

```
guard
```

Coding style
------------

TODO: check with rubocop

https://github.com/bbatsov/ruby-style-guide

Services
--------

Long running tasks are taken care of by Sidekiq:

* thumbnail generation
* geocoding

To start/restart:

```
rake sidekiq:restart
```

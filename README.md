Repara Clujul API
=================

NOTE: make sure you set Content-Type:application/json header whenever you
make a request

NOTE: HTTP status codes matter. 200 means ok

NOTE: when creating an issue, if lat and lon are set (and != 0 ), address gets geocoded

---

Sample Issue
============

    {
      "lat": "0.0",
      "lon": "0.0",
      "title": "groapa in centru",
      "description": "bla bla bla description",
      "comments": [
        "bla bla this is bad", "yea this is bad"
      ],
      "categories": [
        "fixed", "groapa"
      ],
      "videos": [
      ],
      "images": [
        "http://reparaclujul.st2k.net/images/foo.png"
      ],
      "created_at": "2013-04-17 16:27:05 +0300",
      "updated_at": "2013-04-17 16:27:05 +0300"
    }

---

Sample Error
============

Status code is the same as the code in the hash

    {
      "code":400,
      "message":"error message"
    }

---

Requests
========

__GET '/issues'__

    [
      {
        "lat": "0.0",
        "lon": "0.0",
        "title": "hello world",
        "id": "515979d74fe3984859000001"
      },
      {
        "lat": "0.0",
        "lon": "0.0",
        "title": "hello world",
        "id": "515979df4fe398488d000001"
      }
    ]

---

__POST '/issues'__

_requires 'lat', 'lon', 'title'_

returns the issue (see __Sample issue__)

---

__PUT '/issues'__
_require 'lat', 'lon', 'title', 'id'_

returns the issue (see __Sample issue__)

---

__PUT '/add_to'__
_requires 'id', 'key', 'value'_

returns the issue (see __Sample issue__)

---

__DELETE '/issues'__

---

__POST '/images'__
_requires 'image', 'id'_

  { "url": "/system/uploads/1.png" }

---

__GET '/meta'__

_returns json_

{
  "attributes" => ["id", "lat", "lon", "etc"]
  "categories" => ["gunoi", "groapa"]
}

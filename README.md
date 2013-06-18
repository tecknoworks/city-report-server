NOTE: make sure you set Content-Type:application/json header whenever you
make a request
NOTE: HTTP status codes matter. 200 means ok
NOTE: when creating an issue, if lat and lon are set (and != 0 ), address gets geocoded

Sample issue:

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

ISSUE REQUESTS =================================================================

GET '/issues'
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

POST '/issues'
requires 'lat', 'lon', 'title'
on success:
  {
    "id": "your id"
    "all": "your attributes"
  }
on error:
  {
    "code":400,
    "message":"error message"
  }

PUT '/issues'
require 'lat', 'lon', 'title', 'id'
same responses as POST

PUT '/add_to'
requires 'id', 'key', 'value'
on success:
  the issue as json
on error:
  {
    "code":400,
    "message":"error message"
  }


DELETE '/issues'

IMAGE UPLOAD REQUESTS ==========================================================

POST '/images'
requires 'image'
on success:
  { "url": "/system/uploads/1.png" }
on error:
  {
    "code":400,
    "message":"error message"
  }

ATTRIBUTES REQUEST ============================================================
GET '/attributes'
returns json
{
  "attributes" => ["id", "lat", "lon", "etc"]
  "categories" => ["gunoi", "groapa"]
}

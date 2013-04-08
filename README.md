NOTE: make sure you set Content-Type:application/json header whenever you
make a request
NOTE: HTTP status codes matter. 200 means ok

Sample issue:

{
  "lat": "0.0",
  "lon": "0.0",
  "title": "groapa in centru",
  "categories": [
    "fixed", "groapa"
  ],
  "youtube": [
  ],
  "images": [
    "http://reparaclujul.st2k.net/images/foo.png"
  ]
}

REQUESTS ======================================================================

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

DELETE '/issues'

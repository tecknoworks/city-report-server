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
    "code":200,
    "message":"success"
  }
on error:
  {
    "code":400,
    "message":"error message"
  }

Note: also HTTP status code will be 400 in case of error

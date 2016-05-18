app.factory 'CityReportFactory', ['$http', '$q', ($http, $q)->
  self = @

  self.meta = {}

  getIssues = ->
    deffered = $q.defer()
    $http(method: 'GET', url: '/issues.json').then((response) ->
      deffered.resolve response.data
    )
    deffered.promise

  updateMeta = ->
    deffered = $q.defer()
    $http(method: 'GET', url: '/meta').then((response) ->
      data = response.data.body
      self.meta = data
      self.meta.map_center.latitude = self.meta.map_center.lat
      self.meta.map_center.longitude = self.meta.map_center.lon

      deffered.resolve self.meta
    , (response) ->
      deffered.reject(response)
    )
    deffered.promise

  {
    updateMeta: updateMeta
    getIssues: getIssues
  }
]

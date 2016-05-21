app.factory 'CityReportFactory', ['$http', '$q', ($http, $q)->
  self = @

  self.meta = {}

  getIssues = ->
    deffered = $q.defer()
    $http(method: 'GET', url: '/issues.json?limit=1000').then((response) ->
      deffered.resolve response.data
    )
    deffered.promise

  upvote = (issue) ->
    deffered = $q.defer()
    $http(method: 'POST', url: "/issues/#{issue._id}/vote.json").then((response) ->
      deffered.resolve response.data
    )
    deffered.promise

  update = (json) ->
    deffered = $q.defer()
    $http(method: 'POST', url: "/issues.json", data: JSON.stringify(json)).then((response) ->
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

      self.meta.checked_categories = {}
      for category in self.meta.categories
        self.meta.checked_categories[category] = true

      deffered.resolve self.meta
    , (response) ->
      deffered.reject(response)
    )
    deffered.promise

  {
    updateMeta: updateMeta
    getIssues: getIssues
    upvote: upvote
    update: update
  }
]

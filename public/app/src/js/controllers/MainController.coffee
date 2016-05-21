MainController = ($scope, $rootScope, $location, $mdToast, $mdSidenav, $mdBottomSheet, $log, $q, CityReportFactory, uiGmapGoogleMapApi) ->
  $scope.goTo = (url) ->
    $location.path url

  $scope.toast = (text) ->
    $mdToast.show(
      $mdToast.simple()
        .content(text)
        .position('bottom right')
        .hideDelay(3000)
    )

  $scope.toggleList = (nav = 'left') ->
    pending = $mdBottomSheet.hide() or $q.when(true)
    pending.then ->
      $mdSidenav(nav).toggle()

  $scope.openList = (nav = 'left') ->
    $mdSidenav(nav).open()

  $scope.closeList = (nav = 'left') ->
    $mdSidenav(nav).close()

  $scope.swipeLeft = ->
    $scope.map.window.model.previewIndex += 1
    if $scope.map.window.model.previewIndex >= $scope.map.window.model.json.images.length
      $scope.map.window.model.previewIndex = 0

  $scope.swipeRight = ->
    $scope.map.window.model.previewIndex -= 1
    if $scope.map.window.model.previewIndex < 0
      $scope.map.window.model.previewIndex = $scope.map.window.model.json.images.length - 1

  $scope.getVoteText = (count) ->
    if count == 1
      "#{count} vote"
    else
      "#{count} votes"

  $scope.upvote = (json) ->
    json.vote_counter += 1
    CityReportFactory.upvote(json).then(->
      $scope.toast('thank you for your vote')
    )

  $scope.setCategory = (category) ->
    $rootScope.map.window.model.json.category = category
    $rootScope.map.window.model.icon = $scope.getIconForIssue(category: category)

  $scope.save = (model) ->
    model.json.device_id = 'web'
    CityReportFactory.update(model.json).then (data) ->
      json = data.body
      model.id = json._id
      model.json = json

  $scope.isValid = (json) ->
    return false unless json?
    json.name && json.category

  $scope.getIconForIssue = (issue) ->
    "assets/png/#{issue.category}.png"

  $rootScope.useCurrentGpsPosition = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (position) ->
        lat = position.coords.latitude
        lon = position.coords.longitude
        $rootScope.map.center.latitude = lat
        $rootScope.map.center.longitude = lon
        $rootScope.map.window.model.latitude = lat
        $rootScope.map.window.model.longitude = lon
        $rootScope.map.window.model.json.lat = lat
        $rootScope.map.window.model.json.lon = lon
        $rootScope.$apply()
    else
      $scope.toast 'Geolocation is not supported.'

  base = "//#{$location.host()}:#{$location.port()}"
  $rootScope.map =
    center:
      latitude: 46.768322
      longitude: 23.595002
    zoom: 15
    fit: false
    doCluster: false
    markers: []
    events:
      click: (map, eventName, args) ->
        newMarker =
          id: 'new'
          previewIndex: 0
          json: {
            name: ''
            status: 'unresolved'
            updated_at: new Date()
            images: [{
              url: "#{base}/app/build/assets/png/camera_placeholder.png"
            }]
          }

        found = (item for item in $rootScope.map.markers when item.id is 'new')[0]
        unless found?
          $rootScope.map.markers.push newMarker
          found = newMarker

        found.latitude = args[0].latLng.lat()
        found.longitude = args[0].latLng.lng()
        found.json.lat = found.latitude
        found.json.lon = found.longitude

        $rootScope.map.window.model = found
        # $scope.openList('left')

        $rootScope.$digest()

      tilesloaded: (map) ->
        $scope.$apply(->
          $rootScope.mapInstance = map
        )
    markersEvents:
      click: (marker, eventName, model, args) ->
        $rootScope.map.window.model = model
        $scope.openList('left')
    window:
      marker: {}
      show: false
      options:
        pixelOffset:
          width: 0
          height: -40
      closeOnClick: ->
        @show = false
    options:
      mapTypeControl: false
      zoomControl: false
      zoomControlOptions:
        position: 6 # LEFT_BOTTOM
      streetViewControl: false
      streetViewControlOptions:
        position: 6 # LEFT_BOTTOM
      styles:
        [
          {
            'featureType': 'administrative.locality'
            'elementType': 'all'
            'stylers': [
              { 'hue': '#2c2e33' }
              { 'saturation': 7 }
              { 'lightness': 19 }
              { 'visibility': 'on' }
            ]
          }
          {
            'featureType': 'landscape'
            'elementType': 'all'
            'stylers': [
              { 'hue': '#ffffff' }
              { 'saturation': -100 }
              { 'lightness': 100 }
              { 'visibility': 'simplified' }
            ]
          }
          {
            'featureType': 'poi'
            'elementType': 'all'
            'stylers': [
              { 'hue': '#ffffff' }
              { 'saturation': -100 }
              { 'lightness': 100 }
              { 'visibility': 'off' }
            ]
          }
          {
            'featureType': 'road'
            'elementType': 'geometry'
            'stylers': [
              { 'hue': '#bbc0c4' }
              { 'saturation': -93 }
              { 'lightness': 31 }
              { 'visibility': 'simplified' }
            ]
          }
          {
            'featureType': 'road'
            'elementType': 'labels'
            'stylers': [
              { 'hue': '#bbc0c4' }
              { 'saturation': -93 }
              { 'lightness': 31 }
              { 'visibility': 'on' }
            ]
          }
          {
            'featureType': 'road.arterial'
            'elementType': 'labels'
            'stylers': [
              { 'hue': '#bbc0c4' }
              { 'saturation': -93 }
              { 'lightness': -2 }
              { 'visibility': 'simplified' }
            ]
          }
          {
            'featureType': 'road.local'
            'elementType': 'geometry'
            'stylers': [
              { 'hue': '#e9ebed' }
              { 'saturation': -90 }
              { 'lightness': -8 }
              { 'visibility': 'simplified' }
            ]
          }
          {
            'featureType': 'transit'
            'elementType': 'all'
            'stylers': [
              { 'hue': '#e9ebed' }
              { 'saturation': 10 }
              { 'lightness': 69 }
              { 'visibility': 'on' }
            ]
          }
          {
            'featureType': 'water'
            'elementType': 'all'
            'stylers': [
              { 'hue': '#e9ebed' }
              { 'saturation': -78 }
              { 'lightness': 67 }
              { 'visibility': 'simplified' }
            ]
          }
        ]

app.controller 'MainController', ['$scope', '$rootScope', '$location', '$mdToast', '$mdSidenav', '$mdBottomSheet', '$log', '$q', 'CityReportFactory', 'uiGmapGoogleMapApi', MainController]

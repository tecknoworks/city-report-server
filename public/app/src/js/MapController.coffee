MapController = ($scope, $rootScope, $window, uiGmapGoogleMapApi, uiGmapIsReady, CityReportFactory) ->

  uiGmapIsReady.promise(1).then (instances) ->
    instances.forEach (inst) ->
      uiGmapGoogleMapApi.then (googleMaps) ->
        $scope.api = googleMaps
        $scope.getIssues()

      # $rootScope.map.setOptions(
        # zoomControlOptions: { position: $window.google.maps.ControlPosition.LEFT_BOTTOM }
        # streetViewControlOptions: { position: $window.google.maps.ControlPosition.LEFT_BOTTOM }
      # )

  $scope.getIssues = ->
    CityReportFactory.getIssues().then((response) ->
      for mark in response.body
        $rootScope.map.markers.push
          id: mark._id
          latitude: mark.lat
          longitude: mark.lon
          previewIndex: 0
          icon: $scope.getIconForIssue(mark)
          json: mark
    )

  $scope.getIconForIssue = (issue) ->
    "assets/png/#{issue.category}.png"


  $rootScope.map =
    center: $scope.meta.map_center
    zoom: 13
    fit: true
    doCluster: false
    markers: []
    events:
      click: ->
        $scope.closeList('left')
        $scope.closeList('right')
      tilesloaded: (map) ->
        $scope.$apply(->
          $rootScope.mapInstance = map
        )
    markersEvents:
      click: (marker, eventName, model, args) ->
        $rootScope.map.window.model = model
        $scope.openList('left')
        $scope.closeList('right')
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
  return

angular.module('app').controller 'MapController', ['$scope', '$rootScope', '$window', 'uiGmapGoogleMapApi', 'uiGmapIsReady', 'CityReportFactory', MapController]

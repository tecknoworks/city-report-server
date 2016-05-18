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
    fit: false
    doCluster: false
    markers: []
    events:
      click: ->
        $scope.closeList()
      tilesloaded: (map) ->
        $scope.$apply(->
          $rootScope.mapInstance = map
        )
    markersEvents:
      click: (marker, eventName, model, args) ->
        $rootScope.map.window.model = model
        $scope.openList()
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
      zoomControlOptions:
        position: 6 # LEFT_BOTTOM
      streetViewControlOptions:
        position: 6 # LEFT_BOTTOM
      styles: [
        {
          'featureType': 'administrative'
          'elementType': 'geometry.stroke'
          'stylers': [
            { 'visibility': 'on' }
            { 'color': '#0096aa' }
            { 'weight': '0.30' }
            { 'saturation': '-75' }
            { 'lightness': '5' }
            { 'gamma': '1' }
          ]
        }
        {
          'featureType': 'administrative'
          'elementType': 'labels.text.fill'
          'stylers': [
            { 'color': '#0096aa' }
            { 'saturation': '-75' }
            { 'lightness': '5' }
          ]
        }
        {
          'featureType': 'administrative'
          'elementType': 'labels.text.stroke'
          'stylers': [
            { 'color': '#ffe146' }
            { 'visibility': 'on' }
            { 'weight': '6' }
            { 'saturation': '-28' }
            { 'lightness': '0' }
          ]
        }
        {
          'featureType': 'administrative'
          'elementType': 'labels.icon'
          'stylers': [
            { 'visibility': 'on' }
            { 'color': '#e6007e' }
            { 'weight': '1' }
          ]
        }
        {
          'featureType': 'landscape'
          'elementType': 'all'
          'stylers': [
            { 'color': '#ffe146' }
            { 'saturation': '-28' }
            { 'lightness': '0' }
          ]
        }
        {
          'featureType': 'poi'
          'elementType': 'all'
          'stylers': [ { 'visibility': 'off' } ]
        }
        {
          'featureType': 'road'
          'elementType': 'all'
          'stylers': [
            { 'color': '#0096aa' }
            { 'visibility': 'simplified' }
            { 'saturation': '-75' }
            { 'lightness': '5' }
            { 'gamma': '1' }
          ]
        }
        {
          'featureType': 'road'
          'elementType': 'labels.text'
          'stylers': [
            { 'visibility': 'on' }
            { 'color': '#ffe146' }
            { 'weight': 8 }
            { 'saturation': '-28' }
            { 'lightness': '0' }
          ]
        }
        {
          'featureType': 'road'
          'elementType': 'labels.text.fill'
          'stylers': [
            { 'visibility': 'on' }
            { 'color': '#0096aa' }
            { 'weight': 8 }
            { 'lightness': '5' }
            { 'gamma': '1' }
            { 'saturation': '-75' }
          ]
        }
        {
          'featureType': 'road'
          'elementType': 'labels.icon'
          'stylers': [ { 'visibility': 'off' } ]
        }
        {
          'featureType': 'transit'
          'elementType': 'all'
          'stylers': [
            { 'visibility': 'simplified' }
            { 'color': '#0096aa' }
            { 'saturation': '-75' }
            { 'lightness': '5' }
            { 'gamma': '1' }
          ]
        }
        {
          'featureType': 'water'
          'elementType': 'geometry.fill'
          'stylers': [
            { 'visibility': 'on' }
            { 'color': '#0096aa' }
            { 'saturation': '-75' }
            { 'lightness': '5' }
            { 'gamma': '1' }
          ]
        }
        {
          'featureType': 'water'
          'elementType': 'labels.text'
          'stylers': [
            { 'visibility': 'simplified' }
            { 'color': '#ffe146' }
            { 'saturation': '-28' }
            { 'lightness': '0' }
          ]
        }
        {
          'featureType': 'water'
          'elementType': 'labels.icon'
          'stylers': [ { 'visibility': 'off' } ]
        }
      ]
  return

angular.module('app').controller 'MapController', ['$scope', '$rootScope', '$window', 'uiGmapGoogleMapApi', 'uiGmapIsReady', 'CityReportFactory', MapController]

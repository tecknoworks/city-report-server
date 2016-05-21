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

angular.module('app').controller 'MapController', ['$scope', '$rootScope', '$window', 'uiGmapGoogleMapApi', 'uiGmapIsReady', 'CityReportFactory', MapController]

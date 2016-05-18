MainController = ($scope, $mdSidenav, $mdBottomSheet, $log, $q, CityReportFactory, uiGmapGoogleMapApi) ->
  $scope.toggleList = ->
    pending = $mdBottomSheet.hide() or $q.when(true)
    pending.then ->
      $mdSidenav('left').toggle()

  $scope.openList = ->
    $mdSidenav('left').open()

  $scope.closeList = ->
    $mdSidenav('left').close()

  $scope.swipeLeft = ->
    $scope.map.window.model.previewIndex += 1
    if $scope.map.window.model.previewIndex >= $scope.map.window.model.json.images.length
      $scope.map.window.model.previewIndex = 0

  $scope.swipeRight = ->
    $scope.map.window.model.previewIndex -= 1
    if $scope.map.window.model.previewIndex < 0
      $scope.map.window.model.previewIndex = $scope.map.window.model.json.images.length - 1

app.controller 'MainController', ['$scope', '$mdSidenav', '$mdBottomSheet', '$log', '$q', 'CityReportFactory', 'uiGmapGoogleMapApi', MainController]

MainController = ($scope, $mdSidenav, $mdBottomSheet, $log, $q, CityReportFactory, uiGmapGoogleMapApi) ->
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

app.controller 'MainController', ['$scope', '$mdSidenav', '$mdBottomSheet', '$log', '$q', 'CityReportFactory', 'uiGmapGoogleMapApi', MainController]

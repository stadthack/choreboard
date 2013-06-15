app.controller "MainCtrl", @MainCtrl = ($scope, $http, $route, $routeParams, $location, $log) ->
  $scope.location = $location
  $scope.routeParams = $routeParams
  $scope.completionModal = true
  
  $scope.validate = (form) ->
    return false unless form?
    form.submitted = true
    
    if form.$invalid
      for own k, v of form
        v.$pristine = false if v and typeof(v) is "object" and "$pristine" of v

    not form.$invalid

  $scope.onComplete = ->
    $scope.completionModal = true
    
  $scope.onMoreTasks = ->
    $scope.moreTasksModal = true
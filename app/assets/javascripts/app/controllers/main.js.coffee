app.controller "MainCtrl", @MainCtrl = ($scope, $http, $route, $routeParams, $location, $log) ->
  $scope.location = $location
  $scope.routeParams = $routeParams
  $scope.completionModal = false
  $scope.selectedTask = null
  
  $scope.tasks = [
    { id: 1, title: "Müll rausbringen", points: 10 }
    { id: 2, title: "Bad putzen", points: 30 }
    { id: 3, title: "Flur staubstaugen", points: 15 }
  ]
  
  $scope.latestTasks = [
    { id: 1, title: "Fremd abwaschen", points: 5, authors: ["Marcel", "Jörg"] }
  ]
  
  $scope.scores = [
    { label: "Marcel", value: 20 }
    { label: "Colin", value: 40 }
    { label: "Moritz", value: 30 }
  ]
  
  $scope.validate = (form) ->
    return false unless form?
    form.submitted = true
    
    if form.$invalid
      for own k, v of form
        v.$pristine = false if v and typeof(v) is "object" and "$pristine" of v

    not form.$invalid
    
  $scope.onCompleteTask = (task) ->
    console.log = "wat"
    index = $scope.tasks.indexOf task
    $scope.tasks.splice index, 1 if index >= 0
    task.authors = ["Marcel"]
    $scope.latestTasks.push task
    $scope.completionModal = false

  $scope.showCompleteTask = (task) ->
    $scope.selectedTask = task
    $scope.completionModal = true
    
  $scope.onMoreTasks = ->
    $scope.moreTasksModal = true
    
  $scope.onRejectTask = (task) ->
    delete task.authors
    index = $scope.latestTasks.indexOf task
    $scope.latestTasks.splice index, 1 if index >= 0
    $scope.tasks.push task
    
app.controller "MainCtrl", @MainCtrl = ($scope, $http, $route, $routeParams, $location, $log, $timeout) ->
  $scope.location = $location
  $scope.routeParams = $routeParams
  $scope.completionModal = false
  $scope.selectedTask = false
  $scope.participantsModal = false
  $scope.moreTasksModal = false
  $scope.now = new Date()

  counter = ->
    $scope.now = new Date()
    
  $timeout counter, 60000
  
  Participants = ["Marcel", "Heiko", "Jörg", "Colin"]
  
  $scope.tasks = [
    { title: "Montag: Stiefmutter abholen", points: 90, scheduled: true }
    { title: "Bad putzen", meta: "seit 2 Wochen", points: 30, scheduled: true }
    { title: "Flur staubstaugen", points: 15, scheduled: true }
  ]
  
  $scope.moreTasks = [
    { title: "Blumen gegossen", points: 5 }
    { title: "Müll rausgebracht", points: 10 }
    { title: "Fremdes Zeug abgewaschen", points: 10 }
    { title: "Gassi gegangen", points: 15 }
  ]
  
  $scope.selectedTask = $scope.tasks[0]
  
  $scope.latestTasks = [
    { title: "Fremd abwaschen", points: 5, authors: ["Marcel", "Jörg"] }
  ]
  
  $scope.scores = [
    { label: "Marcel", value: 5 }
    { label: "Heiko", value: 40 }
    { label: "Colin", value: 30 }
    { label: "Jörg", value: 10 }
  ]
  
  $scope.$watch "action", (action) ->
    return unless action
    $timeout((-> $scope.action = false), 3000)
  
  $scope.validate = (form) ->
    return false unless form?
    form.submitted = true
    
    if form.$invalid
      for own k, v of form
        v.$pristine = false if v and typeof(v) is "object" and "$pristine" of v

    not form.$invalid
    
  $scope.onEditParticipants = ->
    $scope.participantsModal = true
    $scope.participants = _.map Participants, (p) ->
      return {
        label: p
        checked: (p is "Marcel")
      }
      
  $scope.onParticipantsDone = ->
    $scope.selectedTask.authors = $scope.participants.filter((p) -> p.checked).map((p) -> p.label)
    $scope.participantsModal = false
  
  $scope.onCompleteTask = (task) ->
    return unless task.authors?.length > 0
    index = $scope.tasks.indexOf task
    $scope.tasks.splice index, 1 if index >= 0
    
    scores = $scope.scores
    
    oldWinner = _(scores).sortBy("value").slice(-1)[0]
    
    scores = scores.map (oldScore) ->
      value = oldScore.value
      
      if task.authors.indexOf(oldScore.label) >= 0
        value += task.points
        
      return {
        label: oldScore.label
        value: value
      }
        
    newWinner = _(scores).sortBy("value").slice(-1)[0]
    
    if oldWinner.label isnt newWinner.label and newWinner.label is $scope.scores[0].label
      $scope.action = true
    
    $scope.completionModal = $scope.moreTasksModal = false
    delete $scope.selectedTask
    
    todo = ->
      $scope.latestTasks.unshift _.clone task
      $scope.scores = scores
    
    if $scope.action
      $timeout todo, 4000
    else
      todo()

  $scope.showCompleteTask = (task) ->
    $scope.selectedTask = task
    $scope.selectedTask.authors = ["Marcel"]
    $scope.completionModal = true
    
  $scope.onMoreTasks = ->
    $scope.moreTasksModal = true
    
  $scope.onRejectTask = (task) ->
    $scope.scores.forEach (score) ->
      if task.authors.indexOf(score.label) >= 0
        score.value -= task.points
    
    delete task.authors
    index = $scope.latestTasks.indexOf task
    $scope.latestTasks.splice index, 1 if index >= 0
    
    if task.scheduled
      $scope.tasks.unshift task
    
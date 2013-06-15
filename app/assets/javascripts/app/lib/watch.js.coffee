@app.run ($rootScope) ->
  $rootScope.multiWatch = (args..., callback) ->
    checker = => _.map args, (arg) => @$eval arg
    wrapper = (args) => callback.apply @, args
    @$watch checker, wrapper, true
  
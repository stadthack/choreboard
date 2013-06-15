@app.directive "ndValue", ->
  return {
    link: (scope, el, attr) ->
      scope.$watch attr.ndValue, (v) -> el.val v
  }

@app.directive "ngVisible", ->
  return {
    link: (scope, el, attr) ->
      scope.$watch attr.ngVisible, (v) ->
        el.css visibility: (if v then "visible" else "hidden")
  }

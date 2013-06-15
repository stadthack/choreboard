@app.directive "ndEqualize", ->
  return {
    link: (scope, el, attr) ->
      scope.$watch attr.ndEqualize, ->
        _.defer -> $(el).equalize("outerHeight")
  }

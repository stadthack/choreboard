@app.directive 'ndHolder', ->
  return {
    link: (scope, element, attrs) ->
      element.attr "data-src", attrs.ndHolder
      Holder.run images: element.get(0)
  }
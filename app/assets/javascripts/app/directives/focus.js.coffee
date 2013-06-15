@app.directive "ngFocus", ($timeout) ->
  link: (scope, element, attrs) ->
    oldVal = false
    
    scope.$watch attrs.ngFocus, ((val) ->
      val = !!val
      return if oldVal is val
      oldVal = val
      return unless val
      $timeout -> element[0].focus()
    ), true
    element.bind "blur", ->
      scope.$apply attrs.ngFocusLost if attrs.ngFocusLost?


#
# * Defines the ui-if tag. This removes/adds an element from the dom depending on a condition
# * Originally created by @tigbro, for the @jquery-mobile-angular-adapter
# * https://github.com/tigbro/jquery-mobile-angular-adapter
# 
@app.directive "ngIf", ->
  transclude: "element"
  priority: 1000
  terminal: true
  restrict: "A"
  compile: (element, attr, transclude) ->
    (scope, element, attr) ->
      child = null
      oldValue = false
      
      scope.$watch attr.ngIf, (newValue) ->
        newValue = !!newValue
        return if oldValue is newValue
        oldValue = newValue
        
        if child
          child.element?.remove()
          child.scope?.$destroy()
          child = null
        
        if newValue        
          child = { scope: scope.$new() }
          transclude child.scope, (clone) ->
            child.element = clone
            element.after clone

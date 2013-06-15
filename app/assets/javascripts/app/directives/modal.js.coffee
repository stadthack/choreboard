@app.directive 'modal', ($document, $parse) ->
  return {
    scope: false
    require: '^ngModel'
    link: (scope, element, attr, ngModel) ->
      $element = $(element)
      modal = null

      ngModel.$render = ->
        active = ngModel.$viewValue
        
        if modal?
          action = if active then "show" else "hide"
          $element.modal action
        else if active
          $element.modal()
          
          $element.on "hidden", ->
            toDo = -> ngModel.$setViewValue false
            
            if $scope.$root.$$phase
              toDo()
            else
              scope.$apply toDo
            
          modal = $element.data "modal"
        else
          $element.hide()

      scope.$on "$destroy", ->
        modal?.$backdrop?.remove()
  }
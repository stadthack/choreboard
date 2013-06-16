@app.directive 'modal', ($document, $parse) ->
  return {
    scope: false
    require: '^ngModel'
    link: (scope, element, attr, ngModel) ->
      $element = $(element)
      modal = null
      
      setupReturn = (active) ->
        if active
          $(document).on "keyup.modal", (e) ->
            return if $(e.target).parents().is(":input")
            return unless e.which is $.ui.keyCode.ENTER or e.which is $.ui.keyCode.SPACE
            
            targets = $element.find('[data-default=modal]')
            
            if targets.length isnt 0
              e.preventDefault()
              targets.trigger("click")
        else
          $(document).off ".modal"
      
      ngModel.$render = ->
        active = ngModel.$viewValue
        
        if modal?
          action = if active then "show" else "hide"
          $element.modal action
          setupReturn active
        else if active
          setupReturn active
          $element.modal()
          
          $element.on "hidden", ->
            toDo = -> ngModel.$setViewValue false
            
            if scope.$root.$$phase
              toDo()
            else
              scope.$apply toDo
            
          modal = $element.data "modal"
        else
          $element.hide()
          $(document).off "keyup.modal"

      scope.$on "$destroy", ->
        modal?.$backdrop?.remove()
        setupReturn false
  }
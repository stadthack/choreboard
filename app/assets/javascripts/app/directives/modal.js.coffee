@app.directive 'modal', ($document, $parse) ->
  return {
    scope: false
    link: (scope, element, attr) ->
      $element = $(element)
      modal = null

      scope.$watch attr.modal, (active) ->
        if modal?
          action = if active then "show" else "hide"
          $element.modal action
        else if active
          $element.modal()
          $element.on "hidden", ->
            scope.$apply ->
              scope.$emit "modalClosed"
            
          modal = $element.data "modal"
        else
          $element.hide()

      scope.$on "$destroy", ->
        modal?.$backdrop?.remove()
  }
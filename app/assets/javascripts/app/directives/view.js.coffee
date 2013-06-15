@app.directive "ndView", ["$http", "$templateCache", "$route", "$anchorScroll", "$compile", "$controller", "$log",
    ( $http,   $templateCache,   $route,   $anchorScroll,   $compile,   $controller, $log) ->
      return {
        restrict: "ECA"
        terminal: true
        link: (scope, element, attr) ->
          lastScope = lastTemplate = null
          onloadExp = attr.onload or ""

          destroyLastScope = ->
            return unless lastScope?
            lastScope.$destroy()
            lastScope = null

          clearContent = ->
            element.html ""
            destroyLastScope()

          update = ->
            locals = $route.current?.locals
            template = locals?.$template

            if not template?
              clearContent()
            else if template isnt lastTemplate
              element.html template
              destroyLastScope()
              link = $compile element.contents()
              current = $route.current
              controller = undefined
              lastScope = current.scope = scope.$new()

              if current.controller?
                locals.$scope = lastScope
                controller = $controller current.controller, locals
                element.contents().data "$ngControllerController", controller

              link lastScope
              lastScope.$emit "$viewContentLoaded"
              lastScope.$broadcast "reset"
              lastScope.$eval onloadExp

              # $anchorScroll might listen on event...
              $anchorScroll()
            
            lastTemplate = template

          scope.$on "$routeChangeSuccess", update
          update()
      }
]

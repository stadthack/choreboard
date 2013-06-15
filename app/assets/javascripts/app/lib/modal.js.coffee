@app.run ($rootScope) ->
  $rootScope.startModal = ->
    $rootScope.openingModal = true
    $rootScope.openingModalFade = !$(".modal-backdrop").is(":visible")
    -> $rootScope.openingModal = false

  $rootScope.$watch "openingModal", (opening)->
    $loader = $("#modal-loader").stop(true, true)

    if opening
      if $rootScope.openingModalFade then $loader.fadeIn(150) else $loader.show()
    else
      $loader.hide()
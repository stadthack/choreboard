@app.config ['$httpProvider', ($httpProvider) ->
  csrfToken = $("meta[name='csrf-token']").attr("content")

  angular.forEach ["head", "post", "put", "delete", "patch"], (method) ->
    methodHeaders = $httpProvider.defaults.headers[method] ?= {}
    methodHeaders["X-CSRF-Token"] = csrfToken
]

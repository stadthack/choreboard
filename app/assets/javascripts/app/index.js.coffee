#= require_self
#= require_tree ./lib
#= require_tree ./filters
#= require_tree ./directives
#= require_tree ./controllers
#= require ./routes

dependencies = ['ngResource', 'ngSanitize']

@app = angular.module 'app', dependencies

@app.animation "animate-enter", ->
  setup: (element) ->
    element.hide()

  start: (element, done) ->
    element.slideDown(200, done)

@app.animation "animate-leave", ->
  start: (element, done) ->
    element.slideUp(200, done)

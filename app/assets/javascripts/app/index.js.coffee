#= require_self
#= require_tree ./lib
#= require_tree ./filters
#= require_tree ./directives
#= require_tree ./controllers
#= require ./routes

dependencies = ['ngResource', 'ngSanitize']

@app = angular.module 'app', dependencies

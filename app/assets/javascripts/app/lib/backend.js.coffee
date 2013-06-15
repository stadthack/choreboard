app.factory "Backend", ($http, $q) ->
  convert = (data) ->
    return unless data?
    return data unless typeof data is 'object'
    
    _.tap {}, (copy) ->    
      for own k, v of data
        k = _.str.underscored k
        copy[k] ?= convert v
  
  return {
    delete: (url, data) ->
      if data?.id?
        $http.delete("#{url}/#{data.id}")
      else
        $q.fulfill({ id: data?.id })
        
    save: (url, data) ->
      method = "post"
      
      if data.id?
        url += "/#{data.id}"
        method = "put"
        
      $http[method](url, convert(data))
  }
  
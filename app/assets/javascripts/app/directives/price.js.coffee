FLOAT_REGEXP = /^\-?[0-9\.]+(\,[0-9]*)?$/

app.directive "ndPrice", ->
  require: "ngModel"
  link: (scope, elm, attrs, ctrl) ->
    precision = attrs.ndPrice
    precision = 2 if isNaN precision
    
    scale = Math.pow 10, precision
    
    ctrl.$formatters.unshift (modelValue) ->
      return "" unless modelValue?
      v = Number(modelValue)
      return "" if isNaN v

      sign = ""
      
      if v < 0
        sign = "-"
        v = -v
        
      fraction = String(v % scale)
      whole = Math.floor(v / scale)
      s = "#{sign}#{whole}"
      
      return s if fraction is 0
      
      while fraction.length < precision
        fraction = "0#{fraction}"
        
      "#{s},#{fraction}"
      
    ctrl.$parsers.unshift (viewValue) ->
      if viewValue is "" or not viewValue?
        ctrl.$setValidity "format", true
        return
      else if FLOAT_REGEXP.test viewValue
        s = viewValue.replace(".", "").replace(",", "|")
        [whole, fraction] = s.split("|")
        fraction ?= "0"
        
        if fraction.length > precision
          ctrl.$setValidity "format", false
          return
        
        while fraction.length < precision
          fraction = "#{fraction}0"
          
        fraction = fraction.slice 0, precision
        ctrl.$setValidity "format", true
        Number(whole) * scale + Number(fraction)
      else
        ctrl.$setValidity "format", false
        return

app.directive "ndFixed", ->
  require: "ngModel"
  link: (scope, elm, attrs, ctrl) ->
    precision = attrs.ndFixed || 1
    scale = Math.pow 10, precision
    
    ctrl.$formatters.unshift (modelValue) ->
      return "" unless modelValue?
      v = Number(modelValue)
      
      if isNaN v
        ""
      else
        String(v / scale).replace(".", ",")
      
    ctrl.$parsers.unshift (viewValue) ->
      if viewValue is "" or not viewValue?
        ctrl.$setValidity "format", true
        return
      else if FLOAT_REGEXP.test viewValue
        ctrl.$setValidity "format", true
        s = viewValue.replace(".", "").replace(",", ".")
        [whole, fraction] = s.split(".")
        
        fraction ?= "0"
        
        while fraction.length < precision
          fraction = "#{fraction}0"
          
        fraction = fraction.slice 0, precision
        Number(whole) * scale + Number(fraction)
      else
        ctrl.$setValidity "format", false
        return


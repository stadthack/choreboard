app.filter "defined", ->
  (input) -> input?

app.filter "undefined", ->
  (input) -> !input?

app.filter "isEmpty", ->
  (input) -> (input?.length ? 0) is 0

app.filter "in", ->
  (input, collection) ->
    return false unless _.isArray collection
    input in collection

app.filter "or",   -> (input, other) -> input or other
app.filter "and",  -> (input, other) -> input and other
app.filter "is",   -> (input, other) -> input is other
app.filter "eq",   -> (input, other) -> input is other
app.filter "ne",   -> (input, other) -> input isnt other
app.filter "isnt", -> (input, other) -> input isnt other
app.filter "gt",   -> (input, other) -> input > other
app.filter "gte",  -> (input, other) -> input >= other
app.filter "lt",   -> (input, other) -> input < other
app.filter "lte",  -> (input, other) -> input <= other
app.filter "implies", -> (input, other) -> !input or (!!other)

ifArray = (f) ->
  (collection) ->
    f arguments... if _.isArray collection

app.filter "first",   -> ifArray (a) -> _.first a
app.filter "last",    -> ifArray (a) -> _.last a
app.filter "rest",    -> ifArray (a, c) -> _.rest a, c
app.filter "initial", -> ifArray (a, c) -> _.initial a, c

counter = (o) -> o.length if o?
app.filter "count", -> counter
app.filter "length", -> counter
app.filter "size", -> counter

app.filter "round", -> (input) -> if input? then Math.round(input) else null

app.filter "pluck", -> ifArray (a, attr) -> _.pluck a, attr
app.filter "join", -> ifArray (a, char) -> a.join(char)

app.filter "fallback", ->
  (input, fallback) -> input ? fallback

app.filter "markdown", ->
  converter = new Showdown.converter
  
  (input) ->
    return unless input?
    converter.makeHtml(String(input))

app.filter "time", ->
  (date) ->
    return unless date?
    moment(date).format("H:mm")

app.filter "ifBlank", ->
  (input, fallback) ->
    return fallback unless input?
    return fallback if angular.isString(input) and input.length is 0
    input

app.filter "startsWith", ->
  (input, start) ->
    return false unless input?
    input.indexOf(start) is 0

app.filter "ifElse", ->
  (input, ifValue, elseValue) ->
    if input then ifValue else elseValue

app.filter "equals", ->
  (input, other) ->
    return true if input == other

    if input instanceof Date and other instanceof Date
      return Number(input) == Number(other)

    return false

app.filter "isCurrentPath", ($location) ->
  (input) ->
    return false unless input?
    path = $location.path()
    pathWitoutProject = path.replace(/^\/projects\/[a-z0-9_-]+\//, "/")
    path.indexOf(input) is 0 or pathWitoutProject.indexOf(input) is 0

app.filter "filesize", ($filter) ->
  (input) ->
    number = Number(input)
    number = Math.max(0, number)
    power = 0

    if number > 800
      while number >= 1024
        number /= 1024
        power++

    units = ["Bytes", "KB", "MB", "GB", "TB"]
    unit = if units.length > power then units[power] else "x2^10^#{power}"

    if number % 1 is 0
      precision = 0
    else if number < 10
      precision = 2
    else
      precision = 1

    numberString = $filter('number')(number, precision)
    "#{numberString} #{unit}"

app.filter "humanize", ($filter) ->
  (input, type) ->
    return null unless input?

    switch type
      when "filesize"
        $filter('filesize')(input)
      else
        $filter('number')(input)

app.filter "signed", ->
  (input) ->
    if input < 0
      String(input)
    else if input > 0
      "+#{input}"
    else
      "±#{input}"

app.filter "having", ->
  (input, field, value) ->
    return [] unless _.isArray input
    _.filter input, (item) -> item?[field] is value

app.filter "date", ->
  (input, format) ->
    return null unless input?

    date = moment(input)
    today = moment()
    
    if format?
      date.format format
    else if today.year() is date.year()
      date.format "D. MMMM"
    else
      date.format "D. MMMM YYYY"
      
_.forEach ["month", "day", "year"], (f) ->
  app.filter f, ->
    (input) ->
      return null unless input?
      moment(input)[f]()

app.filter "concat", ->
  (input, other) -> "#{input}#{other}" 

app.filter "reverse", ->
  (input) -> input.split("").reverse().join("")
  
app.filter "urlencode", ->
  (input) -> encodeURIComponent(input ? "")

app.filter "price", (reverseFilter) ->
  (input, precision, currency) ->
    return "" unless input?
    return "" if isNaN input
    
    precision ?= 2
    
    if arguments.length is 2 and isNaN(precision)
      currency = precision
      precision = 2
    
    currency ?= "€"
    scale = Math.pow 10, precision

    input = Math.round input

    sign = ""

    if input < 0
      sign = "-"
      input= -input

    whole = Math.floor(input / scale)
    cents = (input % scale)

    formatted = reverseFilter(reverseFilter(String(whole)).replace(/(\d{3})(?!.*\.|$)/g, "$1."))

    if cents > 0
      centLength = String(cents).length
      formatted += ","
      _(precision - centLength).times -> formatted += "0"
      formatted += "#{cents}"
    else
      cents = ""

    "#{sign}#{formatted}#{currency}"
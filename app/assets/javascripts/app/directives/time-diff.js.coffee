@app.directive "ndTimeDiff", (dateFilter, timeFilter) ->
  return {
    link: (scope, el, attr) ->
      timeout = null

      stop = ->
        clearTimeout timeout if timeout?
        timeout = null

      scope.$on "destroy", stop

      attr.seconds ?= true

      scope.$watch attr.ndTimeDiff, (date) ->
        stop()
        return el.text "" unless date?
        date = new XDate date

        updater = ->
          now = new XDate
          diff = date.diffSeconds now
          next = 60 * 60 # every hour

          if diff < 0
            text = "soon"
            next = 60
          else if diff < 60
            seconds = Math.floor date.diffSeconds now

            if attr.seconds
              text = if seconds > 0 then "#{seconds} seconds ago" else "just now"
              next = 1
            else
              text = "just now"
              next = 30
          else if diff < 60 * 60
            minutes = Math.floor date.diffMinutes now
            text = "#{minutes} minutes ago"
            next = 30
          else if diff < 60 * 60 * 8
            hours = Math.floor date.diffHours now
            text = "#{hours} hours ago"
          else if date >= XDate.today()
            text = timeFilter date
          else if date >= XDate.today().addDays(-1)
            text = "Yesterday, #{timeFilter(date)}"
          else
            text = dateFilter date.toDate()

          el.text text
          timeout = setTimeout(updater, next * 1000)

        updater()
  }
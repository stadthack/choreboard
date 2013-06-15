@app.directive "ndDateDiff", (dateFilter) ->
  return {
    link: (scope, el, attr) ->
      interval = null

      stop = ->
        clearInterval interval if interval?
        interval= null

      scope.$on "destroy", stop

      scope.$watch attr.ndDateDiff, (date) ->
        stop()
        return el.text "" unless date?
        date = new XDate date
        date.clearTime()

        updater = ->
          today = XDate.today()
          diff = today.diffDays date

          if diff is 0
            text = "Today"
          else if diff is -1
            text = "Yesterday"
          else if diff < -1 and diff >= -7
            text = "last " + date.toString("dddd")
          else if diff is 1
            text = "Tomorrow"
          else if diff > 1 and diff < 7
            text = date.toString("dddd")
          else if diff >= 7 and diff < 14
            text = "next " + date.toString("dddd")
          else
            text = dateFilter date.toDate()

          el.text text

        interval = setInterval updater, 1000*60*60*24
        updater()
  }
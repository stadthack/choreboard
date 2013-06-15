@app.directive 'scoreboard', ->
  (scope, el, attr) -> 
    h = 300
    w = 500

    g = d3.select(el.get(0))
    g = g.append("svg") unless /svg/i.test el.get(0).tagName
    
    g = g.attr("width", w).attr("height", h).append("g")
    
    x = d3.scale.linear().range [0, w]
    y = d3.scale.linear().range [h, 20]

    watcher = (data = []) ->
    
      x.domain data.map (v) -> v.label
      
      max = d3.max data, (v) -> v.value
      y.domain [0, max]
      
      rect = g.selectAll(".bar").data(data)

      rect.enter().append("rect")
          .attr("class", "bar")
            
      rect.transition()
        .attr("y", (d, i) -> y(d.value))
        .attr("x", (d, i) -> (i + 0.25) * w / data.length)
        .attr("width", w / data.length * 0.5)
        .attr("height", (d) -> y(0) - y(d.value))
          
      rect.exit().remove()
          
      text = g.selectAll("text").data(data)
      
      text.enter().append("text")
        .text((d) -> d.label)
        
      text.transition()
        .attr("class", (d, i) -> "low" if d.value < max * 0.33)
        .attr("baseline-shift", "-33%")
        .attr "transform", (d, i) ->
          tx = (i + 0.5) * w / data.length
          ty = y(0) - 10
          
          if d.value < max * 0.33
            ty += y(d.value) - y(0)
            
          "translate(#{tx}, #{ty}) rotate(-90)"
       
       text.exit().remove()
    
    scope.$watch attr.scoreboard, watcher, true
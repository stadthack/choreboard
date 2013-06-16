@app.directive 'scoreboard', ->
  (scope, el, attr) -> 
    h = 300
    w = 500

    g = d3.select(el.get(0))
    g = g.append("svg") unless /svg/i.test el.get(0).tagName
    
    g = g.attr("width", w).attr("height", h).append("g")
    
    x = d3.scale.linear().range [0, w]
    y = d3.scale.linear().range [h-10, 40]

    watcher = (data = []) ->
    
      x.domain data.map (v) -> v.label
      
      max = d3.max data, (v) -> v.value
      y.domain [0, max]
      
      transformer = (d, i) ->
        tx = (i + 0.5) * w / data.length
        ty = h - 10

        ty += y(d.value) - h if d.value < max * 0.33
          
        "translate(#{tx}, #{ty}) rotate(-90)"
      
      rect = g.selectAll(".bar").data(data)

      rect.enter().append("rect")
          .attr("class", "bar")
            
      rect.transition().duration(1000).ease(d3.ease("elastic"))
        .attr("y", (d, i) -> y(d.value))
        .attr("x", (d, i) -> (i + 0.25) * w / data.length)
        .attr("width", w / data.length * 0.5)
        .attr("height", (d) -> h - y(d.value))
          
      rect.exit().remove()
          
      names = g.selectAll(".name").data(data)
      
      names.enter().append("text")
        .attr("transform", transformer)
        .attr("baseline-shift", "-33%")
        
      names.transition().duration(1000).ease(d3.ease("elastic"))
        .text((d) -> d.label)
        .attr("class", ((d) -> if d.value < max * 0.33 then "name low" else "name"))
        .attr("transform", transformer)
       
      names.exit().remove()
      
      scores = g.selectAll(".score").data(data)
      
      scores.enter().append("text")
        .attr("class", "score")
        
      scores.transition().duration(1000).ease(d3.ease("elastic"))
        .text((d) -> d.value)
        .attr("x", (d, i) -> (i + 0.5) * w / data.length)
        .attr("y", (d) -> y(d.value) + 32)
        .attr("text-anchor", "middle")
        
      trophy = g.selectAll(".trophy").data([0])
      
      trophy.enter().append("text")
        .attr("class", "trophy icon-trophy")
      
      highest = _.detect data, (i) -> i.value is max
      highestIndex = data.indexOf highest
      
      trophy
        .attr("fill", "#fff")
        .attr("text-anchor", "middle")
        .text("\uf091")
        
      trophy.transition().ease(d3.ease("elastic")).duration(1000)
        .attr("x", (highestIndex + 0.5) * w / data.length)
        .attr("y", 24)
    
    scope.$watch attr.scoreboard, watcher, true
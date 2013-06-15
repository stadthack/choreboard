@app.directive 'scoreboard', ->
  (scope, el, attr) -> 
    h = 300
    w = 500

    g = d3.select(el.get(0))
    g = g.append("svg") unless /svg/i.test el.get(0).tagName
    
    g.attr("width", w).attr("height", h).append("g")
    
    y = d3.scale.linear().range [h, 20]
    x = d3.scale.linear().range [0, w]
    
    scope.$watch attr.scoreboard, (data = []) ->
      
      x.domain data.map (v) -> v.label
      y.domain [0, d3.max(data, (v) -> v.value)]
    
      g.selectAll(".bar").data(data)
        .enter().append("rect")
          .attr("class", "bar")
          .attr("y", (d, i) -> h - y(d.value))
          .attr("x", (d, i) -> (i + 0.25) * w / data.length)
          .attr("width", w / data.length * 0.5)
          .attr("height", (d) -> y(d.value))
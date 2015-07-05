HTMLWidgets.widget({

  name: 'packwidget',

  type: 'output',

  initialize: function(el, width, height) {
    
    /* Add SVG container */
    var svg=d3.select(el).append("svg")
     .attr("width",width)
     .attr("height",height);
    
 
    
    return {
      "svg": svg,
      "width": width,
      "height": height
    }

  },

  renderValue: function(el, x, instance) {
    
    var svg=instance.svg;
    var width=instance.width;
    var height=instance.height;
    
    xnode=HTMLWidgets.dataframeToD3(x.properties);
  
    var padding = 1.5, // separation between same-color nodes
    clusterPadding = 6, // separation between different-color nodes
    maxRadius = 12;

    var n = xnode.length; 
    var m = 1;
    
    /* var color = d3.scale.category10()
     .domain(d3.range(m)); */
   
    clusters = new Array(m);
    nodes = xnode.map(function(e) {
        var i = e.cluster,
        r = e.radius,
        d = {cluster: i, radius: r};
        if (!clusters[i] || (r > clusters[i].radius)) clusters[i] = d;
        return d;
    });
     
     
    // Use the pack layout to initialize node positions.
    var pack = d3.layout.pack()
     .sort(null)
     .size([width, height])
     .children(function(d) { return d.values; })
     .value(function(d) { return d.radius * d.radius; })
     .nodes({values: d3.nest()
      .key(function(d) { return d.cluster; })
      .entries(nodes)});

    var force = d3.layout.force()
     .nodes(nodes)
     .size([width, height])
     .gravity(.02)
     .charge(0)
     .on("tick", tick)
     .start();
     
    var node = svg.selectAll("circle")
     .data(nodes)
     .enter().append("circle")
     .style("fill", function(d) { return x.cols[d.cluster]; })
     .call(force.drag);
    
    node.transition()
     .duration(750)
     .delay(function(d, i) { return i * 5; })
     .attrTween("r", function(d) {
       var i = d3.interpolate(0, d.radius);
       return function(t) { return d.radius = i(t); };
      });
   
    function tick(e) {
      node
       .each(cluster(10 * e.alpha * e.alpha))
       .each(collide(.5))
       .attr("cx", function(d) { return d.x; })
       .attr("cy", function(d) { return d.y; });
    }

    // Move d to be adjacent to the cluster node.
    function cluster(alpha) {
      return function(d) {
        var cluster = clusters[d.cluster];
        if (cluster === d) return;
        var x = d.x - cluster.x,
        y = d.y - cluster.y,
        l = Math.sqrt(x * x + y * y),
        r = d.radius + cluster.radius;
        if (l != r) {
          l = (l - r) / l * alpha;
          d.x -= x *= l;
          d.y -= y *= l;
          cluster.x += x;
          cluster.y += y;
        }
      };
    }

    // Resolves collisions between d and all other circles.
    function collide(alpha) {
      var quadtree = d3.geom.quadtree(nodes);
      return function(d) {
        var r = d.radius + maxRadius + Math.max(padding, clusterPadding),
          nx1 = d.x - r,
          nx2 = d.x + r,
          ny1 = d.y - r,
          ny2 = d.y + r;
        quadtree.visit(function(quad, x1, y1, x2, y2) {
        if (quad.point && (quad.point !== d)) {
          var x = d.x - quad.point.x,
            y = d.y - quad.point.y,
            l = Math.sqrt(x * x + y * y),
            r = d.radius + quad.point.radius + (d.cluster === quad.point.cluster ? padding : clusterPadding);
          if (l < r) {
            l = (l - r) / l * alpha;
            d.x -= x *= l;
            d.y -= y *= l;
            quad.point.x += x;
            quad.point.y += y;
          }
        }
        return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
      });
    };
  }
  
  },

  resize: function(el, width, height, instance) {

  }

});
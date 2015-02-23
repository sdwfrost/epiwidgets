HTMLWidgets.widget({

  name: 'odewidget',

  type: 'output',

  initialize: function(el, width, height) {

    var dashboard=d3.select(el)
      .append("div")
      .attr("class","row")
      .attr("id","dashboard");

    var slide=d3.select("#dashboard")
      .append("div")
      .attr("class","ui-widget ui-corner-all")
      .append("span")
      .text("\u03B2")
      .append("div")
      .attr("id","slider")
      .style("float","right")
      .style("width","95%");

    var slidervalues = Array.apply(0, Array(201)).map(function(e,i) { return i/100; });
    $("#slider").slider({value:100,max:200}).slider("float",{labels: slidervalues});

    d3.select(el).append("br");

    /* Define globals */
    model=this.simodel;

    return {"width":width,"height":height};

  },

  renderValue: function(el, x, instance) {
    /* Initial plot */
    var p1 = $("#slider").slider( "option", "value" )/100;
    $( "#beta" ).val(p1);
    var data=model([0.99,0.01],[p1],0.0,20.0,100);

    var width=instance.width;
    var height=instance.height;
    var margin={top: 30, right: 0, bottom: 30, left: 30};
    var svg=d3.select(el)
     .append("div")
     .attr("class","row")
     .append("svg")
     .attr("width",width)
     .attr("height",height)
     .attr("id","model")
     .append("g")
        .attr("transform",
              "translate(" + margin.left + "," + margin.top + ")");

    var w=width-margin.left-margin.right;
    var h=height-margin.top-margin.bottom;

     // Set the ranges
     var x = d3.scale.linear().range([0, w]);
     var y = d3.scale.linear().range([h, 0]);

     // Define the axes
     var xAxis = d3.svg.axis().scale(x)
       .orient("bottom").ticks(5);

     var yAxis = d3.svg.axis().scale(y)
       .orient("left").ticks(5);

     // Define the line
     var iline = d3.svg.line()
      .x(function(d) { return x(d.t); })
      .y(function(d) { return y(d.I); });

    var sline = d3.svg.line()
      .x(function(d) { return x(d.t); })
      .y(function(d) { return y(d.S); });

     // Scale the range of the data
    x.domain(d3.extent(data, function(d) { return d.t; }));
    y.domain([0, d3.max(data, function(d) { return d.S+d.I; })]);

    // Add the I
    svg.append("path")
        .attr("class", "iline")
        .attr("d", iline(data));

     svg.append("path")
        .attr("class", "sline")
        .attr("d", sline(data));

    // Add the X Axis
    svg.append("g")
        .attr("class", "x axis")
       .attr("transform", "translate(0," + h + ")")
        .call(xAxis);

    // Add the Y Axis
    svg.append("g")
        .attr("class", "y axis")
        //.attr("transform", "translate(0,0)")
        .call(yAxis);

      /* Event handler */
      $( "#slider" ).on( "slidechange", this.update);
  },

  resize: function(el, width, height, instance) {
  },

  simodel: function(y0,p,t0,tf,nsteps){
      var f = function(x,y){
        return [-p[0]*y[0]*y[1],p[0]*y[0]*y[1]];
      };
      var sol = numeric.dopri(t0,tf,y0,f,1e-6,2000);
      var ix =  Array.apply(0, Array(nsteps)).map(function(e,i) { return t0+tf*(i/(nsteps-1)); });
      var iy=sol.at(ix);
      var out=iy.map(function(e,i){return {"t":ix[i],"S":e[0],"I":e[1]};})
      return out;
     },

  update: function(event,ui){
    // Get new data
     var p1 = $("#slider").slider( "option", "value" )/100;
     $( "#beta" ).val(p1);
     var data=model([0.99,0.01],[p1],0.0,20.0,100);

     var svg = d3.select("#model");
     var margin={top: 30, right: 20, bottom: 30, left: 50};
     var width=svg.attr("width")-margin.left-margin.right;
     var height=svg.attr("height")-margin.top-margin.bottom;

    // Set the ranges
     var x = d3.scale.linear().range([0, width]);
     var y = d3.scale.linear().range([height, 0]);

      // Define the axes
     var xAxis = d3.svg.axis().scale(x)
       .orient("bottom").ticks(5);

     var yAxis = d3.svg.axis().scale(y)
       .orient("left").ticks(5);

    // Define the line
     var iline = d3.svg.line()
      .x(function(d) { return x(d.t); })
      .y(function(d) { return y(d.I); });

    var sline = d3.svg.line()
      .x(function(d) { return x(d.t); })
      .y(function(d) { return y(d.S); });

    // Scale the range of the data again
    x.domain(d3.extent(data, function(d) { return d.t; }));
    y.domain([0, d3.max(data, function(d) { return d.S+d.I; })]);

    // Select the section we want to apply our changes to
    var svg = svg.transition();

    // Make the changes
        svg.select(".iline")   // change the line
            .duration(750)
            .attr("d", iline(data));
        svg.select(".sline")   // change the line
            .duration(750)
            .attr("d", sline(data));
        svg.select(".x.axis") // change the x axis
            .duration(750)
            .call(xAxis);
        svg.select(".y.axis") // change the y axis
            .duration(750)
            .call(yAxis);
  }

});

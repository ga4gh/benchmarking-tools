/**
 * helper code to create ROC plots
 *
 * @author Peter Krusche <pkrusche@illumina.com>
 */
'use strict';

var PLOT;
if (PLOT === undefined) {
    PLOT = {};
}

(function (PLOT) {

    var X_METRIC = "METRIC.Recall";
    var Y_METRIC = "METRIC.Precision";
    var X_LABEL = "Recall";
    var Y_LABEL = "Precision";

    var DASHTYPES = [
        null,
        "4,4",
        "2,2",
        "1,5",
        "0.9",
        "5,5,1,5",
    ];

    /** create an identifier that can be used as a class / selector */
    function makeDataID(d, fields) {
        var result = "";
        if(!fields) {
            fields = ["type", "subtype", "subset", "method", "comparisonmethod", "filter"];
        }
        fields.forEach(function(f) {
            if(result != "") {
                result += "_";
            }
            if(!d[f]) {
                console.log(f);
            } else {
                result += ("" + d[f]).replace(/[^A-Z0-9_]/gi, "_");
            }
        });
        return result;
    }

    /** make sure that we show a large enough part of the plot on the axes */
    function fixDomain(d) {
        var MIN_EXTENT = 0.01;
        if (d[1] - d[0] < MIN_EXTENT) {
            d[0] -= MIN_EXTENT / 2;
            d[1] += MIN_EXTENT / 2;
        }
        d[0] = d3.min([1.0, d[0], d[1]]);
        d[0] = d3.max([0.0, d[0]]);
        d[1] = d3.min([1.0, d[1]]);
        d[1] = d3.max([0.0, d[0], d[1]]);
        return d;
    }

    /** make a SVG path for ROC points */
    function makeROCPath(x, y, rocdata) {
        rocdata.sort(function (a, b) {
            return b.QQ - a.QQ;
        });
        return (d3.svg.line()
                .x(function (d) {
                    return x(d[X_METRIC]);
                })
                .y(function (d) {
                    return y(d[Y_METRIC]);
                })
        )(rocdata);
    }

    /** highlight single dataset */
    function highlightSingle(svg, plot_g, d) {
        var id = ".dot_" + makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]);
        plot_g.selectAll(id)
            .style("stroke", "black");
        svg.selectAll(".legend_" + d.method.replace(/[^A-Z0-9_]/gi, "_"))
            .style("font-weight", "bold");
        svg.selectAll(".cmlegend_" + d.comparisonmethod.replace(/[^A-Z0-9_]/gi, "_"))
            .style("font-weight", "bold");        
        plot_g.selectAll(id.replace(/\.dot/g, ".roc"))
            .style("stroke-width", "4px")
            .style("opacity", 1.0);        
        plot_g.selectAll(id.replace(/\.dot/g, ".pf"))
            .style("stroke", "black")
            .style("opacity", 0.8);        
    }

    /** highlight single dataset */
    function unhighlightSingle(svg, plot_g, d) {      
        var id = ".dot_" + makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]);
        plot_g.selectAll(id)
            .style("stroke", function (d) {
                if(d.filter != "ALL") {
                    return d.FILL;
                } else {
                    return "black";
                }                
            });
        svg.selectAll(".legend_" + d.method.replace(/[^A-Z0-9_]/gi, "_"))
            .style("font-weight", "normal");
        svg.selectAll(".cmlegend_" + d.comparisonmethod.replace(/[^A-Z0-9_]/gi, "_"))
            .style("font-weight", "normal");        
        plot_g.selectAll(id.replace(/\.dot/g, ".roc"))
            .style("stroke-width", "2px")
            .style("opacity", 0.5);        
        plot_g.selectAll(id.replace(/\.dot/g, ".pf"))
            .style("stroke", "grey")
            .style("opacity", 0);        
    }

    /**
     * ROC Plot function
     * @param target Something D3 can select
     * @param data the data to plot
     */
    PLOT.roc = function (target, data) {
        var color = d3.scale.category10();
        var shape = d3.scale.ordinal().range(d3.svg.symbolTypes);
        var dashing = d3.scale.ordinal().range(DASHTYPES);

        /** preprocess data / add colors */
        data.forEach(function (d) {
            d["FILL"] = color(d.method);
            d["SHAPE"] = d3.svg.symbol().type(shape(d.comparisonmethod))();
        });
        
        var margin = {top: 20, right: 300, bottom: 30, left: 100},
            width = 1000 - margin.left - margin.right,
            height = 400 - margin.top - margin.bottom;

        var x = d3.scale.linear()
            .range([0, width]);

        var y = d3.scale.linear()
            .range([height, 0]);

        var xAxis = d3.svg.axis()
            .scale(x)
            .tickFormat(d3.format(".2%"))
            .ticks(6)
            .orient("bottom");

        var yAxis = d3.svg.axis()
            .scale(y)
            .ticks(4)
            .tickFormat(d3.format(".2%"))
            .orient("left");

        var svg = d3.select(target).append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

        /** plot clipping */
        svg.append("svg:clipPath")
            .attr("id", "clip")
            .append("svg:rect")
            .attr("x", 0)
            .attr("y", -50)
            .attr("width", width + 20)
            .attr("height", height + 50);
        svg.append("rect");

        var xdomain = fixDomain(d3.extent(data, function (d) {
            return d[X_METRIC];
        }));
        x.domain(xdomain).nice();

        var ydomain = fixDomain(d3.extent(data, function (d) {
            return d[Y_METRIC];
        }));
        y.domain(ydomain).nice();

        var zoom = d3.behavior.zoom()
            .x(x)
            .y(y)
            .scaleExtent([0.01, 5])
            .on("zoom", zoomed);

        var plot_g = svg
            .append("g")
            .attr("clip-path", "url(#clip)");
        plot_g.append("rect")
            .attr("x", 0)
            .attr("y", 0)
            .attr("width", width + 20)
            .attr("height", height + 50)
            .style("fill", "#fff")
            .on("mousedown", function () {
                if (d3.event.ctrlKey) {
                    zoom.scale(1);
                    zoom.translate([0, 0]);
                    zoom.x(x.domain(xdomain).nice());
                    zoom.y(y.domain(ydomain).nice());
                    zoomed();
                    return true;
                }
                if (!d3.event.shiftKey) {
                    return true;
                }
                var e = this,
                    origin = d3.mouse(e),
                    rect = svg.append("rect").attr("class", "zoom");

                origin[0] = Math.max(0, Math.min(width, origin[0]));
                origin[1] = Math.max(0, Math.min(height, origin[1]));
                d3.select(window)
                    .on("mousemove.zoomRect", function () {
                        var m = d3.mouse(e);
                        m[0] = Math.max(0, Math.min(width, m[0]));
                        m[1] = Math.max(0, Math.min(height, m[1]));
                        rect.attr("x", Math.min(origin[0], m[0]))
                            .attr("y", Math.min(origin[1], m[1]))
                            .attr("width", Math.abs(m[0] - origin[0]))
                            .attr("height", Math.abs(m[1] - origin[1]));
                    })
                    .on("mouseup.zoomRect", function () {
                        d3.select(window).on("mousemove.zoomRect", null).on("mouseup.zoomRect", null);
                        var m = d3.mouse(e);
                        m[0] = Math.max(0, Math.min(width, m[0]));
                        m[1] = Math.max(0, Math.min(height, m[1]));
                        if (m[0] !== origin[0] && m[1] !== origin[1]) {
                            zoom.x(x.domain([origin[0], m[0]].map(x.invert).sort()))
                                .y(y.domain([origin[1], m[1]].map(y.invert).sort()));
                        }
                        rect.remove();
                        zoomed();
                    }, true);
                d3.event.stopPropagation();
            })
            .append("svg:title").text("Shift-click to zoom, ctrl-click to reset.");

        plot_g.call(zoom);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(xAxis)
            .append("text")
            .attr("class", "label")
            .attr("x", width)
            .attr("y", -6)
            .style("text-anchor", "end")
            .text(X_LABEL);

        svg.append("g")
            .attr("class", "y axis")
            .call(yAxis)
            .append("text")
            .attr("class", "label")
            .attr("transform", "rotate(-90)")
            .attr("y", 6)
            .attr("dy", ".71em")
            .style("text-anchor", "end")
            .text(Y_LABEL);

        /** this can probably be improved, currently we remove everything and
         *  draw from scratch on zoom
         */
        function zoomed() {
            plot_g.selectAll(".pf").remove();
            plot_g.selectAll(".roc").remove();
            plot_g.selectAll(".dot").remove();

            // var show_filtered = svg.select(".flegend_showfilters").text().index("Show") < 0;
            var show_filtered = false;
            var pdata = data;
            if(!show_filtered) {
                pdata = data.filter(function(d) {return d.filter == "ALL";});
            }

            var pfl = {};
            data.forEach(function(d) {
                var key = makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]);
                if(!pfl.hasOwnProperty(key)) {
                    pfl[key] = { 
                        type: d.type,
                        subtype: d.subtype,
                        subset: d.subset,
                        method: d.method,
                        comparisonmethod: d.comparisonmethod,
                        x1: null, 
                        x2: null, 
                        y1: null, 
                        y2: null };
                }
                if(d.filter == "ALL") {
                    pfl[key].x1 = x(d[X_METRIC]);
                    pfl[key].y1 = y(d[Y_METRIC]);
                } else if(d.filter == "PASS") {
                    pfl[key].x2 = x(d[X_METRIC]);
                    pfl[key].y2 = y(d[Y_METRIC]);
                }
            });

            plot_g.selectAll(".pf")
                .data(d3.values(pfl))
                .enter().append("line")
                .attr("class", function(d) {
                    return "pf" + 
                           " pf_ " + d.method.replace(/[^A-Z0-9_]/gi, "_") +
                           " pf_" + makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]);
                })
                .attr("x1", function(d) {return d.x1;})
                .attr("x2", function(d) {return d.x2;})
                .attr("y1", function(d) {return d.y1;})
                .attr("y2", function(d) {return d.y2;})
                .style("opacity", 0)
                .style("stroke", "grey")
                .style("stroke-width", "8px")
                .style("stroke-lineend", "round")
                .on("mouseover", function (d) {
                    highlightSingle(svg, plot_g, d);
                })
                .on("mouseout", function (d) {
                    unhighlightSingle(svg, plot_g, d);
                });

            plot_g.selectAll(".roc")
                .data(pdata)
                .enter().append("path")
                .attr("class", function(d) {
                    return "roc" + 
                           " roc_ " + d.method.replace(/[^A-Z0-9_]/gi, "_") +
                           " roc_" + makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]) + 
                           " " + (d.filters == "ALL" ? "roc_all" : "roc_pass");
                })
                .attr("stroke", function (d) {
                    return d.FILL;
                })
                .style("stroke-width", "2px")
                .style("stroke-dasharray", function (d) {
                    return dashing(d.comparisonmethod);
                })
                .style("opacity", 0.5)
                .style("fill", "none")
                .attr("d", function (d) {
                    return makeROCPath(x, y, d.roc);
                })
                .on("mouseover", function (d) {
                    highlightSingle(svg, plot_g, d);
                })
                .on("mouseout", function (d) {
                    unhighlightSingle(svg, plot_g, d);
                });

            plot_g.selectAll(".dot")
                .data(data)
                .enter().append("path")
                .attr("class", function(d) {
                    return "dot" +
                           " dot_ " + d.method.replace(/[^A-Z0-9_]/gi, "_") +
                           " dot_" + makeDataID(d, ["type", "subtype", "subset", "method", "comparisonmethod"]) +
                           " " + (d.filter == "ALL" ? "dot_all" : "dot_pass");
                })
                .attr("d", function(d) { return d.SHAPE; })
                .attr("transform", function (d) {
                    var tr = "translate(" + x(d[X_METRIC]) + "," + y(d[Y_METRIC]) +
                        ")";
                    if(d.filter != "ALL") {
                        tr += "scale(2)";
                    }
                    return tr;
                })
                .style("stroke-width", 1)
                .style("stroke", function (d) {
                    if(d.filter != "ALL") {
                        return d.FILL;
                    } else {
                        return "black";
                    }
                })
                .style("fill", function (d) {
                    if(d.filter != "ALL") {
                        return d.FILL;
                    } else {
                        return "black";
                    }
                })
                .on("mouseover", function (d) {
                    highlightSingle(svg, plot_g, d);
                })
                .on("mouseout", function (d) {
                    unhighlightSingle(svg, plot_g, d);
                })
                .append("title")
                    .text(function(d) {
                        return "" + d.method + " / " + d.comparisonmethod  + " / " + d.filter;
                    });
            svg.select(".x.axis").call(xAxis);
            svg.select(".y.axis").call(yAxis);
        }

        zoomed();

        var legend_start = width + 280;

        var legend = svg.selectAll(".legend")
            .data(color.domain())
            .enter().append("g")
            .attr("class", function(d) {
                return "legend legend_" + d.replace(/[^A-Z0-9_]/gi, "_");
            })
            .attr("transform", function (d, i) {
                return "translate(0," + i * 22 + ")";
            });

        legend.append("circle")
            .attr("cx", legend_start - 9)
            .attr("r", 8)
            .style("fill", color);
        legend.append("text")
            .attr("x", legend_start - 24)
            .attr("dy", ".35em")
            .style("text-anchor", "end")
            .style("font-size", "11px")
            .text(function (d) {
                return d;
            });

        var cmlegend = svg.selectAll(".cmlegend")
            .data(shape.domain()).enter()
            .append("g")
            .attr("class", function(d) {
                return "cmlegend cmlegend_" + d.replace(/[^A-Z0-9_]/gi, "_");
            })
            .attr("transform", function(d, i) {
                return "translate(0," + ((i + color.domain().length) * 22 + 10) + ")";
            });

        cmlegend.append("path")
            .attr("d", function(d) {
                return d3.svg.symbol().type(shape(d))();
            })
            .attr("transform", function (d) {
                return "translate(" + (legend_start - 9) + "," + 9 +
                    ")scale(1.5)";
            })
            .style("stroke", "black");
        cmlegend.append("text")
            .attr("x", legend_start - 40)
            .attr("dy", "12px")
            .style("text-anchor", "end")
            .style("font-size", "11px")
            .text(function (d) {
                return d;
            });
    };
})(PLOT);
module.exports = function() {
    

    var model = Magellan.Views.DistributionBarChart = Backbone.View.extend({

        //template: _.template(''),

        id: "ownership-distribution-chart",

        initialize: function(options) {
            var that = this;
            this.objectType = Magellan.Util.getPluralObjectName(options.objectType).toUpperCase();
            this.data = options.data;
            this.totalCount = options.totalCount;
            this.displayedRows = Array.from(options.displayedRows).sort();
            this.d3 = d3.select(this.el);
        },

        render: function() {
            var that = this;
            //this.$el.html(this.template({}));
            this.drawChart(this.data, this.totalCount);
            return this;
        },

        drawChart: function(chartData, totalCount) {
            const CHART_WIDTH = 900;
            var padding = { top: 50, bottom: 40, left: 80, right: 40 }
            const LEFT_COL_WIDTH = 110;
            const RIGHT_COL_WIDTH = 150;
            const NAME_COL_WIDTH = LEFT_COL_WIDTH;
            const COUNT_PERCENTAGE_LEFT_PADDING = 55;
            const BAR_HEIGHT = 40;
            const BAR_VERTICAL_PADDING = 15;
            const AXIS_BOTTOM_PADDING = 20;
            const NAMETAG_HORIZONTAL_PADDING = 13;

            const BAR_MAX_WIDTH = CHART_WIDTH - padding.left - padding.right - LEFT_COL_WIDTH - RIGHT_COL_WIDTH;
            const NUM_BARS = chartData.length;
            const CHART_HEIGHT = padding.top + AXIS_BOTTOM_PADDING 
                + (BAR_HEIGHT + BAR_VERTICAL_PADDING) * NUM_BARS + padding.bottom;
            const MAX_VALUE = d3.max(chartData, function (d) {
                return d[1]
            });

            if(chartData.length === 0) {
                var svg = this.d3
                    .append('svg')
                    .attr('id', 'ownership-distribution-chart-svg')
                    .attr('width', CHART_WIDTH)
                    .attr('height', CHART_HEIGHT);
                svg.append('g').append('text')
                    .attr('width', CHART_WIDTH)
                    .attr('stroke', '#333')
                    .attr('x', '430')
                    .attr('y', '70')
                    .attr('text-anchor', 'middle')
                    .text("No data available");
                return;
            }

            var colors = ['#ADBF38', '#1793CA', '#0D4D65', '#F1716F', '#F9B330', '#1DB7C4'];
            var darkerColors = ['#9CAC32', '#1584B6', '#0C455B', '#D96664', '#E0A12B', '#1AA5B0'];
            var that = this;
            function getFillColorFromIndex(index, darken) {
                var originalIndex = that.displayedRows[index];
                var colorIndex = originalIndex % colors.length;
                return darken ? darkerColors[colorIndex] : colors[colorIndex];
            }

            var x = d3.scaleLinear()
                .domain([0, MAX_VALUE])
                .range([0, BAR_MAX_WIDTH]).nice();

            var svg = this.d3
                .append('svg')
                .attr('id', 'ownership-distribution-chart-svg')
                .attr('width', CHART_WIDTH)
                .attr('height', CHART_HEIGHT);

            var defs = svg.append("defs");

            var filter = defs.append("filter")
                .attr("id", "dropshadow")

            filter.append("feGaussianBlur")
                .attr("in", "SourceAlpha")
                .attr("stdDeviation", 2)
                .attr("result", "blur");
            filter.append("feOffset")
                .attr("in", "blur")
                .attr("dx", 0)
                .attr("dy", 0)
                .attr("result", "offsetBlur")
            filter.append("feFlood")
                .attr("in", "offsetBlur")
                .attr("flood-color", "#3d3d3d")
                .attr("flood-opacity", "0.3")
                .attr("result", "offsetColor");
            filter.append("feComposite")
                .attr("in", "offsetColor")
                .attr("in2", "offsetBlur")
                .attr("operator", "in")
                .attr("result", "offsetBlur");

            var feMerge = filter.append("feMerge");

            feMerge.append("feMergeNode")
                .attr("in", "offsetBlur")
            feMerge.append("feMergeNode")
                .attr("in", "SourceGraphic");


            var g = svg.append('g')
                .attr('transform', 'translate(' + padding.left + ',' + padding.top + ')');

            var xAxis = d3.axisTop(x)
                .ticks(7)
                .tickSize(-(CHART_HEIGHT - padding.top - padding.bottom))
                .tickPadding(15)
                .tickFormat(function(d) {
                    if(d % 1 !== 0) return '';
                    if(d < 10000) return d;
                    else return humanFormat(d);
                });

            // Draw chart title
            g.append('text')
                .attr('class', 'title')
                .attr('transform', 'translate(10, -15)')
                .text(this.objectType);

            // Draw x-axis
            g.append('g')
                .attr('class', 'axis')
                .attr('transform', 'translate(' + LEFT_COL_WIDTH + ', 0)')
                .call(xAxis);

            // Draw bars
            g.selectAll('.bar')
                .data(chartData)
                .enter().append('rect')
                .attr('class', 'bar')
                .attr('x', LEFT_COL_WIDTH)
                .attr('y', function (d, i) {
                    return i * (BAR_HEIGHT + BAR_VERTICAL_PADDING);
                })
                .attr('width', function (d, i) {
                    return x(d[1])
                })
                .attr('height', BAR_HEIGHT)
                .attr('transform', 'translate(0,' + AXIS_BOTTOM_PADDING + ')')
                .attr('fill', function (d, i) {
                    return getFillColorFromIndex(i);
                });


            // Draw nametags
            var leftColContainers = g.selectAll('.nametag-container')
                .data(chartData)
                .enter().append('g')
                .attr('class', 'nametag-container')
                .attr('x', 0)
                .attr('y', function (d, i) {
                    return i * (BAR_HEIGHT + BAR_VERTICAL_PADDING);
                })
                .attr('transform', function (d, i) {
                    return 'translate(0,' + (i * (BAR_HEIGHT + BAR_VERTICAL_PADDING) + AXIS_BOTTOM_PADDING) + ')';
                });
            leftColContainers.append('rect')
                .attr('class', 'nametag')
                .attr('width', LEFT_COL_WIDTH)
                .attr('height', BAR_HEIGHT)
                .attr('fill', function (d, i) {
                    return getFillColorFromIndex(i, true);
                })
            leftColContainers.append('text')
                .text(function (d, i) {
                    return d[0];
                })
                .attr('fill', 'white')
                .attr('pointer-events', 'none')
                .attr('font-size', '11')
                .attr('font-weight', '600')
                .attr('transform', 'translate(' + NAMETAG_HORIZONTAL_PADDING + ',17.5)')
                .attr('dx', 0)
                .attr('y', 0)
                .attr('dy', 0)
                .attr('class', 'text')
                .call(wrap, NAME_COL_WIDTH - (NAMETAG_HORIZONTAL_PADDING * 2))

            // Draw count and percentages
            var rightColContainers = g.selectAll('.right-col-container')
                .data(chartData)
                .enter().append('g')
                .attr('class', 'right-col-container')
                .attr('x', 0)
                .attr('y', function (d, i) {
                    return i * (BAR_HEIGHT + BAR_VERTICAL_PADDING);
                })
                .attr('transform', function (d, i) {
                    return 'translate(' + (NAME_COL_WIDTH + BAR_MAX_WIDTH + 30) + ',' + (i * (BAR_HEIGHT + BAR_VERTICAL_PADDING) + AXIS_BOTTOM_PADDING) + ')';
                });
            rightColContainers.append('text')
                .text(function (d, i) {
                    var count = d[1];
                    var displayString = '';
                    if (count < 1) {
                        displayString = count;
                    } else if (count < 10000) {
                        displayString = d3.format(',')(count); // e.g. "9999" becomes 9,999
                    } else {
                        displayString = humanFormat(count, {decimals: 1}); // e.g. 12300 becomes 12.3 k
                    }
                    return displayString + ' | ';
                })
                .attr('fill', function (d, i) {
                    return getFillColorFromIndex(i);
                })
                .attr('text-anchor', 'end')
                .attr('font-style', 'italic')
                .attr('transform', 'translate(' + (COUNT_PERCENTAGE_LEFT_PADDING) + ',24)')
            rightColContainers.append('text')
                .text(function (d, i) {
                    var count = d[1];
                    var percetage = d3.format(".0%")(count / totalCount);
                    return percetage;
                })
                .attr('fill', function (d, i) {
                    return getFillColorFromIndex(i);
                })
                .attr('text-anchor', 'end')
                .attr('transform', 'translate(' + (37 + COUNT_PERCENTAGE_LEFT_PADDING) + ',24)')
            rightColContainers.selectAll('text')
                .attr('font-size', '15')
                .attr('font-weight', '300');


            d3.selectAll('.nametag-container')
                .on('mouseover', function (d, i) {
                    d3.select(this).select('.nametag')
                        .transition(20)
                        .attr('width', LEFT_COL_WIDTH + 50)
                        .attr('transform', 'translate(-50, 0)')
                        .attr("filter", "url(#dropshadow)");
                    d3.select(this).select('text')
                        .text(chartData[i][0])
                        .attr('dx', '-50')
                        .call(wrap, LEFT_COL_WIDTH + 50 - 2 * NAMETAG_HORIZONTAL_PADDING);
                    d3.select(this).select('text')
                        .attr('fill-opacity', '0.1')
                        .transition(20)
                        .attr('fill-opacity', '1');
                })
                .on('mouseout', function (d, i) {
                    d3.select(this).select('.nametag')
                        .transition(20)
                        .attr('width', LEFT_COL_WIDTH)
                        .attr('transform', 'translate(0, 0)')
                        .attr("filter", "none");
                    d3.select(this).select('text')
                        .text(chartData[i][0])
                        .attr('dx', '0')
                        .call(wrap, LEFT_COL_WIDTH - 2 * NAMETAG_HORIZONTAL_PADDING);
                    d3.select(this).select('text')
                        .attr('fill-opacity', '0.1')
                        .transition(20)
                        .attr('fill-opacity', '1')
                });

            function wrap(text, width) {
                text.each(function () {
                    var text = d3.select(this),
                        words = text.text().split(/\s+/).reverse(),
                        word,
                        line = [],
                        lineNumber = 0,
                        lineHeight = 1.2, // ems
                        y = text.attr("y"),
                        dx = parseFloat(text.attr("dx")),
                        dy = parseFloat(text.attr("dy")),
                        tspan = text.text(null).append("tspan").attr("x", 0).attr("y", y).attr("dx", dx).attr("dy", dy + "em");
                    while (word = words.pop()) {
                        line.push(word);
                        tspan.text(line.join(" "));
                        if (tspan.node().getComputedTextLength() > width) {
                            line.pop();
                            var lineText = line.join(" ");
                            tspan.text(lineText);
                            line = [word];
                            if (lineNumber++ < 1) {
                                // Initialise the next line's tspan
                                tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dx", dx).attr("dy", lineNumber * lineHeight + dy + "em").text(word);
                            } else {
                                var originalText = tspan.text();
                                tspan.text(originalText + "...");
                                break;
                            }
                        }
                    }
                    if (lineNumber === 0) {
                        text.attr('y', '6')
                        text.selectAll('tspan').attr('y', '6')
                    } else {
                        text.attr('y', '0')
                        text.selectAll('tspan').attr('y', '0')
                    }
                });
            }

        }

    });
}

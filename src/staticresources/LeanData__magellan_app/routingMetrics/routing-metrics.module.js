module.exports = function(routingMetrics, startDate, endDate) {
  Magellan.Views.RoutingMetrics = require('./routing-metrics.view')();
  Magellan.Models.RoutingMetrics = require('./routing-metrics.model')();

  // render is called when the view is initialized
  var routingMetrics = new Magellan.Views.RoutingMetrics({
      model: new Magellan.Models.RoutingMetrics(),
      routingMetrics : routingMetrics,
      startDate : startDate,
      endDate : endDate,
  });

  $('.dg_inner-wrapper').html(routingMetrics.$el);
}

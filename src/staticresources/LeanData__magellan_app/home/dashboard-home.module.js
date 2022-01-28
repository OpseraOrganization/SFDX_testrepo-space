module.exports = function(routingMetrics, startDate, endDate) {
  Magellan.Views.Home = require('./dashboard-home.view')();
  Magellan.Models.Home = require('./dashboard-home.model')();

  // render is called when the view is initialized
  const home = new Magellan.Views.Home({
      model: new Magellan.Models.Home(),
      routingMetrics : routingMetrics,
      startDate : startDate,
      endDate : endDate,
  });

  $('.dg_inner-wrapper').html(home.$el);
}

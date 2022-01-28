module.exports = function() {
  return Backbone.Model.extend({
    defaults: {
      'graphLines': {},
      'usageMetrics': [],
      'lineValues': [],
      'firstRowIconNameToPageName': {
        'Matching' : 'matching-CM', 
        'Routing' : 'router-lead-FB',
        'Attribution' : 'attribution',
        'View' : 'view'
      },
      'secondRowIconNameToPageName': {
        'Admin' : 'admin',
        'Help' : 'help'
      },
    }
  });
}

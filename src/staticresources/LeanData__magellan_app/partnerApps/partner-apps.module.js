module.exports = function(metadata) {
  Magellan.Views.PartnerApps = require('./partner-apps.view')();
  Magellan.Models.PartnerApps = require('./partner-apps.model')();

  let partnerApps = new Magellan.Views.PartnerApps({
    model: new Magellan.Models.PartnerApps(),
    metadata: metadata
  });

  $('.dg_inner-wrapper').html(partnerApps.$el);
}

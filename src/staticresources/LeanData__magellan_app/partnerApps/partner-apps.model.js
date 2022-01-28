module.exports = function() {
  return Backbone.Model.extend({
    defaults: {
      showPartnerCards: true, // flag to check if partner cards or config view should be shown
      partnersList: [], // stores a list of partner objects
      selectedPartnerModel: {}, // partner object associated to the partner card clicked
      authMetadata: {}
    }
  });
}

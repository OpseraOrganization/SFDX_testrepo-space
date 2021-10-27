module.exports = function() {
  return Backbone.View.extend({
    tagName: 'div',
    template: _.template(require('./partner-card.template.html')),
    initialize: function(params) {
      this.parent = params.parent;
      this.render();
    },

    events: {
      'click .action-button': 'partnerCardClicked',
      'click #disable-authorization': 'disablePartnerAuthorization',
      'click #learn-more': 'navigateToHelp',
    },

    navigateToHelp: function (e) {
      Magellan.Navigation.navigate('help');
    },

    disablePartnerAuthorization: function() {
      Magellan.Controllers.FlowBuilder.disablePartnerAuthorization(
        this.model.partnerName.toLowerCase()
      ).then((result, event) => {
        if (event.statusCode === 200) {
          // TODO: just refresh (via initialization) again instead
          var successModal = new Magellan.Views.ConfirmationModal({
            header: "Partner Authorization",
            message: "You have successfully disabled authorization. Please refresh this page.",
            primaryButtonText: "OK",
            hideSecondaryButton: true,
          });
          successModal.open();
        }
      });
    },


    partnerCardClicked: function(event) {
      const partnerName = $(event.target).data('partnername');
      this.parent.trigger('partnerCardClicked', partnerName);
    },

    render: function() {
      const content = this.template({
        model: this.model
      });

      this.$el.html(content);
      return this;
    }
  });
}

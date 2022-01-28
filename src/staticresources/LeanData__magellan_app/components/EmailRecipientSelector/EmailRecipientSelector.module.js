module.exports = function() {
  Magellan.Models.EmailRecipientSelector = require('./EmailRecipientSelector.model')();
  Magellan.Views.EmailRecipientSelector = require('./EmailRecipientSelector.view')();
}

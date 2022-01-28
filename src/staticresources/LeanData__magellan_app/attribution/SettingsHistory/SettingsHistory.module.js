module.exports = function(settingsHistoryData) {
  // Declare page view and model
  var SettingsHistoryView = require('./settings-history.view')();
  var SettingsHistoryModel = require('./settings-history.model')();

  // Initialize MVCs
  var settingsHistoryModel = new SettingsHistoryModel( { history: settingsHistoryData} );
  var settingsHistoryPage = new SettingsHistoryView({ model: settingsHistoryModel });

  // Render Page
  $(".dg_inner-wrapper").html(settingsHistoryPage.render().$el);
}

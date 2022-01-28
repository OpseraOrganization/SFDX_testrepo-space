module.exports = function (runHistoryData) {
  // Declare page view and model
  var RunHistoryView = require('./run-history.view')();
  var RunHistoryModel = require('./run-history.model')();

  // Initialize MVCs
  var runHistoryModel = new RunHistoryModel({ 
    allData: runHistoryData,
    history: runHistoryData.history, 
    hasActiveJobs: runHistoryData.hasActiveJobs,
    oneBatchOn: runHistoryData.oneBatchOn,
    emailList: runHistoryData.emailList
  });
  var runHistoryPage = new RunHistoryView({ model: runHistoryModel });

  // Render Page
  $(".dg_inner-wrapper").html(runHistoryPage.render().$el);
}

export const sendSolutionToWebWorker = (
  region,
  model,
  uiSelections,
  webWorkerId
) => {
  // debugger
  console.log('window', window)
  window.oGActiveModel = {};
  window.oGActiveModel.name = model.name;
  window.oGActiveModel.objects = model.objects;
  window.nGShowIdTxt = 2;

  // sGSelectedConfigurationID = 'solution1';
  sGSelectedConfigurationID = webWorkerId;
  console.log('webworker', JSON.stringify(uiSelections))
  doStartWorker(sGSelectedConfigurationID);
  doConfigure(sGSelectedConfigurationID);
  doClearConfiguration(sGSelectedConfigurationID);
  doPostMessage(
    JSON.stringify({ region: region, networkViewData: uiSelections })
  );

  console.info("Message sent to Webworker: ");

  /*
   in the sent solution there are currently all object properties included, just use the "name" property
  for identifying which object is in the UI engine solution.
  */
};

export const destroyWebworker = webworkerId => {
  try {
    if (typeof Worker !== "undefined") {
      if (oWebWorkers[webworkerId] !== "undefined") {
        oWebWorkers[webworkerId].terminate();
        delete oWebWorkers[webworkerId];
      }
    }
  } catch (e) {}
};

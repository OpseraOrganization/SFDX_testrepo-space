let nGSC = 1;

const apiEngine = {
  sGSelectedConfigurationID: (() => "S"+("1234567891"+((new Date()).getTime()).toString()+(Math.floor(Math.random()*10)).toString()+(Math.floor(Math.random()*10)).toString()+(nGSC++).toString()).substr(-11,11) )(),

  doConfigure (sInObjectId, sessionId, reconfigMode) { // ADD STATION
    let xConf = apiEngine.getConfigByID(sInObjectId);

    xConf.data.solution.ZCONFIG_ID = sInObjectId;
    xConf.data.ZCONFIG_ID = sInObjectId;
    xConf.data.ZMODEL_VAL_ID = "Offline tool";
    xConf.data.ZMODEL_VAL_NAME = "Test";
    xConf.data.ZMODEL_VAL_ENGINE = "doCATSolution.js";
    xConf.data.ZMODEL_USER_ROLE = "Normal user";
    xConf.data.reconfigure = !!reconfigMode;

    const webWorkerData = {xConf: xConf, sessionId: sessionId};

    const promise1 = $nuxt.$children[1].$children[0].$children[0].msgBroker("addStation", JSON.stringify(webWorkerData));
    promise1.then((resp) => {
      $nuxt.$bus.$emit('stationAdded', resp.data)
      debugger;
    }).catch((e) => {
      alert("Something went wrong!");
      $nuxt.$children[1].$children[0].$children[0].hideLoader();
      console.log("ERROR! ", e);
    });
  },

  getConfigByID(sInConfigId) {
      return({"data":{"ZCONFIG_ID":sInConfigId,"solution":{}}});
  },

  doPostMessageToConf(oInJSON, sessionId, isLink, solution, fromLink, changingStations, stationId, changingLink, isSecondStationUpdate, linkmsg, linkIdx, changingActiveLink, isDblClick) {// UPDATE STATION
    let xConf = apiEngine.getConfigByID(apiEngine.sGSelectedConfigurationID);

    if(xConf != null) {

      oInJSON !== null
        ? xConf.data.messageobject = JSON.parse(JSON.stringify(oInJSON))
        : xConf.data.lSelections = solution.lGSelections;
      xConf.data.sessionId = sessionId;
      xConf.data.reconfigure = true;

      const webWorkerData = { xConf: xConf };

      var promise1 = $nuxt.$children[1].$children[0].$children[0].msgBroker("updateStation", sessionId, JSON.stringify(webWorkerData));
      promise1.then((resp) => {
        if (isSecondStationUpdate) {
          $nuxt.$bus.$emit('secondStationUpdated', {
            data: resp.data,
            stationId: stationId,
            linkmsg: linkmsg,
            linkIdx: linkIdx
          })
        }
        else
          isLink
            ? $nuxt.$bus.$emit('stationUpdated', {
              data: resp.data,
              isLink: isLink,
              fromLink: fromLink,
              changingStations: changingStations,
              changingLink: !!changingLink,
              stationId: stationId,
              linkIdx: linkIdx,
              changingActiveLink: changingActiveLink,
              isDblClick: isDblClick
            })
            : $nuxt.$bus.$emit('stationUpdated', resp.data);
        debugger;
      }).catch((e) => {
        alert("Something went wrong!");
        $nuxt.$children[1].$children[0].$children[0].hideLoader();
        console.log("ERROR! ", e);
      });
    }
  },

  addObject2SolutionByIndex (nInIndex, nInQty, sInService, sInObjectName, sInSelection,sInSelectionName,sInRequirementOwnerId, solution, sessionId, sublinkIdx, linkIdx) { // ADD LINK
    let xConf = apiEngine.getConfigByID(apiEngine.sGSelectedConfigurationID);

    if(xConf != null) {
      xConf.data.addobjects = [];
      xConf.data.solution = solution;
      xConf.data.addobjects.push({index: nInIndex,qty: nInQty,service: sInService,object: sInObjectName,selection: sInSelection	,selectionname:(sInSelectionName||''),reqownerid:(sInRequirementOwnerId||'')});
      const webWorkerData = { xConf: xConf };

      const promise1 = $nuxt.$children[1].$children[0].$children[0].msgBroker("updateStation", sessionId, JSON.stringify(webWorkerData));
      promise1.then((resp) => {
        $nuxt.$bus.$emit('linkAdded', resp.data, sublinkIdx, linkIdx)
        debugger;
      }).catch((e) => {
        alert("Something went wrong!");
        $nuxt.$children[1].$children[0].$children[0].hideLoader();
        console.log("ERROR! ", e);
      });
    }
  }
};

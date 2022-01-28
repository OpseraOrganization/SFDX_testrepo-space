module.exports = function() {
  const LineGraphView = require('../components/LineGraph/linegraph.view')();
  const GraphTabs = require('../components/LDTabs/LDTabs.view')();
  const RoutingMetricsTable = require('./routingMetricsTable/routing-metrics-table.view')();
  const RoutingMetricsControl = require('./routingMetricsControl/routing-metrics-control.view')();

  return Backbone.View.extend({
    template: _.template(require('./routing-metrics.template.html')),
    initialize: function(params) {
      this.formatUsageMetrics(params.routingMetrics.routingCountMetrics, params.startDate, params.endDate);
      this.model.set('routingUserLicenseCount', params.routingMetrics.routingUserLicenseCount);
      this.setRoutedToIds();
      this.fetchRoutingList(this.model.get('routedToIds'));
      this.model.set('queryStartDate', this.model.get('startDate'));
      this.model.set('queryEndDate', this.model.get('endDate'));
    },

    /***************** CREATING SUBVIEWS ********************/
    render: function() {
      // pass model to the template
      const content = this.template({
        model: this.model.toJSON()
      });

      this.$el.html(content);
      this.createTab();
      this.createRoutingMetricsControl();
      this.createGraphData();
      this.updateMaxUniqueUsers();
      this.parseObjectTypeLineValues();
      this.renderLineGraph();
      this.createRoutingMetricsTable();
      this.setListeners();
      this.setActiveUserAndRecordCount();
      return this;
    },

    createTab: function() {
      this.graphTabs = new GraphTabs(['All Routing', 'Lead', 'Contact', 'Account', 'Opportunity']);
      this.$el.find('.line-graph-tab-wrapper').html(this.graphTabs.$el);
    },

    createRoutingMetricsControl: function() {
      this.routingMetricsControl = new RoutingMetricsControl({
        model: this.model,
      }).bind(this);
      this.$el.find('.line-graph-control-wrapper').html(this.routingMetricsControl.$el);
    },

    createGraphData: function() {
      const lineValues = this.model.get('usageMetrics').map(
        function(metric, i) {
          const routedMap = metric['All_Routing_Users'];
          return {
            'index': i,
            'date': metric.Date,
            'count': metric['All_Routing_User_Count'],
            'metric': metric,
          };
        }
      );

      this.model.set('lineValues', lineValues);
    },

    renderLineGraph: function() {
      const licensedUserCount = this.model.get('routingUserLicenseCount');
      const totalMaxUserCount = Magellan.Util.shortenNumbers(this.model.get('maxUniqueRoutedToCount'));
      const totalRecordsRouted = this.model.get('recordsRouted')['total'];

      this.lineGraphView = new LineGraphView({
        cardInfo: this.getCardInfo(licensedUserCount, totalMaxUserCount, totalRecordsRouted),
        legendInfo: this.getLegendInfo(),
        graphLines: {}, // initialize with empty object first and manually set graphlines below
        params: {
          width: 1050,
          height: 350,
          margin_top: 10,
          margin_left: 15,
          margin_bottom: 30,
          margin_right: 30,
          tick_format_x: d3.timeFormat("%m/%d"),
          tick_format_y: function(y) { return Math.floor(y) == y ? y : undefined; },
          get_data_x: function(p) { return p.date; },
          get_data_y: function(p) { return p.count; },
          transition_time: 700
        }
      });
      this.$el.find('.line-graph-wrapper').html(this.lineGraphView.$el);

      const lineValues = this.model.get('lineValues');
      this.updateGraphLines(lineValues);
    },

    createRoutingMetricsTable: function() {
      this.routingMetricsTable = new RoutingMetricsTable({
        model: this.model
      }).bind(this);
      this.$el.find('.routing-metrics-table-wrapper').html(this.routingMetricsTable.$el);
    },

    setListeners: function() {
      this.listenTo(this.graphTabs, 'selectedTab:changed', this.updateGraphAndTable);
      this.listenTo(this.routingMetricsControl, 'dateRange:changed', this.updateDateRange);
      this.listenTo(this.routingMetricsControl, 'exportRoutingUsageButton:clicked', this.exportRoutingUsage);
      this.listenTo(this.routingMetricsControl, 'hideInactiveUsers:changed', this.handleInactiveUsers);
      this.listenTo(this.lineGraphView, 'dataPoint:selected', this.selectPoint);
      this.listenTo(this.routingMetricsTable, 'dateFilter:changed', this.deselectPoint);
      this.listenTo(this.model, 'change:routingList', this.updateMaxUniqueUsers);
    },

    updateMaxUniqueUsers: function() {
      let userCount = 0;
      let queueCount = 0;
      let deletedCount = 0;
      const routingList = this.model.get('routingList').filter(routingInfo => routingInfo.Count[this.model.get('selectedTab')] > 0);
      
      for (let i = 0; i < routingList.length; i++) {
        if (routingList[i].Profile === 'User') {
          userCount++;
        } else if (routingList[i].Profile === 'Queue') {
          queueCount++;
        } else if (routingList[i].Profile === 'Deleted') {
          deletedCount++;
        }
      }

      this.model.set('maxUniqueRoutedToCount', userCount + queueCount + deletedCount);
      this.model.set('maxUniqueUsers', userCount);
      this.model.set('maxUniqueQueues', queueCount);
      this.model.set('deletedUsersOrQueues', deletedCount);
    },

    handleInactiveUsers: function() {
      if (this.model.get('hideInactiveUsers') === true) {
        const activeRoutingList = this.model.get('routingList').filter(routingListObj => routingListObj.Status === 'Active');
        // store current routingList used in temp 
        this.model.set('tempRoutingList', this.model.get('routingList'));
        this.model.set('routingList', activeRoutingList);
      } else {
        this.model.set('routingList', this.model.get('tempRoutingList'));
        this.model.set('tempRoutingList', []);
      }

      const selectedPoint = this.model.get('selectedPoint');
      const objectType = this.model.get('selectedTab') === 'total' ? 'All Routing' : this.model.get('selectedTab');
      if (selectedPoint) {
        const indexOfSelectedPoint  = selectedPoint.index;
        const newSelectedPoint = this.getNewSelectedPoint(indexOfSelectedPoint, objectType);
        if (selectedPoint.count != newSelectedPoint.count) { // only reselect point if the counts are different
          this.model.set('selectedPoint', undefined);
          this.selectPoint(newSelectedPoint);
        }
      } else {
        this.lineGraphView.setTransitionDuration(700);
        this.filterGraphLinesByObject(objectType, true);
      }
    },

    /***************** SELECT POINT ********************/
    selectPoint: function(point) {
      if (this.model.get('selectedPoint')) {
        return;
      }

      this.$el.find('.line-graph-wrapper').LoadingOverlay('show');

      // toggle display attribute
      this.$el.find('.primary-line, .secondary-line, .tertiary-line').hide();
      this.$el.find('.point-selection').show();

      this.model.set('selectedPoint', point);
      this.updateGraphLines(this.model.get('lineValues'));

      // set transition duration
      this.lineGraphView.setTransitionDuration(0);
      this.lineGraphView.updateGraph();

      // make callout to retrieve data for day
      const date = moment(this.model.get('selectedPoint').date).format(Magellan.Validation.DATE_FORMAT);
      const getUsageMetricsRoutingListOnDatePromise = Magellan.Controllers.FlowBuilder.getUsageMetricsRoutingListOnDate(date);
      $.when(getUsageMetricsRoutingListOnDatePromise).then(function(result) {
        this.updateRoutingListForDate(result);
        this.updateInactiveUserIds(result.User);
        this.routingMetricsTable.render();

        this.$el.find('.line-graph-wrapper').LoadingOverlay('hide', true);

        // update data cards
        const licensedUserCount = this.model.get('routingUserLicenseCount'); // hardcoded until usage provisioning is ready
        const selectedTab = this.model.get('selectedTab');

        let recordsRouted = 0;
        const inactiveUserIds = this.model.get('inactiveUserIds');

        for (let id in result.routingMetrics) {
          if (!this.model.get('hideInactiveUsers') || !inactiveUserIds.includes(id)) {
            const sObjectTypeCount = result.routingMetrics[id][selectedTab];
            if (!_.isUndefined(sObjectTypeCount)) {
              recordsRouted += sObjectTypeCount;
            }
          }
        }
        const updatedCardInfo = this.getCardInfo(licensedUserCount, this.model.get('maxUniqueRoutedToCount'), recordsRouted);
        this.lineGraphView.updateCardInfo(updatedCardInfo);

      }.bind(this));
    },

    createSelectedPointLine: function() {
      const selectedPoint = this.model.get('selectedPoint');
      let selectedPointLine = [];
      const count = this.model.get('selectedTab') == 'total' ? 'All' : _.capitalize(this.model.get('selectedTab'));
      const hideInactiveUsers = this.model.get('hideInactiveUsers');
      if (selectedPoint) {
        selectedPointLine = [Object.assign({}, selectedPoint, { count: (this.model.get('selectedTab') == 'total' && !hideInactiveUsers) ? selectedPoint.metric['All_Routing_User_Count'] : selectedPoint.count  })];
      }
      return selectedPointLine;
    },

    // returns the new selected point on the same date when inactive users is toggled or when the tab is changed
    getNewSelectedPoint: function(indexOfPrevSelectedPoint, objectType) {
      const newSelectedPoint = Object.assign({},
        this.model.get(objectType === 'All Routing' ? 'lineValues' : (objectType.toLowerCase() + 'LineValues')).
        filter(x => x.index === indexOfPrevSelectedPoint)[0]
      );

      if (this.model.get('hideInactiveUsers') === true) {
        const inactiveUserIds = this.model.get('inactiveUserIds');
        const routingUserToCount = objectType === 'All Routing' ? newSelectedPoint['metric']['All_Routing_Users'] : newSelectedPoint['metric'];
        newSelectedPoint.count = Object.keys(routingUserToCount).filter(x => !inactiveUserIds.includes(x)).length;
      }
      return newSelectedPoint;
    },

    updateRoutingListForDate: function(data) {
      const routingListOnDate = [];
      this.formatRoutingList(data.Queue, data.routingMetrics, 'Queue', routingListOnDate);
      this.formatRoutingList(data.User, data.routingMetrics, 'User', routingListOnDate);
      this.includeDeletedUsersAndQueues(routingListOnDate, data.routingMetrics);
      this.model.set('routingList', routingListOnDate);
    },

    /***************** DESLECT POINT ********************/

    deselectPoint: function(withRender) {
      if (!this.model.get('selectedPoint')) {
        return;
      }
      this.$el.find('.primary-line, .secondary-line, .tertiary-line').show();
      this.$el.find('.point-selection').hide();

      // deselect point
      this.model.set('selectedPoint', undefined);

      const objectType = this.model.get('selectedTab') === 'total' ? 'All Routing' : this.model.get('selectedTab');
      this.filterGraphLinesByObject(objectType, true);
      this.model.set('routingList', this.model.get('allRoutingList'));

      if (this.model.get('hideInactiveUsers') === true) {
        const activeRoutingList = this.model.get('routingList').filter(routingListObj => routingListObj.Status === 'Active');
        // store current routingList used in temp 
        this.model.set('tempRoutingList', this.model.get('routingList'));
        this.model.set('routingList', activeRoutingList);
      }

      this.updateDataCardValues(this.model.get('selectedTab')); // update card values after routingList is changed

      // used when date filter is removed (show original graph before selection)
      if (withRender) {
        this.lineGraphView.setTransitionDuration(0);
        this.lineGraphView.updateGraph();
        this.routingMetricsTable.render();
      }
    },

    /***************** EXPORT GRAPH DATA ********************/

    exportRoutingUsage: function() {
      this.routingMetricsTable.downloadCsv();
    },

    /***************** DATE RANGE CHANGED ********************/

    updateDateRange: function(dateRange) {
      this.deselectPoint(false);
      const startDate = moment(dateRange.startDate).format(Magellan.Validation.DATE_FORMAT);
      const endDate = moment(dateRange.endDate).format(Magellan.Validation.DATE_FORMAT);

      this.model.set('hideInactiveUsers', false);
      this.$el.find('#hide-inactive-users').prop('checked', false); // uncheck checkbox

      const getRoutingCountMetricsPromise = Magellan.Controllers.FlowBuilder.getRoutingUsageMetricsAndLicenseCount(startDate, endDate);
      $.when(getRoutingCountMetricsPromise).then(function(result){
        if (!_.isEmpty(result.routingCountMetrics)) {
          this.model.set('allRoutingList', []); // reset routing list
          const formatUsageMetricsPromise = new Promise(function(resolve, reject) {
            if (this.formatUsageMetrics(result.routingCountMetrics, startDate, endDate)) {
              resolve();
            } else {
              reject();
            }
          }.bind(this));

          formatUsageMetricsPromise.
            then(() => this.setRoutedToIds()).
            then(() => this.fetchRoutingList(this.model.get('routedToIds')));
        } else {
          this.$el.find('.primary-line, .secondary-line, .tertiary-line').hide();
          this.model.set('routingList', []);
          this.lineGraphView.render();
          const updatedCardInfo = this.getCardInfo(0, 0, 0);
          this.lineGraphView.updateCardInfo(updatedCardInfo);
          this.routingMetricsTable.render();
        }
      }.bind(this));
    },

    /***************** LD TAB CHANGED ********************/

    updateGraphAndTable: function(objectType) {
      let indexOfSelectedPoint = undefined;
      let withRender = true;
      const selectedPoint = this.model.get('selectedPoint');

      if (selectedPoint) {
        indexOfSelectedPoint = selectedPoint.index;
        this.model.set('selectedPoint', undefined);
        withRender = false;
      }
      this.lineGraphView.setTransitionDuration(700);
      this.filterRoutingMetricsTableByObject(objectType, withRender);
      this.filterGraphLinesByObject(objectType, withRender);

      if (indexOfSelectedPoint) {
        const newSelectedPoint = this.getNewSelectedPoint(indexOfSelectedPoint, objectType);
        this.selectPoint(newSelectedPoint);
      }

      if (objectType !== 'All Routing') {
        console.log(this.$el.find('.data-card-2'));
        this.$el.find('.data-card-2').hide();
      }
    },

    filterRoutingMetricsTableByObject: function(objectType, withRender) {
      if (objectType === 'All Routing') {
        this.model.set('selectedTab', 'total');
      } else {
        this.model.set('selectedTab', objectType.toLowerCase());
      }

      this.updateMaxUniqueUsers();
      if (withRender) {
        this.routingMetricsTable.render();  
      }
    },

    // change line graph when objectType selected from LDTab
    filterGraphLinesByObject: function(objectType, withRender) {
      const hideInactiveUsers = this.model.get('hideInactiveUsers');

      if (objectType === 'All Routing') {
        this.updateDataCardValues('total');
        this.updateGraphLines(this.model.get('lineValues'));
        return;
      }

      if (withRender) {
        // update line graph
        const filteredLineValuesKey = objectType.toLowerCase() + 'LineValues';
        this.updateDataCardValues(objectType.toLowerCase());
        this.updateGraphLines(this.model.get(filteredLineValuesKey));
      }
    },

    updateDataCardValues: function(objectType) {
      let userCount = this.model.get('maxUniqueRoutedToCount');
      let recordsRouted;
      if (this.model.get('hideInactiveUsers')) {
        recordsRouted = this.model.get('activeRecordsRouted');
      } else {
        recordsRouted = this.model.get('recordsRouted');
      }
      const licensedUserCount = this.model.get('routingUserLicenseCount');
      const objectTypeTotalRecordsRouted = recordsRouted[objectType];
      const updatedCardInfo = this.getCardInfo(licensedUserCount, userCount, objectTypeTotalRecordsRouted);

      this.lineGraphView.updateCardInfo(updatedCardInfo);
    },

    /***************** FETCHING & FORMATTING DATA ********************/

    fetchRoutingList: function(ids) {
      const serializedIds = JSON.stringify(ids);
      const getRoutingUsersPromise = Magellan.Controllers.FlowBuilder.getUsageMetricsRoutingList(serializedIds, 'User');
      const getRoutingQueuesPromise = Magellan.Controllers.FlowBuilder.getUsageMetricsRoutingList(serializedIds, 'Queue');

      $.when(getRoutingUsersPromise, getRoutingQueuesPromise).then(function(result1, result2) {
          this.updateRoutingList(result1[0], 'User', 'allRoutingList');
          this.updateInactiveUserIds(result1[0]);
          this.updateRoutingList(result2[0], 'Queue', 'allRoutingList');
          this.includeDeletedUsersAndQueues(this.model.get('allRoutingList'), this.model.get('idToRecordTypeCount'));

          // set routingList to be same as allRoutingList
          this.model.set('routingList', this.model.get('allRoutingList'));
          this.render();
      }.bind(this));
    },

    formatUsageMetrics: function(rawRoutingMetrics, startDate, endDate) {
      const formattedMetrics = Magellan.Util.formatUsageMetrics(rawRoutingMetrics);

      this.model.set({
        'usageMetrics': formattedMetrics.usageMetrics,
        'recordsRouted': formattedMetrics.recordsRouted,
        'idToRecordTypeCount' : formattedMetrics.idToRecordTypeCount,
        'rawRoutingMetrics' : rawRoutingMetrics,
        'startDate': moment(startDate).format('MMMM D, YYYY'),
        'endDate': moment(endDate).format('MMMM D, YYYY'),
      });

      return true;
    },

    parseObjectTypeLineValues: function() {
      for (const objectType of Magellan.Util.objectTypes) {
        const filteredLineValuesKey = objectType.toLowerCase() + 'LineValues';
        const filteredLineValues = this.model.get('lineValues').map(
          function(lineValueObj, index) {
            const objectTypeMetric = JSON.parse(lineValueObj.metric[objectType + '_Routing_Users']);
            const routingCount = Object.keys(objectTypeMetric).length;
            return {
              'index' : index,
              'date' : lineValueObj.date,
              'count' : routingCount,
              'metric': objectTypeMetric
            }
          });
        this.model.set(filteredLineValuesKey, filteredLineValues);
      }
    },

    setActiveUserAndRecordCount: function() {
      const inactiveUserIds = this.model.get('inactiveUserIds');
      const rawActiveRoutingMetrics = this.model.get('rawRoutingMetrics');
      for (let date in rawActiveRoutingMetrics) {
        const routingMetricOnDate = rawActiveRoutingMetrics[date];
        for (let objectType in routingMetricOnDate) {
          const objectRoutingMetric = routingMetricOnDate[objectType];
          for (let id in objectRoutingMetric) {
            if (inactiveUserIds.includes(id)) {
              delete objectRoutingMetric[id];
            }
          }
        }
      }

      const formattedActiveMetrics = Magellan.Util.formatUsageMetrics(rawActiveRoutingMetrics);

      this.model.set({
        'activeUserCount' : formattedActiveMetrics.userCount,
        'activeRecordsRouted' : formattedActiveMetrics.recordsRouted,
      });
    },

    updateRoutingList: function(data, dataType, routingListType) {
      const routingList = this.model.get(routingListType);
      this.formatRoutingList(data, this.model.get('idToRecordTypeCount'), dataType, routingList);
      this.model.set(routingListType, routingList);
    },

    includeDeletedUsersAndQueues: function(routingList, idToRecordTypeCount) {
      let deletedIds = [];
      let nonDeletedIds = routingList.map(x => x.Id);
      let allIds = Object.keys(idToRecordTypeCount);

      for (let id of allIds) {
        if (!nonDeletedIds.includes(id)) {
          deletedIds.push(id);
        }
      }

      for (let deletedId of deletedIds) {
        const routingListObject = {
          Name: 'Deleted', 
          Id:  deletedId,   
          Status: 'Deleted',
          Role: 'Deleted',
          Profile: 'Deleted',
          Count: idToRecordTypeCount[deletedId]
        };

        routingList.push(routingListObject);
      }
    },

    formatRoutingList: function(data, idToRecordTypeCount, dataType, routingList) {
      const inactiveUserIds = this.model.get('inactiveUserIds');
      let isActive;
      for (let eachRecord of data) {
        if (dataType === 'User') {
          isActive = eachRecord.IsActive ? 'Active' : 'Inactive';
        } else {
          isActive = 'Active';
        }
        
        const routingListObject = {
          Name: eachRecord.Name, 
          Id:  eachRecord.Id,   
          Status: isActive,
          Role: dataType === 'User' ? eachRecord.Profile.Name : dataType,
          Profile: dataType,
          Count: idToRecordTypeCount[eachRecord.Id]
        };

        if (!this.model.get('hideInactiveUsers') || !inactiveUserIds.includes(routingListObject.Id)) {
          routingList.push(routingListObject);
        }
      }
    },

    // get an array of all the Ids (users/queues) that are being routed to
    setRoutedToIds: function() {
      const idArray = [];
      this.model.get('usageMetrics').map(
        function(usageMetric, index) {
          const dailyIds = Object.keys(usageMetric['All_Routing_Users']);
          for (let id of dailyIds) {
            if (!_.contains(idArray, id)) {
              idArray.push(id);
            }
          }
      }); 
      this.model.set('routedToIds', idArray);
    },

    updateInactiveUserIds: function(data) {
      const inactiveUserIds = this.model.get('inactiveUserIds');
      for (let eachRecord of data) {
        if (!eachRecord.IsActive && !inactiveUserIds.includes(eachRecord.Id)) {
          inactiveUserIds.push(eachRecord.Id);
        }
      }
    },

    /***************** LINE GRAPH METHODS ********************/

    updateGraphLines: function(lineValues) {
      if (lineValues != undefined) {
        // get variables
        const startDate = this.model.get('startDate');
        const endDate = this.model.get('endDate');
        const licensedUserCount = this.model.get('routingUserLicenseCount');
        const selectedPointLine = this.createSelectedPointLine();
        let filteredLineValues = lineValues;

        if (this.model.get('hideInactiveUsers') === true) {
          filteredLineValues = lineValues.map(function(eachLineValue, index) {
            const objectType = this.model.get('selectedTab') === 'total' ? 'All' : _.capitalize(this.model.get('selectedTab'));
            let routedToIdsForType = [];
            const objectTypeRoutingUserMetric = objectType === 'All' ? eachLineValue.metric[objectType + '_Routing_Users'] : eachLineValue.metric;
            if (!_.isUndefined(objectTypeRoutingUserMetric)) {
              routedToIdsForType = Object.keys(objectTypeRoutingUserMetric);  
            }
            const activeUsersId = routedToIdsForType.filter(id => !this.model.get('inactiveUserIds').includes(id));
            return {
              index: eachLineValue.index,
              date: eachLineValue.date,
              count: activeUsersId.length,
              metric: objectTypeRoutingUserMetric,
            };
          }.bind(this));
        }

        this.lineGraphView.createAndSetGraphLine(startDate, endDate, licensedUserCount, filteredLineValues, selectedPointLine);
        this.lineGraphView.updateGraph();
      }
    },
    
    /***************** DATA CARDS METHODS ********************/

    getCardInfo: function(licensedUserCount, maxUserCount, recordsRouted) {
      return [
        { title: 'Licensed Users', value: numberWithCommas(licensedUserCount) }, // hardcode value at least until user provisioning is ready
        { title: 'Unique Users', value: numberWithCommas(maxUserCount) },
        { title: 'Records Routed', value: numberWithCommas(recordsRouted) },
      ];
    },

    getLegendInfo: function() {
      return [
        'Active Users/Queues',
        'Licensed Users',
      ];
    },
  });
}

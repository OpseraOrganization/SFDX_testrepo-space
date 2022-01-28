module.exports = function() {
  var DetailView = require('./detail-view/detail-view.view')();
  var dateFormat = 'MM/DD/YYYY, h:mm A';
  return Backbone.View.extend({
    template: _.template(require('./settings-history.template.html')),

    events: {
      'click .ld-secondary-small-button.viewLog': 'viewLogDetail',
      'click #summaryViewLink': 'returnToSummary',
    },

    initialize: function() {
    },

    render: function() {
      var content = this.template({
        model: this.model.toJSON(),
        formatMomentDate: Magellan.Util.formatMomentDate,
        dateFormat: dateFormat,
      });
      this.$el.html(content);
      
      var options = Object.keys(this.model.get('descriptionMap')).sort();
      options.unshift('All');
      this.settingsPageDropdown = new Magellan.Views.LDDropdown({ 
        required: false,
        options: options,
        placeholder: 'Display - All Settings',
        onChange: (function(val) {
        this.filterSettingsPage(val);
        }).bind(this)
      });
      this.$el.find('#settingsPageDropdown').html(this.settingsPageDropdown.$el);
      
      _.defer((this.renderTable).bind(this));

      return this;
    },
    
    renderTable: function() {
      var descriptionMap = this.model.get('descriptionMap');
      this.settingsSummaryTable = this.$el.find('#settingsSummaryTable').DataTable({
        ordering: false,
        paging: true,
        pageLength: 10,
        info: true,
        dom: 'tip',
        createdRow: function (row, data, index) {
          $(row).addClass('hover-row summaryRow');
        },
        columns: [
          {
            title: 'Setting Page', 
            data: 'Settings_Page__c', 
          },
          {
            title: 'Description',
            render: function(data, type, row, meta) { 
              return descriptionMap[row['Settings_Page__c']] || '';
            }
          },
          {
            title: 'User', 
            width: '150px', 
            data: 'User__r.Name', 
          },
          {
            title: 'Date', 
            width: '150px', 
            render: function(data, type, row, meta) { 
              return Magellan.Util.formatMomentDate(row.CreatedDate, dateFormat, true);
            } 
          },
          {
            title: '', 
            width: '120px', 
            render: function(data, type, row, meta) { 
              return '<div class="viewLog ld-secondary-small-button" data-index="'+ meta.row +'">View Logs</div>';
            } 
          },
        ],
        data: this.model.get('history')
      });
    },
    
    filterSettingsPage: function(page) {
       if (page === 'All') {
         this.settingsSummaryTable.columns(0).search('').draw();
       } else {
         this.settingsSummaryTable.columns(0).search(page).draw();
       }
    },
    
    viewLogDetail: function(e) {
      var el = $(e.currentTarget);
      this.parseSettingsLogRow(this.model.get('history')[el.attr('data-index')]);
    },
    
    renderDetailView: function() {
      //add email notifcation user
      if (!this.detailView) {
        this.detailView = new DetailView({model: this.model});
        this.$el.find('#logDetailView').html(this.detailView.$el);
      } else {
        this.model.set('viewSpecificSettingCategory', false);
        this.model.trigger('renderDetailView');
      }
      this.$el.find('#logSummaryView').hide();
      this.$el.find('#logDetailView').show();
    },
    
    returnToSummary: function() {
      this.$el.find('#logSummaryView').show();
      this.$el.find('#logDetailView').hide();
    },
    
    
    parseSettingsLogRow: function(settingsLog) {
      this.model.set('selectedLog', settingsLog);
      const oldSettings = JSON.parse(settingsLog['Old_Settings__c'].replace(/LeanData__/g, '')); //array of reporting settings
      const updatedSettings = JSON.parse(settingsLog['Updated_Settings__c'].replace(/LeanData__/g, ''));
      var oldSettingsMap = {}; //these maps used for mapping setttings into
      var updatedSettingsMap = {};// easier format for comparison
      
      //Deserialize the settings into a format to compare
      //arrays, i.e. in the case of mappings where multiple stages can be mapped to the same stage,
      //will be converted into a list of stage -> stage which is easier to view what was removed
      if ( settingsLog['Settings_Page__c'].indexOf('Campaign Type Weighting') !== -1 ) {
        for(var i = 0; i < oldSettings.length; i++){
          if (oldSettings[i]['Category__c'].indexOf('Setting Switch') !== -1){
            oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
          } else {
            oldSettingsMap[oldSettings[i]['Category__c']] = JSON.parse(oldSettings[i]['Value__c']);
          }
        }
        for(var i = 0; i < updatedSettings.length; i++){
          if (updatedSettings[i]['Category__c'].indexOf('Setting Switch') !== -1){
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
          } else {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = JSON.parse(updatedSettings[i]['Value__c']);
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Campaign Member Status Weighting') !== -1 ) {
        for(var i = 0; i < oldSettings.length; i++){
          if (oldSettings[i]['Category__c'].indexOf('Setting Switch') !== -1){
            oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
          } else {
            Object.assign(oldSettingsMap, JSON.parse(oldSettings[i]['Value__c']));
          }
        }
        for(var i = 0; i < updatedSettings.length; i++){
          if (updatedSettings[i]['Category__c'].indexOf('Setting Switch') !== -1){
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
          } else {
            Object.assign(updatedSettingsMap, JSON.parse(updatedSettings[i]['Value__c']));
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Custom Field Mappings') !== -1) {
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettings[i]['Value__c']) {
            if (oldSettings[i]['Category__c'] === 'Campaign Member To Marketing Touch Mapping') {
              oldSettingsMap[oldSettings[i]['Category__c']] = JSON.stringify(oldSettings[i]['Value__c']);
            } else {
              oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
            }
          }
        }
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Value__c']) {
            if (updatedSettings[i]['Category__c'] === 'Campaign Member To Marketing Touch Mapping') {
              updatedSettingsMap[updatedSettings[i]['Category__c']] = JSON.stringify(updatedSettings[i]['Value__c']);
            } else {
              updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
            }
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Opportunity Stage Mappings') !== -1 ) {
        //collapse multiple rows (if they map to the same stage) into one map of mapped-to-stage : list of stages that map to it
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettingsMap[oldSettings[i]['Value__c']]) {
            oldSettingsMap['Stages that map to ' + oldSettings[i]['Value__c']] = oldSettingsMap[oldSettings[i]['Value__c']].concat(JSON.parse(oldSettings[i]['Value_2__c']));
          } else {
            oldSettingsMap['Stages that map to ' + oldSettings[i]['Value__c']] = JSON.parse(oldSettings[i]['Value_2__c']);
          }
        }
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettingsMap[updatedSettings[i]['Value__c']]) {
            updatedSettingsMap['Stages that map to ' + updatedSettings[i]['Value__c']] = updatedSettingsMap[updatedSettings[i]['Value__c']].concat(JSON.parse(updatedSettings[i]['Value_2__c']));
          } else {
            updatedSettingsMap['Stages that map to ' + updatedSettings[i]['Value__c']] = JSON.parse(updatedSettings[i]['Value_2__c']);
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Campaign Costs') !== -1 ) {
        if (oldSettings[0]) {
          oldSettingsMap = JSON.parse(oldSettings[0]['Value__c']);
        }
        if (updatedSettings[0]) {
          updatedSettingsMap = JSON.parse(updatedSettings[0]['Value__c']);
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Custom Filters') !== -1 ) {
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettings[i]['Value__c']) {
            //remove custom and [FILL] from the text
            oldSettingsMap[oldSettings[i]['Category__c'].slice(7)] = oldSettings[i]['Value__c'].slice(6);
          }
        }
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Value__c']) {
            updatedSettingsMap[updatedSettings[i]['Category__c'].slice(7)] = updatedSettings[i]['Value__c'].slice(6);
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Dashboard Attribution Settings') !== -1 ) {
        var oppStageMappings = [];
        for (var i = 0 ; i < oldSettings.length; i++) {
          if (oldSettings[i]['Category__c'].indexOf('Include') !== -1 ) {
              oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'] !== 'null' ? JSON.parse(oldSettings[i]['Value__c']) : [];
          } else if (oldSettings[i]['Category__c'] === 'Custom Opportunity Stage') {
            var mappings = JSON.parse(oldSettings[i]['Value_2__c']);
            for (var j = 0; j < mappings.length; j++) {
              oppStageMappings.push(mappings[j] + ' -> ' + oldSettings[i]['Value__c']);
            }                    
          } else {
            oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
          }
        }
        oldSettingsMap['Opportunity Stage Mappings'] = oppStageMappings;
        oppStageMappings = [];
        for (var i = 0 ; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Category__c'].indexOf('Include') !== -1 ) {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'] !== 'null' ? JSON.parse(updatedSettings[i]['Value__c']) : [];
          } else if (updatedSettings[i]['Category__c'] === 'Custom Opportunity Stage') {
            var mappings = JSON.parse(updatedSettings[i]['Value_2__c']);
            for (var j = 0; j < mappings.length; j++) {
              oppStageMappings.push(mappings[j] + ' -> ' + updatedSettings[i]['Value__c']);
            }   
          } else {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
          }
        }
        updatedSettingsMap['Opportunity Stage Mappings'] = oppStageMappings;
      } else if ( settingsLog['Settings_Page__c'].indexOf('Wizard Unchecked Campaigns') !== -1 ) {
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Category__c'] === 'Exclude Campaign') {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = JSON.parse(updatedSettings[i]['Value__c']);
          } else if ( updatedSettings[i]['Category__c'] === 'Campaign Member Status By Campaign Type Exclusion' ) {
            var cmsExclusionList = [];
            cmsExclusionMap = JSON.parse(updatedSettings[i]['Value__c']);
            for (var cms in cmsExclusionMap) {
              var campaignTypes = cmsExclusionMap[cms];
              for (var j = 0; j < campaignTypes.length; j++)
                cmsExclusionList.push(campaignTypes[j] + ': ' + cms);
            }
            updatedSettingsMap['Campaign Member Status Exclusions'] = cmsExclusionList;
          } else {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
          }
        }
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettings[i]['Category__c'] === 'Exclude Campaign' ) {
            oldSettingsMap[oldSettings[i]['Category__c']] = JSON.parse(oldSettings[i]['Value__c']);
          } else if (oldSettings[i]['Category__c'] === 'Campaign Member Status By Campaign Type Exclusion') {
            var cmsExclusionList = [];
            cmsExclusionMap = JSON.parse(oldSettings[i]['Value__c']);
            for (var cms in cmsExclusionMap) {
              var campaignTypes = cmsExclusionMap[cms];
              for (var j = 0; j < campaignTypes.length; j++)
                cmsExclusionList.push(campaignTypes[j] + ': ' + cms);
            }
            oldSettingsMap['Campaign Member Status Exclusions'] = cmsExclusionList;
          } else {
            oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
          }
        }
        //only stored as IDs in the setting, so we need to query names
        this.queryCampaignsAndCompare(oldSettingsMap, updatedSettingsMap);
      } else if ( settingsLog['Settings_Page__c'].indexOf('Attribution Wizard') !== -1 ) {
        for (var i = 0 ; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Category__c'].indexOf('Include') !== -1 || updatedSettings[i]['Category__c'].indexOf('Exclude') !== -1) {
            //these are arrays in value__c
            updatedSettingsMap[updatedSettings[i]['Category__c']] = JSON.parse(updatedSettings[i]['Value__c']);
          } else {
            if (updatedSettings[i]['Value__c'])
              updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
            else
              updatedSettingsMap[updatedSettings[i]['Category__c']] = 'empty';
          }
        }
        for (var i = 0 ; i < oldSettings.length; i++) {
          if (oldSettings[i]['Category__c'].indexOf('Include') !== -1 || oldSettings[i]['Category__c'].indexOf('Exclude') !== -1) {
            //these are arrays in value__c
            oldSettingsMap[oldSettings[i]['Category__c']] = JSON.parse(oldSettings[i]['Value__c']);
          } else {
            if (oldSettings[i]['Value__c'])
              oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
            else
              oldSettingsMap[oldSettings[i]['Category__c']] = 'empty';
          }
        }
      } else if ( settingsLog['Settings_Page__c'].indexOf('Custom Tuples') !== -1 ) {
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettings[i]['Value__c']) {
            let tupleMap = JSON.parse(oldSettings[i]['Value__c']);
            tupleMap['conditions'] = JSON.stringify(tupleMap['conditions']);
            tupleMap['rpnLogic'] = JSON.stringify(tupleMap['rpnLogic']);
            oldSettingsMap[oldSettings[i]['Category__c']] = tupleMap;
          }
        }
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Value__c']) {
            let tupleMap = JSON.parse(updatedSettings[i]['Value__c']);
            tupleMap['conditions'] = JSON.stringify(tupleMap['conditions']);
            tupleMap['rpnLogic'] = JSON.stringify(tupleMap['rpnLogic']);
            updatedSettingsMap[updatedSettings[i]['Category__c']] = tupleMap;
          }
        }
      } else {
        //try serialize with category and value
        for (var i = 0; i < oldSettings.length; i++) {
          if (oldSettings[i]['Value__c']) {
            oldSettingsMap[oldSettings[i]['Category__c']] = oldSettings[i]['Value__c'];
          }
        }
        for (var i = 0; i < updatedSettings.length; i++) {
          if (updatedSettings[i]['Value__c']) {
            updatedSettingsMap[updatedSettings[i]['Category__c']] = updatedSettings[i]['Value__c'];
          }
        }
      }
      
      if (settingsLog['Settings_Page__c'].indexOf('Wizard Unchecked Campaigns') === -1) {
        //if the page is wizard unchecked campaigns, it will call compare after querying campaigns
        this.compareSettings(oldSettingsMap, updatedSettingsMap);
      }
    },
    
    compareSettings: function(oldSettingsMap, updatedSettingsMap) {
      var addedSettings = [], removedSettings = [];
      var overlapSettings = []; //settings in both updated/old
      var settingsComparisonObjs = []; //list of objects with removed/added/overlapping settings
      //Compare the old and new settings and check for differences
      //note that due to some values being false, must check against null and undefined
      //rather than using shorthand if (map[key])
      for (var category in updatedSettingsMap) {
        if (updatedSettingsMap[category] instanceof Array) {
          //each list gets pair of tables on detail view
          //separate list of removed/added settings so it doesn't overwrite the general settings
          var listAddedSettings = [], listRemovedSettings = [], listOverlapSettings = [];
          if (oldSettingsMap[category] !== undefined && oldSettingsMap[category] !== null) {
            var updatedSettingsArray = updatedSettingsMap[category];
            this.arrayDiff(oldSettingsMap[category], updatedSettingsMap[category], listRemovedSettings, listAddedSettings, listOverlapSettings);
          } else {
            //this category didn't exist in old map
            for (var i = 0; i < updatedSettingsMap[category].length; i++) {
              listAddedSettings.push(updatedSettingsMap[category][i]);
            }
          }
          settingsComparisonObjs.push({
            addedSettings: listAddedSettings,
            removedSettings: listRemovedSettings,
            overlapSettings: listOverlapSettings,
            name: category
          });
        } else if (typeof updatedSettingsMap[category] === 'object' && updatedSettingsMap[category] !== null) {
          var map = updatedSettingsMap[category];
          var mapAddedSettings = [], mapRemovedSettings = [], mapOverlapSettings = [];
          for (var key in map) {
            if (oldSettingsMap[category] && oldSettingsMap[category][key] !== undefined && oldSettingsMap[category][key] !== null) {
              if (updatedSettingsMap[category][key] !== oldSettingsMap[category][key]) {
                mapRemovedSettings.push(key + ': ' + oldSettingsMap[category][key]);
                mapAddedSettings.push(key + ': ' + updatedSettingsMap[category][key]);
              } else {
                mapOverlapSettings.push(key + ': ' + updatedSettingsMap[category][key]);
              }
            } else {
              //is in new but not old settings
              mapAddedSettings.push(key + ': ' + updatedSettingsMap[category][key]);
            }
          }
          settingsComparisonObjs.push({
            addedSettings: mapAddedSettings,
            removedSettings: mapRemovedSettings,
            overlapSettings: mapOverlapSettings,
            name: category
          });
        } else {
          //single setting
          if (oldSettingsMap[category] !== undefined && oldSettingsMap[category] !== null ) {
            if (updatedSettingsMap[category] !== oldSettingsMap[category]) {
              addedSettings.push(category + ': ' + updatedSettingsMap[category]);
              removedSettings.push(category + ': ' + oldSettingsMap[category]);
            } else {
              overlapSettings.push(category + ': ' + updatedSettingsMap[category]);
            }
          } else {
            //setting not in old map
            addedSettings.push(category + ': ' + updatedSettingsMap[category]);
          }
        }
      }
      
      for (var category in oldSettingsMap) {
        //only need to cover things that were removed, that is they do not exist in updatedSettingsMap
        if (updatedSettingsMap[category] === undefined || updatedSettingsMap[category] === null) {
          if (oldSettingsMap[category] instanceof Array) {
            var listRemovedSettings = [];
            for (var i = 0; i < oldSettingsMap[category].length; i++) {
              listRemovedSettings.push(oldSettingsMap[category][i]);
            }
            settingsComparisonObjs.push({
              addedSettings: [],
              removedSettings: listRemovedSettings,
              overlapSettings: [],
              name: category
            });
          } else if (typeof oldSettingsMap[category] === 'object') {
            var map = oldSettingsMap[category];
            var mapRemovedSettings = [];
            for (var key in map) {
              mapRemovedSettings.push(key + ': ' + oldSettingsMap[category][key]);
            }
            settingsComparisonObjs.push({
              addedSettings: [],
              removedSettings: mapRemovedSettings,
              overlapSettings: [],
              name: category
            });
          } else {
            removedSettings.push(category + ': ' + oldSettingsMap[category]);
          }
        }
      }
      
      settingsComparisonObjs.sort(function(a,b) {return a.name.localeCompare(b.name)});
      
      settingsComparisonObjs.push({
        addedSettings: addedSettings,
        removedSettings: removedSettings,
        overlapSettings: overlapSettings,
        name: 'General'
      });
      
      this.model.set('settingsComparisonObjs', settingsComparisonObjs);
      this.renderDetailView();
    },
    
    queryCampaignsAndCompare: function(oldSettingsMap, updatedSettingsMap) {
      var waitingScreen = Magellan.Controllers.GUI.appWaitingScreen.show('Loading Data...');
      Magellan.Services.Attribution.queryCampaigns(
        oldSettingsMap['Exclude Campaign'] || [], updatedSettingsMap['Exclude Campaign'] || [])
        .then((function(result, event) {
          oldSettingsMap['Excluded Campaigns'] = result['old campaigns'];
          delete oldSettingsMap['Exclude Campaign'];
          updatedSettingsMap['Excluded Campaigns'] = result['updated campaigns'];
          delete updatedSettingsMap['Exclude Campaign'];
          this.compareSettings(oldSettingsMap, updatedSettingsMap);
          waitingScreen.resolve();
        }).bind(this));
    },
    
    arrayDiff: function(arr1, arr2, diff1, diff2, overlap) {
      //this function takes into account the # of times an element appears in each array
      //diff1 is the elements in arr1 that are not in arr2
      //diff2 is the elements in arr2 that are not in arr1
      
      var map1 = {}, map2 = {};
      for (var i = 0; i < arr1.length; i++) {
        if (map1[arr1[i]])
          map1[arr1[i]]++;
        else
          map1[arr1[i]] = 1;
      }
      for (var i = 0; i < arr2.length; i++) {
        if (map2[arr2[i]])
          map2[arr2[i]]++;
        else
          map2[arr2[i]] = 1;
      }
      var difference;
      for (var key in map1) {
        if (map2[key]) {
          difference = map2[key] - map1[key];
          if (difference > 0) {
            for (var i = 0; i < difference; i++)
              diff2.push(key);
            for (var i = 0; i < map1[key]; i++)
              overlap.push(key);
          } else if (difference < 0) {
            for (var i = 0; i < -difference; i++)
              diff1.push(key);
            for (var i = 0; i < map2[key]; i++)
              overlap.push(key);
          } else {
            //same # thus you can push either count
            for (var i = 0; i < map1[key]; i++)
              overlap.push(key);
          }
        } else {
          for (var i = 0; i < map1[key]; i++)
            diff1.push(key);
        }
      }
      //take care of elements in map2 but not in map1
      for (var key in map2) {
        if (!map1[key]) {
          for (var i = 0; i < map2[key]; i++)
            diff2.push(key);
        }
      }
    },
    
  });
}

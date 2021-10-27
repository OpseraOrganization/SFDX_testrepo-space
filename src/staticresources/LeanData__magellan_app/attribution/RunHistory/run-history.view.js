module.exports = function () {
  const ErrorView = require('./error-view/error-view.view')();
  const dateFormat = 'MM/DD/YYYY, h:mm A';
  const runHistoryRowTemplate = _.template(require('./run-history-row.template.html'));
  return Backbone.View.extend({
    template: _.template(require('./run-history.template.html')),

    events: {
      'click .summaryRow': 'toggleSubrows',
      'click .viewErrorButton': 'viewErrors',
      'click #oneTimeAttributionButton': 'startOneTimeAttribution',
      'click #emailNotificationCheckbox': 'toggleEmailInput',
      'click .cancelRunButton': 'abortCurrentOneTimeRun'
    },

    initialize: function () {
      this.processLogs();
      this.model.set('onSummaryView', true);
      this.listenTo(this.model, 'returnToSummary', this.returnToSummary);
    },

    render: function () {
      var content = this.template({model: this.model.toJSON()});
      this.$el.html(content);
      
      // run type
      this.runTypeDropdown = new Magellan.Views.LDDropdown({ 
        required: false,
        options: ['All', 'One-Time', 'Scheduled'],
        placeholder: 'Run Type - All',
        value: null,
        size: 'large',
        onChange: (function (val) {
         this.filterRunType(val);
        }).bind(this)
      });
      this.$el.find('#runTypeDropdown').html(this.runTypeDropdown.$el);
      
      // prepopulate emailList if setting exists
      const emailList = this.model.get('emailList');
      if(emailList.length > 0 && emailList[0].Value__c) {
        this.$el.find('#emailNotificationCheckbox').prop('checked', true);
        this.$el.find('#emailInput').val(emailList[0].Value__c);
        this.$el.find('#emailInput').show();
      }
      
      _.defer(this.renderTable.bind(this));
      return this;
    },
    
    renderTable: function() {
      this.runSummaryTable = this.$el.find('#attributionRunSummaryTable').DataTable({
        ordering: false,
        paging: true,
        pageLength: 10,
        info: true,
        dom: 'tip',
        createdRow: function (row, data, index) {
          $(row).attr('data-type', data.Run_Type__c);
          $(row).attr('data-index', index);
          $(row).attr('class', 'hover-row summaryRow');
        },
        columns: [
          {
            title: '', 
            width: '30px',
            className: 'expandArrow',
            render: function(){
              return '';
            } 
          },
          {
            title: 'Type', 
            data: 'Run_Type__c',
            render: function(data, type, row, meta){
              return data || '';
            }  
          },
          {
            title: 'Start', 
            width: '160px', 
            data: 'Run_Start__c',
          },
          {
            title: 'End', 
            width: '160px',
            data: 'Run_End__c', 
          },
          {
            title: 'Run Time', 
            data: 'Run_Time', 
          },
          {
            title: 'Errors', 
            width: '100px',
            data: 'Batches_With_Errors__c', 
          },
          {
            title: 'User', 
            data: 'User__r.Name', 
          },
          { 
            render: (function(data, type, row, meta) { 
              if (meta.row === 0 && this.model.get('hasActiveJobs')) {
                return '<div class="cancelRunButton ld-secondary-small-button">Cancel Run</div>';
              } else {
                return '<div class="viewErrorButton ld-secondary-small-button" data-index="'+ meta.row +'">View Errors</div>';
              }
            }).bind(this)
          },
        ],
        data: this.model.get('history')
      });
      
      this.$el.find('#attributionRunSummaryTable').on('page.dt search.dt', (function(){
        this.$el.find('#attributionRunSummaryTable tr.summaryRow td.expandedArrow').removeClass('expandedArrow').addClass('expandArrow');
      }).bind(this))
    },
    
    renderErrorView: function () {
      // add email notifcation user
      if (!this.errorView) {
        this.errorView = new ErrorView({model: this.model});
        this.$el.find('#runErrorView').html(this.errorView.$el);
      } else {
        this.model.trigger('renderErrorView');
      }
    },
    
    filterRunType: function (runType) {
      if (runType === 'All') {
        this.runSummaryTable.columns(1).search('').draw();
      } else {
        this.runSummaryTable.columns(1).search(runType).draw();
      }
    },
    
    toggleEmailInput: function (e) {
      this.$el.find('#emailInput').slideToggle();
    },
    
    toggleSubrows: function (e) {
      var clickedRow = $(e.currentTarget);
      var summaryIndex = clickedRow.attr('data-index');
      
      // if the subrows aren't built yet build them
      if (!clickedRow.next('tr').hasClass('summarySubrow')) {
        var batchSummary = this.model.get('history')[summaryIndex].Batch_Summary__c;
        // insert batch name into summary then sort by batch start time
        _.each(batchSummary, function (batch, key) {
          // start time and end time are stored in seconds, need to use milliseconds in new Date()
          batch['batchName'] = key;
          batch['start time string'] = batch['start time'] ? Magellan.Util.formatMomentDate(batch['start time'] * 1000, dateFormat, true) : '-';
          if (!batch['start time']) {
            batch['end time string'] = '-';
          } else {
            batch['end time string'] = batch['end time'] ? Magellan.Util.formatMomentDate(batch['end time'] * 1000, dateFormat, true) : '-';
          }
        })
        var batches = Object.values(batchSummary);
        batches.sort(function (a,b) { return a['start time'] - b['start time'] });
        // append the subrows
        _.each(batches, function (batch, index) {
          var hasFailures = false; //if batches have error highlight red
          hasFailures = (batch['num failures'] && batch['num failures'] > 0);
          clickedRow.after(runHistoryRowTemplate({
            hasFailures: hasFailures,
            batch: batch,
            summaryIndex: summaryIndex,
          }));
        });
      }
      
      // now show or hide subrows
      if (clickedRow.find('td.expandArrow').length) {
        clickedRow.find('td.expandArrow').removeClass('expandArrow').addClass('expandedArrow');
        clickedRow.siblings('tr[data-index=\'' + summaryIndex + '\']').show();
      } else {
        clickedRow.find('td.expandedArrow').removeClass('expandedArrow').addClass('expandArrow');
        clickedRow.siblings('tr[data-index=\'' + summaryIndex + '\']').hide();
      }
      
    },
    
    viewErrors: function (e) {
      // don't call show error on this row
      e.stopImmediatePropagation();
      const el = $(e.currentTarget);
      
      this.model.set('viewErrorIndex', el.attr('data-index'));
      this.renderErrorView();
      this.$el.find('#runSummaryView').hide();
      this.$el.find('#runErrorView').show();
    },
    
    returnToSummary: function () {
      this.$el.find('#runErrorView').hide();
      this.$el.find('#runSummaryTable tr.summarySubrow').hide();
      this.$el.find('#runSummaryTable tr.summaryRow td.expandedArrow').removeClass('expandedArrow').addClass('expandArrow');
      this.$el.find('#runSummaryView').show();
    },
    
    processLogs: function () {
      // parse data and sort batch summaries
      _.each(this.model.get('history'), function (log, index) {
        // run time is stored as milliseconds
        log.Run_Time = log.Run_End__c ? Magellan.Util.convertMSToHoursMinutes(log.Run_End__c - log.Run_Start__c) : '&mdash;';
        log.Run_Start__c = Magellan.Util.formatMomentDate(log.Run_Start__c, dateFormat, true);
        
        if (!log.Run_End__c) {
          if (index != 0) {
            log.Run_End__c = 'ABORTED/ERRORED';
          } else {
            log.Run_End__c = this.model.get('hasActiveJobs') ? 'IN PROGRESS' : 'ABORTED/ERRORED';
          }
        } else {
          log.Run_End__c = log.Run_End__c ? Magellan.Util.formatMomentDate(log.Run_End__c, dateFormat, true) : 'IN PROGRESS';
        }
        
        if (log.Batches_With_Errors__c) {
          log.Batches_With_Errors__c = log.Batches_With_Errors__c + (log.Batches_With_Errors__c === 1 ? ' Batch' : ' Batches');
        } else {
          log.Batches_With_Errors__c = '0 Batches';
        }
        log.Batch_Summary__c = log.Batch_Summary__c ? JSON.parse(log.Batch_Summary__c) : {};
        log.Attribution_Errors__c = log.Attribution_Errors__c ? JSON.parse(log.Attribution_Errors__c) : {};
      }, this);
    },
    
    startOneTimeAttribution: function () {
      var emails = null;
      if (this.$el.find('#emailNotificationCheckbox').prop('checked')) {
        // remove whitespace then split on commas
        emails = this.$el.find('#emailInput').val().replace(/\s/g, '').split(',');
        for (var email of emails) {
          if (!Magellan.Util.isValidEmail(email)) {
            var errorModal = new Magellan.Views.ConfirmationModal({
              header: "Attribution One-Time Run",
              message: "Invalid email list",
              primaryButtonText: "Ok",
              hideSecondaryButton: true
            });
            errorModal.open();
            return;
          }
        }
      }
      
      var oneTimeRunModal = new Magellan.Views.ConfirmationModal({
        header: "Start One-Time Run?",
        message: "Begin a full Multi-Touch Attribution run based on current product settings. This will recalculate all current Attribution and Marketing Touch object values.",
        primaryButtonText: "Yes, Continue with Run",
        hideSecondaryButton: false,
        onConfirmed: function () {
          var promise = Magellan.Services.Attribution.startOneTimeAttribution(emails);
          promise.then((function (result, event) {
            var successModal = new Magellan.Views.ConfirmationModal({
              header: "Attribution One-Time Run",
              message: "One-Time run has started",
              primaryButtonText: "Ok",
              hideSecondaryButton: true
            });
            successModal.open();
          }).bind(this))
        }
      });
      oneTimeRunModal.open();
      
    },
    
    abortCurrentOneTimeRun: function (e) {
      e.stopImmediatePropagation();
      var promise = Magellan.Services.Attribution.abortCurrentOneTimeRun();
      promise.then((function (result, event) {
        var modalText = '';
        if (result) {
          modalText = 'Attribution Run successfully Aborted'
        } else {
          modalText = 'Cannot abort current Attribution Run, deletion of old Marketing Touch Rows may have begun.'
        }
        var successModal = new Magellan.Views.ConfirmationModal({
          header: "Abort Attribution Run",
          message: modalText,
          primaryButtonText: "Ok",
          hideSecondaryButton: true
        });
        successModal.open();
      }).bind(this))
    }
    
  });
}

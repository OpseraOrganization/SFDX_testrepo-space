module.exports = function() {
  return Backbone.View.extend({
    template: _.template(require('./error-view.template.html')),
    initialize: function(options) {
      //listen to render error view event
      this.listenTo(this.model, 'renderErrorView', this.render);
      
      //set nonErrorSet for filtering out non errors
      this.model.set('nonErrorSet', new Set([
        'total batches', 'failed batches', 'batch size', 'num records', 'runtime', 'run type', 'start time', 
        'end time', 'num failures','start time string', 'end time string', 'batchName', 'last opp ids'
      ]));
      
      this.render();
    },
    
    events: {
      'click #runSummaryLink': 'returnToSummary',
    },
    
    render: function() {
      var log = this.model.get('history')[this.model.get('viewErrorIndex')];
      var numErrors = 0;
      _.each(log.Batch_Summary__c, function(batchSummary, index) {
        numErrors += batchSummary['num failures'] || 0;
      });
      
      var content = this.template({
        model: this.model.toJSON(),
        log: log,
        numErrors: numErrors,
        nonErrorSet: this.model.get('nonErrorSet'),
      });
      
      this.$el.html(content);
      
      //user dropdown
      var options = Object.keys(log.Batch_Summary__c);
      options.unshift('All');
      this.batchErrorDropdown = new Magellan.Views.LDDropdown({ 
        required: false,
        value: null,
        options: options,
        size: 'large',
        placeholder: 'Batch - All',
        onChange: (function(val) {
         this.filterBatchErrors(val);
        }).bind(this)
      });
      this.$el.find('#batchErrorDropdown').html(this.batchErrorDropdown.$el);
      
      _.defer(this.renderTable.bind(this), log);
      return this;
    },
    
    renderTable: function (log) {
      var rowData = [];
      var nonErrorSet = this.model.get('nonErrorSet');
      _.each(log.Batch_Summary__c, function(batchSummary, batchName) {
        _.each(batchSummary, function(numOccurences, errorMsg) {
             if (nonErrorSet.has(errorMsg)) return;
             rowData.push({
               'batchName': batchName,
               'errorMsg': errorMsg,
               'numOccurences': numOccurences
             });
        });
      });
      delete(log.Attribution_Errors__c['last opp ids']);
      _.each(log.Attribution_Errors__c, function(errorMsg, oppId) {
        rowData.push({
          'batchName': 'Opportunity Attribution',
          'oppId': oppId,
          'errorMsg': errorMsg,
          'numOccurences': 1
        });
      })
      
      this.errorViewTable = this.$el.find('#errorViewTable').DataTable({
        searching: true,
        ordering: false,
        paging: true,
        pageLength: 100,
        info: true,
        dom: 'tip',
        createdRow: function (row, data, index) {
          $(row).attr('data-batch', data.batchName);
          $(row).attr('data-index', index);
        },
        columns: [
          {
            title: 'Batch Name', 
            data: 'batchName' 
          },
          {
            title: 'Opportunity Id',
            data: 'oppId', 
            render: function(data, type, row, meta) {
              return data || '';
            } 
          },
          {
            title: 'Error Message', 
            data: 'errorMsg', 
          },
          {
            title: 'Number Occurences',  
            data: 'numOccurences',
          },
        ],
        data: rowData
      });
    },
    
    filterBatchErrors: function(batchName) {
      if (batchName === 'All') {
        this.errorViewTable.columns(0).search('').draw();
      } else {
        this.errorViewTable.columns(0).search(batchName).draw();
      }
    },
    
    returnToSummary: function() {
      this.model.trigger('returnToSummary');
    },
    
  });
}

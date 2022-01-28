module.exports = function() {
  return Backbone.View.extend({
    template: _.template(require('./routing-metrics-control.template.html')),
    initialize: function() {
      this.render();
    },

    events: {
      'click #update-btn' : 'changeDateRange',
      'click #export-routing-usage-btn': 'exportRouting',
      'click #hide-inactive-users' : 'toggleHideInactiveUsers',
    },

    changeDateRange: function() {
      const newStartDate = this.$el.find('#start-datepicker').datepicker('getDate');
      const newEndDate = this.$el.find('#end-datepicker').datepicker('getDate');

      this.trigger('dateRange:changed', {startDate: newStartDate, endDate : newEndDate});
    },

    exportRouting: function() {
      this.trigger('exportRoutingUsageButton:clicked');
    },

    toggleHideInactiveUsers: function(event) {
      setTimeout(function() {
        this.model.set('hideInactiveUsers', event.currentTarget.checked);
        this.trigger('hideInactiveUsers:changed');
      }.bind(this), 0);
    },

    isEqualsOrAfter(anchorDate, dateToCompare) {
      // format first so it only takes into account YYYY/MM/DD and not more granular units like miliseconds
      const formattedAnchorDate = moment(anchorDate).format('YYYY-MM-DD');
      const formattedDateToCompare = moment(dateToCompare).format('YYYY-MM-DD');
      return moment(formattedAnchorDate).isSame(formattedDateToCompare) || moment(formattedDateToCompare).isAfter(formattedAnchorDate);
    },

    openDateWarning(errorText) {
      var alertModal = new Magellan.Views.ConfirmationModal({
          header: "Error",
          message: errorText,
          primaryButtonText: "Ok",
          hideSecondaryButton: true
      });
      alertModal.open();
    },

    render: function() {
      const content = this.template({
        model: this.model.toJSON(),
        queryStartDate: moment(this.model.get('queryStartDate')).format('MM/DD/YYYY'),
        queryEndDate: moment(this.model.get('queryEndDate')).format('MM/DD/YYYY')
      });

      this.$el.html(content);
      var that = this;

      const datepickerOptions = {
        changeMonth: true,
        changeYear: true,
        onSelect: function(date) {
          const dateField = this.getAttribute('data-field-name');
          const prevSelectedDate = that.model.get(dateField);
          const dateToday = moment().format('YYYY-MM-DD');
          const selectedDate = moment(that.$el.find(this).datepicker('getDate')).format('YYYY-MM-DD');
          let updateDateRange = true;
          
          // if either datePicker is after today's date
          if (that.isEqualsOrAfter(dateToday, selectedDate)) {
            that.render();
            that.openDateWarning('Date must be before today\'s date.');
            updateDateRange = false;

          } else if (dateField === 'queryStartDate') {
            const endDate = that.model.get('queryEndDate');
            if (that.isEqualsOrAfter(endDate, selectedDate)) {
              that.render();
              that.openDateWarning('Start date cannot be after or equals to end date.');
              updateDateRange = false;
            } 
          } else if (dateField === 'queryEndDate') {
            const startDate = that.model.get('queryStartDate');
            if (that.isEqualsOrAfter(selectedDate, startDate)) {
              that.render();
              that.openDateWarning('End date cannot be before or equals to start date.');
              updateDateRange = false;
            }
          }

          if (updateDateRange) {
            that.model.set(dateField, selectedDate);
            that.render();
            that.changeDateRange(); 
          }
        }
      }
      this.$el.find('#start-datepicker').datepicker(datepickerOptions);
      this.$el.find('#end-datepicker').datepicker(datepickerOptions);

      return this;
    }
  });
}

module.exports = function() {
  return Backbone.View.extend({
    template: _.template(require('./routing-metrics-table.template.html')),
    initialize: function() {
      this.render();
    },

    events: {
      'click .ld-date-filter': 'removeDateFilter'
    },
    
    render: function() {
      const content = this.template({
        model: this.model.toJSON(),
      });

      this.$el.html(content);
      this.graphTable = this.$el.find('#graph-table');

      if (this.$el.find('.no-data-row').length == 0) {
        this.graphTable.DataTable({
          'pageLength': 10,
          'dom': '<"ld-table-filter-info"><"ld-table-length"l>t<"ld-table-pagination"<p>>'
        });
      }

      let tableInfo = this.$el.find('.ld-table-filter-info');
      let typeToCount = {
        'Users': this.model.get('maxUniqueUsers'),
        'Queue': this.model.get('maxUniqueQueues'),
        'Deleted': this.model.get('deletedUsersOrQueues'), 
      }

      for (let type of Object.keys(typeToCount)) {
        if (typeToCount[type] > 0) {
          tableInfo.append(`<span class="ld-table-info">${type} <span class="bold">(${typeToCount[type]})</bold></span>`);
        }
      }

      if (this.model.get('selectedPoint')) {
        const momentDate = moment(this.model.get('selectedPoint').date);
        const monthStr = momentDate.format('MMMM');
        const dateStr = '' + momentDate.format('DD');
        tableInfo.append('<span class="ld-date-filter">' + monthStr + ' ' + dateStr + '<svg width="10" height="10" style="vertical-align: middle; margin-left:10px; position: relative; top: -1px; right: -3px;"><line x1="0" y1="0" x2="10" y2="10" stroke="white" stroke-width="2"/><line x1="0" y1="10" x2="10" y2="0" stroke="white" stroke-width="2"/></svg></span>');
      }

      return this;
    },

    removeDateFilter: function() {
      // boolean parameter to be passed into callback function to render graph with animation
      this.trigger('dateFilter:changed', true);
    },

    downloadCsv: function() {
      let tableRows = this.graphTable.DataTable().rows({ order: 'applied' }).data();

      // Escape characters
      tableRows = tableRows.map(function(row) {
        return row.map(function(cellValue) {
          cellValue = cellValue ? cellValue.toString() : '';
          cellValue = cellValue.replace(/"/g, '""');
          if (cellValue.search(/("|,|\n)/g) >= 0) {
            cellValue = '"' + cellValue + '"';
          }
          return cellValue;
        });
      })

      const csvVal = tableRows.map(function(row) { return row.join(','); }).join('\n');
      const filename = 'export.csv';
      const blob = new Blob([csvVal], { type: 'text/csv;charset=utf-8;' });
      if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
      } else {
        const link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
          // Browsers that support HTML5 download attribute
          const url = URL.createObjectURL(blob);
          link.setAttribute("href", url);
          link.setAttribute("download", filename);
          if (typeof sforce != "undefined") {
            link.setAttribute("target", "_blank");
          }
          link.style.visibility = 'hidden';
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
        }
      }
    }
  });
}

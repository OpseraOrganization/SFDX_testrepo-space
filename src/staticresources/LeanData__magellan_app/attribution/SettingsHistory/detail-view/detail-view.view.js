module.exports = function() {
  var dateFormat = 'MM/DD/YYYY, h:mm A';
  return Backbone.View.extend({
    template: _.template(require('./detail-view.template.html')),
    initialize: function(options) {
      this.listenTo(this.model, 'renderDetailView', this.render);
      
      this.render();
    },
    
    events: {
      'click .categoryLink': 'viewCategoryDetail',
      'click #detailViewLink': 'returnToDetailView',
    },
    
    render: function() {
      
      var content = this.template({
        model: this.model.toJSON(),
        formatMomentDate: Magellan.Util.formatMomentDate,
        dateFormat: dateFormat,
      });
      
      this.$el.html(content);
      
      return this;
    },
    
    viewCategoryDetail: function(e) {
      var el = $(e.currentTarget);
      this.model.set('selectedComparisonObj', this.model.get('settingsComparisonObjs')[el.attr('index')]);
      this.model.set('viewSpecificSettingCategory', true);
      this.render();
    },
    
    returnToDetailView: function() {
      this.model.set('viewSpecificSettingCategory', false);
      this.render();
    }
    
  });
}

module.exports = function() {
   return Backbone.View.extend({
    className: 'additional-recipients-wrapper',
    template: _.template(require('./AdditionalRecipientRows.template.html')),
    events: {
      'click .add-additional-recipient-button': '_addAdditionalRecipientRow',
      'click .remove-additional-recipient-row': '_removeAdditionalRecipientRow',
    },

    initialize: function(config) {
      this.additionalObjects = config.additionalObjects;
      this._getAdditionalObjectsLabels = config._getAdditionalObjectsLabels;

      var contextOptions = _.map(Magellan.Controllers.FlowBuilder.getObjectContextDropdownOptions(
        this.model.get('primaryObjectType'),
        this.model.get('matchedObjectTypes'),
        this.model.get('createdObjectTypes')
      ), function(objectType) {
        return objectType.label;
      }, this);
      this.contextOptionsSet = new Set(contextOptions);

      this.render();
    },

    getSelections: function() {
      return this.additionalObjects;
    },

    _addAdditionalRecipientRow: function(e) {
      if (!this.additionalObjectsTypeahead.validate()) return;

      var selections = _.cloneDeep(this.additionalObjectsTypeahead.selection);

      this.additionalObjects.push({
        userField: Magellan.Util.convertFieldSelectionArrayToString(selections.slice(1)),
        objectType: selections[0].objectType,
        contextType: selections[0].contextType.toLowerCase(),
      });

      this.render();
    },

    _removeAdditionalRecipientRow: function(e) {
      var idx = $(e.target).data('index');
      this.additionalObjects.splice(idx, 1);
      this.model.set('additionalObjectUserFields', this.additionalObjects);
      this.render();
    },

    render: function() {
      var content = this.template({
        additionalObjectsLabels: this._getAdditionalObjectsLabels(this.additionalObjects),
      });
      this.$el.html(content);

      var userFieldsFilter = Magellan.Util.createUserFieldsFilter();
      var ownerToOwnerMappingFilter = Magellan.Util.createOwnerToOwnerMappingFilter();
      this.additionalObjectsTypeahead = new Magellan.Views.NestedTypeaheadSelector({
        required: false,
        root: 'Object',
        data: this.model.get('fieldMetaData'),
        filter: (suggestions) => {
          var objectType = suggestions[0] ? suggestions[0].objectType : '';
          var blacklistFilter = Magellan.Util.createBlacklistFilter(objectType);

          suggestions = _.filter(suggestions, (suggestion) => suggestion.contextType ? this.contextOptionsSet.has(suggestion.label) : true, this);
          suggestions = blacklistFilter(suggestions);
          suggestions = userFieldsFilter(suggestions);
          suggestions = ownerToOwnerMappingFilter(suggestions);

          return suggestions;
        },
        customValidationFunction: function() {
          var lastSelection = this.selection[this.selection.length - 1];
          var isParent = lastSelection && lastSelection['parent'] && lastSelection['parent'].length > 0 && lastSelection['type'] === 'REFERENCE';
          return this.selection.length > 1 && !isParent;
        },
      });

      this.$el.find('.additional-recipient-typeahead').html(this.additionalObjectsTypeahead.$el);

      return this;
    },
  });
}

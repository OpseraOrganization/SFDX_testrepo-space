module.exports = function() {
  return Backbone.View.extend({
    className: 'email-template-selector-wrapper',
    template: _.template(require('./EmailTemplateSelector.template.html')),
    events: {
      'click .view-email-template-link': '_viewTemplate',
      'nestedTypeaheadSelector:select .email-template-selector': '_selectTemplate',
    },

    initialize: function(config) {
      // Check if config exists, otherwise initialize empty object
      config = config || {};
      // Set on change handler
      this.onChangeCallback = typeof config.onChange === 'function' ? config.onChange : _.noop;
      // Set model values
      this.model = new Magellan.Models.EmailTemplateSelector();
      this.model.set('templateId', config.templateId || null);
      // Render view after initialize
      this.render();
    },

    getTemplateInfo: function() {
      return this.model.get('templateId');
    },

    _initializeEmailTypeahead: function() {
      this.$el.LoadingOverlay('show');

      // Initialize typeahead
      this.emailNestedTypeaheadView = new Magellan.Views.NestedTypeaheadSelector({
        required: true,
        disableBreadcrumbs: true,
        requireSelectionFromData: true,
        selection: [],
        asyncServiceCall: Magellan.Controllers.FlowBuilder.searchEmailTemplates,
      });
      this.$el.find('.email-template-selector').html(this.emailNestedTypeaheadView.$el);

      // Fetch template name, then update typeahead
      this.validate().then((function(emailTemplate, errors) {
        if (_.isEmpty(errors) && !_.isEmpty(emailTemplate)) {
          this.model.set({
            'templateId': emailTemplate[0].Id,
            'templateName': emailTemplate[0].Name,
          });
        } else {
          this.model.set({
            'templateId': null,
            'templateName': null,
          })
          var $emailTemplateErrorMessage = this.$el.find('.email-template-error-message');
          $emailTemplateErrorMessage.toggleClass('hidden', false);
          $emailTemplateErrorMessage.html(errors['invalidTemplateIdMessage']);
        }
      }).bind(this))
      .always((function() {
        this._updateTypeaheadSelection();
      }).bind(this));
    },

    _updateTypeaheadSelection: function() {
      var templateId = this.model.get('templateId');
      var templateName = this.model.get('templateName') || '';

      // Format object to be used in nestedTypeaheadSelector
      var templateObject = {
        'Id': templateId,
        'Name': templateName,
        'label': templateName,
      }
      
      this.emailNestedTypeaheadView.setSelection(templateId ? [templateObject] : null);

      var isValid = !!templateId;
      this.emailNestedTypeaheadView.$('.typeahead-input').toggleClass('input-invalid', !isValid);
      this.emailNestedTypeaheadView.$('.users-error-text').toggle(!isValid);
      this.$el.LoadingOverlay('hide', true);
    },

    _selectTemplate: function(e, typeaheadSelector) {
      // Remove invalid template error (if shown) once valid template is selected
      this.$el.find('.email-template-error-message').toggleClass('hidden', true);
      // Set values
      var selection = typeaheadSelector.selection[0];
      var selectionObject = selection ? { id: selection.Id, Name: selection.Name } : {};
      this.model.set('templateId', selectionObject.id);
      this.model.set('templateName', selectionObject.Name);
      // Trigger change
      this.trigger('selectedTemplate', this.getTemplateInfo());
      this.onChangeCallback(this.getTemplateInfo());
    },

    _viewTemplate: function() {
      var templateId = this.model.get('templateId');
      if (!_.isNull(templateId)) {
        window.open('/' + templateId);
      }
    },

    validate: function() {
      var promise = $.Deferred();
      var errorMessages = {};

      Magellan.Controllers.FlowBuilder.searchEmailTemplates('', [this.model.get('templateId')]).then((function(emailTemplate) {
        if (!_.isEmpty(this.model.get('templateId')) && _.isEmpty(emailTemplate)) {
          errorMessages.invalidTemplateIdMessage = 'Previously selected template (Id: ' + this.model.get('templateId') + ') no longer exists';
        } else if (!_.isEmpty(emailTemplate) && !emailTemplate[0].IsActive) {
          errorMessages.invalidTemplateIdMessage = 'Previously selected template (Id: ' + this.model.get('templateId') + ') is inactive';
        }
        promise.resolve(emailTemplate, errorMessages)
      }).bind(this));

      return promise;
    },

    render: function() {
      var content = this.template({})
      this.$el.html(content);

      // Create nested typeahead
      // Use "defer" to allow parent and this component to render first before fetching data and initializing typeahead
      _.defer(() => {
        this._initializeEmailTypeahead();
      });

      return this;
    },

  });
}

module.exports = function() {
  var AdditionalRecipientRowsView = require('./AdditionalRecipientRows.view')();

  return Backbone.View.extend({
    className: 'email-recipient-selector-wrapper',
    template: _.template(require('./EmailRecipientSelector.template.html')),
    events: {
      'click .edit-recipients-button': '_showEditor',
      'click .save-receipients-button': '_hideEditor',
      'click .notif-owner-checkbox': '_toggleOwner',
      'input .emails-text-area': '_emailTextareaHandler',
      'click .subcontent-toggle': '_toggleSubcontentForm',
    },

    initialize: function(config) {
      // Check if config exists, otherwise initialize empty object
      config = config || {};
      // Set config value
      this.editMode = config.editMode || false;
      // Set on save handler
      this.onSaveCallback = _.isFunction(config.onSave) ? config.onSave : _.noop;
      // Set limit on explicit emails you can send. Based on salesforce email limits for a single action
      this.emailRecipientLimit = Magellan.Validation.EMAIL_RECIPIENT_LIMIT || 20;
      // Set model values
      this.model = new Magellan.Models.EmailRecipientSelector(config);
      this.model.set('fieldMetaData', fieldMetaData);
      // Parse "additionalObjectUserFields" with dropdowns
      this._processAdditionalObjectUserFields();
    },

    _processAdditionalObjectUserFields: function() {
      var userFieldOptions = {};
      var userFieldOptionsMap = {};
      _.each(Magellan.Util.objectTypes, function(sobject) {
        var flattenedFields = _.cloneDeep(Magellan.Controllers.FlowBuilder.getFlattenedFieldsByObject(sobject));
        userFieldOptions[sobject] = _.filter(flattenedFields, function(field) {
          if (!Magellan.Validation.FIELD_BLACKLIST_SETS.USER_FIELDS.has(field.name) && _.contains(field.parent, 'User')) {
            if (field.name.endsWith('id')) {
              var insertAt = field.name.length - 2;
              field.name = field.name.substr(0, insertAt) + '.' + field.name.substr(insertAt);
            } else {
              field.name = field.name.replace('__c', '__r.id');
            }
            return true;
          } else {
            return false;
          }
        });
        userFieldOptionsMap[sobject] = _.indexBy(userFieldOptions[sobject], 'name');
      }, this);
      this.model.set('userFieldOptions', userFieldOptions);
      this.model.set('userFieldOptionsMap', userFieldOptionsMap);

      // Declare view variables used for additional object user fields
      this.matchedObjectData = new Set();
      this.matchedObjectDropdownViews = {};
      this.additionalObjects = [];

      // In additionalObjectUserFields, if the type is "Match" and only a single layer deep (first level user field), create dropdown
      _.each(this.model.get('additionalObjectUserFields'), function(obj) {
        var isFirstLevelUserField = obj.userField.split('.').length === 2 && obj.userField.endsWith('.id');
        if (obj.contextType === 'matched' && _.isEmpty(this.matchedObjectDropdownViews[obj.objectType]) && isFirstLevelUserField) {
          this._createMatchedUserFieldDropdown(obj.objectType, obj.userField);
          this.matchedObjectData.add(obj.objectType);
        } else {
          this.additionalObjects.push(obj);
        }
      }, this);

      // Create empty dropdowns if matched object exists, but additionalObjectUserFields doesn't contain any value for that matched object type
      _.each(this.model.get('matchedObjectTypes'), function(sobject) {
        if (_.isEmpty(this.matchedObjectDropdownViews[sobject])) {
          this._createMatchedUserFieldDropdown(sobject);
        }
      }, this);

      // Render
      this.render();
    },

    _createMatchedUserFieldDropdown: function(sobjectType, savedUserField) {
      var userFieldDropdown = new Magellan.Views.LDDropdown({
        required: true,
        options: this.model.get('userFieldOptions')[sobjectType],
        value: this.model.get('userFieldOptionsMap')[sobjectType][savedUserField],
        optionTemplate: function(option) {
          return _.template('<span><%=option ? option.label : null%></span>')({ option: option })
        }
      });
      userFieldDropdown.validate();

      this.matchedObjectDropdownViews[sobjectType] = {
        selector: '.matched-' + sobjectType + '-dropdown',
        view: userFieldDropdown,
      };
    },

    _setAdditionalObjectUserFieldsInModel: function() {
      var additionalObjectUserFields = [];
      // If .matched-object-toggle is not checked, dont iterate through the dropdown views to get values
      var that = this;
      if (this.$el.find('.matched-object-toggle').prop('checked')) {
        this.$el.find('.matched-object-checkbox').each(function() {
          var $checkbox = $(this);
          var sobjectType = $checkbox.data('objectType');
          var isChecked = $checkbox.prop('checked');
          var matchedObjSelection = that.matchedObjectDropdownViews[sobjectType].view.val();

          if (isChecked && !_.isEmpty(matchedObjSelection)) {
            additionalObjectUserFields.push({
              userField: matchedObjSelection.name,
              objectType: sobjectType,
              contextType: 'matched',
            });
            that.matchedObjectData.add(sobjectType);
          } else {
            that.matchedObjectData.delete(sobjectType);
          }
        });
      } else {
        this.matchedObjectData.clear();
      }
      // if .additional-recipients-toggle is not checked, dont iterate through the dropdown views to get values
      if (this.$el.find('.additional-recipients-toggle').prop('checked')) {
        additionalObjectUserFields = additionalObjectUserFields.concat(this.additionalRecipientRowsView.getSelections());
      }
      // Set valid user field data into model
      this.model.set('additionalObjectUserFields', additionalObjectUserFields);
    },

    _showEditor: function() {
      // Enter edit mode
      this.editMode = true;
      this._processAdditionalObjectUserFields();
    },

    _hideEditor: function() {
      this._setAdditionalObjectUserFieldsInModel();

      // Validate and set data
      this.validate().then((function(errorMessages) {
        if (!_.isEmpty(errorMessages)) {
          this.$el.find('.email-recipients-error-messages').html(Object.values(errorMessages).join('<br>'));
          return;
        }
        // Compile data to send back in trigger/callback
        var recipientData = { emails: this.model.get('emails') };
        if (this.model.get('showOwnerOptions')) {
          recipientData.notifyPostOwner = this.model.get('notifyPostOwner');
          recipientData.notifyPreOwner = this.model.get('notifyPreOwner');
          recipientData.notifyNewObjectOwner = this.model.get('notifyNewObjectOwner');
        }
        if (this.model.get('showAdditionalObjectUserOptions')) {
          recipientData.additionalObjectUserFields = this.model.get('additionalObjectUserFields');
        }
        // Trigger change
        this.trigger('savedRecipients', recipientData);
        this.onSaveCallback(recipientData);
        // Exit edit mode
        this.editMode = false;
        this._processAdditionalObjectUserFields();
      }).bind(this));
    },

    _toggleOwner: function(e) {
      // Next / Previous owner checkbox handler
      var $target = $(e.target);
      this.model.set($target.data('ownerType'), $target.prop('checked'));
    },

    _toggleSubcontentForm: function(e) {
      // Toggle subcontent for Emails and Matched Objects
      var $target = $(e.target);
      var isChecked = $target.prop('checked');
      $target.closest('.recipient-editor-row').find('.recipient-editor-subcontent').toggleClass('hidden', !isChecked);
    },

    _getAdditionalObjectsLabels: function(additionalObjects) {
      return _.map(additionalObjects, function(obj) {
        var selectionsString = `${obj.contextType} ${obj.objectType}.${obj.userField}`.toLowerCase();
        var selectionsLabels = _.map(Magellan.Util.convertFieldSelectionStringToArray(selectionsString, 'Object', this.model.get('fieldMetaData')), function(selection, a, b) {
          return (a === b.length - 1) ? selection.label : selection.label.replace(' ID', '');
        }, this);
        return selectionsLabels.join(' > ');
      }, this);
    },

    _createRecipientCards: function() {
      this.recipientCards = [];

      if (this.model.get('notifyPostOwner')) this.recipientCards.push('New Owner');
      if (this.model.get('notifyPreOwner')) this.recipientCards.push('Previous Owner');
      if (this.model.get('notifyNewObjectOwner')) this.recipientCards.push('Created Object Owner');
      _.each(this.model.get('emails') , function(email) { this.recipientCards.push(email) }, this);
      _.each(this.model.get('additionalObjectUserFields'), function(obj) {
        var fieldSelectionLength1 = Magellan.Util.convertFieldSelectionStringToArray(obj.userField, obj.objectType, this.model.get('fieldMetaData')).length;
        var fieldSelectionLength2 = obj.userField.split('.').length;
        if (fieldSelectionLength1 !== fieldSelectionLength2) {
          this.recipientCards.push(_.capitalize(obj.contextType) + ' ' + obj.objectType + ' > ' + obj.userField + ' (DELETED)');
        } else {
          this.recipientCards.push(this._getAdditionalObjectsLabels([obj]));
        }
      }, this);
    },

    _getElementClasses: function() {
      var classes = {
        'edit-recipients-button': new Set(['edit-recipients-button']),
        'email-recipients-wrapper': new Set(['email-recipients-wrapper']),
        'email-recipients-editor': new Set(['email-recipients-editor', 'hidden']),
        'empty-recipients-message': new Set(['empty-recipients-message']),
        'next-owner-row': new Set(['next-owner-row', 'hidden']),
        'previous-owner-row': new Set(['previous-owner-row', 'hidden']),
        'new-object-owner-row': new Set(['new-object-owner-row', 'hidden']),
        'matched-object-row': new Set(['matched-object-row', 'hidden']),
        'additional-recipients-row': new Set(['additional-recipients-row', 'hidden']),
      };
      if (this.editMode) {
        classes['edit-recipients-button'].add('invisible');
        classes['email-recipients-wrapper'].add('hidden');
        classes['email-recipients-editor'].delete('hidden');
      }
      if (this.model.get('showOwnerOptions')) {
        if (this.model.get('showNewPreviousOwnerOptions')) {
          classes['next-owner-row'].delete('hidden');
          classes['previous-owner-row'].delete('hidden');
        }
        if (this.model.get('showNewObjectOption')) {
          classes['new-object-owner-row'].delete('hidden');
        }
      }
      if (this.model.get('showAdditionalObjectUserOptions')) {
        classes['matched-object-row'].delete('hidden');
        classes['additional-recipients-row'].delete('hidden');
      }
      if (this.recipientCards.length > 0) {
        classes['empty-recipients-message'].add('hidden');
      }

      return classes;
    },

    _emailTextareaHandler: function(e) {
      this.model.set('emails', $(e.target).val());
    },

    validate: function(forceUpdateEmails) {
      var promise = $.Deferred();
      var errorMessages = {};
      
      // Validate the emails string. Regex removes all whitespace and line/carriage returns, and returns an array of emails or null
      var emailValidationResult = Magellan.Validation.validateEmailString(this.$el.find('.emails-text-area').val());
      var isValidEmails = emailValidationResult.isValid;
      var validEmails = emailValidationResult.validEmails;
      var invalidEmails = emailValidationResult.invalidEmails;

      var isEmailsChecked = this.$el.find('.emails-toggle').prop('checked');
      var allEmailsValid = !isEmailsChecked || (isEmailsChecked && isValidEmails);
      this.$el.find('.emails-text-area').toggleClass('input-invalid', !allEmailsValid);
      if (!allEmailsValid) {
        errorMessages.invalidEmailRecipients = 'Invalid email recipients listed: ' + invalidEmails.join(', ');
      } else if (validEmails.length > this.emailRecipientLimit) {
        errorMessages.emailRecipientCountExceedsLimit = 'Number of valid email recipients exceeds limit of ' + this.emailRecipientLimit;
      } else {
        this.model.set('emails', isEmailsChecked ? validEmails : []);
      }
      // This is to handle the case when the recipients are saved when you click on the "OK" button in the edit node panel
      if (forceUpdateEmails) {
        this.model.set('emails', validEmails);
      }

      // Check if checkbox for "Created Object Owner" is still valid when detached from created objects
      if (!this.model.get('showNewObjectOption') && this.model.get('notifyNewObjectOwner')) {
        errorMessages.missingCreatedObject = 'Created object node no longer exists';
        this.model.set('notifyNewObjectOwner', false);
      }

      // Validate Additional Recipients options
      var validAdditionalObjectUserFields = [];
      _.each(this.model.get('additionalObjectUserFields'), function(obj, idx) {
        // Used to compare the length of simply splitting the userField string and getting the selection array from the fieldMetaData
        // If the lengths are different, a field or reference no longer exists in the fieldMetaData
        var fieldSelectionLength1 = Magellan.Util.convertFieldSelectionStringToArray(obj.userField, obj.objectType, this.model.get('fieldMetaData')).length;
        var fieldSelectionLength2 = obj.userField.split('.').length;

        if (obj.contextType === 'matched' && !this.model.get('matchedObjectTypes').includes(obj.objectType)) {
          errorMessages.missingMatchedObject = 'Previously selected ' + obj.contextType + ' ' + obj.objectType + ' object node no longer exists (selected user field: ' + obj.userField + ')';
          this.matchedObjectData.delete(obj.objectType);
        } else if (obj.contextType === 'created' && !this.model.get('createdObjectTypes').includes(obj.objectType)) {
          errorMessages.missingCreatedObject = 'Previously selected ' + obj.contextType + ' ' + obj.objectType + ' object node no longer exists (selected user field: ' + obj.userField + ')';
        } else if (fieldSelectionLength1 !== fieldSelectionLength2) {
          errorMessages.invalidMatchedObjectData = 'Previously selected ' + obj.contextType + ' ' + obj.objectType + ' object field ' + obj.userField + ' no longer exists.';
        } else {
          validAdditionalObjectUserFields.push(obj);
        }
      }, this);
      this.model.set('additionalObjectUserFields', validAdditionalObjectUserFields);

      return promise.resolve(errorMessages);
    },

    render: function() {
      this._createRecipientCards();

      var classes = _.mapValues(this._getElementClasses(), function(val) {
        return Array.from(val).join(' ');
      });

      var content = this.template({
        classes: classes,

        recipientCards: this.recipientCards,
        recipientData: this.model.toJSON(),

        matchedObjectTypes: this.model.get('matchedObjectTypes'),
        matchedObjectData: this.matchedObjectData,
        hasAdditionalObjectData: this.additionalObjects.length > 0,
      })
      this.$el.html(content);

      // Render matched object dropdowns
      _.each(this.matchedObjectDropdownViews, function(dropdown) {
        this.$el.find(dropdown.selector).html(dropdown.view.$el);
        dropdown.view.delegateEvents();
      }, this);

      // Render additional recipients dropdowns
      this.additionalRecipientRowsView = new AdditionalRecipientRowsView({
        model: this.model,
        additionalObjects: this.additionalObjects,
        _getAdditionalObjectsLabels: this._getAdditionalObjectsLabels,
      });
      this.$el.find('.additional-recipients-content').html(this.additionalRecipientRowsView.$el)

      // Initialize tooltips
      Magellan.Util.initializeTooltip(this.$el.find(".matched-object-recipient-tooltip"), {
        title: "Requires Matched Object",
        body: "No matched object edges were found leading to this Send Notification node."
      });

      // Validate
      this.validate().then((function(errorMessages) {
        if (_.isEmpty(this.recipientCards)) errorMessages.emptyEmailRecipients = 'Required: email recipient(s) must be selected';
        var $errorMessageDiv = this.$el.find('.email-recipients-error-messages');
        $errorMessageDiv.html(!_.isEmpty(errorMessages) ? Object.values(errorMessages).join('<br>') : '');
      }).bind(this));

      return this;
    },
  });
}

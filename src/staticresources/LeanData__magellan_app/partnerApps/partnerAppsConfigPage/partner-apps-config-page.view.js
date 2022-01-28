module.exports = function() {
  return Backbone.View.extend({
    template: _.template(require('./partner-apps-config-page.template.html')),
    initialize: function() {
      const InstructionsView =
        require('./partnerInstructions/partner-instructions.view')();
      this.instructionsView = new InstructionsView(
        this.model.partnerName.toLowerCase(),
        { partnerData: this.model },
      );
      this.render();
      this.hasIntegrationConfigChanged = false;
      // TODO - this model isn't a real Backbone model, rename

    },

    authorizationURLGenerators: {
      'Outreach': (clientID, callbackUrl) => `https://accounts.outreach.io/oauth/authorize?client_id=${clientID}&redirect_uri=${callbackUrl}&response_type=code&scope=accounts.all+callDispositions.all+callPurposes.all+calls.all+events.all+mailings.all+mailboxes.all+personas.all+prospects.all+sequenceStates.all+sequenceSteps.all+sequences.all+stages.all+taskPriorities.all+users.all+tasks.all+snippets.all+templates.all+rulesets.all+opportunities.all+opportunityStages.all+sequenceTemplates.all+customValidations.all+webhooks.all+teams.all+mailboxContacts.all+meetingTypes.all+experiments.all+phoneNumbers.all+meetingFields.all+customDuties.all+duties.all+favorites.all`,
      'Salesloft': (clientID, callbackUrl) => `https://accounts.salesloft.com/oauth/authorize?client_id=${clientID}&redirect_uri=${callbackUrl}&response_type=code`,
    },

    events: {
      'input .ld-input-large': 'handleInputChange',
      'change .cb-container-large': 'toggleCheckbox',
      'click #authorize-update-button': 'saveConfigurationSettings'
    },

    saveConfigurationSettings: function() {
      console.log('this.model.integrationConfig', this.model.integrationConfig);
      Magellan.Controllers.FlowBuilder.savePartnerIntegrationConfiguration(
        this.model.partnerName.toLowerCase(),
        JSON.stringify(this.model.integrationConfig),
        JSON.stringify(this.model.mappingFields),
      ).then((result, event) => {
        if (event.statusCode === 200) {
          const clientID = this.model.integrationConfig['applicationId'];
          const redirectURL =
            this.authorizationURLGenerators[this.model.partnerName](
              clientID,
              this.model.callbackUrl
            );
          window.location = redirectURL;
        }
      });
    },

    toggleCheckbox: function(event) {
      if (!this.$el.find('#confirm-config-checkbox').is(':checked')) {
        this.$el.find('#authorize-update-button').addClass('disabled');
      } else {
        this.enableAuthorizeUpdateButton();
      }
    },

    handleInputChange: function(event) {
      const inputId = event.target.id;
      let key = '';

      if (inputId === 'app-id-input') {
        key = 'applicationId';
      } else if (inputId === 'client-secret-input') {
        key = 'clientSecret';
      } else if (inputId === 'retry-time-input') {
        key = 'retryTime';
      }

      this.updateIntegrationConfigHelper(key, this.$el.find('#' + inputId + '').val());
      this.enableAuthorizeUpdateButton();
    },

    // updates the map that will be used to save values to the backend
    updateIntegrationConfigHelper(field, value) {
      if (this.model.integrationConfig[field] !== value) {
        this.model.integrationConfig[field] = value;
        this.hasIntegrationConfigChanged = true;
      }
    },

    // only works for outreach nodes, have to do refactoring
    // before it works for anything else.
    initializeFieldMappingDropdowns: function() {
      this.model.mappingFields.forEach((field) => {
        let dropdown = new Magellan.Views.LDDropdown({
          required: false,
          value: this.model.isAuthorized ?
            this.model.fieldMappingOptions[field.sObject].filter(
              item => item.value === this.model.integrationConfig[field.integrationConfigKey]
            )[0] : null,
          options: Magellan.Util.createBlacklistFilter(field.sObject, 'value')(this.model.fieldMappingOptions[field.sObject]),
          size: 'large',
          optionTemplate: function (option) {
            return `<span>${option.label}</span>`;
          },
          placeholder: 'Select ' + _.capitalize(field.name) + ' Field',
          onChange: (function(field) {
            return (function (value) {
              this.handleFieldMappingDropdownChange(field, value);
            }).bind(this);
          }).bind(this)(field),
          // tokenize the labels (space separated) and field names
          // (underscore separated)
          datumTokenizer: (datum) => 
            [].concat(datum.label.split(' ')).concat(datum.value.split('_')),
        });

        this.$el.find('#' + field.integrationConfigKey + '-field-dropdown').html(dropdown.$el);
      });
    },

    // handles when field mappings change
    handleFieldMappingDropdownChange: function(field, fieldSelection) {
      this.updateIntegrationConfigHelper(field.integrationConfigKey, fieldSelection.value);
      this.enableAuthorizeUpdateButton();
    },

    handleRetryTimeDropdownChange: function(value) {
      let fieldKey = 'retryTimeUnit';
      this.updateIntegrationConfigHelper(fieldKey, value);
      this.enableAuthorizeUpdateButton();
    },

    enableAuthorizeUpdateButton: function() {
      if (!Object.values(this.model.integrationConfig).includes(null) &&
        (this.$el.find('#confirm-config-checkbox').is(':checked') ||
        this.model.mappingFields.length === 0) &&
        this.hasIntegrationConfigChanged === true
      ) {
        this.$el.find('#authorize-update-button').removeClass('disabled');
      }
    },

    initializeTimeUnitDropDown: function() {
      let dropdown = new Magellan.Views.LDDropdown({
        required: false,
        value: this.model.integrationConfig.retryTimeUnit || null, 
        options: ['Minutes', 'Hours', 'Days'],
        size: 'large',
        placeholder: null,
        onChange: ((value) => {
         this.handleRetryTimeDropdownChange(value);
        }).bind(this),
      });
      this.$el.find('#retry-time-unit-dropdown').html(dropdown.$el);
    },

    updateConfigurationInput: function() {
      if (this.model.isAuthorized) {
        let integrationConfig = this.model.integrationConfig;
        this.$el.find('#app-id-input').val(integrationConfig.applicationId);
        this.$el.find('#client-secret-input').val(integrationConfig.clientSecret);
      }
      this.$el.find('#retry-time-input').val(this.model.integrationConfig.retryTime);
    },

    render: function() {
      const content = this.template({
        model: this.model
      });
      this.$el.html(content);

      this.initializeFieldMappingDropdowns();
      this.initializeTimeUnitDropDown();
      this.updateConfigurationInput();
      // confirmation checkbox should be checked if authorized
      if (this.model.isAuthorized) {
        this.$el.find('#confirm-config-checkbox').prop('checked', true);
      }

      if (this.model.mappingFields.length == 0) {
        this.enableAuthorizeUpdateButton();
      }

      this.$el.find('.config-instructions-wrapper').html(
        this.instructionsView.$el
      );
      return this;
    }
  })
}

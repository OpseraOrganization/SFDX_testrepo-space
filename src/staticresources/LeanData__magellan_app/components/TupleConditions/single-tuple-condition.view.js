 module.exports = function() {
  Magellan.Views.SingleTupleCondition = Backbone.View.extend({
    template: _.template(require('./single-tuple-condition.template.html')),
    initialize: function(config) {
      // Required variables
      this.idx = config.idx;
      this.selectedRoutingType = this.model.get('selectedRoutingType');
      this.fieldObjectType = this.model.get('fieldObjectType');
      this.operandObjectType = this.model.get('operandObjectType');
      this.fieldData = this.model.get('fieldData');
      this.operandData = this.model.get('operandData');
      this.condition = config.condition;

      // cache
      this.operandFieldCache = null;
      this.operandValueCache = null;

      this.render();
    },

    events: {
      'click .tuple-condition-delete': 'deleteCondition',
      'change .tuple-fieldset-radiogroup input': 'radioButtonHandler',
      'keyup .tuple-condition-operand-input': 'operandInputHandler',
      'change .tuple-condition-operand-input': 'operandInputHandler',
    },

    deleteCondition: function(e) {
      var index = $(e.target).closest('.tuple-condition').data('ruleIndex');
      this.model.deleteCondition(index);  // this will trigger a re-render of all rows in tuple-conditions.view.js
    },

    radioButtonHandler: function(e) {
      this.condition['value/field'] = this.$el.find('fieldset input:checked').val();

      var operandDropdown = this.$el.find('.tuple-condition-operand-dropdown');
      var operandInput = this.$el.find('.tuple-condition-operand-input');
      if (this.condition['value/field'] === 'field') {
        this.condition.operand = this.operandFieldCache;
      } else {
        this.condition.operand = this.operandValueCache;
      }

      this.render();
    },

    operandInputHandler: function(e) {
      var $input = $(e.target);
      var inputVal = $input.val();
      $input.toggleClass('input-invalid', _.isEmpty(inputVal) || !Magellan.Validation.isValidValueOfType(this.condition.type, inputVal));
      this.condition.operand = _.isEmpty(inputVal) ? null : inputVal;
      this.operandValueCache = _.isEmpty(inputVal) ? null : inputVal;
    },

    _createFieldNestedTypeahead: function() {
      var fieldSelection = Magellan.Util.convertFieldSelectionStringToArray(this.condition.field, this.fieldObjectType, Magellan.Controllers.FlowBuilder.getFieldMetaDataMap());
      if (fieldSelection.length === 0) {
        this.condition.field = null;
      } else {
        fieldSelection = Magellan.Util.createFlattenedFields(fieldSelection);
      }
      
      this.fieldNestedTypeahead = new Magellan.Views.NestedTypeaheadSelector({
        required: true,
        data: this.fieldData,
        root: this.fieldObjectType,
        selection: fieldSelection,
        onSelect: function(dropdownView, selection) {
          this.condition.field = Magellan.Util.convertFieldSelectionArrayToString(selection);
          this.condition.type = selection[selection.length - 1].type;
          if (this.condition.type !== 'REFERENCE') this.render();
        }.bind(this),
      });
      this.$el.find('.tuple-condition-field').html(this.fieldNestedTypeahead.$el);
    },

    _createOperatorDropdown: function() {
      var operators;
      var routingType = this.model.get('selectedRoutingType');
      var typeGrouping = Magellan.Validation.SFDC_TYPE_TO_GROUPING[this.condition.type];

      if (routingType === 'Update') {
        operators = Magellan.Views.UT_GROUPING_TO_OPERATORS[typeGrouping];
      } else {
        operators = Magellan.Views.GROUPING_TO_OPERATORS[typeGrouping];
      }

      var selectedOperator;
      if (operators && operators.indexOf(this.condition.operator) !== -1) {
        selectedOperator = this.condition.operator;
      } else {
        selectedOperator = this.condition.operator = null;
      }
      this.$el.find('.tuple-condition-operator').LDDropdown({ 
        required: true, 
        options: operators, 
        value: selectedOperator, 
        onChange: function(val) {
          this.condition.operator = val;
          this.render();
        }.bind(this),
      });
    },

    _createOperandColumn: function() {
      var operandDropdown = this.$el.find('.tuple-condition-operand-dropdown');
      var operandInput = this.$el.find('.tuple-condition-operand-input');

      if (['has changed', 'is null', 'not null'].includes(this.condition.operator)) {
        // If operator is any of the above, do not show operand column since it's not needed
        operandDropdown.hide();
        operandInput.hide();
        this.condition.operand = '';
      } else if (this.condition['value/field'] === 'field') {
        // If type of field is 'field', create nested typeahead selector for operand column
        this.$el.find('fieldset input[value="field"]').prop('checked', true);
        operandInput.hide();
        var fieldGroupingType = Magellan.Validation.SFDC_TYPE_TO_GROUPING[this.condition.type];
        var operandSelection = Magellan.Util.convertFieldSelectionStringToArray(this.condition.operand, this.operandObjectType, Magellan.Controllers.FlowBuilder.getFieldMetaDataMap());
        if (operandSelection.length === 0 || (operandSelection.length > 0 && Magellan.Validation.SFDC_TYPE_TO_GROUPING[operandSelection[operandSelection.length - 1].type] !== fieldGroupingType)) {
          operandSelection = [];
          this.condition.operand = null;
        }
        this.operandFieldCache = this.condition.operand;
        this.operandNestedTypeahead = new Magellan.Views.NestedTypeaheadSelector({
          required: true,
          data: this.operandData,
          root: this.operandObjectType,
          selection: operandSelection,
          filter: Magellan.Util.createFieldsFilter(Magellan.Validation.SFDC_TYPE_TO_GROUPING[this.condition.type]),
          onSelect: function(dropdownView, selection) {
            this.condition.operand = Magellan.Util.convertFieldSelectionArrayToString(selection);
            this.condition['operand type'] = selection[selection.length - 1].type;
            this.operandFieldCache = this.condition.operand;
          }.bind(this),
        });
        operandDropdown.html(this.operandNestedTypeahead.$el);
      } else {
        // If type of field is 'value' (default), need to check type of the condition, then show different inputs
        this.$el.find('fieldset input[value="value"]').prop('checked', true);
        switch (this.condition.type) {
          case 'BOOLEAN':
            operandInput.hide();
            operandDropdown.LDDropdown({
              required: true, 
              options: [true, false],
              value: this.condition.operand, 
              onChange: function(val) {
                this.condition.operand = val;
              }.bind(this),
            })
            break;
          case 'COMBOBOX':
          case 'PICKLIST':
            operandInput.hide();  

            var cachedValues = Magellan.Controllers.FlowBuilder.getCachedPicklistValues(this.operandObjectType + this.condition.field);
            if (!_.isEmpty(cachedValues)) cachedValues = JSON.parse(cachedValues);

            var emptyData = {};
            emptyData[this.operandObjectType] = [];

            var picklistTypeahead = new Magellan.Views.NestedTypeaheadSelector({
              required: true,
              requireSelectionFromData: false,
              disableBreadcrumbs: true,
              data: _.isEmpty(cachedValues) ? emptyData : cachedValues,
              root: this.operandObjectType,
              selection: _.isEmpty(this.condition.operand) ? Magellan.Util.convertStringSelectionToArray('') : Magellan.Util.convertStringSelectionToArray(this.condition.operand),
              fetchData: _.isEmpty(cachedValues) ? Magellan.Controllers.FlowBuilder.getPicklistFields.bind(null, this.operandObjectType, this.condition.field) : null,
              onSelect: function(dropdownView, selection) {
                this.condition.operand = Magellan.Util.convertFieldSelectionArrayToString(selection);
                this.condition['operand type'] = 'STRING';
                this.operandFieldCache = this.condition.operand;
                this.render();
              }.bind(this),
            });
            operandDropdown.html(picklistTypeahead.$el);
            break;
          case 'DATE':
          case 'DATETIME': 
            operandDropdown.hide();
            var utcDateTime = moment.utc(this.condition.operand);
            if (!Magellan.Validation.isValidValueOfType(this.condition.type, this.condition.operand)) {
              operandInput.toggleClass('input-invalid', true).val(this.condition.operand);
            } else {
              var localDateTime = utcDateTime.local().format(Magellan.Validation.DATETIME_FORMAT);
              operandInput.val(localDateTime);
            }
              
            if (this.condition.type === 'DATE') {
              operandInput.datepicker({ 
                dateFormat: 'yy-mm-dd'
              });
            } else {
              operandInput.datetimepicker({
                dateFormat: 'yy-mm-dd',
                timeFormat: 'HH:mm:ss',
                timeInput: true,
                showHour: false,
                showMinute: false,
                showSecond: false
              });
            }
            break;
          default: 
            operandDropdown.hide();
            if (!Magellan.Validation.isValidValueOfType(this.condition.type, this.condition.operand)) {
              operandInput.toggleClass('input-invalid', true).val(this.condition.operand);
            }
        }
        operandInput.val(this.condition.operand);
        this.operandValueCache = this.condition.operand;
        this.condition['operand type'] = 'STRING';
      }
    },

    render: function() {
      var content = this.template({
        idx: this.idx,
        condition: this.condition,
        hideToggleColumn: this.model.get('hideToggleColumn'),
      });
      this.$el.html(content);

      this._createFieldNestedTypeahead();
      this._createOperatorDropdown();
      this._createOperandColumn();

      return this;
    }
  });
}

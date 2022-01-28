module.exports = function() {
  Magellan.Models.TupleConditions = Backbone.Model.extend({
    defaults: {

    },

    initialize: function(config) {
      this.set({
        'data': config.data || {},
        'selectedRoutingType': config.selectedRoutingType || 'New',
        'fieldObjectType': config.fieldObjectType || 'Lead',
        'operandObjectType': config.operandObjectType || 'Lead',
        'flattenField': config.flattenField || false,
        'flattenOperand': config.flattenOperand || false,
        'conditions': config.conditions || [],
        'logic': config.logic || '',
        'rpnLogic': config.rpnLogic || [],
        'rpnLogicIsValid': config.rpnLogicIsValid || true,
        'rpnLogicErrorMessages': [],
        'hideToggleColumn': config.hideToggleColumn || false,
      });

      this.processData();
    },

    processData: function() {
      var data = this.get('data');

      var fieldData = {};
      var fieldObjectType = this.get('fieldObjectType');
      if (this.get('flattenField')) {
        fieldData[fieldObjectType] = Magellan.Util.createFlattenedFields(data[fieldObjectType]);
      } else {
        fieldData[fieldObjectType] = data[fieldObjectType];
      }
      this.set('fieldData', fieldData);

      var operandData = {};
      var operandObjectType = this.get('operandObjectType');
      if (this.get('flattenOperand')) {
        operandData[operandObjectType] = Magellan.Util.createFlattenedFields(data[operandObjectType]);
      } else {
        operandData[operandObjectType] = data[operandObjectType];
      }
      this.set('operandData', operandData);
    },

    addCondition: function(condition, logic) {
      // Add new or existing condition
      if (_.isEmpty(condition)) {
        condition = {
          'value/field':'value',
          'field':null,
          'type':null,
          'operator':null,
          'operand':null,
        };
      }
      var conditions = _.cloneDeep(this.get('conditions'));
      conditions.push(condition);
      this.set('conditions', conditions);

      this.parseLogic(logic);
      this.trigger('addedCondition');
    },

    deleteCondition: function(index) {
      var conditions = _.cloneDeep(this.get('conditions'));
      conditions.splice(index, 1);
      this.set('conditions', conditions);

      var num = conditions.length + 1;
      var re = new RegExp(' AND '+num+'| OR '+num, 'g');
      this.set('logic', this.get('logic').replace(re, ''));

      this.parseLogic(this.get('logic'));
      this.trigger('deletedCondition');
    },

    parseLogic: function(logic) {
      var conditions = this.get('conditions');

      var newLogic = !_.isEmpty(logic) ? logic : (conditions.length === 1 ? '1' : this.get('logic') + ' AND ' + conditions.length);
      var parsedLogicObject = Magellan.Util.parseLogic(conditions.length, newLogic);
      this.set('logic', newLogic);
      this.set('rpnLogic', parsedLogicObject.RPNTokens);
      this.set('rpnLogicIsValid', parsedLogicObject.feedbackMessage.length === 0);
      this.set('rpnLogicErrorMessages', parsedLogicObject.feedbackMessage);
    },

    setDefaultLogic: function() {
      var conditions = this.get('conditions');
      var logic = [];
      for (var i = 0; i < conditions.length; i++) {
        logic.push(i + 1);
      }
      var logicString = logic.join(' AND ');
      this.parseLogic(logicString);
      this.trigger('resetLogic');
    },

    validate: function() {
      var valid = true;
      var conditions = this.get('conditions');

      // Parse current logic when validating
      this.parseLogic(this.get('logic'));

      // Check if logic is valid, and there is at least 1 condition
      valid = valid && this.get('rpnLogicIsValid');
      valid = valid && conditions.length > 0;

      // Check if each condition entry/row is valid
      _.each(conditions, function(condition, idx) {
        var conditionValid = Magellan.Validation.validateSingleCondition(condition, this.get('fieldObjectType'), this.get('operandObjectType'));
        valid = valid && conditionValid === true;
      }, this);

      return valid;
    },

  });
}
module.exports = function() {
  require('./tuple-conditions.model')();

  Magellan.Views.TupleConditions = Backbone.View.extend({
    className: 'tuple-conditions-wrapper',
    template: _.template(require('./tuple-conditions.template.html')),
    initialize: function(config) {
      this.model = new Magellan.Models.TupleConditions(config);
      
      this.listenTo(this.model, 'addedCondition', this.render);
      this.listenTo(this.model, 'deletedCondition', this.render);
      this.listenTo(this.model, 'resetLogic', this.render);

      this.render();
    },

    events: {
      'click .add-tuple-condition-btn': 'addConditionButtonHandler',
      'click .reset-tuple-rule-logic': 'setDefaultLogic',
      'input .tuple-rule-logic-input': 'ruleLogicInputHandler',
    },

    returnModelValues: function() {
      return this.model.toJSON();
    },

    returnConditionValues: function() {
      return {
        conditions: this.model.get('conditions'),
        logic: this.model.get('logic'),
        rpnLogic: this.model.get('rpnLogic'),
      }
    },

    validate: function() {
      return this.model.validate();
    },

    setDefaultLogic: function() {
      this.model.setDefaultLogic();
    },

    ruleLogicInputHandler: function(e) {
      var $ruleLogicInput = $(e.target);
      var logic = $ruleLogicInput.val();

      if (_.isEmpty(logic)) {
        this.model.set('logic', null);
        this.model.set('rpnLogicIsValid', false);
      } else {
        this.model.parseLogic(logic);
      }

      var $ruleErrorDiv = this.$el.find('.rule-logic-error-row')
      if (!this.model.get('rpnLogicIsValid')) {
        $ruleLogicInput.toggleClass('input-invalid', true);
        $ruleErrorDiv.html(this.model.get('rpnLogicErrorMessages')[0]);
        $ruleErrorDiv.show();
      } else {
        $ruleLogicInput.toggleClass('input-invalid', false);
        $ruleErrorDiv.html('');
        $ruleErrorDiv.hide();
      }
    },

    addConditionButtonHandler: function(e) {
      this.addCondition(null);
    },

    addCondition: function(params) {
      this.model.addCondition(params);
    },

    createRuleRows: function() {
      var $conditionsRow = this.$el.find('.tuple-conditions-row');
      $conditionsRow.empty();

      var conditions = this.model.get('conditions');

      if (conditions.length === 0) {
        this.addCondition(null);
      } else {
        _.each(conditions, function(condition, idx) {
          var condRow = new Magellan.Views.SingleTupleCondition({
            idx: idx,
            model: this.model,
            condition: condition,
          });
          $conditionsRow.append(condRow.$el);
        }, this);        

        this.model.validate();
      }
    },

    render: function() {
      var content = this.template({
        fieldObjectType: this.model.get('fieldObjectType'),
        operandObjectType: this.model.get('operandObjectType'),
        logic: this.model.get('logic'),
        rpnLogicIsValid: this.model.get('rpnLogicIsValid'),
      });
      this.$el.html(content);

      this.createRuleRows();

      return this;
    }
  });
}
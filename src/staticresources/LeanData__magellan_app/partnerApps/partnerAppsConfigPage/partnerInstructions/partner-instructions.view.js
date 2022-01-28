/**
 * Basic template rendering with params.
 */
module.exports = function () {
  return Backbone.View.extend({
    templates: {
      'outreach': require('./outreach-instructions.template.html'),
      'salesloft': require('./salesloft-instructions.template.html'),
    },

    initialize: function (partner, params) {
      this.params = params;
      this.partner = partner;
      this.template = _.template(this.templates[this.partner]);
      this.render();
    },

    render: function () {
      const content = this.template({ params: this.params });
      this.$el.html(content);
    },
  })
}

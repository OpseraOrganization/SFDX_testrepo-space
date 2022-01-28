module.exports = function() {
    var template = require('./ConfirmationModal.template.html');

    return Magellan.Views.ConfirmationModal = Backbone.View.extend({
        _promise: null,
        _templatePromise: null,
        header: "Confirmation Dialog",
        message: "Are you sure?",
        footer: "",
        container: '#magellan-modals',
        template: _.template(template),
        events: {
            "click .cancel-button": "_cancel",
            "click .confirm-button": "_confirm",
            'click .modal': 'handleOutsideClick',
        },
        initialize: function(options) {
            this._promise = $.Deferred();
            this.container = options.container || this.container;

            if (typeof options.onConfirmed === 'function')
                this._promise.then(options.onConfirmed);
            if (typeof options.onCancelled === 'function')
                this._promise.fail(options.onCancelled);
                
            this._promise.always(this.close.bind(this));

            this.header = options.header || this.header;
            this.message = options.message || this.message;
            this.footer = options.footer || this.footer;

            this.primaryButtonText = options.primaryButtonText || 'Confirm';
            this.hideSecondaryButton = options.hideSecondaryButton || false;
            this.secondaryButtonText = options.secondaryButtonText || 'Cancel';
        
            this.render();
        },
        _cancel: function(event) {
            this._promise.reject(event);
        },
        _confirm: function(event) {
            this._promise.resolve(event);
        },

        /**
         * Triggers off of all click events on .modal but only
         * processes outside of the modal box.
         * @param {*} event
         */
        handleOutsideClick: function (event) {
          // event not associated with children, confirm outside click
          if (event.target === event.currentTarget) {
            if (!this.hideSecondaryButton) {
              // secondary button exists, can cancel
              this._cancel(event);
            } else {
              // secondary button hidden, can't cancel have to confirm
              this._confirm(event);
            }
          }
        },

        render: function() {
            var that = this;
            that.$el.html(that.template({ header: that.header, message: that.message, footer: that.footer, primaryButtonText: that.primaryButtonText, hideSecondaryButton: that.hideSecondaryButton, secondaryButtonText: that.secondaryButtonText}));
            $(that.container).append(that.$el);
            return this;
        },
        open: function() {
          this.$el.find('.modal').modal({'show': true, backdrop: 'static'});
        },
        close: function() {
            var that = this;
            this.$el.find('.modal').on('hidden.bs.modal', function() {
                that.remove();
            });
            this.$el.find(".modal").modal('hide');
            return this;
        },
        onConfirmed: function(callback) {
            if (typeof callback === 'function') this._promise.then(callback);
            else throw("ConfirmationModal Error: confirmation callback must be a function.");

            return this;
        },
        onCancelled: function(callback) {
            if (typeof callback === 'function') this._promise.fail(callback);
            else throw("ConfirmationModal Error: cancellation callback must be a function.");

            return this;
        }
    });
};

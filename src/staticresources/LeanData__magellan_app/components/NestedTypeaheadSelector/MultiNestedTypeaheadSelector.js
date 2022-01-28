module.exports = function(){
    /**
   * MultiNestedFieldSelect component
   * @description: render a dropdown select that allows user to search for a field given a root object
   *      or a field in another object which the root object references and allows you to select multiple objects.
   * @object: an object has "label", "name", and ("parent" which is an array of keys to a other objects)
   */

  var fieldSelectionTemplate = require("./multiple-field-selection.template.html");
  var multiSelectionTemplate = require("./multi-select.template.html")

  var hasChildren = function (obj) {
    return (obj['parent'] && obj['parent'].length > 0 && obj['type'] === 'REFERENCE')
  } // helper

  Magellan.Models.MultiNestedTypeaheadSelector = Magellan.Models.NestedTypeaheadSelector.extend({
    defaults: (fieldMetaData || null) // assuming fieldMetaData exists globally
  });

  Magellan.Views.MultiNestedTypeaheadSelector = Magellan.Views.NestedTypeaheadSelector.extend({

    multiSelectTemplate: _.template(multiSelectionTemplate),
    events: {
        'click .tt-custom-input' : '_onCustomInputSelect',
        'click .multi-nestedtypeahead-checkbox': '_onSelectCheckBox',
        'typeahead:autocomplete .typeahead': '_selectFirstItemOnMenu',
        'typeahead:render .typeahead': '_onSuggestionsRendered',
        'input .typeahead': '_onInputChange',
        'blur .typeahead': '_setInputValueWithSelected',
        'focus .typeahead': function (evt) {
            this.$('.tt-custom-input').toggleClass('hidden', true); 
            this.$(evt.target).typeahead('val', '');
            this._refreshSelectionBreadcrumbs();
        }
    },

    initialize: function(options){
      Magellan.Views.MultiNestedTypeaheadSelector.__super__.initialize.apply(this, arguments);
      this.multiSelect = true;
      this.selection = [];
      this.type = options.type || 'PICKLIST';
      // attach components to template and render
      this.selectionTemplate = _.template(fieldSelectionTemplate);
      this.render();
      if (options.selection) this.setSelection(options.selection);
    },

    getTypeaheadConfigurations: function (name, searchEngine) {
      var context = this;
      var noSuggestionTemplate = context.requireSelectionFromData ? context.notFoundTemplate : function() { return '<div></div>'; };
      var config = {
        name: name || 'multi-nested-typeahead-selector',
        limit: 1000, //For async functions, ensure the method that fetches results returns a LIMIT 100~ to improve performance
        display: function (obj) {
          if (hasChildren(obj)) return obj['label'].replace(' ID', '');
          else if (context.multiSelect) return obj['label'].replace(' ID', ', ');
          else return obj['label'];
        },
        source: searchEngine,
        templates: {
          header: _.template('<div class="mnts-selected-field-container"></div>'),
          suggestion: function (obj) {
            var templateData = {
              suggestion: obj,
              title: obj.name
            };
            return context.multiSelectTemplate(templateData);
          },
          notFound: noSuggestionTemplate
        }
      };
      return config;
    },

    _onCustomInputSelect: function (evt) {
      var selectedText = $(evt.currentTarget).text();
      var customObj = Magellan.Util.convertStringSelectionToArray(selectedText)[0];
      var indexInSelection = this._indexInSelection(customObj);
      if (this._indexInSelection(customObj) != -1 ) {
        this.selection.splice(indexInSelection, 1);
      } else {
        this.selection.push(customObj);
      }
      this._refreshSelectionBreadcrumbs();
      this.onSelectCallback(this, this.selection);
      this.$('.typeahead.tt-input').blur();
      this.customInputSelect = true;
    },

    _onSelectCheckBox: function (evt, selected) {
      var targetE = $(evt.currentTarget);
      var isChecked = targetE.is(':checked')
      var label = targetE.attr('label');

      var optionObj = _.find(this.model.get(this.root), function(option) {
        return option.label === label;
      }, this);

      if (isChecked && this._indexInSelection(optionObj) == -1){
        this.selection.push(optionObj);
      } else {
        this.selection.remove(optionObj);
      }

      this._refreshSelectionBreadcrumbs();

      if (_.isEmpty(this.bloodHound.remote)) this._refreshSelectionMenu(false);

      this.onSelectCallback(this, this.selection);
    },
    _refreshSelectionBreadcrumbs: function () {
      var renderedSelection = this.selectionTemplate({
        root: this.root,
        selection: this.selection,
        currentCustomValue: this.currentCustomValue,
        type: this.type,
      });

      if (this.breadcrumbsEl) this.breadcrumbsEl.remove();
      this.breadcrumbsEl = $(renderedSelection);
      this.$('.tt-menu').prepend(this.breadcrumbsEl);
    },

    _indexInSelection: function(obj) {
      for(var i = 0; i < this.selection.length; i++){
        if (obj.label === this.selection[i].label && obj.name === this.selection[i].name) {
          return i;
        }
      }
      return -1;
    },

    setSelection: function(newSelection) {
      if (!newSelection) return false;
      //This will split all of the labels into recognizeable labels
      if (newSelection.length > 0){
        //handle labels with labels surrounded by quotes in them
        var selectionInQuotes = newSelection[0].name.match(/".*?"/g);
        if (selectionInQuotes) {
          for (var j = 0; j < selectionInQuotes.length; j++){
            var parsed = JSON.parse(selectionInQuotes[j].replace(/,/g, 'LDCOMMA'));
            newSelection[0].name = newSelection[0].name.replace(selectionInQuotes[j], parsed);
          }
        }
        var names = (this.type === 'PICKLIST') ? newSelection[0].name.split(/, /) : newSelection[0].name.split(/; /);
        for (var i = 0; i < names.length; i++){
          names[i] = names[i].replace(/LDCOMMA/g, ',');
          var optionObj = _.find(this.model.get(this.root), function(option) {
            return option.name === names[i];
          }, this) || Magellan.Util.convertStringSelectionToArray(names[i])[0];
          if (optionObj && this._indexInSelection(optionObj) == -1 ) {
            this.selection.push(optionObj);
          }
        }
      }
      this.$('.typeahead.tt-input').blur();
    },

    _setInputValueWithSelected: function (evt) {
      var punct = (this.type === 'PICKLIST') ? ', ' : '; ';
      var inputValue = this.selection.reduce(function (acc, item) {
        var itemLabel = hasChildren(item) ? item['label'].replace(' ID', '') : item['label'];
        if(punct === ', ' && itemLabel.includes(',')) itemLabel = JSON.stringify(itemLabel);
        return acc += (acc !== "" ? punct : "") + htmlDecode(itemLabel);
      }, "");
      
      //behavior as of original nestedtypeahead 
      if (this.requireSelectionFromData) {
        this.$(evt.target).typeahead('val', inputValue);
      }
      else if (this.currentTextValue !== '' && this.customInputSelect) {
        this.$(evt.target).typeahead('val', this.currentTextValue);
        this._addToSelection(Magellan.Util.convertStringSelectionToArray(this.currentTextValue)[0]);
        this.$el.trigger("multiNestedTypeaheadSelector:select", this);
      }
      //a selection has been made without requireSelectionFromData, emptyTextDesired differentiates this case from when user deletes stuff from input field
      else if (inputValue !== null && inputValue !== '' && !this.emptyTextDesired) {
        this.$(evt.target).typeahead('val', inputValue);
        this.$el.trigger("multiNestedTypeaheadSelector:select", this);
      }
      else {
        this.$(evt.target).typeahead('val', this.currentTextValue);
        this._addToSelection(Magellan.Util.convertStringSelectionToArray(this.currentTextValue)[0]);
        this.$el.trigger("multiNestedTypeaheadSelector:select", this);
      }
      this.customInputSelect = false;
      this.validate();
    },
  });
};

module.exports = function() {
  var Magellan = window.Magellan = window.Magellan || Magellan || {};
  Magellan.Util = Magellan.Util || {}
  Magellan.Util.MultiSelectDropdownMap = Magellan.Util.MultiSelectDropdownMap || {};

  // Clicking out of the multi select will close all multi selects
  $(window).click(function(e){
    e.stopPropagation();
    var el = $(e.target);
    if (el.parents('.multiselect-dropdown').length === 0 && !el.hasClass('multiselect-dropdown')) {
      var lastOpenMultiSelect = $('.multiselect-dropdown.open');
      lastOpenMultiSelect.toggleClass('open', false);
      if (lastOpenMultiSelect.length > 0) {
        var lastMultiselectView = lastOpenMultiSelect.parent();
        var msdView = Magellan.Util.MultiSelectDropdownMap[lastMultiselectView[0].className];
        if (msdView) {
          var selectedItems = msdView._getSelectedItems(true);
          msdView.onCloseCallback(selectedItems.string, selectedItems.object);
        }
      }
    }
  });

  // Directly attach multi select to a DOM element
  $.fn.MultiSelectDropdown = function(config) {
    var currentClasses = $(this)[0].className;

    if (config === 'MultiSelectDropdown') {
      return Magellan.Util.MultiSelectDropdownMap[currentClasses] || null;
    }

    var MultiSelectDropdownView = new Magellan.Views.MultiSelectDropdown(config);
    $(this).html(MultiSelectDropdownView.$el);
    Magellan.Util.MultiSelectDropdownMap[currentClasses] = MultiSelectDropdownView;

    return MultiSelectDropdownView;
  };

  var MultiSelectDropdownModel = Backbone.Model.extend({
    defaults: {
      options: []
    }
  });

  Magellan.Views.MultiSelectDropdown = Backbone.View.extend({
    tagName: 'div',
    template: _.template(require('./LDMultiSelect.template.html')),
    optionTemplate: _.template(require('./LDMultiSelectOption.template.html')),
    initialize: function(config) {
      config = config || {};
      this.model = new MultiSelectDropdownModel({ options: config.options || [] });

      this.dropdownType = config.dropdownType || 'items';
      this.placeholder = config.placeholder || 'Select ' + this.dropdownType;
      this.allSelectedPlaceholder = 'All ' + this.dropdownType + ' selected';
      this.selectAll = config.selectAll || false;
      this.labelPropertyName = config.customLabelProperty || 'label';
      this.valuePropertyName = config.customValueProperty || 'value';
      this.generatePlaceholder = typeof config.generatePlaceholder === 'function' ? config.generatePlaceholder : null;
      this.onChangeCallback = typeof config.onChange === 'function' ? config.onChange : _.noop;
      this.onCloseCallback = typeof config.onClose === 'function' ? config.onClose : _.noop;

      this.size = config.size && config.size === 'large' ? 'large' : 'small';
      this.checkboxClass = 'cb-container-' + this.size;
      this.$el.attr('class', 'multiselect-dropdown multiselect-dropdown-' + this.size);

      this.listenTo(this, 'setToggleCheckboxState', this.setToggleCheckboxState);

      this.render();
    },

    events: {
      'mouseup .multiselect-dropdown-option-list-item': 'selectOption',
      'mouseup .multiselect-toggle-all-list-item': 'toggleAllOptions',
      'mouseup': 'toggleDropdown'
    },

    toggleDropdown: function(e) {
      e.stopPropagation();
      var el = $(e.target);
      var thisDropdown = el.closest('.multiselect-dropdown');
      var isOpen = thisDropdown.hasClass('open');
      if (el.parents('.multiselect-dropdown-menu').length === 0 && !el.hasClass('multiselect-dropdown-menu')) {
        $('.multiselect-dropdown.open').not(thisDropdown).toggleClass('open', false);
        thisDropdown.toggleClass('open').find('.multiselect-dropdown-toggle').focus();
        if (isOpen) {
          var selectedItems = this._getSelectedItems(true);
          this.onCloseCallback(selectedItems.string, selectedItems.object);
          this.trigger('MultiSelectDropdown:close', selectedItems.string, selectedItems.object, this);
        }
      }
    },

    toggleAllOptions: function(e) {
      var toggleCheckbox = $(e.currentTarget).find('input[type="checkbox"]');
      var listItemCheckboxes = this.$el.find('.multiselect-dropdown-option-list-item input[type="checkbox"]');
      toggleCheckbox.prop('checked', !toggleCheckbox.is(':checked'));
      listItemCheckboxes.prop('checked', toggleCheckbox.is(':checked'));
      
      var selectedItems = this._getSelectedItems(true);
      var totalSelected = selectedItems.string.length;
      var totalOptions = this.model.get('options').length;

      if(_.isNull(this.generatePlaceholder)) {
        this.$el.find('.placeholder-text').text(toggleCheckbox.is(':checked') ? this.allSelectedPlaceholder : this.placeholder);
      } else {
        this.$el.find('.placeholder-text').html(this.generatePlaceholder(null, selectedItems.string, selectedItems.object, totalOptions, this.dropdownType));
      }
      this.$el.find('.toggleText').text(toggleCheckbox.is(':checked') ? 'Deselect All' : 'Select All');

      this.onChangeCallback(null, selectedItems.string, selectedItems.object, totalOptions);
      this.trigger('MultiSelectDropdown:select', null, selectedItems.string, selectedItems.object, totalOptions, this);
      this.trigger('setToggleCheckboxState', totalSelected === totalOptions, totalSelected, totalOptions);
    },

    setToggleCheckboxState: function(allSelected, selectedCount, totalCount) {
      var cb = this.$el.find('.multiselect-toggle-all-list-item input[type="checkbox"]');
      cb.prop('checked', allSelected);
      this.$el.find('.toggleText').text(allSelected ? 'Deselect All' : 'Select All');
    },

    selectOption: function(e) {
      var targetEl = $(e.currentTarget).find('input[type="checkbox"]');
      targetEl.prop('checked', !targetEl.is(':checked'));
 
      var value = targetEl.data('value');
      var selectedItems = this._getSelectedItems(true);
      var totalSelected = selectedItems.string.length;
      var totalOptions = this.model.get('options').length;

      if(!_.isNull(this.generatePlaceholder)) {
        this.$el.find('.placeholder-text').html(this.generatePlaceholder(null, selectedItems.string, selectedItems.object, totalOptions, this.dropdownType));
      } else if (totalSelected === totalOptions) {
        this.$el.find('.placeholder-text').text(this.allSelectedPlaceholder);
      } else if (totalSelected > 0) {
        this.$el.find('.placeholder-text').text(totalSelected + ' of ' + totalOptions + ' ' + this.dropdownType + ' selected');
      } else {
        this.$el.find('.placeholder-text').text(this.placeholder);
      }

      this.onChangeCallback(value, selectedItems.string, selectedItems.object, totalOptions);
      this.trigger('MultiSelectDropdown:select', value, selectedItems.string, selectedItems.object, totalOptions, this);
      this.trigger('setToggleCheckboxState', totalSelected === totalOptions, totalSelected, totalOptions);
    },

    _getSelectedItems: function(returnBothFormats) {
      var valuesArr = [];
      var objectArr = [];
      var allSelectedItems = this.$el.find('.' + this.checkboxClass + ' input[type="checkbox"]:checked');
      _.each(Array.prototype.slice.apply(allSelectedItems), function(item) {
        // Toggle all checkbox will not have any data and should be excluded in general
        var data = $(item).data();
        if (!_.isEmpty(data)) {
          var obj = {};
          obj[this.labelPropertyName] = data.label;
          obj[this.valuePropertyName] = data.value;
          objectArr.push(obj);
          valuesArr.push(obj[this.valuePropertyName]);
        }
      }, this);
      return returnBothFormats ? { 'object': objectArr, 'string': valuesArr } : valuesArr;
    },

    _updateSelectList: function(options) {
      this.model.set('options', options || []);
      this._renderSelectList();
    },

    _renderSelectList: function() {
      var options = this.model.get('options');
      var optionList = '';
      this.$el.find('.multiselect-dropdown-option-list-item').remove();
      _.each(options, function(option) {
        var listItem = this.optionTemplate({
          label: option[this.labelPropertyName],
          value: option[this.valuePropertyName],
          checkboxClass: this.checkboxClass,
        })
        optionList += listItem;
      }, this);


      if (options.length > 0) {
        this.$el.find('.multiselect-toggle-all-list-item').show();
        this.$el.find('.multiselect-dropdown-menu').append(optionList);
        this.$el.find('.' + this.checkboxClass + ' input[type="checkbox"]').prop('checked', this.selectAll);
        this.$el.find('.toggleText').text(this.selectAll ? 'Deselect All' : 'Select All');
      } else {
        this.$el.find('.multiselect-toggle-all-list-item').hide();
      }

      var selectedItems = this._getSelectedItems(true);
      var totalSelected = selectedItems.string.length;
      var totalOptions = this.model.get('options').length;

      if(!_.isNull(this.generatePlaceholder)) {
        this.$el.find('.placeholder-text').html(this.generatePlaceholder(null, selectedItems.string, selectedItems.object, totalOptions, this.dropdownType));
      } else if(options.length > 0) {
        this.$el.find('.placeholder-text').text(this.selectAll ? this.allSelectedPlaceholder : this.placeholder);
      } else {
        this.$el.find('.placeholder-text').text('No ' + this.dropdownType + ' to select');
      }

      setTimeout(this._setDropdownWidth.bind(this));
    },

    _setDropdownWidth: function() {
      var dropdownEl = this.$el.find('.multiselect-dropdown-menu');
      var contentWidth = this.$el.width();
      var dropdownWidth = dropdownEl.width();

      if (dropdownWidth > contentWidth) {
        this.$el.css({'width': dropdownWidth + 2});
      } else {
        dropdownEl.css({'width': contentWidth + 32});
      }
    },

    render: function() {
      var content = this.template({
        placeholder: this.placeholder,
        allSelectedPlaceholder: this.allSelectedPlaceholder,
        selectAll: this.selectAll,
        checkboxClass: this.checkboxClass,
      });
      this.$el.html(content);

      this._renderSelectList();

      return this;
    }
  });
}

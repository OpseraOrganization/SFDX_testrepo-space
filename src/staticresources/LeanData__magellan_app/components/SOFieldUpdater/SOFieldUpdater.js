module.exports = function() {
    Magellan = Magellan || {};
    Magellan.Views = Magellan.Views || {};
    Magellan.Models = Magellan.Models || {};

    var template = require('./SOFieldUpdater.template.html');
    var updateRowTemplate = require('./update-row.template.html');
    var updaterModel = require('./SOFieldUpdater.model')();
    var nillableFields = []; //adding this here because nillable can be changed by user, we need to keep fetching for the most up to date status

    Magellan.Views.SOFieldUpdater = Backbone.View.extend({
        tagName: "div",
        className: "so-field-updater",
        typeaheadDropdowns: null,
        initialize: function(options) {
          // Blacklist fields
          let fields = options.fields || [];
          let blacklistSet = Magellan.Validation.FIELD_BLACKLIST_SETS[`${options.object.toUpperCase()}_FIELDS`];
          fields = _.filter(fields, (field) => !blacklistSet.has(field.name));

            this.model = new updaterModel({
                object: options.object,
                fields: fields || [],
                updates: options.updates || []
            });

            this.model.get('updates').on('add', this._renderUpdates.bind(this));
            this.model.get('updates').on('change', this._triggerModelChangeEvent.bind(this));

            this.typeaheadDropdowns = [];

            this.render();
        },

        template: _.template(template),
        updateRowTemplate: _.template(updateRowTemplate),

        events: {
            'click .add-rule-div': 'addRow',
            'click .sofu-boolean-dropdown-option': '_booleanDropdownHandler'
        },

        render: function() {
            this.$el.html(this.template({ model: this.model }));
            this._renderUpdates();

            return this;
        },

        addRow: function() {
            this.model.get('updates').add({ field: null, value: null, type: null });
        },

        deleteRow: function(row, update) {
            row.remove();
            this.model.get('updates').remove(update);
            this._triggerModelChangeEvent();
        },

        val: function() {
            return this.model.get("updates").toJSON();
        },

        _triggerModelChangeEvent: function() {
            this.$el.trigger('SOFieldUpdater:change', this);
        },

        _renderUpdates: function() {
            this.$('.field-updates-list').empty();

            // normalize data to fit in with NestedTypeaheadSelector
            var dropdownData = {};
            dropdownData[this.model.get('object')] = this.model.get('fields').toJSON();
            var selectUpdateValueFromDropdown = function(updateRow) {
                return function(event) {
                    event.preventDefault();
                    updateRow.find('.update-value').val($(this).data('value'));
                }
            };
            this.model.get('updates').each(function(update) {
                var updateRow = $(this.updateRowTemplate({ update: update }));
                var dropdown = this._createFieldsDropdown(update, dropdownData);
                updateRow.find('.sofu-field-selector').html(dropdown.$el);
                updateRow.find('.sofu-delete-column').on('click', this.deleteRow.bind(this, updateRow, update));
                updateRow.find('.sofu-update-value').on('change', this._setUpdateValue.bind(this, update));
                updateRow.find('.sofu-ld-dropdown').LDDropdown({ options: [true, false], value: update.get('value')});
                updateRow.find('.sofu-ld-dropdown').on('LDDropdown:change', this._setUpdateValue.bind(this, update));
                //adding new rows/ opening node for first time hits the conditions below
                if (_.isEmpty(update.get('field'))) {
                    var picklistTypeahead = this._createValueTypeahead(update, dropdownData);
                    updateRow.find('.sofu-ld-typeahead').html(picklistTypeahead.$el);
                    updateRow.find('.sofu-ld-typeahead').on('nestedTypeaheadSelector:select .sofu-ld-typeahead', this._setUpdateValue.bind(this, update));
                }
                this._refreshUpdateValueColumn(updateRow, update);
                this.$('.sofu-field-updates-list').append(updateRow);
            }, this);

            return this;
        },

        _createValueTypeahead: function (update) {
            var cachedValues = Magellan.Controllers.FlowBuilder.getCachedPicklistValues(this.model.get('object') + update.get('field'));
            if (cachedValues != null) {
                cachedValues = JSON.parse(cachedValues);
            }
            var emptyData = {};
            emptyData[this.model.get('object')] = [];
            var picklistTypeahead = new Magellan.Views.NestedTypeaheadSelector({
                data: cachedValues == null ? emptyData : cachedValues,
                root: this.model.get('object'),
                disableBreadcrumbs: true,
                requireSelectionFromData: false,
                required: false,
                fetchData: cachedValues == null ? Magellan.Controllers.FlowBuilder.getPicklistFields.bind(null,this.model.get('object'), update.get('field')) : null,
                selection: Magellan.Util.convertStringSelectionToArray(update.get('value'))
            });
            return picklistTypeahead;
        },

        _createMultiValueTypeahead: function(update){
          var cachedValues = Magellan.Controllers.FlowBuilder.getCachedPicklistValues(this.model.get('object') + update.get('field'));
          if (cachedValues != null) {
            cachedValues = JSON.parse(cachedValues);
          }
          var emptyData = {};
          emptyData[this.model.get('object')] = [];
          var picklistTypeahead = new Magellan.Views.MultiNestedTypeaheadSelector({
            type: update.get('type'),
            data: cachedValues == null ? emptyData : cachedValues,
            root: this.model.get('object'),
            onSelect: this._setUpdateValue.bind(this, update),
            disableBreadcrumbs: true,
            requireSelectionFromData: false,
            required: false,
            fetchData: cachedValues == null ? Magellan.Controllers.FlowBuilder.getPicklistFields.bind(null,this.model.get('object'), update.get('field')) : null,
            selection: Magellan.Util.convertStringSelectionToArray(update.get('value'))
          });
          return picklistTypeahead;
        },

        _createFieldsDropdown: function(update, fieldsData) {
            var selection = _.find(fieldsData[this.model.get('object')], function(fld) { return fld.name === update.get('field') });
            var trimmedFieldsData = {}; //removes all items in fieldsData that are not updatetable like id,createdDate...
            var customUserFields = Magellan.Controllers.FlowBuilder.getCustomUserFieldsByObject(LeanData__PrimarySObjectType); //potential loophole possibilities - remove these from available list
            var illegalAssignmentList = ['ownerid']; //populates a list by name from the above list for faster checking (ownerid is default salesforce field)
            _.each(customUserFields, function(customUserField) {
                if (customUserField['name'].endsWith('__r.id')) {
                    illegalAssignmentList.push(customUserField['name'].substring(0,customUserField['name'].length-6) + '__c');
                }
                else if (customUserField['name'].endsWith('.id')) {
                    illegalAssignmentList.push(customUserField['name'].substring(0,customUserField['name'].length-3));
                }
            });

            trimmedFieldsData[this.model.get('object')] = fieldsData[this.model.get('object')].filter(function(fieldProperties) {
                return fieldProperties['isUpdateable'] === true && illegalAssignmentList.includes(fieldProperties['name']) === false;
            });
            nillableFields = fieldsData[this.model.get('object')].filter(function(fieldProperties) {
                return fieldProperties['isNillable'] === true;
            });
            console.log(nillableFields);

            var dropdown = new Magellan.Views.NestedTypeaheadSelector({
                required: true,
                root: this.model.get('object'),
                data: trimmedFieldsData,
                selection: selection ? [selection] : [],
                onSelect: this._updateFieldOnSelected.bind(this, update)
            });
            dropdown.validate();

            this.typeaheadDropdowns.push(dropdown);

            return dropdown;
        },

        _setUpdateValue: function(update, evt, vwLDDropdown) {
            var rowEl, updateValue;
            var updateFieldType = update.get('type');
            var fieldNillableAndEmpty = false;
            if (vwLDDropdown instanceof Magellan.Views.LDDropdown) {
                updateValue = vwLDDropdown.val();
                rowEl = vwLDDropdown.$el.closest('.update-row');
            } else if (vwLDDropdown instanceof Magellan.Views.MultiNestedTypeaheadSelector) {
              if (_.isEmpty(vwLDDropdown.selection)) updateValue = '';
              else {
                updateValue = vwLDDropdown.selection.reduce(function(str, field) {
                  if (str!== "") str += "; ";
                  if (field.type === 'REFERENCE')
                    return str += Magellan.Util.flattenReferenceAPIs(field.name);
                  else
                    return str += field.name;
                }, "");
              }
              fieldNillableAndEmpty = this._isFieldNillable(update.get('field')) && (updateValue === '' || updateValue === null);
              rowEl = vwLDDropdown.$el.closest('.update-row');
            } else if (vwLDDropdown instanceof Magellan.Views.NestedTypeaheadSelector) {
                if (_.isEmpty(vwLDDropdown.selection)) updateValue = '';
                else updateValue = vwLDDropdown.selection[0]['name'];
                fieldNillableAndEmpty = this._isFieldNillable(update.get('field')) && (updateValue === '' || updateValue === null);
                rowEl = vwLDDropdown.$el.closest('.update-row');
            } else {
                updateValue = $(evt.target).val();
                fieldNillableAndEmpty = this._isFieldNillable(update.get('field')) && (updateValue === '' || updateValue === null);
                if (updateFieldType === 'DATETIME') {
                    //if fieldNillableAndEmpty is false, then perform previous behavior
                    if (fieldNillableAndEmpty === false) { //if it's not true, it is a null field and we should just set the value to updateVal without converting using moment
                        updateValue = moment(updateValue).format(Magellan.Validation.DATETIME_FORMAT);
                    }
                    //if the above is true, then set the text to the blank string that it is supposed to be
                    $(evt.target).val(updateValue);
                }
                rowEl = $(evt.target).closest('.update-row');
            }
            if (fieldNillableAndEmpty) {
                update.set('value', null);
            } else {
                update.set('value', updateValue);
            }

            this._validateRow(update, rowEl);
        },

        _updateFieldOnSelected: function(update, dropdownVw, selected) {
            var field = null;
            if (selected.length > 0) {
                field = selected[selected.length - 1];
            }

            update.set({
                'field': field['name'],
                'type': field['type']
            });

            this._refreshUpdateValueColumn(dropdownVw.$el.closest('.update-row'), update);
        },

        _refreshUpdateValueColumn: function(rowEl, update) {
            rowEl.find('.sofu-update-value').datepicker('destroy').removeClass('hasDatepicker');
            var hideBooleanDropdown = true;
            var hidePicklistDropdown = true;
            var fieldType = (update.get('type') || '').toLowerCase();
            if (fieldType === 'date') {
                rowEl.find('.sofu-update-value').datepicker({ dateFormat: 'yy-mm-dd'});
            } else if (fieldType === 'datetime') {
                rowEl.find('.sofu-update-value').datetimepicker({
                    dateFormat: 'yy-mm-dd',
                    timeFormat: 'HH:mm:ss',
                    timeInput: true,
                    showHour: false,
                    showMinute: false,
                    showSecond: false
                });
            } else if (fieldType === 'boolean') {
                hideBooleanDropdown = false;
            } else if (fieldType === 'picklist') {
                hidePicklistDropdown = false;
                var picklistTypeahead = this._createValueTypeahead(update);
                rowEl.find('.sofu-ld-typeahead').html(picklistTypeahead.$el);
                rowEl.find('.sofu-ld-typeahead').on('nestedTypeaheadSelector:select .sofu-ld-typeahead', this._setUpdateValue.bind(this, update));
            } else if (fieldType === 'multipicklist') {
              hidePicklistDropdown = false;
              var picklistTypeahead = this._createMultiValueTypeahead(update);
              rowEl.find('.sofu-ld-typeahead').html(picklistTypeahead.$el);
              rowEl.find('.sofu-ld-typeahead').on('multiNestedTypeaheadSelector:select .sofu-ld-typeahead', this._setUpdateValue.bind(this, update));
          }

            rowEl.find('.sofu-update-value').toggleClass('hidden', !hideBooleanDropdown || !hidePicklistDropdown);
            rowEl.find('.sofu-ld-dropdown').toggleClass('hidden', hideBooleanDropdown);
            rowEl.find('.sofu-ld-typeahead').toggleClass('hidden', hidePicklistDropdown);
            rowEl.find('.sofu-update-value').val(update.get('value'));
            this._validateRow(update, rowEl);
        },
        
        _validateRow: function(update, updateRowEl) {
            var updateValue = update.get('value');
            var updateFieldType = update.get('type');
            //mark this row as valid if its nillable and the field is blank ... implying user wants to update to null      
            var isValidValue = Magellan.Validation.isValidValueOfType(updateFieldType, updateValue) || (this._isFieldNillable(update.get('field')) && (updateValue === '' || updateValue === null));
            //strings make isValidValue true based off of the isValidValueofType check, so we need to make sure it is still valid
            //applies to fields that are String and notNillable like Lead Status/Company
            if ((updateValue === '' || updateValue === null)) {
                isValidValue = this._isFieldNillable(update.get('field'));
            }

            updateRowEl.find('.sofu-ld-dropdown .ld-dropdown, .sofu-update-value').toggleClass('input-invalid', !isValidValue);
        },

        _isFieldNillable: function(fieldName) {
            var nillableField = _.find(nillableFields, function(fld) { return fld.name === fieldName });
            return nillableField != undefined;
        },

        _booleanDropdownHandler: function(event) {
            event.preventDefault();
            var dropdownOption = $(event.target).text();
            var dropdownOptionValue = $(event.target).data('value');
            $(event.target).closest('.sofu-boolean-dropdown').find('.sofu-boolean-dropdown-value-text').text(dropdownOption);
            $(event.target).closest('.sofu-boolean-dropdown').find('.sofu-boolean-dropdown-value').val(dropdownOptionValue).trigger('change');
            $(event.target).closest('.sofu-boolean-dropdown').toggleClass('input-invalid', false);
        },

        remove: function() {
            this.typeaheadDropdowns.forEach(function(dropdown) {
                dropdown.remove();
            });
            Backbone.View.prototype.remove.apply(this, arguments);
        }
    });
};

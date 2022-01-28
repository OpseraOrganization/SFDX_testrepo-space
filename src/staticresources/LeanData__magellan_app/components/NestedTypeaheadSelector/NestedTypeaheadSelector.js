module.exports = function() {
    /**
     * NestedTypeaheadSelector component
     * 
     * @description: render a dropdown select that allows user to search for a field given a root object
     *      or a field in another object which the root object references.
     * 
     * @param asyncServiceCall
     *   Callback that takes one param (user's string input in typeahead)
     *   and returns a promise which resolves with a list of filtered
     *   objects with 2-3 key-value pairs (custom keys can exist also):
     *   {
     *     name: 'foo', // string
     *     label: 'bar', // string
     *     parents: [] // optional, array of keys to a other objects
     *   }
     * 
     *   NOTE: the first item (index 0) of the returned list helps
     *         populate the suggestion (via Bloodhound, the suggestion engine)
     * 
     * @param size
     *   optional (defaults to 'small')
     *   can be 'large', 'small' or 'xtra-small'
     * 
     * See https://twitter.github.io/typeahead.js/examples/ for more info
     * on generic typeahead.js uses.
     */

    var template = require("./NestedTypeaheadSelector.template.html");
    var fieldSelectionTemplate = require("./field-selection.template.html");
    
    var hasChildren = function (obj) {
        return (obj['parent'] && obj['parent'].length > 0 && obj['type'] === 'REFERENCE')
    } // helper

    Magellan = Magellan || {};
    Magellan.Models = Magellan.Models || {};
    Magellan.Views = Magellan.Views || {};

    var model = Magellan.Models.NestedTypeaheadSelector = Backbone.Model.extend({
        defaults: (fieldMetaData || null) // assuming fieldMetaData exists globally
    });

    var view = Magellan.Views.NestedTypeaheadSelector = Backbone.View.extend({
        tagName: "span",
        selection: null,
        fieldSuggestionTemplate: _.template('<p title="<%=title%>"><%=suggestion.label%></p>'),
        categoryLabelTemplate: _.template('<p class="nts-category-label" title="<%=title%>"><%=suggestion.label%></p>'),
        objectSuggestionTemplate: _.template(
            '<p title="<%=title%>">' +
            '<span><%=suggestion.label.replace(" ID", "")%></span>' +
            '&nbsp;&nbsp;<span class="expand-arrow">▸</span>' +
            '</p>'
        ),
        disabledSuggestionTemplate: _.template(
            '<p class="disabled" title="<%=title%>">' +
            '<span><%=suggestion.label.replace(" ID", "")%></span>' +
            '&nbsp;&nbsp;<span class="expand-arrow">▸</span>' +
            '&nbsp;&nbsp;<span class="glyphicon glyphicon-warning-sign text-danger"></span>' +
            '</p>'
        ),
        notFoundTemplate: _.template(
            '<div class="alert alert-danger" style="padding: 0 5px; margin: 0">No Suggestion Found.</div>'
        ),
        customValueTemplate: _.template(
            '<div class="tt-dataset tt-dataset-nested-typeahead-selector">' + 
                '<div class="nts-selected-field-container">' + 
                    '<p title="" class="tt-suggestion tt-custom-input tt-selectable hidden"></p>' +
                '</div>' + 
            '</div>'
        ),
        bloodHound: null,
        searchEngine: null,
        breadcrumbsEl: null,
        customValueEl: null,
        onSelectCallback: null,
        filterSuggestions: null,
        currentCustomValue: null,
        events: {
            'click .tt-custom-input' : '_onCustomInputSelect',
            'typeahead:select .typeahead': '_onSelect',
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

        initialize: function (options) {
            // check for data
            var that = this;
            if (typeof options.data === 'object') {
                this.model = new model(options.data);
            } else if (options.model instanceof model) {
                this.model = options.model;
            } else {
                this.model = new model();
            }
            this.selection = [];
            this.root = options.root;
            this.placeholder = options.placeholder || 'Search';
            this.filterSuggestions = typeof options.filter === 'function' ? options.filter : null;
            this.onSelectCallback = typeof options.onSelect === 'function' ? options.onSelect : function() {};
            this.required = (options.required === true) || false;
            this.aliases = options.aliases || {};
            this.disableBreadcrumbs = options.disableBreadcrumbs != null ? options.disableBreadcrumbs : false;
            this.requireSelectionFromData = options.requireSelectionFromData != null ? options.requireSelectionFromData : true;
            this.emptyTextDesired = false;
            // if options.asynServiceCall is defined, the instance wants to have the remote functionality - thus initialize a different kind of bloodhound
            this.datumTokenizer = options.datumTokenizer;
            this.queryTokenizer = options.queryTokenizer;
            this.bloodHound = _.isFunction(options.asyncServiceCall) ? this._getAsyncBloodHound(options.asyncServiceCall) : this._getBloodHound(this.model.get(this.root));
            this.currentTextValue = ''; //Tracks the current search so it does not get reset on clicking nestedtypeahead
            this.currentCustomValue = {'label' : 'blah', 'name' : 'blah', 'isCustomValue' : true};
            this.customValidationFunction = _.isFunction(options.customValidationFunction) ? options.customValidationFunction : null;
            this.cachedValidValues = []; //async validation cache, do not have to requery to see if IDs exist
            this.asyncServiceCall = _.isFunction(options.asyncServiceCall) ? options.asyncServiceCall : null;
            //used for picklist typeahead, use when data fields are not loaded in metadata
            if (_.isFunction(options.fetchData)) {
                options.fetchData().then(function(fetchedData){
                    parsedData = JSON.parse(fetchedData);
                    that.model = new model(parsedData);
                    that.bloodHound = options.asyncServiceCall != undefined ? that._getAsyncBloodHound(options.asyncServiceCall) : that._getBloodHound(that.model.get(that.root));
                    that.searchEngine = that._getSearchEngine(that.bloodHound);
                    that.render();
                    if (that.selection) that.setSelection(that.selection);       
                }).fail(function(result, event) {
                    that.render();
                    if (that.bloodHound) that.bloodHound.clear();
                    that.$('.typeahead-input').toggleClass('input-invalid', true);
                });
            }
            this.searchEngine = _.isUndefined(options.asyncServiceCall) ? this._getSearchEngine(this.bloodHound) : this.bloodHound;
            // typeahead size
            if (options.size) {
                this.$el.attr('class', 'nested-typeahead-selector typeahead-' + options.size);
            } else {
                this.$el.attr('class', 'nested-typeahead-selector typeahead-small');
            }
            // attach component templates and render

            this.template = _.template(template);
            this.selectionTemplate = _.template(fieldSelectionTemplate);
            this.render();

            if (options.selection) this.setSelection(options.selection);
        },

        render: function () {
            this.$el.empty(''); // in the event of re-rendering
            this.$el.append(this.template(this));

            this._initTypeahead(this.$('.typeahead'), this.searchEngine);
            return this;
        },

        getTypeaheadOptions: function () {
            return {
                hint: true,
                highlight: true,
                minLength: 0
            }
        },

        getTypeaheadConfigurations: function (name, searchEngine) {
            var context = this;
            var noSuggestionTemplate = context.requireSelectionFromData ? context.notFoundTemplate : function() { return '<div></div>'; };
            var config = {
                name: name || 'nested-typeahead-selector',
                limit: 1000, //For async functions, ensure the method that fetches results returns a LIMIT 100~ to improve performance
                display: function (obj) {
                    return obj['label'];
                },
                source: searchEngine,
                templates: {
                    header: _.template('<div class="nts-selected-field-container"></div>'),
                    suggestion: function (obj) {
                        var templateData = {
                            suggestion: obj,
                            title: obj.name
                        };
                        if (obj.isCategoryLabel) {
                            return context.categoryLabelTemplate(templateData);
                        } else if (hasChildren(obj)) {
                            if (context.selection.length >= 4) {
                                templateData.title = "Maximum number of objects selected reached.";
                                return context.disabledSuggestionTemplate(templateData);
                            } else {
                                return context.objectSuggestionTemplate(templateData);
                            }

                        } else {
                            return context.fieldSuggestionTemplate(templateData);
                        }
                    },
                    notFound: noSuggestionTemplate
                }
            };

            return config;
        },

        setSelection: function(newSelection) {
            if (!newSelection) return false;
            this.selection = newSelection;
            this._resetBloodHoundDataUsingCurrentSelection();
            this.$('.typeahead.tt-input').blur();
        },

        /**
         * Refresh bloodhound and re-prefetch data from
         * source. In most cases can be used to clear
         * cached data and re-call asyncServiceCall.
         */
        refreshBloodhoundData: function () {
          this.searchEngine.initialize(true);
        },

        validate: function() {
            if (this.customValidationFunction) return this.customValidationFunction(this);
            var that = this;

            var validationPromise = $.Deferred().always(function(isValid) {
                that.$('.typeahead-input').toggleClass('input-invalid', !isValid);
            });

            if (this.selection.length === 0) {
                return this.required ? validationPromise.reject() : validationPromise.resolve(true);
            } else if (this.bloodHound.remote) {
                // async validation
                if (this.cachedValidValues.includes(that.selection[0]['Id'])) {
                    return validationPromise.resolve(true);
                } else {
                  this.asyncServiceCall(this.selection[0]['name']).then(function (queryResults) {
                    _.each(queryResults, function (queryResult) {
                      if (that.selection[0]['Id'] === queryResult['Id']) {
                        that.cachedValidValues.push(queryResult['Id']);
                        validationPromise.resolve(true);
                        return false; // break
                      }
                    });
                  }).fail(function (result, event) {
                    validationPromise.reject();
                  });
                  return validationPromise;
                }
            }/* else if (this.bloodHound.local) {
                // validate against local data
                var isFound = false;
                _.each(this.bloodHound.local, function (item) {
                    if (that.selection[0]['label'] === item['label'] && that.selection[0]['name'] === item['name']) {
                        isFound = true;
                        return false; // break 
                    }
                });
                
                return isFound ? validationPromise.resolve(true) : validationPromise.reject();
            }*/ else {
                // validation for nested fields: only valid if hasChildren return false (leaf field)
                // ex: Lead.Account is invalid, Lead.Account.Id or Lead.AccountId is valid
                return hasChildren(this.selection[this.selection.length - 1]) ? validationPromise.reject() : validationPromise.resolve(true);
            }
        },

        _prefetchSelectionData: function (promise) {
            if (promise == null) {
                return;
            }
            var that = this;
            promise.then(function(data){
                parsedData = JSON.parse(data);
                that.model = new model(parsedData);
                that.bloodHound = that._getBloodHound(that.model.get(that.root));
                that.searchEngine = that._getSearchEngine(that.bloodHound);
                that.render();
                if (that.selection) that.setSelection(that.selection);
            });
        },

        _getParentFields: function (objectKeys) {
            var context = this;
            var allFields = [];
            var aliases = this.aliases;
            var appendedFields = {};

            // nested loops ok here, the number of objectKeys are small enough to not affect any performance
            _.each(objectKeys, function(objectKey) {
                var objectFields = context.model.get(objectKey);
                if (objectKeys.length > 1) {
                    // add in a fake Field item as Category label separator for displaying on the menu
                    allFields.push({label: objectKey, isCategoryLabel: true});
                }

                _.each(objectFields, function(field) {
                    var fieldFullName = objectKey + "." + field['name'];
                    // only add to fields list if NOT already aliased by other field before it
                    if (!aliases.hasOwnProperty(fieldFullName) || !appendedFields.hasOwnProperty(aliases[fieldFullName])) {
                        allFields.push(field);
                        appendedFields[fieldFullName] = field;
                    }
                });
            });

            return allFields;
        },

        _resetBloodHoundData: function (newData) {
            if (this.bloodHound != null) this.bloodHound.clear();
            if (newData) this.bloodHound.local = newData;
            if (this.bloodHound != null) this.bloodHound.initialize(true);
        },

        _resetBloodHoundDataUsingCurrentSelection: function() {
            var lastItemWithParent = null;
            for (var i = this.selection.length - 1; i >= 0; i--) {
                if (hasChildren(this.selection[i])) {
                    lastItemWithParent = this.selection[i];
                    break;
                }
            }

            if (this.selection.length === 0 || lastItemWithParent === null) {
                var rootDataset = this.model.get(this.root);
                if (rootDataset != null){
                    this._resetBloodHoundData(rootDataset);
                }
            } else {
                // if selected field has parent then we go one level in and refresh the menu with parents' fields
                var newDataset = this._getParentFields(lastItemWithParent['parent']);
                if (newDataset != null) {
                    this._resetBloodHoundData(newDataset);
                }
            }
        },

        _onSuggestionsRendered: function(evt, suggestions) {
            this.emptyTextDesired = this.currentTextValue.length > 0 && this.$(evt.target).typeahead('val') == '';
            this.currentTextValue = this.$(evt.target).typeahead('val');
            this.$('.tt-suggestion.disabled, .tt-suggestion.nts-category-label').on('click', function(e) {
               e.preventDefault();
               return false;
            });
        },

        _onInputChange: function(evt) {
            if (this.requireSelectionFromData === false) {
                var updatedInput = $(evt.currentTarget).val();
                this.$('.tt-custom-input').text(updatedInput);
                this.$('.tt-custom-input')[0].title = updatedInput;
                if (updatedInput == '') {
                    this.$('.tt-custom-input').toggleClass('hidden', true);           
                }
                else {
                    this.$('.tt-custom-input').toggleClass('hidden', false);
                }
            }
        },

        _onCustomInputSelect: function (evt) {
            var selectedText = $(evt.currentTarget).text();
            this._addToSelection(Magellan.Util.convertStringSelectionToArray(selectedText)[0]);
            this.$el.trigger("nestedTypeaheadSelector:select", this);
            this.onSelectCallback(this, this.selection);
            this.$('.typeahead.tt-input').blur();
            this.customInputSelect = true;
        },

        _onSelect: function (evt, selected) {
            this._addToSelection(selected);
            this._refreshSelectionBreadcrumbs();
            this._resetBloodHoundDataUsingCurrentSelection();
            if (_.isEmpty(this.bloodHound.remote)) this._refreshSelectionMenu();

            this.$el.trigger("nestedTypeaheadSelector:select", this);
            this.onSelectCallback(this, this.selection);
            if (!hasChildren(selected)) this.$('.typeahead-input').trigger('blur');
        },

        _selectFirstItemOnMenu: function (evt) {
            // on autocomplete select the first one on the list with the down arrow key
            var e = $.Event("keydown");
            e.keyCode = e.which = 40; // 40 === arrow down
            this.$(evt.target).triggerHandler(e);
        },

        _setInputValueWithSelected: function (evt) {
            var inputValue = this.selection.reduce(function (acc, item) {
                var itemLabel = item['label'];

                return acc += (acc !== "" ? "." : "") + htmlDecode(itemLabel);
            }, "");
            
            //behavior as of original nestedtypeahead 
            if (this.requireSelectionFromData) {
                this.$(evt.target).typeahead('val', inputValue);
            }
            else if (this.currentTextValue !== '' && this.customInputSelect) {
                this.$(evt.target).typeahead('val', this.currentTextValue);
                this._addToSelection(Magellan.Util.convertStringSelectionToArray(this.currentTextValue)[0]);
                this.$el.trigger("nestedTypeaheadSelector:select", this);
            }
            //a selection has been made without requireSelectionFromData, emptyTextDesired differentiates this case from when user deletes stuff from input field
            else if (inputValue !== null && inputValue !== '' && !this.emptyTextDesired) {
                this.$(evt.target).typeahead('val', inputValue);
            }
            else {
                this.$(evt.target).typeahead('val', this.currentTextValue);
                this._addToSelection(Magellan.Util.convertStringSelectionToArray(this.currentTextValue)[0]);
                this.$el.trigger("nestedTypeaheadSelector:select", this);
            }
            this.customInputSelect = false;
            this.validate();
        },

        _getAsyncBloodHound: function(serviceCall) {
            context = this;
            var filter = typeof this.filterSuggestions === 'function' ? this.filterSuggestions : null;
            return new Bloodhound({
                remote: {
                    //url usage will change with Overlord implementation
                    url: '%query%',
                    wildcard: '%query%',
                    transport: function(options, onSuccess, onError) {
                        if (filter === null) {
                            serviceCall(decodeURI(options.url)).then(onSuccess, onError);
                        } else {
                            serviceCall(decodeURI(options.url)).then(function(result) {
                                let filteredResults = filter(result);
                                onSuccess(filteredResults);
                            }, onError);
                        }
                    },
                    cache: false
                },
                sufficient: 100,
                queryTokenizer: context.queryTokenizer || function(query) { return [query]; },
                datumTokenizer: context.datumTokenizer || function(datum) { return datum },
                identify: function(obj) { return obj.Id; }
            });
        },

        _getBloodHound: function (data) {
            if (!data) throw("NestedTypeaheadSelector Error: Invalid data. Failed to create bloodhound.");
            globalData = data;
            context = this;
            return new Bloodhound({
                local: data,
                identify: function (obj) {
                    return obj.name + " / " + obj.label
                },
                datumTokenizer: context.datumTokenizer || function (datum) {
                    nameTokens = Bloodhound.tokenizers.whitespace(datum['name']);
                    labelTokens = Bloodhound.tokenizers.whitespace(datum['label']);
                    return nameTokens.concat(labelTokens).concat(datum['parent'] || []);
                },
                
                queryTokenizer: context.queryTokenizer || Bloodhound.tokenizers.whitespace
            });
        },

        _getSearchEngine: function (theHound) {
            var filter = this.filterSuggestions;
            // Bloodhound Doc: https://github.com/twitter/typeahead.js/blob/master/doc/bloodhound.md
            return function (q, sync) {
                if (q === '') {
                   if (typeof filter === 'function') sync(filter(theHound.all()));
                   else sync(theHound.all());
                } else {
                    theHound.search(q, function(suggestions) {
                        if (typeof filter === 'function') sync(filter(suggestions));
                        else sync(suggestions);
                    });
                }
            }
        },

        _initTypeahead: function (inputEl, searchEngine) {
            // Typeahead Doc: https://github.com/twitter/typeahead.js/blob/master/doc/jquery_typeahead.md
            // in case of re-initialization
            inputEl.typeahead('destroy');

            // avoid typeahead cached being shared with other typeaheads
            var typeaheadInstanceName = 'nested-typeahead-selector' + "-" + Date.now();

            // initialize Typeahead
            inputEl.typeahead(
                this.getTypeaheadOptions(),
                this.getTypeaheadConfigurations(typeaheadInstanceName, searchEngine)
            );

            if (this.requireSelectionFromData === false) {
                this.customValueEl = this.customValueTemplate;
                this.$('.tt-menu').prepend(this.customValueEl);
            }

            this._refreshSelectionBreadcrumbs();
        },

        _addToSelection: function (selectedField) {
            if (!selectedField) return this;
            var lastIndex = this.selection.length - 1;
            if (lastIndex > -1 && !hasChildren(this.selection[lastIndex])) {
                this.selection[lastIndex] = selectedField;
            } else {
                this.selection.push(selectedField);
            }
        },

        _refreshSelectionBreadcrumbs: function () {
            var renderedSelection = this.selectionTemplate({
                root: this.root,
                selection: this.selection,
                currentCustomValue: this.currentCustomValue,
                hasChildren: hasChildren
            });

            if (this.breadcrumbsEl) this.breadcrumbsEl.remove();
            this.breadcrumbsEl = $(renderedSelection);
            this.breadcrumbsEl.find('.nts-selected-node.nts-parent-node').each((function(index, nodeEl) {
                $(nodeEl).on('click', this._deselectTo.bind(this, index));
            }).bind(this));

            if (!this.disableBreadcrumbs){
                this.$('.tt-menu').prepend(this.breadcrumbsEl);
            }
        },

        _refreshSelectionMenu: function(sliding=true) {
            this._initTypeahead(this.$('.typeahead'), this._getSearchEngine(this.bloodHound));
            this.$('.typeahead').focus();
            if (sliding){
              this.$('.tt-dataset').hide(0, function () {
                  $(this).slideDown();
              });
            }
        },

        _deselectTo: function(index) {
            // note: selection does not contain root.
            this.selection.splice(index);
            this._resetBloodHoundDataUsingCurrentSelection();
            this._refreshSelectionMenu();
            this._refreshSelectionBreadcrumbs();
        }
    });

};

var LDDropdown = function() {
    var template = require('./LDDropdown.template.html');
    j$(document).on('mouseup', function() {
        j$('.ld-dropdown.open').toggleClass('open', false);
    });

    var listItemTemplate =  '<li class="ld-dropdown-option-list-item <%=selected%> <%=hiddenClass%>"><div class="ld-dropdown-option" data-model-index="<%=modelIndex%>">' +
        '<%=renderedOptionTemplate%>' +
        '</div></li>';
    var cacheRenderedOptionItem = {};

    $.fn.LDDropdown = function(option) {
        if (option === 'val') return (this.magellanLDDropdown instanceof Magellan.Views.LDDropdown ? this.magellanLDDropdown.val() : null);
        if (option === 'LDDropdown') return this.magellanLDDropdown || null;

        var vwLDDropdown = new Magellan.Views.LDDropdown(option);
        j$(this).html(vwLDDropdown.$el);

        this.magellanLDDropdown = vwLDDropdown;

        return j$(this);
    }

    var model = Magellan.Models.LDDropdown = Backbone.Model.extend({
        defaults: {
            value: null,
            options: null,
            required: false
        },

        isValid: function() {
            var isValid = true;

            if (this.get('required') === false) return isValid;

            var value = this.get('value');
            if (_.isNull(value) || _.isUndefined(value) || value === '' || this.get('options').indexOf(value) < 0) {
                isValid = false;
            }

            return isValid;
        }
    });

    var view = Magellan.Views.LDDropdown = Backbone.View.extend({
        tagName: 'div',
        optionTemplate: _.template('<span><%=option%></span>'),
        customOptionTemplate: null,
        customValues: null,
        template: _.template(template),
        bloodhound: null,
        datumTokenizer: Bloodhound.tokenizers.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        enableSearch: false,
        menuAlignClass: '',
        placeholder: null,
        onChangeCallback:  null,
        initialize: function(config) {
            this.model = new model();

            if (!_.isUndefined(config)) {
                this.model.set('value', _.isUndefined(config.value) ?  null : config.value);
                this.model.set('options', config.options || []);
                this.model.set('required', config.required === true);
                this.model.set('customValues', config.customValues || {});
                this.model.set('preferredOptions', config.preferredOptions || []);
                this.model.set('hidePreferredOptions', config.hidePreferredOptions === true);

                if (typeof config.optionTemplate === 'string') {
                    this.customOptionTemplate = _.template(config.optionTemplate);
                } else {
                    this.customOptionTemplate = config.optionTemplate || null;
                }
                
                this.queryTokenizer = config.queryTokenizer || this.queryTokenizer;
                this.datumTokenizer = config.datumTokenizer || this.datumTokenizer;
                this.enableSearch = _.isBoolean(config.enableSearch) ? config.enableSearch : this.model.get('options').length >= 10;
                this.menuAlignClass = config.alignMenuRight ? 'pull-right' : '';
                this.placeholder = typeof config.placeholder === 'string' && config.placeholder ? config.placeholder : 'Select One';
                this.onChangeCallback = typeof config.onChange === 'function' ? config.onChange : _.noop;
                if (this.enableSearch) this._initBloodhound(this.model.get('options'));
                this.isValid = _.isFunction(config.isValid) ? config.isValid : this.model.isValid.bind(this.model);
            }
            if (config && config.size) {
                switch (config.size) {
                    case 'large':
                        this.$el.attr('class', 'ld-dropdown ld-dropdown-large');
                        break;
                    case 'xtra-small':
                        this.$el.attr('class', 'ld-dropdown ld-dropdown-xtra-small');
                        break;
                    default: 
                        this.$el.attr('class', 'ld-dropdown ld-dropdown-small');
                }
            } else {
                this.$el.attr('class', 'ld-dropdown ld-dropdown-small');
            }

            this.render();

            this.listenTo(this.model, 'change', this._handleModelChange);
        },
        _initBloodhound: function(data) {
            this.bloodhound = new Bloodhound({
                local: data,
                queryTokenizer: this.queryTokenizer,
                datumTokenizer: this.datumTokenizer
            });
            
            this.bloodhound
                .initialize()
                .then(this._search.bind(this, this.$('.ld-dropdown-search-filter-input').val()));
        },

        events: {
            'click .ld-dropdown-search-filter-container': function(e) { e.preventDefault(); e.stopPropagation(); },
            'click .ld-dropdown-option-list-item': 'selectOption',
            'mouseup .ld-dropdown-search-filter-input': function(e) { e.stopPropagation(); },
            'keyup .ld-dropdown-search-filter-input': '_searchInputChanged',
            'mouseup .ld-dropdown-toggle': function(e) {
                e.stopPropagation();
                var thisDropdown = $(e.target).closest('.ld-dropdown');
                $('.ld-dropdown.open').not(thisDropdown).toggleClass('open', false);
                thisDropdown.toggleClass('open').find('.ld-dropdown-toggle').focus();
                if (this.enableSearch) this.$('.ld-dropdown-search-filter-input').focus();
            },
            'mouseup .ld-dropdown': function(e) {
                e.stopPropagation();
            }
        },

        render: function() {
            var content = this.template(this);

            this.$el.html(content);

            this._renderSelectList();
            this._renderSelectedValue();
            
            this.$('.ld-dropdown-search-filter-container').toggleClass('hidden', this.enableSearch === false);

            return this;
        },

        selectOption: function(evt) {
            var targetEl = $(evt.target);
            if (!$(evt.target).is('.ld-dropdown-option-list-item')) targetEl = $(evt.target).closest('.ld-dropdown-option-list-item');
            var itemIndex = targetEl.find('.ld-dropdown-option').data('model-index');
            var optionData = this.model.get('options')[itemIndex];
            this.model.set('value', optionData);

            this.$('.ld-dropdown-option-list-item.selected').toggleClass('selected', false);
            targetEl.toggleClass('selected', true);
        },

        val: function() {
            return this.model.get('value');
        },

        validate: function() {
            var isValid = this.isValid();
            this.$el.toggleClass('input-invalid', !isValid);
            return isValid;
        },

        // Passes in two arguments to the callback function provided. The second argument is optional but it allows
        // the callback function to have access to the dropdown element. This is helpful in the case where you need
        // to find the closest element/parent 
        _handleModelChange: function() {
            this._renderSelectedValue();
            this.$el.trigger('LDDropdown:change', this);
            this.onChangeCallback(this.val(), this);
        },

        _getOptionItemMarkup: function(option) {
            var renderedOptTpl = '';

            if (typeof this.customOptionTemplate === 'function') {
                renderedOptTpl = this.customOptionTemplate(option);
            } else if (typeof option === 'object' && _.isNull(option) === false) {
                console.warn("LDDropdown: option an item is an object, but no custom template was provided (optionTemplate)");
                renderedOptTpl =  this.optionTemplate({ option: JSON.stringify(option) });
            } else if (typeof option === 'boolean') {
                renderedOptTpl =  this.optionTemplate({ option: _.capitalize(option + '') });
            } else {
                renderedOptTpl =  this.optionTemplate({ option: ((_.isNull(option) || _.isUndefined(option)) ? '' : option) + '' });
            }

            return renderedOptTpl;
        },

        _renderSelectedValue: function() {
            var selectedValue = this.model.get('value');
            var valueText = this.placeholder; // default

            if (!_.isEmpty(selectedValue) || _.isBoolean(selectedValue) || _.isNumber(selectedValue)) {
                valueText = this._getOptionItemMarkup(selectedValue);
            }

            this.$('.ld-dropdown-value').html(valueText);
            this.$('.ld-dropdown-value').prop('title', $('<div>').html(valueText).text()); // extract only text if it's html
            this.validate();
        },

        _renderSelectList: function() {
            var optionList = '';
            this.$('.dropdown-menu .ld-dropdown-option-list-item').remove();
            var preferredIndexToModelIndex = {};
            var preferredOptions = this.model.get('preferredOptions');
            var hidePreferredOptions = this.model.get('hidePreferredOptions');
            
            var createListItemHtml = (function(option, index, isPreferredList) {
                var isPreferredOption = preferredOptions.includes(option);
                var listItem = _.template(listItemTemplate)({
                    renderedOptionTemplate:  this._getOptionItemMarkup(option),
                    modelIndex: index,
                    selected: option === this.model.get('value') ? 'selected' : '',
                    hiddenClass: (hidePreferredOptions && isPreferredOption && !isPreferredList) ? 'hidden' : ''
                });
                
                return listItem;
            }).bind(this);
            
            // assemble a big HTML string and render using $.html() at the end to improve performance
            var preferredIndex = 0;
            _.each(this.model.get('options'), function(option, modelIndex) {
                optionList += createListItemHtml(option, modelIndex, false);
                if (option == preferredOptions[preferredIndex]) {
                    preferredIndexToModelIndex[preferredIndex] = modelIndex;
                    preferredIndex++;
                }
            }, this);
           
            var preferredItems = '' 
            _.each(preferredOptions, function(option, preferredIndex) {
                preferredItems += createListItemHtml(option, preferredIndexToModelIndex[preferredIndex], true); 
            });
           
            if (!_.isEmpty(preferredItems)) {
                optionList = preferredItems + '<li class="separator preferred-section-separator" style="border-bottom: 1px solid #CCC;"></li>' + optionList;
            } 
            
            this.$('.dropdown-menu').append(optionList);
                        
            var separatorIndex = this.$('.preferred-section-separator').index();
            if (separatorIndex > -1) {
                this.$('.dropdown-menu li').slice(0, separatorIndex).each(function() {
                    if ($(this).hasClass('ld-dropdown-option-list-item')) {
                        $(this).toggleClass('is-preferred-option', true);      
                    }
                });
            }
        },

        _searchInputChanged: _.debounce(function(e) {
            var keywords = $(e.currentTarget).val();
            if (!keywords) {
                this.$('.ld-dropdown-option-list-item').show();
            } else {
                this._search(keywords);
            }
        }, 300),
        
        _search:function(keywords) {
            this.bloodhound.search(keywords, this._filterByItems.bind(this));
        },
        
        _filterByItems: function(itemsToShow) {
            var options = this.model.get('options');
            if (itemsToShow.length === options.length) {
                this.$('.dropdown-menu .ld-dropdown-option-list-item').show();
                return;
            }
            
            this.$('.dropdown-menu .ld-dropdown-option-list-item').hide();
            _.each(itemsToShow, function(item) {
                var modelIndex = options.indexOf(item);
                this.$('.dropdown-menu .ld-dropdown-option-list-item:not(.is-preferred-option)').eq(modelIndex).show();
            }, this);
        }
    });

    return view;
};

module.exports = LDDropdown;

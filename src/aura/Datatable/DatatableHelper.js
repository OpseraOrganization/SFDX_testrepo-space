({
    selectedRows : [],
    timeout: null,
    filter: function (component, data, searchText) {
        var rowsLoaded = parseInt(component.get('v.rowsLoaded')), helper = this;
        if(data != null && data.length > 0) {
            let column = component.get("v.sortedBy");
            if(column) {
                data = data.sort(helper.sortBy(
                    column.typeAttributes && column.typeAttributes.label ? column.typeAttributes.label.fieldName : column.fieldName,
                    component.get("v.sortedDirection") !== 'asc'
                ));                
            }
            helper.filterData(component, data, searchText, (result) => {
                component.set('v.visibleData', component.get('v.type') !== 'extended' && result.length > rowsLoaded ? result.slice(0, rowsLoaded) : result);
            	component.set('v.filteredData', result);
            	component.set('v.infiniteLoading', component.get('v.type') !== 'extended' && result.length > rowsLoaded);
        		helper.updateMetaText(component);
            });
        } else {
            component.set('v.filteredData', []);
            component.set('v.visibleData', []);
            component.set('v.infiniteLoading', false);
            helper.updateMetaText(component);
        }
    },
    filterData: function (component, data, searchText, callback) {
        let columns = component.get('v.columns'),
            filters = component.get('v.filters'),
            caseSensitive = component.get('v.caseSensitive');
        return callback(data.filter(cur => {
            let searchFound = false,
                searchFilter = false,
                activeSearch = false,
                activeFilter = false;
            if (searchText && searchText !== '' && !component.get('v.disableSearch')) {
                searchText = caseSensitive ? searchText : searchText.toLowerCase();
                activeSearch = true;
                for (let i = 0; i < columns.length; i++) {
                    if (columns[i].searchable) {
                        let fieldName = columns[i].typeAttributes && columns[i].typeAttributes.label ? columns[i].typeAttributes.label.fieldName : columns[i].fieldName,
                            value = (cur[fieldName] != null && cur[fieldName] != '') ? (caseSensitive ? ('' + cur[fieldName]) : ('' + cur[fieldName]).toLowerCase()) : null;
                        if (value != null && value.indexOf(searchText) != -1) {
                            searchFound = true;
                            break;
                        }
                    }
                }
            }
            if (!component.get('v.disableFilter')) {
                for (let i = 0; i < filters.length; i++) {
                    if (filters[i].active) {
                        activeFilter = true;
                        let curFieldName = caseSensitive ? (cur[filters[i].fieldName] + '') : (cur[filters[i].fieldName] + '').toLowerCase(),
                            value = caseSensitive ? (filters[i].value + '') : (filters[i].value + '').toLowerCase();
                        if (curFieldName) {
                            switch (filters[i].condition) {
                                case 'equals':
                                    searchFilter = (value === curFieldName);
                                    break;
                                case 'not equal to':
                                    searchFilter = !(value === curFieldName);
                                    break;
                                case 'less than':
                                    searchFilter = (value < curFieldName);
                                    break;
                                case 'greater than':
                                    searchFilter = (value > curFieldName);
                                    break;
                                case 'less or equal':
                                    searchFilter = (value <= curFieldName);
                                    break;
                                case 'greater or equal':
                                    searchFilter = (value >= curFieldName);
                                    break;
                                case 'contains':
                                    searchFilter = (curFieldName.indexOf(value) != -1);
                                    break;
                                case 'does not contain':
                                    searchFilter = (curFieldName.indexOf(value) == -1);
                                    break;
                                case 'starts with':
                                    searchFilter = (curFieldName.indexOf(value) == 0);
                                    break;
                                case 'ends with':
                                    searchFilter = (curFieldName.indexOf(value) == (curFieldName.length) - value.length);
                                    break;
                            }
                        }
                    }
                }
            }
            return (!activeSearch || searchFound) && (!activeFilter || searchFilter);
        }));
    },
    updateMetaText : function(component) {
    	const data = component.get('v.filteredData');
    	const sortedBy = component.get('v.sortedBy');
    	const filters = component.get('v.filters');
    	//
        let metaText = `${data.length} item${data.length != 1 ? 's' : ''}`;
        metaText += sortedBy ? (' • Sorted by ' + sortedBy.label) : '';
    	//
    	let filterText = [];
        for(let i = 0, len = filters.length; i < len; i++) {
            const filter = filters[i];
            if(filter.active) {
                const value = filter.value ? filter.value : 'empty'; 
                switch (filter.condition) {
                    case 'equals':
                        filterText = [...filterText, `${filter.label} ${value}`];
                        break;
                    case 'not equal to':
                        filterText = [...filterText, `${filter.label} not ${value}`];
                        break;
                    case 'less than':
                        filterText = [...filterText, `${filter.label} < ${value}`];
                        break;
                    case 'greater than':
                        filterText = [...filterText, `${filter.label} > ${value}`];
                        break;
                    case 'less or equal':
                        filterText = [...filterText, `${filter.label} <= ${value}`];
                        break;
                    case 'greater or equal':
                        filterText = [...filterText, `${filter.label} >= ${value}`];
                        break;
                    case 'contains':
                        filterText = [...filterText, `${filter.label} containing ${value}`];
                        break;
                    case 'does not contain':
                        filterText = [...filterText, `${filter.label} not containing ${value}`];
                        break;
                    case 'starts with':
                        filterText = [...filterText, `${filter.label} starting with ${value}`];
                        break;
                    case 'ends with':
                        filterText = [...filterText, `${filter.label} ending with ${value}`];
                        break;
                }
            }
        }
    	metaText += filterText.length > 0 ? (' • Filtered by ' + filterText.join(' - ')) : '';
        component.set('v.metaText', metaText);
    },
	filterGlobalActions : function(component, globalActions) {
        const len = globalActions.length;
        if(len > 0) {
            let groupActions = [], menuActions = [];
            for(let i = 0; i < len; i++) {
                if(globalActions[i].type == 'dropdown' || globalActions[i].type == 'menu') {
                    menuActions = [...menuActions, globalActions[i]];
                }
                else {
                    groupActions = [...groupActions, globalActions[i]];
                }
            }
        	component.set('v.groupActions', groupActions);
        	component.set('v.menuActions', menuActions);
        }
	},
	sort : function(component, column, sortDirection) {
        if(!column) { return null; }
        component.set("v.data", component.get("v.data").sort(this.sortBy(
            column.typeAttributes && column.typeAttributes.label ? column.typeAttributes.label.fieldName : column.fieldName,
            sortDirection !== 'asc'
        )));
	},
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    }
})
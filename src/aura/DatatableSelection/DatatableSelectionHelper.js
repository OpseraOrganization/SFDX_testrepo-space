({
	filter : function(component, data, searchText) {
        if(data != null && data.length > 0) {            
            let columns 	  = component.get('v.columns'),
                filters 	  = component.get('v.filters'),
                caseSensitive = component.get('v.caseSensitive');
            component.set('v.filteredData', data.filter(cur => {
                let searchFound = false, searchFilter = false, activeSearch = false, activeFilter = false;
                if(searchText && searchText !== '' && !component.get('v.disableSearch')) {
                	searchText = caseSensitive?searchText:searchText.toLowerCase();
                    activeSearch = true;
                    for(let i = 0; i < columns.length; i++) {
                        if (columns[i].searchable) {
                            let fieldName = columns[i].typeAttributes && columns[i].typeAttributes.label?columns[i].typeAttributes.label.fieldName:columns[i].fieldName,
                                value = (cur[fieldName] != null && cur[fieldName] != '')?(caseSensitive?(''+cur[fieldName]):(''+cur[fieldName]).toLowerCase()):null;
                			if (value != null && value.indexOf(searchText) != -1) {
                                searchFound = true;
                                break;
                            }
                        }
                    }
                }
                if(!component.get('v.disableFilter')) {
                    for(let i = 0; i < filters.length; i++) {
                        if(filters[i].active) {
                            activeFilter = true;
                            let curFieldName = caseSensitive?(cur[filters[i].fieldName]+''):(cur[filters[i].fieldName]+'').toLowerCase(),
                                value = caseSensitive?(filters[i].value+''):(filters[i].value+'').toLowerCase();
                            if(curFieldName) {
                                switch(filters[i].condition) {
                                    case 'equals': searchFilter = (value === curFieldName); break;
                                    case 'not equal to': searchFilter = !(value === curFieldName); break;
                                    case 'less than': searchFilter = (value < curFieldName); break;
                                    case 'greater than': searchFilter = (value > curFieldName); break;
                                    case 'less or equal': searchFilter = (value <= curFieldName); break;
                                    case 'greater or equal': searchFilter = (value >= curFieldName); break;
                                    case 'contains': searchFilter = (curFieldName.indexOf(value) != -1); break;
                                    case 'does not contain': searchFilter = (curFieldName.indexOf(value) == -1); break;
                                    case 'starts with': searchFilter = (curFieldName.indexOf(value) == 0); break;
                                    case 'ends with': searchFilter = (curFieldName.indexOf(value) == (curFieldName.length) - value.length); break;
                                }                                
                            }	
                        }
                    }   
                }                     
                return (!activeSearch || searchFound) && (!activeFilter || searchFilter);
            }));
        } else component.set('v.filteredData', []);
	},
	sort : function(component, column, sortDirection) {
        var data = component.get("v.data"),
            reverse = sortDirection !== 'asc';
        if(column.typeAttributes && column.typeAttributes.label){
        	data.sort(this.sortBy(column.typeAttributes.label.fieldName, reverse));
        } else {
        	data.sort(this.sortBy(column.fieldName, reverse));
        }
        component.set("v.data", data);
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
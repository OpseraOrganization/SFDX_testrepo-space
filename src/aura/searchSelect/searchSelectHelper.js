({
	filter : function(component, searchText, options) {
		component.set('v.filteredOptions', options.filter(cur => {
            if(searchText && searchText != '') return cur.label.toLowerCase().indexOf(searchText.toLowerCase()) != -1;
            else return true;
        }));
	},
	preSelect : function(component, value, options) {
        if(value && value != '') {
            for(let i = 0; i < options.length; i++) {
                if(options[i].value === value) {
                    component.find('search').set('v.value', options[i].label);
                    component.set('v.selected', options[i].label);
                    break;
                }
            }            
        }
	}
})
({
	doInit : function(component, event, helper) {
        const viewType = component.get('v.type');
        component.set('v.focusData', []);
        component.set('v.productData', []);
        var tableStructure = (component.get('v.tableColumns').length != 0?component.get('v.tableColumns'):[
            {label: 'Name', fieldName: 'Name', sortable: 'true', searchable: 'true', type: 'String'},
            {label: 'Description', fieldName: 'Description', sortable: 'true', searchable: 'true', type: 'String'}
        ]);
        component.set('v.tableColumns', tableStructure);
        //
       	var predefinedFields = component.get('v.predefinedFields');
        for(let target in predefinedFields) {
            if(target !== 'country') {
                let targetName = target.replace(/([A-Z])/g, ' $1').trim();
                targetName = targetName.charAt(0).toUpperCase() + targetName.slice(1);
                targetName = targetName.replace('Sw', 'SW');
                targetName = targetName.replace('Hw', 'HW');
                helper.select(component, { Id: target, Name: targetName}, predefinedFields[target], false, predefinedFields[target]?predefinedFields[target].Name:'', true);
            }
            else helper.emit(component, 'select', {target: 'Country', object : predefinedFields[target] == ''? null : predefinedFields[target]});
        }
        if(predefinedFields['product']) {
            helper.searchProduct(component, predefinedFields['product'].Name);
        }
        component.set('v.inFocus', viewType === 'ExtendedOnly' || component.find('product').get("v.disabled")?'':{ Id: 'product', Name: 'Product'});
	},
	changeTable : function(component, event, helper) {
        let element = event.getSource();
        if(element.get("v.disabled") == false) {
            var inFocus = { Id: element.get("v.name"), Name: element.get("v.label")};
            component.set('v.inFocus', inFocus);
            if(inFocus.Id === 'product'){
                component.set("v.focusData", component.get('v.productData'));
                let product = component.get('v.product');
                if(helper.valid(product)) {
                    component.find("productTable").setSelectedRows(new Array(product.Id));
                    component.set('v.productDescription', component.get('v.showDescription') && product.Description?product.Description:'');
                }
            }
            else helper.searchProductRelated(component, inFocus);
    	}
    },
    handleSearch: function(component, event, helper) {
        var target = component.get('v.inFocus'), searchText = component.find(target.Id).get('v.value');
        if(target.Id === 'product') {
            if(component.get("v.automaticSearch") == false && event.keyCode == 13 ||
            component.get("v.automaticSearch") == true && searchText.length >= 3 ) {
                helper.searchProduct(component, searchText);             
            }
            else if(component.get("v.automaticSearch") == true)
                helper.select(component, target, null);
        }
        else component.set("v.searchText", searchText);
    },
    handleSelection : function(component, event, helper) {
        var target = component.get('v.inFocus');
        if(helper.valid(target)) {
            let selectedRows = event.getParam('selectedRows');
            let clear = event.getParam('action') === 'clearSelection';
            if(selectedRows.length != 0 || clear) helper.select(component, target, selectedRows[0]);
        }
    },
    handleCountrySelection : function(component, event, helper) {
        let country = component.find("country").get("v.value");
        helper.emit(component, 'select', {target: 'Country', object : country == ''? null : country});
    }
})
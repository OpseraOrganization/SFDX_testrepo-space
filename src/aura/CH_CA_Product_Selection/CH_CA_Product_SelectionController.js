({
    // When an element gets focus set the title and preload the values
    onFocus : function(component, event, helper){
        var productType = event.getSource().get("v.id");
        component.set('v.productType', productType);
        var searchValue = component.find(productType).get("v.value");
        // Preload the values
        helper.searchProductType(component, productType, searchValue);

        var selectedRowId = component.get("v." + productType + "Id");
        if (selectedRowId != null){
            var rows = new Array();
            rows[0] = selectedRowId;
            component.set("v.setSelectedRow", selectedRowId);
        }
    },
    // When the product field changes and the enter key is pressed, 
    // search for products according to the search criteria
    // This works different than the other fields as there are too many products
    onProductChange : function(component, event, helper){
        var searchValue = component.find("product").get("v.value");
        if (searchValue.length > 0) {
            // If enter is pressed
        	if (event.which == 13){
            	helper.searchProductType(component, "product", searchValue);
            }
        }
    },
    // When the product name is made blank, empty the selected value
    onProductChange2 : function(component, event, helper){
        var searchValue = component.find("product").get("v.value");
        if (searchValue.length == 0) {
        	component.set("v.productId", null); 
            component.set("v.productReleaseId", null);
            component.find("productRelease").set("v.value","");
            component.set("v.productVariantId", null);
            component.find("productVariant").set("v.value","");
            component.set("v.productModuleId", null); 
            component.find("productModule").set("v.value","");
            helper.searchProductType(component, "product", searchValue);
        }
    },
    // When a field get's focus, all values are retrieved
	// When the field value changes, the list with all values is 
	// filter. The product field has different methods   
    onChange : function(component, event, helper){
        var productType = component.get("v.productType");
        var rows = component.get('v.tableRows');
        var searchValue = component.find(productType).get("v.value");
        if (searchValue.length > 0) {
        	var regex = new RegExp(searchValue, "i");
        	var filteredRows = rows.filter(row => regex.test(row.Name));
        	component.set('v.filteredtableRows', filteredRows);
        }
        else {
            component.set('v.filteredtableRows', rows);
        	component.set("v." + productType + "Id", null);    
        }
    },
    // When an item is selected, save the Id
    select: function(component, event, helper) {
        var productType = component.get("v.productType");
        var selectedTableRow = event.getParam('selectedRows')[0]
        if(selectedTableRow){
        	component.set("v." + productType + "Id", selectedTableRow.Id);
			component.find(productType).set("v.value", selectedTableRow.Name);
        } 
    },    
})
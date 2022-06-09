({
    // When a field gets focus, the values are searched and displayed
    searchProductType: function(component, productType, searchValue) {
        component.set("v.Spinner", true);
        const sharedjs = component.find("sharedJavaScript");
        
        var productId = component.get("v.productId");
        var solutionId = component.get("v.solutionId");

        sharedjs.apex(component,'searchProductRelated',{productType: productType, searchValue: searchValue, 
                                                        solutionId: solutionId, productId: productId, 
                                                        prodRelease: null})
        .then(function(response){
            component.set('v.tableRows', response);
            component.set('v.filteredtableRows', response);
            component.set("v.Spinner", false);
            // If a item was selected, make it selected
            var selectedRowId = component.get("v." + productType + "Id");
            component.set("v.setSelectedRow", selectedRowId);
        });        
    },
})
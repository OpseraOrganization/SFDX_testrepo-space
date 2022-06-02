({
    Search: function(component, event, helper) {
        var searchField = component.find('searchField');
        var isValueMissing = searchField.get('v.validity').valueMissing;
        if(isValueMissing) {
            searchField.showHelpMessageIfInvalid();
        }else{
            helper.SearchHelper(component, event);
        }
    },
    AddProduct: function(component, event, helper) {
        component.set("v.addnewproduct", true);
        component.set("v.showModal", true);
        component.set("v.showAdd", true);
        component.set("v.ShowParentModal", false);
    },
    
    AddToCart: function(component, event, helper) {
        var inventoryName = event.target.getElementsByClassName('prod-id')[0].value;
        component.set("v.EditProductId", inventoryName);
        component.set("v.showModal", true);
        component.set("v.showAdd", false);
        component.set("v.ShowParentModal", false);
    },
    
    eventvalueset: function(component, event, helper) {
        var ShowMessage = event.getParam("ShowMessage"); 
        var ShowParentModal = event.getParam("ShowParentModal"); 
        
        component.set("v.Message", ShowMessage);
        component.set("v.ShowParentModal", ShowParentModal);
        
        if(ShowMessage)
        {
            helper.RedirectTocart(component, event, helper);
        }
        
    },
    RedirectTocart: function(component, event, helper) {
        helper.RedirectTocart(component, event, helper);
        
    },
    
    BulkUpload: function(component, event, helper) {
    	helper.RedirectToVF(component, event, helper);
		
    },
    
    
    
})
({
    
     doInit: function(component, event, helper) {
        
      var caseRecordId = component.get("v.selectedRecordForFlow");	
         var action = component.get("c.getProductFromCase");
        // set param to method  
        action.setParams({
            'caseId':  caseRecordId
                    
        });
        // set a callBack    
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse.length != 0) {
                    component.set('v.productName', storeResponse.Product.Name);
                    component.set('v.productId', storeResponse.productId);
                }
                }
             });
        // enqueue the Action  
        $A.enqueueAction(action);
        
        
    },
    handleComponentEvent : function(component, event, helper){ 
        
        var showSection = event.getParam("showSection")
        
        if(showSection == 1){
            var objectId = event.getParam("selectedProductId");
            component.set("v.productName", objectId);
            
            //   var prodList =[];
            //   prodList.push(event.getParam("selectedProductId"));
            //  component.set("v.prodList", prodList);
            //     alert(prodList);
            //    alert(JSON.stringify(prodList));
            //alert('prasuna'+objectId);
        }
        
        
        if(showSection == 2){
            var unitName = event.getParam("SelectedUnitId");
            component.set("v.ODRUnits", unitName);
        } 
        
        
        
        if(showSection == 3){
            
            var picklistUnitName = event.getParam("PicklistUnitId");
            component.set("v.picklistODRUnits", picklistUnitName);
        } 
        
    },
    
    Show:function(component, event, helper){
        component.set("v.testValue", true);
    },
    
    Save:function(component,event,helper){
        
        helper.searchHelper(component,event);
        
    },
    refresh : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
    
})
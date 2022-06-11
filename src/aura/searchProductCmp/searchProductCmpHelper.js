({
    SearchHelper: function(component, event) {
        component.find("Id_spinner").set("v.class" , 'slds-show');
        var action = component.get("c.fetchProduct");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            'ProductConfigId' : component.get("v.ProductConfigId")
        });
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                if (storeResponse.length == 0) {
                    component.set("v.RecordDisplayMessage", "No Record Found"); 
                } else {
                    component.set("v.RecordDisplayMessage", ""); 
                }
                component.set("v.searchResult", storeResponse); 
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    RedirectTocart: function(component, event, helper) {
        //For SP20 added additional operation (Constraint rules api call) and redirect to pricing page
        var action = component.get("c.executeAdditionalOperation");
        action.setParams({
            'productConfigId' : component.get("v.ProductConfigId")
        });
        action.setCallback(this, function(response) {
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                var vars = {};
                var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                    vars[key] = value;
                });
         
               	var vURL = "https://"+$A.get("$Label.c.CartURL")+"/apex/Cart?configRequestId="+ vars["configRequestId"]+"&cartStatus=New&id="+vars["id"]+"&flow=";
                
                window.location = vURL;
               
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    RedirectToVF: function(component, event, helper) {
        component.set("v.showModal2", true);
        component.set("v.ShowParentModal", false);

    }
    
})
({
    accessCheck : function(component,event,helper) {
    var userId = $A.get("$SObjectType.CurrentUser.Id");
    var action = component.get("c.accessToOBM");
        action.setParams({ "userId" : userId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(response.getState()==="SUCCESS")
            {
                component.set("v.accessExist", response.getReturnValue()); 
                if(response.getReturnValue()==='SYSADMIN'){
                   // component.find("createButton").set("v.disabled", true);
                   // component.find("createButton").set("v.disabled", false);
                     
                }
                else
                {
                   // var cmpTarget = component.find("createButton");
       				//	 $A.util.addClass(cmpTarget, 'slds-hidden');
                   // component.find("createButton").set("v.disabled", false);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
	fetchData : function(component,event,helper) { 
        console.log('No Error1');
		var action = component.get("c.getOMSList");
        var namesList;
       // action.setParams({ });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('No Error'+state);
            if (state === "SUCCESS") {
                console.log('No Error');
                component.set("v.data", response.getReturnValue());   
            }
            else
            {
             	console.log('Some Error'+state);   
            }
        });
        $A.enqueueAction(action);
    },
    deleteSetting : function (component, row ) {
       
       var toastEvent = $A.get("e.force:showToast");
    			toastEvent.setParams({
       				 "title": "Success!",
       					 "message": "The record has been deleted successfully."
   					 });
    				toastEvent.fire();
        var action = component.get("c.deleteOMS");
        action.setParams({ omName : row });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                this.fetchData(component,event,helper);
                component.set('v.isEditPage',false);
                component.set('v.isEditPage',true);
            }
        });
        $A.enqueueAction(action);
    },
    showSuccess: function (cmp) {
        cmp.set("v.success", true);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.success", false);
            }), 2000
        );
        cmp.set('v.isEditPage',true);
        cmp.set('v.isDetailPage',false);
    },
    showError: function (cmp, message) {
        cmp.set("v.error", true);
        cmp.set("v.errorMessage", message);
        window.setTimeout(
            $A.getCallback(function() {
                cmp.set("v.true", false);
            }), 2000
        );
    },
     handleConfirmDialog : function(component, event, helper) {
      
        component.set('v.showConfirmDialog', true);
    }
})
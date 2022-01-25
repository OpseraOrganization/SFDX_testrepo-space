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
            }
        });
        $A.enqueueAction(action);
    },
	fetchData : function(component,event,helper) {      
		var action = component.get("c.getOMSList");
        var namesList;
        action.setParams({ });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.data", response.getReturnValue());   
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
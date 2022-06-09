({
    doInit : function(component, event, helper) {
        var action=component.get("c.getPartnerUserType");
        component.set("v.selectedLstView", "PS_MyPartnerSupportTickets");
        action.setCallback(this, function(resp){
            var state = resp.getState();
            if(state === 'SUCCESS'){
                var retVal = resp.getReturnValue();
                console.log('isPartner:'+ JSON.stringify(retVal));
                component.set("v.isPartner", retVal);
                if(!retVal){
                    var action1=component.get("c.getAllAvailableListViews");
                    action1.setCallback(this, function(resp){
                        var state = resp.getState();
                        if(state === 'SUCCESS'){
                            var retVal = resp.getReturnValue();
                            var lstViews = [];
                            console.log('val'+JSON.stringify(retVal))
                            retVal.forEach(function(item, index){
                                console.log(item);
                                lstViews.push({'label':item.Name, 'value':item.DeveloperName});
                            });
                            console.log('lstViews:'+ JSON.stringify(lstViews));
                            component.set("v.lstViews", lstViews);
                            component.set("v.selectedLstView", lstViews[0].value);
                        }
                    });
                    
                    $A.enqueueAction(action1);
                }
                
            }
        });
        
        $A.enqueueAction(action);
        
        
        
        
    },
    
    handleChange : function(component, event, helper){
        component.set("v.isVisible", false);
        component.set("v.isVisible", true);
    },
    
    refreshView : function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    }
})
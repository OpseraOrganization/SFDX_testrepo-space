({
    doInit : function(component, event, helper){
        var actionstatusDetails = component.get("c.getStatusDeatils");
        actionstatusDetails.setParams({
            "currentRecordId":component.get("v.recordId")
        });  
        actionstatusDetails.setCallback(this, function(response) {
            component.set("v.relatedData",response.getReturnValue());
            /*if(response.getReturnValue().Analytics_Source__c == 'CCRE')
            {
                component.set("v.docFlag",2);
                
            }
            else 
            { */
                component.set("v.docFlag",1);
                
           // }
            
            
        });
        $A.enqueueAction(actionstatusDetails);
        
        helper.getAllProposal(component);
        helper.getAllProposal1(component);
        helper.getServiceInfoItems(component);
        
        
        
    },
    OpenPage1: function(component, event, helper) {
        
        var Id = event.getSource().get("v.name");
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/proposal-line-item/"+Id,
        });
        urlEvent.fire();
    },
    OpenPage :function(component, event, helper)
    {
        var Title= event.getSource().get("v.name");
        var QuoteId= component.get("v.QuoteID");
        var LineId= event.getSource().get("v.value");
        var action = component.get("c.getDocumentIdforLine");
        
        action.setParams({
            "QuoteLineID": LineId,
            "Title":Title
        });
        action.setCallback(this, function(a){
            var ID=a.getReturnValue();
            
            $A.get('e.lightning:openFiles').fire({
                recordIds: [ID]
            });
            // alert(a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    handleComponentEvent : function(cmp, event) {
        var message = event.getParam("packageList");
        var message1 = event.getParam("ShowPackage");
        var message2 = event.getParam("level1Info");
        
        // set the handler attributes based on event data
        cmp.set("v.packageListFromEvent", message);
        cmp.set("v.ShowPackageFromEvent", message1);
        cmp.set("v.level1FromEvent", message2);
        
        
    },
    closeModal : function(component, event, helper){
        component.set("v.ShowPackageFromEvent" ,false);
    }
    
    
})
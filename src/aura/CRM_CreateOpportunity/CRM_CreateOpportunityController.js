({
    init : function(cmp, evt, helper)
    {
        cmp.set("v.accountId",cmp.get("v.recordId"));
        var action = cmp.get("c.canCreate");
        action.setCallback(this, function(response) 
                           {
                               cmp.set("v.loading",false);
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   var canCreate = response.getReturnValue();
                                   if(!canCreate)
                                   {
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Access Denied.",
                                           "message": "User profile does not have the rights to create an Opportunity."
                                       });
                                       toastEvent.fire();
                                       $A.get("e.force:closeQuickAction").fire();
                                   }
                               }
                           })
        $A.enqueueAction(action);
        cmp.set("v.loading",true);
    },
   	
    next: function(cmp, evt, helper)
    {
        console.log(cmp.get("v.oppTypeSelected"));
        cmp.set("v.errorMsg", "");//clean error banner
        helper.evaluateActions(cmp,evt, helper);
    },
    
    back: function(cmp, evt, helper)
    {
        console.log(cmp.get("v.oppTypeSelected"));
        cmp.set("v.errorMsg", "");//clean error banner
		cmp.set("v.navStep",cmp.get("v.navStep")-1);        
    },
    
    save: function(cmp, evt, helper)
    {
        cmp.set("v.errorMsg", "");//clean error banner
        if(helper.validateFields(cmp,evt, helper))
        {
        	helper.evaluateActions(cmp,evt, helper);  
        }
    },
    
    cancel: function(cmp, evt, helper)
    {
        $A.get("e.force:closeQuickAction").fire();
    },
    
    goToOpp: function(cmp, evt, helper)
    {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": cmp.get("v.fastTrackOppId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    },
 	/*
    addOIFLine: function(cmp, evt, helper)
    {
        var oifList = cmp.get("v.oifLineList");
        var oif = cmp.get("v.oifLine");
        var newOIF = {RecordTypeId:oif.RecordTypeId, BusinessLine__c:null, OIF_Value__c:null, Forecast_Category__c:null, POPlanReceipt__c:null,Rev_RecPlan_Receipt__c:null};
        oifList.push(newOIF);
        cmp.set("v.oifLineList",oifList);
    },
    
    deleteOIFLine: function(cmp, evt, helper)
    {
        var index;
        if(typeof evt.getParam("value") != 'undefined'  )
        {
            index = evt.getParam("value"); //for lightning:menuItem
        }
        else
        {
           index = evt.getSource().get("v.value"); //for lightning:buttonIcon
        }
        var oifList = cmp.get("v.oifLineList");
        oifList.splice(index, 1);
        cmp.set("v.oifLineList",oifList);
    },
    */
})
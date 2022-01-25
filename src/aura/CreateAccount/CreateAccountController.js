({
    doInit : function(component, event, helper){
        var WaitMsg = component.find("waiting");  
        $A.util.addClass(WaitMsg,'slds-hide');                            
        $A.util.removeClass(WaitMsg,'slds-show');
        var leadData = component.get("c.getLeadData");
        var recordId = component.get("v.recordId");
        var WaitMsg = component.find("waiting");  
        $A.util.addClass(WaitMsg,'slds-hide');                            
        $A.util.removeClass(WaitMsg,'slds-show');
        var sucessBody = component.find("sucessBody");  
        $A.util.addClass(sucessBody,'slds-hide');                            
        $A.util.removeClass(sucessBody,'slds-show');
        leadData.setParams({
            "leadId": recordId
        });
        leadData.setCallback(this, function(a) {
            component.set("v.accName",a.getReturnValue()[0]);
            component.set("v.street",a.getReturnValue()[2]);
            component.set("v.postalCode",a.getReturnValue()[4]);
            component.set("v.city",a.getReturnValue()[3]);
            component.set("v.country",a.getReturnValue()[6]);
            //component.find("sector").set("v.value",a.getReturnValue()[1]);
            var address = a.getReturnValue()[2] + "\n" + a.getReturnValue()[4] + " " + a.getReturnValue()[3]+ "\n" + a.getReturnValue()[6];
            //component.find("market").set("v.value",a.getReturnValue()[5]);
            component.set("v.optMarket",a.getReturnValue()[5]);
            component.set("v.optAddress",address);
        });
        $A.enqueueAction(leadData);
        
        var cusCompliance = component.get("c.getCustomerCompliance");
        cusCompliance.setCallback(this, function(a) {
            component.set("v.optCompliance",a.getReturnValue());
        });
        $A.enqueueAction(cusCompliance);
        helper.loadPicklistData(component, event, helper);
        //var marketSeg = component.get("c.getMarketSegment");
        var marketSeg = component.get("c.getMarketSegmentMdt");
        marketSeg.setCallback(this, function(a) {
            component.set("v.optSegments",a.getReturnValue());
        });
        $A.enqueueAction(marketSeg);
        var cusCompliance = component.get("c.getCustomerCompliance");
        cusCompliance.setCallback(this, function(a) {
            component.set("v.optCompliance",a.getReturnValue());
        });
        $A.enqueueAction(cusCompliance);
        /*var market = component.get("c.getMarket");
        market.setCallback(this, function(a) {
            component.set("v.optMarket",a.getReturnValue());
        });
        $A.enqueueAction(market);*/
    },
 	handleRecordUpdated: function(component, event, helper) {
     
 	},
    handleSave : function(component, event, helper)
    {
        var isName = true;
        if(component.find("name").get("v.value") == '') {
            component.find("name").showHelpMessageIfInvalid();
            isName = false;
        }
        var isCustomer = true;
        if(component.find("customer").get("v.value") == '') {
            component.find("customer").showHelpMessageIfInvalid();
            isCustomer = false;
        }
        var isWebsite = true;
        if(component.find("web").get("v.value") == '') {
            component.find("web").showHelpMessageIfInvalid();
            isWebsite = false;
        }
        var isSegmet = true;
        if(component.find("segment").get("v.value") == '') {
            component.find("segment").showHelpMessageIfInvalid();
            isSegmet = false;
        }
        if(isSegmet == true && isCustomer == true && isName == true && isWebsite == true) {
            helper.save(component, event, helper);
        }
      
        
    },
    getActivitySector : function(component, event, helper)
    {
        var optsactivity=[];
        var segment = component.find("segment").get("v.value");
        var activitySector = component.get("c.getActivitySectorValues");
        activitySector.setParams({
            "marketSegment" : segment
        });
        activitySector.setCallback(this, function(a) {
            for(var i=0;i< a.getReturnValue().length;i++){                
                optsactivity.push(a.getReturnValue()[i]);
            }	
            component.set("v.optActivity",optsactivity);
            
        });
        $A.enqueueAction(activitySector);
    },
    cancel : function(component, event, helper)
    {
        $A.get("e.force:closeQuickAction").fire();
    },
    
   

})
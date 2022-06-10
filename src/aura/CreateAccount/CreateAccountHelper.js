({
    loadPicklistData : function(component, event, helper){
        var actionGetPicklist = component.get("c.GetPicklistDateFromAccount");
        actionGetPicklist.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               component.set("v.pickListDate",response.getReturnValue())
               //alert(response.getReturnValue())
            }
         });
         $A.enqueueAction(actionGetPicklist); 
    },
    
    save : function(component, event, helper) {
        //var accName = component.find("name").get("v.value");
        //var website = component.find("website").get("v.value");
        //var marketSegment = component.find("segment").get("v.value");
        //var customerCompliance = component.find("compliance").get("v.value");
        //var businessRole = component.find("role").get("v.value");
        var WaitMsg = component.find("waiting");
        $A.util.removeClass(WaitMsg,'slds-hide');                            
        $A.util.addClass(WaitMsg,'slds-show');
        component.set("v.ErrMessage",'');
        //var accName = NameFieldValues[0].value;
        var accName = component.find("name").get("v.value");
        //var website = NameFieldValues[1].value;
        var website = component.find("web").get("v.value");
        var marketSegment = component.find("segment").get("v.value");;
        //var customerCompliance = NameFieldValues[2].value;
        var customerCompliance = component.find("customer").get("v.value");
        var businessRole = component.find("role").get("v.value");
        var ASN = component.find("ActivitySector").get("v.value");
        var market = component.find("market").get("v.value");
        var street = component.get("v.street");
        var postalCode = component.get("v.postalCode");
        var city = component.get("v.city");
        var country = component.get("v.country");
        var details = [accName,website,marketSegment,customerCompliance,businessRole,market,street,postalCode,city,country,ASN];
        var save = component.get("c.saveAccount");
        save.setParams({
            "details": JSON.stringify(details)
        });
        save.setCallback(this, function(response) {
            var waiting = component.find("waiting");
            $A.util.addClass(waiting,'slds-hide');                            
            $A.util.removeClass(waiting,'slds-show');
            if(response.getReturnValue() == 'sucesss') {
                var success = component.find("sucessBody");
                $A.util.removeClass(success,'slds-hide');                            
                $A.util.addClass(success,'slds-show');
                var creation = component.find("creationBody");
                $A.util.addClass(creation,'slds-hide');                            
                $A.util.removeClass(creation,'slds-show');
            }else {
                component.set("v.ErrMessage",response.getReturnValue());
            }
        }); 
        $A.enqueueAction(save);
    }
})
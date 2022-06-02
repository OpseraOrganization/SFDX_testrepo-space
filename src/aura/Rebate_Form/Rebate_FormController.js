({
    doInit : function(component, event, helper) {
  
        
        var madate = component.find('madate');
        $A.util.addClass(madate, 'hide');
        var cmpTarget = component.find('MainLoad');
        $A.util.removeClass(cmpTarget, 'main'); 
        
        
        var alertBox = component.find('alertBox');
        $A.util.addClass(alertBox, 'hide'); 
        var CLoseTab = component.find('CLoseTab');
        $A.util.addClass(CLoseTab, 'hide'); 
        var Success = component.find('Success');
        $A.util.addClass(Success, 'hide'); 
        
        var validUserDetail = component.get("c.checkValidUser");
        validUserDetail.setCallback(this, function(response3) {
            component.set("v.validUser",response3.getReturnValue());
        if(response3.getReturnValue() == 'EndOfEnrollment')
            {
                var errString='Enrollment for this rebate period is closed';
                //component.set("v.errMessage",errString);
                //valueText.set("v.value",errString);
                component.set("v.errMessage",errString);
                var cmpTarget = component.find('MainLoad');
                $A.util.addClass(cmpTarget, 'main'); 
                var alertBox = component.find('alertBox');
                $A.util.addClass(alertBox, 'show'); 
                $A.util.removeClass(alertBox, 'hide'); 
            }
            else if(response3.getReturnValue() == 'ContractExpired')
            {
                var errString='You are not eligible to enroll for this rebate period. For more details, contact your Nokia PSM.';
                component.set("v.errMessage",errString);
                var cmpTarget = component.find('MainLoad');
                $A.util.addClass(cmpTarget, 'main'); 
                var alertBox = component.find('alertBox');
                $A.util.addClass(alertBox, 'show'); 
                $A.util.removeClass(alertBox, 'hide'); 
            }
                else if(response3.getReturnValue() == 'duplicateAccount')
                {
                   var errString='This account has already enrolled for this rebate period. For more details, contact your Nokia PSM.';
                   component.set("v.errMessage",errString);
                    var cmpTarget = component.find('MainLoad');
                    $A.util.addClass(cmpTarget, 'main'); 
                    var alertBox = component.find('alertBox');
                    $A.util.addClass(alertBox, 'show'); 
                   $A.util.removeClass(alertBox, 'hide'); 
                }
            
        });
        $A.enqueueAction(validUserDetail);
        //alert(response5.getReturnValue());
        var actionUserDetails = component.get("c.getUserInstance");
        actionUserDetails.setCallback(this, function(response) {
            component.set("v.UserDetails",response.getReturnValue());
            var address=[];
            address.push(response.getReturnValue().Contact.Account.BillingStreet);
            address.push(response.getReturnValue().Contact.Account.BillingCity);
            address.push(response.getReturnValue().Contact.Account.BillingState);
            address.push(response.getReturnValue().Contact.Account.BillingPostalCode);
            component.set("v.Address",address);
            //alert(address);
        });
        $A.enqueueAction(actionUserDetails); 

        
        var rebatePeriodDetails = component.get("c.getRebatePeriod");
        
        rebatePeriodDetails.setCallback(this, function(response2) {
            if(response2.getReturnValue() != null) {
                component.set("v.periodName",response2.getReturnValue().Name);
                component.set("v.Terms",response2.getReturnValue().Rebate_Terms_and_Conditions__c);
                component.set("v.rebatePeriod",response2.getReturnValue());
                var str=response2.getReturnValue().Technologies__c;
                str = str.split(';')
                var valueArr=[];
                valueArr.push(str);
                component.set("v.rebatePeriod",str);
                
                helper.helperMethod1(component, event, helper,str);
            }
        });
        $A.enqueueAction(rebatePeriodDetails);
      
        
    },
    onload : function(component, event, helper) {
        var Prod1 = component.find("credit").get("v.label");
        helper.helperMethod(component, event, helper);
    },
    onload1 : function(component, event, helper) {
        var abc=component.get("v.RebateName");
        var value=component.find("test").get("v.value");
        
    },
    goToHome : function(component, event, helper)
    {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        urlEvent.fire();
    },
    TandC: function(component, event, helper){
        
        var CLoseTab = component.find('CLoseTab');
        $A.util.addClass(CLoseTab, 'show'); 
        $A.util.removeClass(CLoseTab, 'hide'); 
        var checked = component.find('Agretc').get("v.value");
        if(checked == false)
        {
            var buttonValue= component.find("buttonDisable");
            buttonValue.set("v.disabled",true);
        }
        
        
    },
    onCheck : function(component, event, helper){
        var checked = component.find('Agretc').get("v.value");
        var buttonValue= component.find("buttonDisable");
        if(checked === true)
        {
            buttonValue.set("v.disabled",false);
        }
        else
        {
            buttonValue.set("v.disabled",true); 
        }
        
    },
    closeModal : function(component, event, helper)
    {
      
         var CLoseTab = component.find('CLoseTab');
        $A.util.addClass(CLoseTab, 'hide'); 
          
    }
})
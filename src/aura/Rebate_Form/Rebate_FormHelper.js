({
    helperMethod : function(component, event, helper) {
        
        var Prod1 = '';
        var Prod2 = '';
        var Prod3 = '';
        var Prod4 = '';
        
        var checkedValue=component.find("checkBox");
        if (!Array.isArray(checkedValue)) {
            checkedValue = [checkedValue];
        }
        var optselected=[];
        for(var i=0; i<checkedValue.length; i++)
        {
            if(checkedValue[i].get("v.checked"))
            {
                optselected.push(checkedValue[i].get("v.name"));
            }
            
        }
        
       
        var Period2 = component.find("JulyToDec").get("v.checked");
        //var Period1 = component.find("JanToJuly").get("v.checked");
        var creditComp=component.find("credit");
        var credit = creditComp.get("v.checked");
        if(optselected.length == 0 || credit == false)
        {
             var showToast = $A.get('e.force:showToast');
                showToast.setParams(
                    {
                        'message': 'All fields must be completed before the form can be submitted',
                        'type' : 'error'
                        
                    }
                );
                showToast.fire(); 
            return false;
        }
        else
        {
            //data.set("v.value","");
            var checked = component.find('Agretc').get("v.value");
            if(checked != true){
                var showToast = $A.get('e.force:showToast');
                showToast.setParams(
                    {
                        'message': 'You have to review and accept the terms and conditions before the Rebate Enrollment Form can be submitted',
                        'type' : 'error'
                        
                    }
                );
                showToast.fire(); 
                return false;
            }
        }
        //var cash = component.find("cash").get("v.checked");
        var Period1 = false;
        var period;
        var payment;
        var cash = false;
        if(credit == true){
            payment = component.find("credit").get("v.label");
        }else if(cash==true){
            //payment = component.find("cash").get("v.label");
        }
        period = component.find("JulyToDec").get("v.label");
        
        
        
        var allDetails = [period,payment];
        for(var i=0;i<allDetails.length;i++){
            if(allDetails[i] == undefined){
                allDetails[i] = ' ';
            }
        }
         var SuccessSpinner = component.find('Spinner');
            $A.util.addClass(SuccessSpinner, 'slds-show'); 
            $A.util.removeClass(SuccessSpinner, 'slds-hide'); 
        var actionDetails = component.get("c.saveRebate");
        
        actionDetails.setParams({
            "details": JSON.stringify(allDetails),
            "technologiesList" : optselected
        });
        var res;
        actionDetails.setCallback(this, function(response2) {
             var state = response2.getState();
            if (state === "SUCCESS") {
              var SuccessSpinner = component.find('Spinner');
            $A.util.addClass(SuccessSpinner, 'slds-hide'); 
            $A.util.removeClass(SuccessSpinner, 'slds-show'); 
            component.set("v.EnrolmentId",response2.getReturnValue());
            res = response2.getReturnValue();
            var Success = component.find('Success');
            $A.util.addClass(Success, 'show'); 
            $A.util.removeClass(Success, 'hide'); 
            }
        });
        $A.enqueueAction(actionDetails); 
        
    },
    helperMethod1 : function(component, event, helper,str) {
        
        // porfolio values
        var checkedValue=component.find("checkBox");
        var portDetails = component.get("c.availableTech");
        portDetails.setCallback(this, function(response5) {
            component.set("v.portifolios",response5.getReturnValue());
            var port=response5.getReturnValue();
           /* for(var i = 0; i<checkedValue.length; i++)
            {
                for(var j = 0; j<port.length; j++)
                {
                    if(checkedValue[i].get("v.value") == port[j])
                    {
                        checkedValue[i].set("v.disabled",false);
                    }
                    
                }
            } */
        });
        $A.enqueueAction(portDetails); 
    }
})
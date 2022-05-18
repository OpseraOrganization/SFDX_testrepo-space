({  //Updates the maintenance type picklist values
    
    doInit: function(component, event, helper) {
        
        helper.savefunctionOnInit(component, event, helper);
        component.set("v.Spinner", true); 
        
        //set the fields to read only when stages are In Review, Approved, Accepted, Expired, Closed (not won)
        var actionreadonly = component.get("c.approvalStageValueReturn");
        
        actionreadonly.setParams({"recordIDvar" : component.get("v.recordId")});
        
        actionreadonly.setCallback(this, function(response){
            
            if (response.getState() == "SUCCESS") {
                var booleanVal = response.getReturnValue();
                component.set("v.disableboolSSP",booleanVal);
                component.set("v.disableboolSRS",booleanVal);
                component.set("v.readOnlybool",booleanVal);
                
                //Commented out for ITCCPQ-2556 by Christie JJ
                //component.set("v.disableboolNBOS",booleanVal);
            }    
        });
        $A.enqueueAction(actionreadonly);   
        
        //show the field values on lightning component
        var action = component.get("c.updateMaintenanceTypeValue");        
        var actiontwoSSP = component.get("c.getportfolioSSP");
        var actiontwoSRS = component.get("c.getportfolioSRS");
        var actionthree = component.get("c.updateExistingMaintContract");
        var actionfour = component.get("c.updateExistingMaintContract");
        var actionfive = component.get("c.updateExistingMaintContract");
        var actionMaintLvl = component.get("c.updateExistingMaintContract");
        var actionsix = component.get("c.updateExistingMaintContract");
        
        actiontwoSSP.setParams({"recordIDvar" : component.get("v.recordId")});
        
        actiontwoSSP.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var sldsVal = response.getReturnValue();
                //console.log(sldsVal);
                if(component.get("v.disableboolSSP")==false){
                    
                    component.set("v.disableboolSSP",sldsVal);
                    
                }
                
            }
        });
        $A.enqueueAction(actiontwoSSP);
        
        actiontwoSRS.setParams({"recordIDvar" : component.get("v.recordId")});
        
        actiontwoSRS.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var sldsVal = response.getReturnValue();
                //console.log(sldsVal);
                if(component.get("v.disableboolSRS")==false){
                    
                    component.set("v.disableboolSRS",sldsVal);
                    
                }
                
            }
        });
        $A.enqueueAction(actiontwoSRS);
        
        
        action.setParams({"recordIDvar" : component.get("v.recordId")}); 
        
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                //console.log(allValues);
                component.set("v.favoritelist",allValues);
            }
        });
        $A.enqueueAction(action);
        
        actionthree.setParams({"recordIDvar" : component.get("v.recordId"),
                               "fieldapiname" : "NokiaCPQ_SSP_Level__c"}); 
        
        actionthree.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var listValues = response.getReturnValue();
                //alert(listValues);
                component.set("v.subscrlist1",listValues);
            }
        });
        $A.enqueueAction(actionthree);
        
        actionMaintLvl.setParams({"recordIDvar" : component.get("v.recordId"),
                               "fieldapiname" : "NokiaCPQ_Maintenance_Level__c"}); 
        
        actionMaintLvl.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var lvllistValues = response.getReturnValue();
                //alert(lvllistValues);
                //alert(lvllistValues.length);
                
                //Commented out for ITCCPQ-2556
                /*if(lvllistValues.length <= 1){
                    component.set("v.disableboolNBOS",true);
                }*/

                //console.log('lvllistValues'+lvllistValues);
                component.set("v.MaintenanceLvl",lvllistValues);
                //alert(component.get("v.MaintenanceLvl"));
            }
        });
        $A.enqueueAction(actionMaintLvl);
        
        
        
        actionfour.setParams({"recordIDvar" : component.get("v.recordId"),
                              "fieldapiname" : "NokiaCPQ_SRS_Level__c"}); 
        
        actionfour.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var listValues = response.getReturnValue();
                //alert(listValues);
                component.set("v.subscrlist2",listValues);
            }
        });
        $A.enqueueAction(actionfour);
        
        actionfive.setParams({"recordIDvar" : component.get("v.recordId"),
                              "fieldapiname" : "NokiaCPQ_Existing_IONMaint_Contract__c"}); 
        
        actionfive.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var listValues = response.getReturnValue();
                //console.log('listValues'+listValues);
                component.set("v.extMaintList",listValues);
            }
        });
        $A.enqueueAction(actionfive);
        
        actionsix.setParams({"recordIDvar" : component.get("v.recordId"),
                             "fieldapiname" : "NokiaCPQ_No_of_Years__c"}); 
        
        actionsix.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var listValues = response.getReturnValue();
                //alert(listValues);
                component.set("v.numberlist",listValues);
                
            }
        });
        $A.enqueueAction(actionsix);
         var actionforaccreditation = component.get("c.accreditationValueReturn");
        
        actionforaccreditation.setParams({"recordIdVar" : component.get("v.recordId")});
        
        actionforaccreditation.setCallback(this, function(response)
		{
            
            if (response.getState() == "SUCCESS") 
			{
                var accrdvalue = response.getReturnValue();
                component.set("v.accreditation_check",accrdvalue);
                //alert(component.get("v.accreditation_check"));  
			}
		});
				$A.enqueueAction(actionforaccreditation);
        var actionforportfolio = component.get("c.portfolioValueReturn");
        
        actionforportfolio.setParams({"recordIdVar" : component.get("v.recordId")});
        
        actionforportfolio.setCallback(this, function(response)
		{
            
            if (response.getState() == "SUCCESS") 
			{
                var recvd_value = response.getReturnValue();
                component.set("v.portfolio_check",recvd_value);
                
                //Commented out for ITCCPQ-2556
                //if(/*component.get("v.portfolio_check")=='Airscale Wifi' ||*/ component.get("v.accreditation_check")=='Nokia Brand of Service' )
                   //{
                   //component.set("v.disableboolNBOS",true);
                   //}
			}
		});
				$A.enqueueAction(actionforportfolio);
        
    },
    
    // Save the value of Maintenance Type
    
    handleClick: function(component, event, helper) {
        
        helper.savefunction(component, event, helper);
    }, 
    
    //Collapsible section 
    changeState : function changeState(component, event, helper){ 
        //console.log('v.isexpanded-->prev val'+component.get("v.isexpanded"));
        
        var expandVal = component.get("v.isexpanded");
        var newVal = "slds-section";
        var altVal = "slds-section slds-is-open";
        if(expandVal==newVal){
            component.set("v.isexpanded",altVal);
        }
        else{
            component.set("v.isexpanded",newVal);
        }
        
        var booleanVal = component.get("v.boolVal");
        
        component.set("v.boolVal",!component.get("v.boolVal"));
        
    },
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        //component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        var counter = component.get("v.num1") + 1;
        component.set("v.num1", counter);
        //console.log("v.num1 ---->"+component.get("v.num1"));
        
        setTimeout(function(){ component.set("v.Spinner", false); }, 4000);
        
        
    },
    
    // Chnage no. of maintenance years on the basis of Existing Maintenance Contract value
    handleClickExistMaint : function(component,event,helper){
        var existMaintVal = component.find("ExistMaint").get("v.value");
        var numbers = [];
        var porfolio_value;
        var action = component.get("c.portfolioValueReturn");
        
        action.setParams({"recordIdVar":component.get("v.recordId")});
        
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                
                porfolio_value = response.getReturnValue();
                //console.log(porfolio_value);
            }
        });
        
        $A.enqueueAction(action);
        
        if(existMaintVal=="Yes"){
            
            if(porfolio_value!="Airscale Wifi"){
                numbers.push('1');
                numbers.push('2');
                numbers.push('3');
            }
            
             else{
                 numbers.push('1');
                 numbers.push('3');
                 numbers.push('5');
         } 
            
            component.find("noMaintYears").set("v.value","3");
        }
        else{
            numbers.push('1');
            component.find("noMaintYears").set("v.value","1");
        }
        component.set("v.numberlist",numbers);
        //console.log('[+] befor save');
        helper.savefunction(component, event, helper);
        
    },
    
    
    
})
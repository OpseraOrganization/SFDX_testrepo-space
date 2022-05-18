({
    init: function(component, event, helper){
        var myPageRef = component.get("v.pageReference");
        
        var name = myPageRef && myPageRef.state ? myPageRef.state.c__cloneRecordId : "";
        if(name == ''){
            component.set("v.showCloneButton",true);
        }
        
        if (window.location.href.indexOf("recordTypeId") > -1) {
            component.set("v.showCloneButton",false);
        }
        if(name!=="" && name!== undefined){
            var edit = myPageRef && myPageRef.state ? myPageRef.state.c__edit : "";
            if(edit!=""){
                component.set("v.edit",edit);
                component.set("v.showCloneButton",false);
                var wgId = myPageRef.state.c__cloneRecordId;
                helper.getWGRuleDetails(component,event,helper,wgId);
                component.set("v.recordTypeId", myPageRef && myPageRef.state ? myPageRef.state.c__recordTypeId : "");
            }}        
    },
    // When a save is complete display a message
    saveCompleted: function(component,event,helper){
        helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        messageBox.displayToastMessage('Workgroup Rule is saved');
    },
    // When cancel is pressed
    cancel: function(component,event,helper){
        helper.closeConsoleTAB(component);
    },
     openAssignment : function(component, event, helper) {
        //  helper.openSubTab(component,event, helper,'c__CH_CA_Workgroup_Rule',component.get('v.recordId'),'Clone Workgroup Rule');
        helper.openSubTab(component,'c__CH_CA_Workgroup_Rule',component.get('v.recordId'),'Clone Workgroup Rule');
    },
    // Fix to load the contract type with the selected value
    typeChanged: function(component,event,helper){
        var selectedType = component.find("mySelect").get("v.value");
        component.set("v.selectedValue", selectedType);
    },
    // As the contract type is a seperate picklist, save the value on the object
    submit: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        fields["CH_Contract_Type__c"] = component.get("v.selectedValue");
        var serviceTypeValue = fields["CH_ServiceType__c"];
        var workGrouptypeValue = fields["CH_Workgroup_Type__c"];        
        if(serviceTypeValue == 'Hardware Support' && (workGrouptypeValue !='Quotation Only' && workGrouptypeValue != 'Warranty Only' && workGrouptypeValue != 'Warranty and Quotation' && workGrouptypeValue !='' && workGrouptypeValue != null && workGrouptypeValue !='Exclusions Quotation Support-CDM' && workGrouptypeValue !='Exclusions Quotation Support-OC') ){	//modified for HWSDDP-58
            document.getElementById("workgrouptypeId").innerHTML = 'Please select either "--None--" or "Warranty Only" or "Quotation Only" or "Warranty and Quotation" or "Exclusions Quotation Support-CDM" or "Exclusions Quotation Support-OC"';
		}
        else{
			document.getElementById("workgrouptypeId").innerHTML = '';
            var byPassNoneValue=fields["CH_Contract_Type__c"];
            if(byPassNoneValue=='--None--'){
                fields["CH_Contract_Type__c"] = '';
            }
            fields["RecordTypeId"] = component.get("v.recordTypeId");
            component.find("workgroupEditForm").submit(fields);
        }
    },
    // When the rule is retrieved, get all contract types
    loadedRule : function(component, event, helper) {
        //Start Changes for 30061
       
        //End Changes for 30061
        var action = component.get("c.getCdbRecords");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                component.set("v.options", response.getReturnValue());
                component.set("v.refresh", true);
                var setVal=component.find("contractType").get("v.value");
                component.set("v.selectedValue",setVal);                
             
            }
        });
        $A.enqueueAction(action);
    },
})
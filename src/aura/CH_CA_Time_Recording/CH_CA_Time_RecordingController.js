({
    onRefreshView: function(component, event, helper) {  
        var onRefreshView = component.get('c.doInit');
        $A.enqueueAction(onRefreshView);
    },
    //Initialize time recording component
    doInit : function(component, event, helper) {  
        //Checking from which page the initialization happening
        //Also define mode from here 
        var pageRef = component.get("v.pageReference");
        if(pageRef){
            var state = pageRef.state; // state holds any query params
            var base64Context = state.inContextOfRef;		
            if (base64Context.startsWith("1\.")) {
                base64Context = base64Context.substring(2);
            }
            var addressableContext = JSON.parse(window.atob(base64Context));
            if ((addressableContext.attributes.actionName == "list") &&(!component.get("v.recordId"))){
                helper.showToast('error',"Error","Add new record disabled from this page.") ;
                helper.closeConsoleTAB(component);
                return false;
            }
            
            if (addressableContext.type=="standard__recordRelationshipPage" || addressableContext.type=="standard__recordPage"){
                component.set("v.recordTicketId", addressableContext.attributes.recordId);
            }
            if((component.get("v.recordTicketId")) &&(!component.get("v.recordId")))
            {
                component.set("v.mode",'AddFromList');
            }                            
        }
        helper.init(component,event,helper);     
    },   
    
    //Close modal function
    closeModal: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
        if (component.get("v.mode")=='Edit' || component.get("v.mode")=='AddFromList'){
            helper.closeConsoleTAB(component,'cancel'); 
        }
    },
    
    // modal open for Add time recording
    handleAddTimeClick: function (component, event, helper) {
        component.set("v.mode",'Add');
        component.set("v.selectedRole","");
        component.set("v.hours",0);
        component.set("v.minutes",0);
        helper.getStartDate(component, event, helper);
        helper.handleAddTimeClick(component, event, helper);
    },
    
    //Add time recording function to save data
    saveTime :function(component, event, helper) {
        var hours = component.find("hours");
        var minutes = component.find("minutes");
        var roleOption= component.find("roleOption");
        var startDate= component.find("startDate");
        //Validate input field
        if ($A.util.isEmpty(roleOption.get("v.value"))){   
            helper.showToast('error',"Error","Please select a role.") ;
            return false;
        }
		//Ref:NOKIASC-36264 Validate Hours & Minutes
        if(component.get("v.hours")===0 && component.get("v.minutes")===0){
             helper.showToast('error',"Error","Please enter a duration.");
             return false;
        }
        //Group all the fields aura ids 
        var controlAuraIds = ["roleOption","hours","minutes","startDate"];
        //reducer function iterates over the array and return false if any of the field is invalid otherwise true.
        let isAllValid = controlAuraIds.reduce(function(isValidSoFar, controlAuraId){
            //fetches the component details from the auraId
            var inputCmp = component.find(controlAuraId);
            //displays the error messages associated with field 
            inputCmp.reportValidity();
            //form will be invalid if any of the field's valid property value is false.
            return isValidSoFar && inputCmp.checkValidity();
        },true);
        //check if the input value is valid if yes the proceed to save/edit
        if(isAllValid){
            if (component.get("v.mode")=='Add' ||component.get("v.mode")=='AddFromList'){
                helper.saveTime(component, event, helper); 
            }        
            else if(component.get("v.mode")=='Edit'){
                helper.editTime(component, event, helper); 
            }
        }
    },
    
})
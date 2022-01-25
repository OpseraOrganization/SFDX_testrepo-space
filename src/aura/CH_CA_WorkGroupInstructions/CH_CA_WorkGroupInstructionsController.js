({
    
    onInit : function(component,event,helper){
        var recordId = component.get("v.recordId");
	    //Start changes For US-30650
        if(recordId!==""&& recordId!=undefined && recordId!="undefined"){
            component.set("v.isCloneEnabled",true);
        }
        //End changes For US-30650
        var action = component.get("c.accessCheckWGInstructions");
        action.setParams({ accessCheck : recordId });
        action.setCallback(this, function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.booleanEdit",response.getReturnValue());
				 //Start changes For US-30650
                if(component.get("v.booleanEdit")==false){
                    helper.getWorkgroupInstructions(component,recordId)
                    .then(function(result){
                        var getRecord=result;
                        if (getRecord.CH_AssignmentType__c == "Active"){    
                            component.set("v.disabledSeverityType", true);  
                        }
                        else {   
                            component.set("v.disabledSeverityType", false); 
                        }
                    });
                }
                 //End changes For US-30650
            }
            else {
                var errors = response.getError();   
                var messageBox = component.find('messageBox'); 
                messageBox.displayToastMessage('error', errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong",'Error');
            }
        });
        $A.enqueueAction(action);               
    },
    
    // Change severityType with the assignmentType selected value
    assignmentTypeChanged: function(component,event,helper){
        var selectedValue = component.find("assignmentType").get("v.value");  
        if (selectedValue == "Active"){    
            component.set("v.disabledSeverityType", true);  
        }
        else {   
            component.set("v.disabledSeverityType", false); 
        }
    },
    // When a save is complete display a message
    saveCompleted: function(component,event,helper){
        
        helper.closeConsoleTAB(component);
        // Display the status of the save                        
        var messageBox = component.find('messageBox'); 
        messageBox.displayToastMessage('Workgroup Instruction is saved');
    },
    // When cancel is pressed
    cancel: function(component,event,helper){
        helper.closeConsoleTAB(component);
    },
    // When the values are retrieved, get all assignmentType
    loadedInstructions : function(component, event, helper) {
        // Set the AssignmentType fields
        var recUi = event.getParam("recordUi");
        var selectedValue = recUi.record.fields["CH_AssignmentType__c"].value;
        if (selectedValue == "Active"){    
            component.set("v.disabledSeverityType", true);  
        }
    },
    
    saveFields: function(component,event,helper){
        event.preventDefault();
        var fields = event.getParam("fields");
        var byPassNoneValue=fields["CH_AssignmentType__c"];
        if(byPassNoneValue=='Passive'||byPassNoneValue==='Case Team'){
            fields["CH_Severity__c"] = '';
        }
        component.find("workgroupInstructionForm").submit(fields);
    },
	
	//Open the Clone record in a subTab
	 openAssignment : function(component, event, helper) {
        helper.openSubTab(component,'c__CH_CA_WorkGroupInstructions',component.get('v.recordId'),'Clone WorkgroupInstruction');
    },
	
	  //Initializing the clone function
    initializeClone: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var recordId = myPageRef && myPageRef.state ? myPageRef.state.c__cloneRecordId : "";
        if(recordId!=="" && recordId!== undefined){
            var edit = myPageRef && myPageRef.state ? myPageRef.state.c__booleanEdit : "";
            if(edit!=""&& edit!=undefined && edit!="undefined"){
                component.set("v.edit", edit);
                component.set("v.isCloneEnabled",false);
                debugger;
                helper.getWorkgroupInstructions(component,recordId)
                .then(function(result){
                    var getRecord=result;
                    component.find("workgroupInstruction").set("v.value", getRecord.CH_WorkgroupInstructions__c);
                    component.find("active").set("v.value", getRecord.CH_Active__c);
                    component.find("assignmentType").set("v.value", getRecord.CH_AssignmentType__c);
                    if (component.find("assignmentType").get("v.value") == "Active"){    
                        component.set("v.disabledSeverityType", true);  
                        component.find("severityType").set("v.value", getRecord.CH_Severity__c);
                    }
                    else {   
                        component.set("v.disabledSeverityType", false); 
                    }
                    component.find("workgroup").set("v.value", getRecord.CH_Workgroup__r.Id);
                    
                })
                .catch(function(error) {
                    component.set("v.Spinner", false);
                    var messageBox = component.find('messageBox'); 
                    messageBox.displayToastMessage("An error occured. " + error, "error");
                });
            }
            
        }
    },
    
})
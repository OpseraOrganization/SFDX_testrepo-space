/******************************************************************************
Name: CH_CPA_AcceptRejectController.js
Developed Date: 17.10.2019
Developed By: Suman Samaddar, Gourisankar Patra
User Story: https://yoursl.atlassian.net/browse/NOKIASC-23197
The component should appear when the stage is ‘implement’ and the status is ‘assigned’ and 
the assigned person is logged in ; the “Please accept or reject CPA ( with rejection cause) 
to proceed “  message is displayed close to component

User Story : https://yoursl.atlassian.net/browse/NOKIASC-20346
proposal is to have a button accept as the one reject and when the CPA owner clicks on it , 
the status becomes 'In Progress'.

Last Modified by Gourisankar Patra on 23.06.2020 for defect https://jiradc2.int.net.nokia.com/browse/NOKIASC-29224
Line-94 to 102
Last Modified in line - 85 and 96
***************************************************************************/

({
	myAction : function(component, event, helper) {
		
	},

 AcceptCPA : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var recordId = component.get("v.recordId");
     console.log("message is :"+recordId);
     var value1=component.find('select').get('v.value');
     
     if (value1 ==''){
      var action = component.get('c.acceptCPA');
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
           			toastEvent.setParams({
                    "title": "Success!",
                    "message": "CPA has been updated successfully.",
                    "type": "success"
       		 });
        			toastEvent.fire();
                     $A.get('e.force:refreshView').fire();
            }
                 else {
                    helper.showToastMessage('Error',response.getState());  
                }                              
            
        });
        $A.enqueueAction(action);
     }
     
     else
     {
         
        //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
         toastEvent.setParams({
                        "title": "Failure!",
                        "message": $A.get("$Label.c.CH_Donot_Fill_Rejection_Cause_For_Accepting_CPA"),
                        "type": "error"
                    });
                 
					 toastEvent.fire();
         
     }
        /*toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been updated successfully.",
            "type": "success"
        });
        toastEvent.fire();*/
    },
  
  RejectCPA : function(component, event, helper) {
       var toastEvent = $A.get("e.force:showToast");
        var recordId = component.get("v.recordId");
     console.log("message is :"+recordId);
      var value1=component.find('select').get('v.value');
      //alert(value1);
      var action = component.get('c.transferCPAFieldsQuery');
       action.setParams({ "recordId" : component.get("v.recordId") });
      
       action.setCallback(this,function(response){
           var state = response.getState();
            if (state === "SUCCESS") {
           		var storeResponse = response.getReturnValue();
               // alert('fecthed value' +storeResponse.CH_Free_text_box__c);
                var rejectioncause = null; 
                var freeTextValue=storeResponse.CH_Free_text_box__c;
                alert('Alert ! You are about to reject the CPA');
                if (value1==''){
                   
                      //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                      toastEvent.setParams({
                        "title": "Failure!",
                        "message": $A.get("$Label.c.CH_Fill_Rejection_Cause_For_Status_Rejected"),
                        "type": "error"
                    });
                    toastEvent.fire();
                }
                 if (value1=='Other' && freeTextValue==null){
                   
                     //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                      toastEvent.setParams({
                        "title": "Failure!",
                        "message": $A.get("$Label.c.CH_Specify_Value_In_Details_For_Other"),
                        "type": "error"
                    });
                
					 toastEvent.fire();
                
					  
					}
                
                else{   
                     
                     var action1 = component.get('c.rejectCPA');
                    //action1.setParams({ "recordId" : component.get("v.recordId") });
                    ////rejectcause
        			//action1.setParams({ "rejectcause" :  value1});
                        action1.setParams({
                        "recordId": component.get("v.recordId"),
                        "rejectcause": component.find('select').get('v.value')                  
                    });
                    
                    action1.setCallback(this,function(response){
                	if (response.getState() === "SUCCESS") {
                            
                            toastEvent.setParams({
                            "title": "Success!",
                            "message": "CPA has been updated successfully.",
                            "type": "success"
       						 });
        			toastEvent.fire();
                        }
                        
            		 else {
                    helper.showToastMessage('Error',response.getState());  
                } 
                        
                        $A.get('e.force:refreshView').fire(); 
                 }); 
                   
            		$A.enqueueAction(action1);
          
                }
                
            }
                else{
                   helper.showToastMessage('Error',response.getState());  
                }        
     });
     $A.enqueueAction(action); 
  }
})
/******************************************************************************
Name: CH_ME_AcceptRejectController.js
Developed Date: 11.11.2019
Developed By: Gourisankar Patra
User Story: US: 904
to accept the Escalation request : Escalation status= ‘In Progress’ ,
‘Escalation Level Set Time’ is put when the Escalation status becomes
‘In Progress’ ,Escalation process stage = Activate , the activated notification
is sent to interested people ( ME chatter groups )

to reject the Escalation request : Escalation status= ‘Rejected’ ,
‘Escalation Rejection cause' should be filled ’ when the Escalation
status becomes ‘Rejected otherwise I have an error message ' please fill the Escalation Rejection Cause'
,Escalation process stage = Close, ‘Escalation Rejection date’ is put when the
Escalation status becomes ‘Rejected’  the rejection notification
should be sent to the Escalation Requester


***************************************************************************/

({
	myAction : function(component, event, helper) {
		
	},

 AcceptME : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var recordId = component.get("v.recordId");
     console.log("message is :"+recordId);
     var value1=null;
      value1=component.get("v.myText");     
     
     if (value1 ==null){
        
      var action = component.get('c.acceptME');
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this,function(response){
            if (response.getState() === "SUCCESS") {
           			toastEvent.setParams({
                    "title": "Success!",
                    "message": "Escalation has been updated successfully.",
                    "type": "success"
       		 }); 
        			toastEvent.fire();
                    
            }
                 else {
                    helper.showToastMessage('Error',response.getState());  
                }    
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
         
     }
     
     else
     {
       //  alert('inside else ' +value1)
        
         //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
         toastEvent.setParams({
                        "title": "Failure!",
                        "message": $A.get("$Label.c.CH_Fill_Rejection_Cause_For_Accepting_Escalation"),
                        "type": "error"
                    });
                    toastEvent.fire();
                //$A.get('e.force:refreshView').fire();
                window.location.reload();
        
					
               
     }
    

    },
  
  RejectME : function(component, event, helper) {
       var toastEvent = $A.get("e.force:showToast");
        var recordId = component.get("v.recordId");
     console.log("message is :"+recordId);
      var value1=component.get("v.myText");
     // alert(value1);
      var action = component.get('c.transferMEFieldsQuery');
       action.setParams({ "recordId" : component.get("v.recordId") });
      
       action.setCallback(this,function(response){
           var state = response.getState();
            if (state === "SUCCESS") {
           		var storeResponse = response.getReturnValue();
                 var rejectioncause = null; 
                alert('Alert ! You are about to reject the Escalation');
                if (value1==null){
                    
                      //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
                      toastEvent.setParams({
                        "title": "Failure!",
                        "message": $A.get("$Label.c.CH_Fill_Rejection_Cause_For_Status_Rejected"),
                        "type": "error"
                    });
                
					 toastEvent.fire(); 
                    //window.location.reload();
                    
                }
                
                else{       
                     var action1 = component.get('c.rejectME');
                        action1.setParams({
                        "recordId": component.get("v.recordId"),
                        "rejectcause": component.get("v.myText")                  
                    });
                    
                    action1.setCallback(this,function(response){
                	
                        if (response.getState() === "SUCCESS") {
                            toastEvent.setParams({
                            "title": "Success!",
                            "message": "Escalation has been updated successfully.",
                            "type": "success"
       						 });
        			toastEvent.fire();
                                  
           			 $A.get('e.force:refreshView').fire();
                        }
            		 else {
                    helper.showToastMessage('Error',response.getState()); 
                         $A.get('e.force:refreshView').fire();
                }   
                
				     });            
            		$A.enqueueAction(action1);
          
                }
                
            }
                else{
                   helper.showToastMessage('Error',response.getState());  
                    $A.get('e.force:refreshView').fire();
                    
                }        
            
            $A.get('e.force:refreshView').fire();                                
       
    });
     $A.enqueueAction(action); 
  }
})
({
	 distributecomment : function(component, event, helper) {
        var recordId = component.get("v.recordId");
         var action1 = component.get("c.disableDistributecommentUpdate");
        
        action1.setParams({ caseId: recordId });
        action1.setCallback(this, function(response) {     
        
      
    });
    $A.enqueueAction(action1);
    },
     activeButtonCode : function(component,event,helper){
        var inputText = component.find("incomment").get("v.value");
         
        if(inputText != null ){
            component.set("v.isButtonActive",false);
			component.set("v.comment",inputText); // Nokiasc-35941
        } 
         if(inputText == null || inputText == '' || inputText == undefined  ){
            component.set("v.isButtonActive",true);
         }
    },
	launchOutageStatusUpdate : function (component,event,helper) {
           
           var action = component.get("c.updateComment"); // Nokiasc-35941
           var caseId = component.get("v.recordId");
  
           action.setParams({"caseId": component.get("v.recordId"),
                             "comment":component.find("incomment").get("v.value")});
           action.setCallback(this, function(response) {
               if (response.getState() == "SUCCESS") {
                   
                   component.set("v.distributeCommentFinish", true);
                   component.set("v.outageStatusFinished",true);
                   var flow = component.find("outageStatus");
                   var inputVariables = [
                       { name : "recordId", type : "String", value: component.get("v.recordId") }
                       
                   ];
                   flow.startFlow("CH_Status_Update_of_Critical_Service_Disruption_Not_Restored",inputVariables);
                   component.set("v.isButtonActive",true);
                   component.set("v.runflow", true);
               }
               if (response.getState() == "ERROR") {
                   alert('ERROR');
               }
           });
           $A.enqueueAction(action);
       },
})
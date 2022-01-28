({
	 distributecomment : function(component, event, helper) {
        var recordId = component.get("v.recordId");
         var action1 = component.get("c.disableDistributecommentUpdate");
        
        action1.setParams({ caseId: recordId });
        action1.setCallback(this, function(response) {     
        component.set("v.isButtonActive",response.getReturnValue());
      
    });
    $A.enqueueAction(action1);
    },
     activeButtonCode : function(component,event,helper){
        var inputText = component.find("incomment").get("v.value");
         
        if(inputText != null ){
            component.set("v.isButtonActive",false);
        } 
         if(inputText == null || inputText == '' || inputText == undefined  ){
            component.set("v.isButtonActive",true);
         }
    }
})
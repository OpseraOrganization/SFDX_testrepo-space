({
    init : function (component,event,helper) {
       	var flow = component.find("flowData");
        var inputVariables = [
         { name : "recordId", type : "String", value: component.get("v.recordId") }
       ];
       flow.startFlow("CRM_Get_Offer_Automatic_Gate_Approval", inputVariables);
    },
    
    handleStatusChange : function (component,event,helper) {
      if(event.getParam("status").includes("FINISHED") ) {
         // Get the output variables and iterate over them
         var outputVariables = event.getParam("outputVariables");
         var offerId = outputVariables[0].value;
         component.set("v.offerId", offerId);
         component.find("recordLoaderOffer").reloadRecord();         
      }
   },
    
    handleRecordUpdated : function(component,event,helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED" ) {
            helper.validateGate(component,event,helper);
        } else if (eventParams.changeType === "CHANGED") {
			component.find("recordLoader").reloadRecord();         
        } else if (eventParams.changeType === "ERROR") {
         	console.log(component.get('v.recordLoadError'));   
        }
    },
    
    handleOfferUpdated : function(component,event,helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED" ) {
        } else if (eventParams.changeType === "CHANGED") {
			component.find("recordLoaderOffer").reloadRecord();         
        } else if (eventParams.changeType === "ERROR") {
         	console.log(component.get('v.offerLoadError'));   
        }
    },
    
    handleClick : function(component,event,helper) {
        helper.disableButtons(component,event,helper);
        helper.buttonAction(component,event,helper);
    },
    
    handleRecall : function(component,event,helper) {
        component.set("v.paramChecked", false);
        helper.disableButtons(component,event,helper);
        helper.recallApproval(component,event,helper);
    },
    
    handleApprove : function(component,event,helper) {
        component.set("v.paramChecked", false);
        helper.disableButtons(component,event,helper);
        helper.approveApproval(component,event,helper);
    },
    
    handleReject : function(component,event,helper) {
        component.set("v.paramChecked", false);
        helper.disableButtons(component,event,helper);
        helper.rejectApproval(component,event,helper);
    },
    
    closeModal: function(component,event,helper) {
        component.set("v.simulateInfo", false);
        component.set("v.paramChecked", false);
        helper.enableButtons(component,event,helper);
    },
        
    handleSubmitInfo: function(component, event, helper) {
        console.log('test');
        event.preventDefault();      
        component.set("v.simulateInfo", false);
        component.set("v.paramChecked", true);
        helper.submitApproval(component,event,helper);
    },
    
    onError:function(component, event, helper) {
        var error = event.getParams();
        console.log( event.getParam("message") );
    },
});
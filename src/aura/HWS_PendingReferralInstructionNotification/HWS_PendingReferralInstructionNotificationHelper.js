({
    subscribe : function(component, event, helper) { 
        const empApi = component.find("empApi");
        var channel = '/event/HWS_Referral_Instruction_Event__e';
		var caseCreatedById = component.get("v.simpleRecord").CreatedById;
		//var helper=this;
        const replayId = -1;
        var RIEventLabel = $A.get("$Label.c.HWS_Referral_Instruction_Event");
        console.log('LABEL:'+RIEventLabel);
        if(RIEventLabel == 'True')
            component.set("v.IsSpinner",true);        
        const callback = function (message) {
            var msg = message.data.payload.HWS_Referral_Instruction_Status__c;
            console.log('msg:'+msg);
            if(msg != null && msg != '' && msg != undefined){
                var value = msg.split('#');
                var internalStatus = value[0]; 
                var caseNumber = value[1];  
                var caseId = value[2];				
                if(internalStatus == 'Pending Referral Instruction' && caseId == caseCreatedById){
                    component.set("v.IsSpinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'This case '+caseNumber+ ' has Referral Instruction(s), please check Supplier Instruction tab',                    
                        type : 'success'                                       
                    });
					helper.unsubscribe(component,event,helper); 
                    toastEvent.fire();
                } else if(internalStatus == 'No Referral Instruction' && caseId == caseCreatedById){
                    component.set("v.IsSpinner",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'No Referral Instruction exists for this Support Ticket '+caseNumber,
                        type : 'success'                                       
                    });
					helper.unsubscribe(component,event,helper); 
                    toastEvent.fire();
                }
               /* helper.unsubscribeHelper(component,event);                   
                setTimeout(function(){
                    $A.get('e.force:refreshView').fire();
                }, 1000);     */           
            }
            
        };  
        var time =  $A.get("$Label.c.HWS_Referral_Instruction_Time");
        setTimeout(function(){
            
            if(component.get("v.IsSpinner")==true){
                component.set("v.IsSpinner",false);
                component.set("v.simpleRecord.CH_InternalStatus__c",'Waiting for Referral Instruction');
                component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                    if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                        console.log('recordSaved');
                        component.set("v.curView", "baseView" );            
                    } else if (saveResult.state === "INCOMPLETE") {
                        console.log("User is offline, device doesn't support drafts.");
                    } else if (saveResult.state === "ERROR") {
                        console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    } else {
                        console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    }
                }));                
                helper.unsubscribe(component,event,helper);   
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: 'sticky',
                    message: 'No response received from SOO, please refresh the page after a moment to see Referral Instructions',
                    type : 'success'                                       
                });
                toastEvent.fire();
            }
        }, time);
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to channel " + channel);
            component.set("v.subscription", newSubscription);            
        });
    },
	unsubscribe : function(component,event,helper) { 
         const empApi = component.find("empApi");        
                var channel = '/event/HWS_Referral_Instruction_Event__e';
                const callback = function (message) {
                    console.log("Unsubscribed from channel " + channel);
                };             
        if(component.get("v.subscription") != undefined){
                empApi.unsubscribe(component.get("v.subscription"), callback); 
				component.set("v.IsFirst",false); 
        }
		/*setTimeout(function(){
			$A.get('e.force:refreshView').fire();
		}, 1000);*/
    }
})
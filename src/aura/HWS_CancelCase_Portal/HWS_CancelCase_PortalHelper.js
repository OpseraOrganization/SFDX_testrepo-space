({
	cancelHwsCaseHelper : function(component,event,helper) {
        //alert('Hello cancel case');
        component.set("v.Spinner", true);//added spinner DEM0053577
        var caseRecId = component.get("v.recordId");
       // alert('Hello cancel case'+caseRecId);
        var action= component.get("c.cancelChildCases"); 
                action.setParams({casId : caseRecId});
                action.setCallback(this, $A.getCallback(function (response) {
                    console.log('Enter response blog');
                    var state = response.getState();
                    var shippedFlag='false';
                    var childShippedFlag='false';
                    var orderedFlag='false';
                    var reqCancel='false';
                     //HWST_1409
            		var childRTCFlag ='false';
                    // alert('Case State'+state);
                    if (state == "SUCCESS"){
                        var caseReturnList = response.getReturnValue();
                        
                        for(var i=0;i<caseReturnList.length;i++){
                            console.log(caseReturnList[i]);
                            if(caseReturnList[i] == 'childShipped' || caseReturnList[i] == 'childPartially Shipped' || caseReturnList[i] == 'childDelivered'){
                                childShippedFlag = 'true';
                            }
                            //HWST_1409
                            else if(caseReturnList[i] == 'childRequest to Cancel'){
                                childRTCFlag = 'true';
                            }
                            else if(caseReturnList[i] == 'Shipped' || caseReturnList[i] == 'Partially Shipped' || caseReturnList[i] == 'Delivered'){
                                shippedFlag = 'true';
                            }
                            else if(caseReturnList[i] == 'Ordered'){
                                orderedFlag = 'true';
                            }
                            else if(caseReturnList[i] == 'Request to Cancel'){
                                reqCancel = 'true';
                            }
                        }
                         //US 1409 started
                        if(orderedFlag == 'true'){
                            //this.showToast('success','Success','The Cancellation request is sent successfully.'); 
                            this.showToast('error','error','The Cancellation request is not sent.'); 
                        }
                        else if(childRTCFlag == 'true'){
                            this.showToast('note','Note','The Cancellation request has been raised already');    
                        }
                        else if(reqCancel == 'true'){
                            //this.showToast('note','Note','The Cancellation request has been raised already');    
                        	this.showToast('success','Success','The Cancellation request is raised successfully.'); 
                        }
                        //US 1409 Ended
                        else if(childShippedFlag=='true'){
                        	this.showToast('note','Note','Cannot cancel as the requested parts are already either Shipped or Partially Shipped or Delivered');
                        }else if(shippedFlag=='true'){
                        	this.showToast('note','Note','The request has some parts which are already shipped/Partially Shipped/delivered,respective Child cases will not be cancelled');    
                        }else if(caseReturnList.length>0){
                        	this.showToast('success','Success','Cancellation Request processed Successfully ');        
                        }
                        component.set("v.Spinner", false);// added spinner for dem0053577
                        $A.get('e.force:refreshView').fire();
                      
                    }else{this.showToast('error','Error','An Internal Error Has occurred. Please try after some time');}
                }));
        $A.enqueueAction(action);
    },
     getCaseStatus : function(component, event, helper) {        
        var id = component.get("v.recordId");                
        var action =component.get("c.getCancellationStatus");
        action.setParams({
            caseid: id
        });                
        action.setCallback(this, function(response) {                       
            var caseCancelStatus = response.getReturnValue();
            component.set("v.CasStatus",caseCancelStatus);            
        });
        $A.enqueueAction(action);
    },
    
    //Helper method to display the error toast message
    showToast : function(type,title,message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            duration:'10000',
            key: 'info_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire(); 
    },
})
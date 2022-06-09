({
	cancelHwsCaseHelper : function(component,event,helper) {
        var caseRecId = component.get("v.recordId");
        var action= component.get("c.cancelChildCases"); 
                action.setParams({casId : caseRecId,
                                  cancelReason : component.get('v.cancelledCase.Cancellation_Reason__c'),
                                  reasonForCancel : component.get('v.cancelledCase.CH_ReasonForCancellation__c')
                                 });
                action.setCallback(this, $A.getCallback(function (response) {
                   // console.log('Enter response blog'); NOKIASC-36296
                    var state = response.getState();
                    var shippedFlag='false';
                    var childShippedFlag='false';
                    var orderedFlag='false';
                    var reqCancel='false';
                    //HWST_1409
            		var childRTCFlag ='false';
                    if (state == "SUCCESS"){
                        component.set('v.isOpen',false);
                        var caseReturnList = response.getReturnValue();
                        
                        for(var i=0;i<caseReturnList.length;i++){
                           // console.log(caseReturnList[i]);NOKIASC-36296
                            if(caseReturnList[i] == 'childShipped' || caseReturnList[i] == 'childPartially Shipped' || caseReturnList[i] == 'childDelivered'){
                                childShippedFlag = 'true';
                            }
                            //HWST_1409
                            else if(caseReturnList[i] == 'childRequest to Cancel'){
                                childRTCFlag = 'true';
                            }
                            else if(caseReturnList[i] == 'Shipped' || caseReturnList[i] == 'Delivered' || caseReturnList[i] == 'Partially Shipped'){
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
                    this.showToast('error','Error',$A.get("$Label.c.HWS_MSG_CancelCase_RequestNotSent")); 
                }
                else if(childRTCFlag == 'true'){
                    this.showToast('note','Note',$A.get("$Label.c.HWS_MSG_CancelCase_Raised_Already"));    
                }
                    else if(reqCancel == 'true'){
                        //this.showToast('note','Note','The Cancellation request has been raised already');    
                        this.showToast('success','Success',$A.get("$Label.c.HWS_MSG_CancelCase_Raised_Successfully")); 
                    }
                //US 1409 Ended
                        else if(childShippedFlag=='true'){
                            this.showToast('note','Note',$A.get("$Label.c.HWS_MSG_CancelCase_ShippedorDelivered"));
                        }else if(shippedFlag=='true'){
                            this.showToast('note','Note',$A.get("$Label.c.HWS_MSG_CancelCase_ShippedorDelivered_NotCancelled"));    
                        }else if(caseReturnList.length>0){
                            this.showToast('success','Success',$A.get("$Label.c.HWS_MSG_CancelCase_Success"));        
                        }
                $A.get('e.force:refreshView').fire();
            }else{this.showToast('error','Error',$A.get("$Label.c.HWS_MSG_Internal_Error"));}
        }));
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
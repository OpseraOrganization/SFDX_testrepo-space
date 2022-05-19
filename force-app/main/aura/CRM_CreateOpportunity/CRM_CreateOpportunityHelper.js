({
    showForm : function(cmp, evt, helper)
    {
        var oppType = cmp.get("v.oppTypeSelected");	
    },
    
    evaluateActions : function(cmp, evt, helper)
    {
        switch(cmp.get("v.navStep"))
        {
            case 1:
                switch(cmp.get("v.oppTypeSelected"))
                {
                    case "Direct Standard":
                        cmp.set('v.cmpToRedirect','c:CRM_CreateStandardOpportunity');
                        break;
                    case "Indirect Standard":
                        cmp.set('v.cmpToRedirect','c:CRM_CreateStandardOpportunity');
                        break;
                    default:
                        cmp.set("v.navStep",cmp.get("v.navStep")+1);
                }
                break;
            case 2:
                if(helper.validateFields(cmp, evt, helper))
                {
                    helper.getDetails(cmp, evt, helper);
                }
                break;
            case 3:
                if(helper.validateFields(cmp, evt, helper))
                {
                    helper.saveFastTrack(cmp, evt, helper); 
                }
                break;
            case 4:
                cmp.set('v.cmpToRedirect','c:OIF_Component');
                //helper.callComponent(cmp, evt, helper, cmp.get("v.fastTrackOppId"));
                break;
            default:
                console.log('wrong navigation steps');
        }
        
    },
    
    getDetails : function(cmp, evt, helper)
    {
        var action = cmp.get("c.getFTDetailsApex");
        action.setParams({"oppId": cmp.get("v.masterOppId"),
                          "contextId": cmp.get("v.recordId"),
                          "fastTrackType": cmp.get("v.oppTypeSelected")});
        action.setCallback(this, function(response) 
                           {
                               cmp.set("v.loading",false);
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   var wrapper = response.getReturnValue();
                                   if(!wrapper.canCreate)
                                   {
                                       var toastEvent = $A.get("e.force:showToast");
                                       toastEvent.setParams({
                                           "title": "Access Denied.",
                                           "message": "User profile does not have the rights to create an opportunity."
                                       });
                                       toastEvent.fire();
                                       $A.get("e.force:closeQuickAction").fire();
                                   }
                                   else if ( !helper.isNullOrBlank(wrapper.errorMessage) ){
                                       helper.showError(cmp,wrapper.errorMessage);
                                   }
                                   else
                                   {
                                       cmp.set("v.masterOppId", wrapper.masterOppId);
                                       cmp.set("v.fastTrackOpp", wrapper.fastTrackOpp);
                                       cmp.set("v.accMarket", wrapper.accMarket)
                                       cmp.set("v.oifLine", wrapper.oifLine);
                                       cmp.set("v.oifLine.Forecast_Category__c", null);//remove default option of forecast category
                                       var oifLineList =  [];
                                       oifLineList.push(wrapper.oifLine);
                                       cmp.set("v.oifLineList", oifLineList);
                                       cmp.set("v.navStep",cmp.get("v.navStep")+1);
                                   }
                               }
                           })
        $A.enqueueAction(action);
        cmp.set("v.loading",true);
    },
    
    saveFastTrack : function(cmp, evt, helper)
    {
        if( helper.isNullOrBlank(cmp.get("v.fastTrackOpp.End_Customer_LE__c")) ){
            cmp.set("v.fastTrackOpp.End_Customer_LE__c",null);
        }
        var action = cmp.get("c.saveFastTrackApex");
        action.setParams({"fastTrack": JSON.stringify(cmp.get("v.fastTrackOpp")),
                          "fastTrackType": cmp.get("v.oppTypeSelected"),
                          "oifLine": JSON.stringify(cmp.get("v.oifLine")),
                          "accountId": cmp.get("v.accountId"),
                          "masterOppId": cmp.get("v.masterOppId")});
        action.setCallback(this, function(response) 
                           {
                               cmp.set("v.loading",false);
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   var wrapper = response.getReturnValue();
                                   if(!helper.isNullOrBlank(wrapper.errorMessage))
                                   {
                                       helper.showError(cmp, wrapper.errorMessage) ;
                                   }
                                   else
                                   {
                                       console.log("fast track opp id: " + wrapper.fastTrackOppId);
                                       cmp.set('v.fastTrackOppId', wrapper.fastTrackOppId)
                                       helper.checkOIFcreation(cmp, evt, helper);
                                   }
                               }
                           })
        $A.enqueueAction(action);
        cmp.set("v.loading",true);
    },
    
    checkOIFcreation : function(cmp, evt, helper)
    {
        var action = cmp.get("c.checkOIFcreationApex");
        action.setParams({"oppId": cmp.get("v.fastTrackOppId")});
        action.setCallback(this, function(response) 
                           {
                               var state = response.getState();
                               if(state === "SUCCESS")
                               {
                                   if(response.getReturnValue())
                                   {
                                       cmp.set("v.navStep",cmp.get("v.navStep")+1);
                                       helper.evaluateActions(cmp, evt, helper);
                                       cmp.set("v.loading",false);
                                   }
                                   else
                                   {
                                       console.log('OIF not created yet.');
                                       var checkCounter = cmp.get("v.checkCounter") + 1;
                                       cmp.set("v.checkCounter", checkCounter);                                       
                                       if(checkCounter > 20)
                                       {
                                           helper.showErrorToast(cmp, evt, helper, 'An error creating the OIF might have ocurred. If no OIF is shown in the grid please create a new one.');
                                           cmp.set("v.navStep",cmp.get("v.navStep")+1);
                                           helper.evaluateActions(cmp, evt, helper);
                                           cmp.set("v.loading",false);
                                       }
                                       else
                                       {
                                           setTimeout(function(){ 
                                               helper.checkOIFcreation(cmp, evt, helper);
                                           }, 2000);
                                       }
                                   }
                               }
                           })
        $A.enqueueAction(action);
        cmp.set("v.loading",true);
    },
    
    validateFields : function(cmp, evt, helper)
    {
        var valid = true;
        switch(cmp.get("v.navStep"))
        {
            case 1:
                break;
            case 2:
                if(helper.isNullOrBlank(cmp.get("v.masterOppId")))
                {
                    //helper.showErrorToast(cmp, evt, helper, 'Master opportunity is required.')
                    helper.showError(cmp, 'Reference Opportunity (Master) is required.') ;
                    valid = false;
                }
                break;
            case 3:
                valid = helper.validateFastTrack(cmp, evt, helper);
                break;
        }     
        return valid;
    },
    
    validateFastTrack : function(cmp, evt, helper)
    {
        var valid = true;
        var errorMessage = 'The following fields are required: ';
        if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.Name")))
        {
            errorMessage = errorMessage + 'Opportunity Name, ';
            valid = false;            
        }
        if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.Lead_BG__c")))
        {
            errorMessage = errorMessage + 'Lead BG, ';
            valid = false;     
        }
        if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.Probability")))
        {
            errorMessage = errorMessage + 'Probability, ';
            valid = false;     
        }
        if(cmp.get("v.oppTypeSelected") === 'Indirect Fast Track (under Frame Contract)'){
            if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.End_Customer_Information__c")))
            {
                errorMessage = errorMessage + 'End Customer Information, ';
                valid = false;     
            }
            if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.Account_Role__c")))
            {
                errorMessage = errorMessage + 'Account Role, ';
                valid = false;     
            }
        }
        if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.Contract_Signing_Entity__c")))
        {
            errorMessage = errorMessage + 'Contract Signing Entity, ';
            valid = false;     
        }
        if(helper.isNullOrBlank(cmp.get("v.fastTrackOpp.CurrencyIsoCode")))
        {
            errorMessage = errorMessage + 'Currency, ';
            valid = false;     
        }	
        var oifLineList = cmp.get("v.oifLineList");
        for(var i=0; i<oifLineList.length; i++)
        {
            oifLineList[i];
            if(helper.isNullOrBlank(oifLineList[i].BusinessLine__c) && !errorMessage.includes('OIF Product Line'))
            {
                errorMessage = errorMessage + 'OIF Product Line, ';
                valid = false;  
            }
            if(helper.isNullOrBlank(oifLineList[i].OIF_Value__c) && !errorMessage.includes('OIF Value'))
            {
                errorMessage = errorMessage + 'OIF Value, ';
                valid = false;     
            }
            if(helper.isNullOrBlank(oifLineList[i].POPlanReceipt__c) && !errorMessage.includes('OIF PO Plan Date'))
            {
                errorMessage = errorMessage + 'OIF PO Plan Date, ';
                valid = false;     
            }
            if(helper.isNullOrBlank(oifLineList[i].Forecast_Category__c) && !errorMessage.includes('OIF Forecast Category'))
            {
                errorMessage = errorMessage + 'OIF Forecast Category, ';
                valid = false;     
            }
        }
		
        if(valid)
        {
            for(var i=0; i<oifLineList.length; i++)
            {
                if(helper.isNullOrBlank(oifLineList[i].Rev_RecPlan_Receipt__c) && cmp.get("v.accMarket") == 'Market North America')
                {
                    errorMessage = 'Please Fill The Rev Rec Plan.  ';
                	valid = false;
                    break;
                }
                else if(oifLineList[i].Forecast_Category__c == 'Booked')
                {
                    errorMessage = 'You cannot book OIF before Win Declaration is complete.  ';
                	valid = false;
                    break;
                }
            }
        }
        
        
        if(!valid)
        {
            //helper.showErrorToast(cmp, evt, helper, );
            helper.showError(cmp, errorMessage.slice(0, -2) ) ;
        }
        
        return valid;
    },
    
    //AUX METHODS
    showSuccessToast : function(cmp, evt, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Successs Message',
            message: message,
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    showErrorToast : function(cmp, evt, helper, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error Message',
            message:message,
            duration:'10000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    }, 
    
    showError : function(cmp, error){
        cmp.set("v.errorMsg",error );
        document.getElementById('scrollable_div').scrollTop = 0;
    },
    
    callComponent : function(cmp, evt, helper, contextId)
    {
        var callEvt = $A.get("e.force:navigateToComponent");
        var cmpToRedirect = cmp.get("v.cmpToRedirect");
        callEvt.setParams(
            {
                componentDef  : cmpToRedirect,
                componentAttribute : 
                {
                    recordId : contextId
                }
            });
        callEvt.fire();
    },
    
    isNullOrBlank : function(variable)
    {
        if(typeof variable === 'undefined' || variable == null || variable == '' )
            return true;
        else
            return false;
    }
})
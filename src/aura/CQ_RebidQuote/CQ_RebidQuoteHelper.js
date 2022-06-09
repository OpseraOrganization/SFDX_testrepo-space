({
    fetchQuote : function(component, event) {
        var recordId = component.get("v.recordId")
        //var showToast = $A.get('e.force:showToast');
        var action = component.get("c.fetchquoteDetails");
        action.setParams({"quoteId" : recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === "SUCCESS")
            {
                var quo = response.getReturnValue();
                if(quo.Apttus_Proposal__Approval_Stage__c=='Rebid')
                {
                    this.showToast({
                        'message': 'Rebid cannot be done for Approval Stage = Rebid',
                        'type' : 'error',
                        'duration' : 10000
                    });
                    //showToast.fire();
                    var urlEvt = $A.get("e.force:navigateToURL");
                    urlEvt.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvt.fire();
                    component.destroy();    
                }//Added by Rajitha
                else if(quo.SDV_Is_Rebid_Completed__c == true){
                    this.showToast({
                        'message': 'Rebid cannot be done because rebid is already completed.',
                        'type' : 'error',
                        'duration' : 10000
                    });
                    //showToast.fire();
                    var urlEvt = $A.get("e.force:navigateToURL");
                    urlEvt.setParams({
                        "url": '/' + component.get("v.recordId")
                    });
                    urlEvt.fire();
                    component.destroy(); 
                } //end by Rajitha
                else
                {
                    component.set('v.quotecreationflag',true);
                    console.log('Quote data: ' + JSON.stringify(response.getReturnValue()));
                    component.set('v.quote',response.getReturnValue());
                    component.set('v.cosvalue',quo.CQ_Customer_Organization_Segment__c);
                    component.set('v.servalue',quo.CQ_Servies_components__c);
                    
                    var ser = 'CQ_Servies_components__c';
                    var getmPicklist = component.get("c.fetchpicklistValues");
                    getmPicklist.setParams({"field" : ser});
                    getmPicklist.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS")
                        {
                            var result = response.getReturnValue();
                            var mplValues = [];
                            for (var i = 0; i < result.length; i++) {
                                mplValues.push({
                                    label: result[i],
                                    value: result[i]
                                });
                            }
                            //alert('mplvalues:::>'+JSON.stringify(mplValues));
                            component.set("v.serlist", mplValues);
                            var sval = component.get("v.servalue");
                            if(!$A.util.isUndefined(sval) && !$A.util.isEmpty(sval))
                            {
                                var mselect = sval.split(';');
                                component.set("v.selectedserlist",mselect);
                            }
                        }
                        else
                        {
                            console.log(state);
                        }
                    });
                    $A.enqueueAction(getmPicklist);
                    
                    var cos = 'CQ_Customer_Organization_Segment__c';
                    var getPicklist = component.get("c.fetchpicklistValues");
                    getPicklist.setParams({"field" : cos});
                    getPicklist.setCallback(this, function(response){
                        var state = response.getState();
                        if(state === "SUCCESS")
                        {
                            var picklist = [];
                            var plvalues = [];
                            picklist = response.getReturnValue();
                            var cosval = component.get("v.cosvalue");
                            if(!$A.util.isUndefined(cosval) && !$A.util.isEmpty(cosval)){
                                plvalues.push({
                                    class: "optionClass", label: cosval, value: cosval
                                });
                            }
                            plvalues.push({
                                class: "optionClass", label: "--- None ---", value: ""
                            });
                            for(var i=0;i<picklist.length;i++){
                                plvalues.push({"class": "optionClass", label: picklist[i], value: picklist[i]});
                            }
                            component.set("v.coslist", plvalues);
                        }
                        else
                        {
                            console.log(state);
                        }
                    });
                    $A.enqueueAction(getPicklist);
                }
            }
            else
            {
                this.showToast({
                    'message': 'Exception occured',
                    'type' : 'warning',
                    'duration' : 10000
                }); 
                //showToast.fire(); 
            }
        });
        $A.enqueueAction(action);
    },
    
    cancelRebid : function(component, event) {
        component.set("v.quotecreationflag", false);
        component.set("v.quote",{'sobjectType' : 'Apttus_Proposal__Proposal__c'});
        
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();        
    },
    
    validateSave : function(component, event) {
        var flag = true;
        var errorMessages = 'Required fields are missing: [ ';
        
        if( $A.util.isUndefined(component.find('quoteName').get('v.value')) ||
           $A.util.isEmpty(component.find('quoteName').get('v.value')) ){
            errorMessages += 'Quote Name, ';
            flag = false;
        }
        if( $A.util.isUndefined(component.find('cqduedate').get('v.value')) ||
           $A.util.isEmpty(component.find('cqduedate').get('v.value')) ){
            errorMessages += 'CQ Due Date ';
            flag = false;
        }
        errorMessages += ' ]';
        
        var err= [] 
        err.push(errorMessages);
        if(flag == false ){
            component.set("v.errors", err);
            component.set("v.has_error", true); 
            component.set("v.disbutton", false);
        }
        return flag;
    },
    
    saveRebid : function(component, event) {
        var servalue = component.get("v.selectedserlist");
        component.set("v.quote.CQ_Servies_components__c",servalue);
        component.set("v.IsSpinner", true);
        component.set("v.disbutton", true);
        component.set("v.has_error", false); 
        var recordId = component.get("v.recordId")
        var quo = component.get("v.quote")
        
        var action = component.get("c.rebidQuote");
        action.setParams({"cqquote": quo,
                          "recordId": recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS")
            {
                var returned =response.getReturnValue();  
                //var showToast = $A.get('e.force:showToast');
                if(returned.includes(' '))
                {
                    component.set("v.IsSpinner", false);
                    component.set("v.disbutton", false);
                    component.set("v.has_error", true);
                    component.set("v.errors", returned);
                    return;
                }
                else
                {
                    this.showToast({
                        'message': 'Quote Rebid Successful',
                        'type' : 'success',
                        'duration' : 10000
                    }); 
                    //showToast.fire();
                    
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": returned,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }
            }
            else
                console.log(state);
        });
        $A.enqueueAction(action);       
    },
    
    showToast : function(params) {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams(params);
            toastEvent.fire();
        }
        else
            console.log('Error in toast');
    },
})
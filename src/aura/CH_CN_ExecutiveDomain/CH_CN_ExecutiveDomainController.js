({
    init: function (component,event,helper) {    
        
        //initialize stage
        
        var recordTypeName=component.get("v.recordTypeName")
        if(recordTypeName=="CH_Workgroup_Domain"){
            component.set('v.steps', [
                { label: 'Workgroup Dimension', value: '1' },
                { label: 'Geographic Dimension', value: '2' },
                { label: 'Account Dimension', value: '3' },
                { label: 'Product Dimension', value: '4' },
                { label: 'Event Subscription', value: '5' }            
            ]);            
        }
        else if(recordTypeName=="CH_Executive_Domain")
        {
            component.set('v.steps', [
                { label: 'Geographic Dimension', value: '1' },
                { label: 'Account Dimension', value: '2' },
                { label: 'Product Dimension', value: '3' },
                { label: 'Event Subscription', value: '4' }            
            ]);         
        }
        var stageList=component.get('v.steps');        
        component.set("v.currentStageName", stageList[0].label); 
        helper.getCustomSettingsForNotification(component,event,helper)
        .then(function(result){                
            if(result){                    
                if(result.hasOwnProperty('Legal Entity Search')) {
                    var LegalEntitySearchLimit=parseInt(result['Legal Entity Search'].CH_NotificationLimitValue__c);
                    component.set("v.LegalEntitySearchLimit",LegalEntitySearchLimit);
                }  
                if(result.hasOwnProperty('Legal Entity Selection')) {    
                    var LegalEntitySelectionLimit=parseInt(result['Legal Entity Selection'].CH_NotificationLimitValue__c);
                    component.set("v.LegalEntitySelectionLimit",LegalEntitySelectionLimit);
                }
                if(result.hasOwnProperty('Product Search')) {
                    var ProductSearchLimit=parseInt(result['Product Search'].CH_NotificationLimitValue__c);
                    component.set("v.ProductSearchLimit", ProductSearchLimit);
                }
                if(result.hasOwnProperty('Product Selection')) {
                    var ProductSelectionLimit=parseInt(result['Product Selection'].CH_NotificationLimitValue__c);
                    component.set("v.ProductSelectionLimit", ProductSelectionLimit);                        
                }
                if(result.hasOwnProperty('CH_CN_Country_Selection')) {
                    var CountryLimit=parseInt(result['CH_CN_Country_Selection'].CH_NotificationLimitValue__c);
                    component.set("v.CountryLimit", CountryLimit);                        
                }
                 if(result.hasOwnProperty('CH_CN_Workgroup_Selection')) {
                    var WorkgroupLimit=parseInt(result['CH_CN_Workgroup_Selection'].CH_NotificationLimitValue__c);
                    component.set("v.WorkgroupLimit", WorkgroupLimit);                        
                }
                if(result.hasOwnProperty('Subscription Limit')) {
                    var SubscriptionLimitPerUser=parseInt(result['Subscription Limit'].CH_NotificationLimitValue__c);
                    component.set("v.SubscriptionLimitPerUser",SubscriptionLimitPerUser);  
                }                                        
            }    
            var recordId=component.get("v.recordId");
            if(recordId){
                helper.getNotificationSubscription(component,event,helper,recordId);
            }
            else{
                component.set("v.showStage",true);
            }
        });   
        
        
    },   
    //Call by aura:waiting event  
    handleShowSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    //Call by aura:doneWaiting event 
    handleHideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    //Method used to handle Next button click
    handleClickNext : function(component,event,helper){
        var subscriptionName=component.get("v.subscriptionName");
        var getselectedStep =parseInt(component.get("v.selectedStage"));
        var stageList=component.get('v.steps');        
        var currentStage=stageList[getselectedStep-1].label;
        
        var isValid= helper.validateStage(component,event,helper,currentStage);
        if(isValid){   
            if(!$A.util.isEmpty(subscriptionName.trim())){  
                getselectedStep++;                
                component.set("v.selectedStage", getselectedStep.toString()); 
                component.set("v.currentStageName", stageList[getselectedStep-1].label); 
                if(stageList.length===getselectedStep){
                    component.set("v.lastStage",true);
                }
                else{
                    component.set("v.lastStage",false);
                }
            }else{
                component.set("v.subscriptionName",'');                
                component.find('subscriptionNameValue').focus();
                component.find('subscriptionNameValue').showHelpMessageIfInvalid();
            } 
            
        }
        else{
            helper.showToast('error',"Error","Please select all the fields to progress to the next dimension") ;
            
        }
        
    },    
    //Method used to handle Previous button click
    handleClickPrevious : function(component,event,helper){
        component.set("v.lastStage",false);
        var getselectedStep =parseInt(component.get("v.selectedStage"));
        var stageList=component.get('v.steps'); 
        var currentStage=stageList[getselectedStep-1].label;
        
        getselectedStep--
        component.set("v.selectedStage", getselectedStep.toString());
        component.set("v.currentStageName", stageList[getselectedStep-1].label); 
        
    },
    
    //Method used to handle Submit button Click
    handleSubmit : function(component,event,helper){
        var recordId=component.get("v.recordId");
        var subscriptionName=component.get("v.subscriptionName");
        //  var currentStage=stageList[getselectedStep-1].label;
        // var isValid = helper.validateEventSubscription(component,event,helper);
        
        var currentStage = 'Event Subscription';
        var stageList=component.get('v.steps'); 
        let isAllValid = stageList.reduce(function(notValidSatge, stage){
            var isValidSoFar= helper.validateStage(component,event,helper,stage.label);
            if (!isValidSoFar){
                notValidSatge +=stage.label + ',';
            }
            return notValidSatge;
        },'');
        
        // var isValid= helper.validateStage(component,event,helper,currentStage);
        if($A.util.isEmpty(isAllValid)){            
            if(!$A.util.isEmpty(subscriptionName.trim())){  
                helper.Save(component,event,helper); 
            }else{
                component.set("v.subscriptionName",'');                
                component.find('subscriptionNameValue').focus();
                component.find('subscriptionNameValue').showHelpMessageIfInvalid();
            } 
        }
        else{
            //helper.showToast('error',"Error","Please select all the fields to progress to the next dimension") ;
            // helper.showToast('error',"Error","Please fill "+currentStage+" before proceed to save");
            helper.showToast('error',"Error","Please fill "+ isAllValid.substr(0,isAllValid.lastIndexOf(",")) +" before proceed to save");
        }
        
    },
    //Method used to handle Progress Indicator button Click
    handleCiickOnSelectedStage : function(component,event,helper){
        var subscriptionName=component.get("v.subscriptionName");
        var clickIndex = event.getParam('index');
        var stageList=component.get('v.steps');
        var getCurrentStep=parseInt(component.get("v.selectedStage"));
        var currentStage=stageList[getCurrentStep-1].label;
        if(clickIndex+1>getCurrentStep)
        {   
            var remainingStageList=[];
            for(var i=0;i<clickIndex;i++){
             remainingStageList.push(stageList[i]);                
            }
            
            let isAllValid = remainingStageList.reduce(function(notValidSatge, stage){
                var isValidSoFar= helper.validateStage(component,event,helper,stage.label);
                if (!isValidSoFar){
                    notValidSatge +=stage.label + ',';
                }
                return notValidSatge;
            },'');
            
            if($A.util.isEmpty(isAllValid)){ 
                if(!$A.util.isEmpty(subscriptionName.trim())){
                    stageList=component.get('v.steps');
                    component.set("v.selectedStage", stageList[clickIndex].value); 
                    component.set("v.currentStageName", stageList[clickIndex].label); 
                    if(stageList.length=== parseInt(component.get("v.selectedStage"))){
                        component.set("v.lastStage",true);
                    }
                    else{
                        component.set("v.lastStage",false);
                    }
                }else{
                    component.set("v.subscriptionName",'');                
                    component.find('subscriptionNameValue').focus();
                    component.find('subscriptionNameValue').showHelpMessageIfInvalid();
                } 
                
            }
            else{
                
                helper.showToast('error',"Error","Please fill "+ isAllValid.substr(0,isAllValid.lastIndexOf(",")) + "  before proceed to another stage.") ;
            } 
        }
        else{
            
            component.set("v.selectedStage", stageList[clickIndex].value); 
            component.set("v.currentStageName", stageList[clickIndex].label); 
            if(stageList.length=== parseInt(component.get("v.selectedStage"))){
                component.set("v.lastStage",true);
            }
            else{
                component.set("v.lastStage",false);
            }
        }
        
    },
    //handle cancel button click for closing tab
    handleCancel : function(component, event, helper) { 
        helper.closeTab(component, event, helper);
    },
    onTabClosed : function(component, event, helper) { 
        /* var navService = component.find("navService");
        var pageReference = {    
            "type": "standard__objectPage",
            "attributes": {
                "objectApiName": "CH_NotificationSubscription__c",
                "actionName": "list"
            },
            "state": {
                "filterName": "All"
            }
        }
        // Uses the pageReference definition in the init handler
        //event.preventDefault();
        navService.navigate(pageReference);*/
    },
    handleReset : function(component, event, helper){
        
        // var clickIndex = event.getParam('index');
        
        var stageList=component.get('v.steps');
        
        var getCurrentStep=parseInt(component.get("v.selectedStage"));
        var currentStage=stageList[getCurrentStep-1].label;  
        var data=component.get("v.notificationSubscription");
        var details=component.get("v.notificationSubscriptionDetails");
        
        switch(currentStage) {
            case 'Geographic Dimension':
                var dimension = component.find('geoDimension');
                
                if(component.get("v.recordId")){
                    helper.getPropertiesForGeographicDimension(component, event, helper,data,details);}
                dimension.resetMethod("reset");
                
                break;
            case 'Account Dimension':
                var dimension = component.find('accountDimension');
                if(component.get("v.recordId") != null && component.get("v.recordId") != '' && component.get("v.recordId") != undefined){
                    helper.getPropertiesForAccountDimension(component, event, helper,data,details);}
                
                dimension.resetMethod("reset");
                
                break; 
            case 'Product Dimension':
                var dimension = component.find('productDimension');
                dimension.resetMethod("reset");
                break;
            case 'Event Subscription':
                var dimension = component.find('eventSubscription');
                if(component.get("v.recordId") != null && component.get("v.recordId") != '' && component.get("v.recordId") != undefined){
                    helper.getPropertiesForEventSubscription(component, event, helper,data,details);}
                dimension.resetMethod("reset");
                break;
            case 'Workgroup Dimension':
                var dimension = component.find('wgDimension');
                if(component.get("v.recordId") != null && component.get("v.recordId") != '' && component.get("v.recordId") != undefined){
                    helper.getPropertiesForWorkgroupDomain(component, event, helper,data,details);}
                dimension.resetMethod("reset");
                
                break;
                
            default:
                
                
        }
    },
    showToolTip : function(component,event,helper) {
        component.set("v.tooltip",true);
        
    },
    HideToolTip : function(component,event,helper){
        component.set("v.tooltip",false);
    }
})
({
   getCustomSettingsForNotification: function(component,event,helper){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getCustomSettingsForNotification',{}));
        });           
        return promise; 
    },
    
    
    //For Cancel button click close the current tab
    closeTab : function(component,event,helper) {  
        
        var notificationId= component.get('v.notificationId');  
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response,event) {
            var focusedTabId = response.tabId;                         
            workspaceAPI.closeTab({tabId: focusedTabId}).then(function(response,event) {
                console.log(response);
            })
        })
        .catch(function(error) {
            console.log(error);
        });   
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
            //var pageReference = component.get("v.pageReference");
            event.preventDefault();
            navService.navigate(pageReference);  */
        
    },
    //Validate stage before proceed to next step or previous step
    validateStage : function(component,event,helper,currentStage){
        //We need to change the code when all stage will developed
        
        var isValid=true;
        switch(currentStage) {
            case 'Workgroup Dimension':
                
                var selectedWorkgroup=component.get("v.selectedWorkgroup").length;                
                var selectedAllWorkgroup = component.get("v.isWorkgroup");
                if((!selectedAllWorkgroup && selectedWorkgroup == 0)){
                    isValid=false;
                }
                break;    
            case 'Geographic Dimension':
                
                var selectedCountry=component.get("v.selectedCountry").length;
                var selectedAllRegion = component.get("v.isRegion");
                var selectedAllCountry = component.get("v.isCountry");
                var selectedRegion = component.get("v.selectedRegion").length;
                console.log('selectedCountry--'+selectedCountry);
                console.log('selectedAllCountry--'+selectedAllCountry);
                if((!selectedAllRegion && selectedRegion==0) || (!selectedAllCountry && selectedCountry == 0)){
                    isValid=false;
                }
                break;
            case 'Product Dimension':
                var selectedAllBGs= component.get("v.selectedAllBGs");
                var selectedAllBUs = component.get("v.selectedAllBUs");
                var SelectedproductList = component.get("v.SelectedproductList").length;
                var selectedBGs = component.get("v.selectedBGs").length;
                var selectedBUs = component.get("v.selectedBUs").length;
                var isAllProductsSelected = component.get("v.isAllProductsSelected");
                
                if(SelectedproductList==0 && !isAllProductsSelected){
                    isValid=false;
                }
                
                break;
            case 'Account Dimension':
                var accountType=component.get("v.accountType");                                
                var isLegalChecked= component.get("v.isLegalAccountChecked");
                var selectedAccount=component.get("v.selectedAccount").length;
                
                if((isLegalChecked == false && selectedAccount == 0 && accountType == 'Legal Account') || (selectedAccount ==0 && accountType == 'Parent Account') || accountType == undefined){
                    isValid=false;
                } 
                break;
            case 'Event Subscription':
                var eventTypeList = component.get("v.eventTypeList").length;
                var notificationMode = component.get("v.notificationMode");
                var checkedAllEventType = component.get("v.checkedAllEventType");
                if((checkedAllEventType == false && eventTypeList == 0) || notificationMode == ''){
                    isValid=false;
                }
                break;    
                
            default:
                
        }
        return isValid;
    },   
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    },
    
    
    //Save Notification SUbscriptions
    Save: function(component, event, helper){
        component.set("v.Spinner",true);
        var recordId=component.get("v.recordId");
        var notificationSubscription= this.setProperties(component, event, helper);        
        var notificationSubscriptionChild= this.setPropertiesForDetails(component, event, helper);        
        let action = component.get('c.saveNotificationSubscription');
        action.setParams({strNotificationSubscription: JSON.stringify(notificationSubscription),
                          strNotificationId:recordId,
                          strdeleteNotificationSubscriptionDetails:JSON.stringify(component.get("v.deleteNotificationSubscriptionDetails")),
                          strNotificationSubscriptionDetails:JSON.stringify(notificationSubscriptionChild),	
                          strNotificationSubscriptionChild:JSON.stringify(component.get("v.notificationSubscriptionChild"))
                         }                                           
                        );        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var returnValue=response.getReturnValue();
                component.set('v.notificationId',returnValue);              
                this.showToast('success',"Success"," Data saved successfully.") ;
                component.set("v.Spinner",false);                
                this.closeTab(component); 
                
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Notification Subscriptions: '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                component.set("v.Spinner",false);
            }
        })
        $A.enqueueAction(action);      
    },
    
    //setProperties for Notification subscription different dimensions
    setProperties: function(component, event, helper){          
        var notificationSubscription={};
        var recordId=component.get("v.recordId");
        if (recordId){
            notificationSubscription.Id= recordId;
        }
        else{
            notificationSubscription.RecordTypeId=component.get("v.recordTypeId");
        }
        notificationSubscription.Name=component.get("v.subscriptionName").trim();
        
        //Geographic Dimention property assignment
        var isRegionAll=component.get("v.isRegion");
        if(isRegionAll){
            notificationSubscription.CH_Region__c='ALL'; 
        }
        else{
            var selectedRegionList=component.get("v.selectedRegion"); 
            var selectedRegion='';
            selectedRegionList.forEach(function(item) {            
                selectedRegion +=item + ';';        
            }); 
            notificationSubscription.CH_Region__c=selectedRegion.substr(0,selectedRegion.lastIndexOf(";"));
        }                
        var isCountryAll=component.get("v.isCountry");
        if(isCountryAll){
            notificationSubscription.CH_Country__c='ALL'; 
        }
        else{
            notificationSubscription.CH_Country__c='';   
        }
        
        //Account Dimension property assignment
        
        var accountType=component.get("v.accountType");
        if(accountType=='Legal Account'){
            notificationSubscription.CH_ParentAccount__c='';
            var isLegalAccountChecked=component.get("v.isLegalAccountChecked");
            if(isLegalAccountChecked){
                notificationSubscription.CH_LegalEntityAccount__c='ALL';                               
            }
            else{
                notificationSubscription.CH_LegalEntityAccount__c='';      
            }            
        }
        else if(accountType=='Parent Account') {
            notificationSubscription.CH_ParentAccount__c='';
            notificationSubscription.CH_LegalEntityAccount__c='';                                    
        }
        
        //Product Dimension property assignment
        var isSelectedAllBGs=component.get("v.selectedAllBGs");
        if(isSelectedAllBGs){
            notificationSubscription.CH_BusinessGroup__c='ALL'
        }
        else{
            var selectedBGsList=component.get("v.selectedBGs"); 
            var selectedBGs='';
            selectedBGsList.forEach(function(item) { 
                selectedBGs +=item + ';';
            }); 
            notificationSubscription.CH_BusinessGroup__c=selectedBGs.substr(0,selectedBGs.lastIndexOf(";"));         
        }                       
        var selectedAllBUs=component.get("v.selectedAllBUs");
        if(selectedAllBUs){
            notificationSubscription.CH_BusinessUnit__c='ALL'
        }
        else{
            var selectedBUsList=component.get("v.selectedBUs"); 
            var selectedBUs='';
            selectedBUsList.forEach(function(item) { 
                selectedBUs +=item + ';';
            }); 
            notificationSubscription.CH_BusinessUnit__c=selectedBUs.substr(0,selectedBUs.lastIndexOf(";"));   
        }
        var isAllProductsSelected=component.get("v.isAllProductsSelected");
        if (isAllProductsSelected){
            notificationSubscription.CH_Product__c='ALL';
        }
        else{
            notificationSubscription.CH_Product__c='';
        }
        //Event Subscription property assignment
        var checkedAllEventType=component.get("v.checkedAllEventType");
        if (checkedAllEventType){
            notificationSubscription.CH_EventType__c="ALL"  ;
        }
        else{
            notificationSubscription.CH_EventType__c=component.get("v.eventTypeList");
        }        
        notificationSubscription.CH_NotificationMode__c=component.get("v.notificationMode"); 
        //Workgroup Domain property assignment
        var recordTypeName=component.get("v.recordTypeName")
        if(recordTypeName=="CH_Workgroup_Domain"){
            var isAllWorkgroupCheck=component.get("v.isWorkgroup");
            if(isAllWorkgroupCheck){
                notificationSubscription.CH_Workgroup__c='ALL';
            }
            else
            {
                notificationSubscription.CH_Workgroup__c=''; 
            }                                    
        }
        return notificationSubscription;
    },
    //setProperties for Notification subscription Details different dimensions
    setPropertiesForDetails: function(component, event, helper){                  
        var notificationSubscriptionChild=[];                
        //Geographic Dimention property assignment
        var isCountryAll=component.get("v.isCountry");
        if(!isCountryAll){
            var selectedCountry=component.get("v.selectedCountry");        
            if(selectedCountry.length>0){                    
                selectedCountry.forEach(function(item) {
                    notificationSubscriptionChild.push({"CH_AttributeRecordID__c":item.Id,"CH_AttributeCode__c":item.Name,"CH_AttributeName__c":item.Country_Name_c,"CH_AttributeType__c":"Country"});                           
                })
            }     
        }
        //Account Dimension property assignment        
        var accountType=component.get("v.accountType");
        if(accountType=='Legal Account'){
            var selectedAccount=component.get("v.selectedAccount");
            if(selectedAccount.length>0){                    
                selectedAccount.forEach(function(item) {
                    notificationSubscriptionChild.push({"CH_AttributeRecordID__c":item.Id,"CH_AttributeCode__c":item.AccountNumber,"CH_AttributeName__c":item.Name,"CH_AttributeType__c":"Legal Entity Account"});                           
                })
            }            
        }   
        else if(accountType=='Parent Account'){
            var selectedAccount=component.get("v.selectedAccount");
            if(selectedAccount.length>0){                    
                selectedAccount.forEach(function(item) {
                    notificationSubscriptionChild.push({"CH_AttributeRecordID__c":item.Id,"CH_AttributeCode__c":item.AccountNumber,"CH_AttributeName__c":item.Name,"CH_AttributeType__c":"Parent Account"});                           
                })
            }            
        }
        //Product Dimension property assignment
        var selectedProductList=  component.get("v.SelectedproductList");
        if(selectedProductList.length>0){                    
            selectedProductList.forEach(function(item) {
                notificationSubscriptionChild.push({"CH_AttributeRecordID__c":item.Id,"CH_AttributeCode__c":item.ProductCode,"CH_AttributeName__c":item.Name,"CH_AttributeType__c":"Product"});                           
            })
        }     
        //Workgroup Domain data table property assignment
        var recordTypeName=component.get("v.recordTypeName")
        if(recordTypeName=="CH_Workgroup_Domain"){
            var selectedWorkgroup=  component.get("v.selectedWorkgroup");
            if(selectedWorkgroup.length>0){                    
                selectedWorkgroup.forEach(function(item) {
                    notificationSubscriptionChild.push({"CH_AttributeRecordID__c":item.Id,"CH_AttributeCode__c":'',"CH_AttributeName__c":item.Name,"CH_AttributeType__c":"Workgroup"});                           
                })
            }   
        }
        
        component.set("v.notificationSubscriptionChild",notificationSubscriptionChild);
        var tempDeleteArray=[];
        var details=component.get("v.notificationSubscriptionDetails");
        
        var insertArray =  notificationSubscriptionChild.filter( el =>
                                                                !details.some( f =>
                                                                              f.CH_AttributeRecordID__c === el.CH_AttributeRecordID__c && f.CH_AttributeType__c===el.CH_AttributeType__c
                                                                             )
                                                               );
        var deleteArray =  details.filter( el =>
                                          !notificationSubscriptionChild.some( f =>
                                                                              f.CH_AttributeRecordID__c === el.CH_AttributeRecordID__c && f.CH_AttributeType__c===el.CH_AttributeType__c
                                                                             )
                                         );
        
        if (notificationSubscriptionChild.length==0){
            insertArray.push({"CH_AttributeRecordID__c":'Default',"CH_AttributeCode__c":'Default',"CH_AttributeName__c":'Default',"CH_AttributeType__c":"Default"}) ;
        }
        component.set("v.deleteNotificationSubscriptionDetails",deleteArray);
        return insertArray;
    },
    //get Notification Subscriptions Data
    getNotificationSubscription: function(component, event, helper,recordId){  
        component.set("v.Spinner",true);
        let action = component.get('c.getNotificationSubscriptionData');
        action.setParams({ notificationSubscriptionId: recordId}
                        );        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data=response.getReturnValue();
                component.set("v.Spinner",false);
                component.set("v.notificationSubscription",data); 
                var recordId=component.get("v.recordId");
                let action1 = component.get('c.getNotificationSubscriptionDetails');
                action1.setParams({ notificationSubscriptionId: recordId}
                                 );        
                action1.setCallback(this,function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var data=response.getReturnValue();
                        component.set("v.notificationSubscriptionDetails",data);                
                        this.getProperties(component, event, helper);                
                    }
                    else {
                        var errors = response.getError();                
                        this.showToast('error', 'Error','Notification Subscriptions Details: '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                    }
                    
                })
                $A.enqueueAction(action1);   
            }
            else {
                var errors = response.getError();                
                this.showToast('error', 'Error','Notification Subscriptions: '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                component.set("v.Spinner",false);
            }
            
        })
        $A.enqueueAction(action);       
    },
    //getProperties for Notification subscription different dimensions
    getProperties: function(component, event, helper){          
        var data=component.get("v.notificationSubscription");
        var details=component.get("v.notificationSubscriptionDetails");
        component.set("v.subscriptionName",data[0].Name); 
        //Geographic Dimension property assignment
        this.getPropertiesForGeographicDimension(component, event, helper,data,details);
        //Account Dimension property assignment
        this.getPropertiesForAccountDimension(component, event, helper,data,details);
        //Product Dimension property assignment
        this.getPropertiesForProductDimension(component, event, helper,data,details);
        //Event Subscription property assignment
        this.getPropertiesForEventSubscription(component, event, helper,data,details);
        //Workgroup Domain property assignment
        this.getPropertiesForWorkgroupDomain(component, event, helper,data,details);
        
        component.set("v.showStage",true);    
    },
    //Geographic Dimension property assignment
    getPropertiesForGeographicDimension: function(component, event, helper,data,details){ 
        component.set("v.selectedRegion",(data[0].CH_Region__c)?data[0].CH_Region__c.split(';'):[]);     
        var selectedRegion=component.get("v.selectedRegion");
        if (selectedRegion.length==1){
            if(selectedRegion[0]=='ALL'){
                component.set("v.isRegion",true);
                component.set("v.selectedRegion",[]); 
            }
            else{
                component.set("v.isRegion",false);
            }
        }
        if(data[0].CH_Country__c) {
            component.set("v.isCountry",true);
        }else{
            var selectedCountry =  details.filter(function(item) {
                return item.CH_AttributeType__c == 'Country';
            });
            component.set("v.selectedCountry",selectedCountry);
        }                        
        
    },
    //Account Dimension property assignment
    getPropertiesForAccountDimension: function(component, event, helper,data,details){ 
        
        if(data[0].CH_LegalEntityAccount__c){
            component.set("v.isLegalAccountChecked",true);
            component.set("v.accountType",'Legal Account');            
        }
        else{
            component.set("v.isLegalAccountChecked",false);
        }
        
        if(data[0].CH_ParentAccount__c){            
            component.set("v.accountType",'Parent Account');
        }           
        var selectedLegalAccount =  details.filter(function(item) {
            return item.CH_AttributeType__c == 'Legal Entity Account';
        }); 
        if(selectedLegalAccount.length>0){
            component.set("v.accountType",'Legal Account');
            component.set("v.selectedAccount",selectedLegalAccount);
        }
        var selectedParentAccount =  details.filter(function(item) {
            return item.CH_AttributeType__c == 'Parent Account';
        }); 
        if(selectedParentAccount.length>0){
            component.set("v.accountType",'Parent Account');
            component.set("v.selectedAccount",selectedParentAccount);
        }
        
    },
    //Product Dimension property assignment
    getPropertiesForProductDimension: function(component, event, helper,data,details){ 
        if(data[0].CH_BusinessGroup__c){
            var CH_BusinessGroup__c=data[0].CH_BusinessGroup__c;
            if (CH_BusinessGroup__c=='ALL'){
                component.set("v.selectedAllBGs",true);
            }
            else{
                component.set("v.selectedBGs",data[0].CH_BusinessGroup__c.split(';'));
            }            
        }        
        if(data[0].CH_BusinessUnit__c){           
            var CH_BusinessUnit__c=data[0].CH_BusinessUnit__c;
            if (CH_BusinessUnit__c=='ALL'){
                component.set("v.selectedAllBUs",true);
            }
            else{
                component.set("v.selectedBUs",data[0].CH_BusinessUnit__c.split(';'));
            }           
        }
        if(data[0].CH_Product__c){
            var isAllProductsSelected=data[0].CH_Product__c;
            if(isAllProductsSelected=='ALL'){
                component.set("v.isAllProductsSelected",true);
            }                      
        }        
        var selectedProductList =  details.filter(function(item) {
            return item.CH_AttributeType__c == 'Product';
        });
        component.set("v.SelectedproductList",selectedProductList);
    },
    //Event Subscription property assignment
    getPropertiesForEventSubscription: function(component, event, helper,data,details){ 
        component.set("v.eventTypeList",(data[0].CH_EventType__c)?data[0].CH_EventType__c:'');
        var eventTypeList=component.get("v.eventTypeList").split(';');
        if (eventTypeList.length==1){
            if(eventTypeList[0]=='ALL'){
                component.set("v.checkedAllEventType",true);
                component.set("v.eventTypeList",'');                
            }
            else{
                component.set("v.checkedAllEventType",false);
                component.get("v.eventTypeList");
            }
        }
        
        component.set("v.notificationMode",(data[0].CH_NotificationMode__c)?data[0].CH_NotificationMode__c:'');
    },
    //Workgroup Domain property assignment
    getPropertiesForWorkgroupDomain: function(component, event, helper,data,details){ 
        var recordTypeName=component.get("v.recordTypeName")
        if(recordTypeName=="CH_Workgroup_Domain"){            
            if(data[0].CH_Workgroup__c){
                var isAllWorkgroupCheck=data[0].CH_Workgroup__c;
                if(isAllWorkgroupCheck=='ALL'){
                    component.set("v.isWorkgroup",true);
                } 
                
            }
            else{
                component.set("v.isWorkgroup",false);
            }
            var selectedWorkgroup =  details.filter(function(item) {
                return item.CH_AttributeType__c == 'Workgroup';
            }); 
            component.set("v.selectedWorkgroup",selectedWorkgroup);
        }
    },
})
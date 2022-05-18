({
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.createProj",true);
        component.set("v.isOpen", true);
        
        
    },
    clearLookupvalues:function(component, event, helper) {
        console.log('I am here inside ligh cmppppp');
        //component.set("v.projectListResult",''); 
        this.removeProjectName(component, event, helper)
    },
    //NOKIASC-35962 | Start
    openEditModel: function(component) {
        component.set("v.isEditButtonClicked",true);
    },
    //NOKIASC-35962 | End
    doInit : function(component, event, helper){
        //helper.isTranslateRequired(component);
        var country= component.get("v.shippingCountry");
        
        //NOKIASC-34978
        var initValue = component.get("v.initialShipToPartyAccount");
        if(initValue != '' && initValue != null){
            if(initValue.HWS_AddressLineLocal1__c != undefined)
            component.set("v.showtranslateValue",$A.util.isEmpty(initValue.HWS_AddressLineLocal1__c)?false:true);
            component.set("v.projectName",initValue.Name);
            component.set("v.LocalShiptoPartyName",initValue.Legal_Name_Ext__c);
            component.set("v.projectAddr1", initValue.Hws_Address_Line_1__c);
            component.set("v.projectAddrLocal1", initValue.HWS_AddressLineLocal1__c);
            component.set("v.projectAddr2", initValue.Hws_Address_Line_2__c);
            component.set("v.projectAddrLocal2", initValue.HWS_AddressLineLocal2__c);
            component.set("v.projectAddr3", initValue.Hws_Address_Line_3__c);
            component.set("v.projectAddrLocal3", initValue.HWS_AddressLineLocal3__c);
            component.set("v.projectCity", initValue.BillingCity +', '+initValue.BillingState + ', '+initValue.BillingCountry+', '+ initValue.BillingPostalCode);
            component.set("v.ShippingCity",initValue.ShippingCity+', '+ initValue.ShippingState+', '+
                initValue.ShippingCountry+', '+ initValue.ShippingPostalCode);
            component.set("v.shipToPartyAccount", initValue);         
            var projectSelected = { 'currentworkingTitleId' : initValue.Id, 
                                   'currentworkingTitleName' : initValue.Name
                                  };
            var projectListResult = component.get("v.projectListResult");
            if(projectListResult != undefined && projectListResult.length==0 )
            	projectListResult.push(projectSelected);
            component.set("v.projectListResult",projectListResult);
            $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
            
        }
        
    },
    shipToPartyError : function(component, event, helper){
        var inputCmp = component.find("strNameAcc");
        //alert('inputCmp1'+inputCmp);
        inputCmp.set("v.value",null); //alert('inputCmp*'+inputCmp);
        inputCmp.set("v.errors", [{message:"Error message"}]);
        
        
    },
    dosearchProject : function(component,event,helper){
        
        // Get the search string, input element and the selection container
        var searchString = component.get('v.strSearchProjectName');
        
        var inputElement = component.find('strNamePilot');
        var contactList  = component.get("v.projectList");
        var lookupList   = component.find('lookuplistPilot');
        var objectName = component.get("v.objectName");
        var returnValue = component.get("v.returnValue");
        //var lookupList = component.find('lookuplist');
        
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        //Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        // Create an Apex action
        var action = component.get('c.findContactListFromConsole');   //('c.getContactlistNameBased');
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        //alert("searchString(setting in class)-->"+searchString);
        // Set the parameters
        action.setParams({ "searchKey" : searchString,
                          "objectName" : objectName,
                          "returnValue" : returnValue
                         });
        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert("state-->"+state);
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var projectList = response.getReturnValue();
                
                //alert(JSON.stringify(projectList));
                
                // If we have no matches, return nothing
                if (projectList.length === 0)
                {
                    component.set('v.projectList', null);
                    //component.set('v.strSearchContactName','');
                    return;
                }
                // Store the results
                component.set('v.projectList', projectList);
                // alert('**'+JSON.stringify(projectList));
                //component.set('v.contactList', contactList);
                //component.set('v.strSearchContactName','');
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        //this.displayToast('Error', errors[0].message);
                        //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                        //helper.displayToast(component,'Deal Request',errors[0].message,'error');
                        // alert("Error-->"+errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                    //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                    //  helper.displayToast(component,'Deal Request','Unknown error.','error');
                    // alert("Error : Unknown error.");
                }
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action);                
        
    },
    
    dosearchShiptoParty : function(component,event,helper){
        
        // Get the search string, input element and the selection container
        var searchString = component.get('v.strSearchProjectName');
        var selectedAsset = component.get("v.SelectedAsset");
        var inputElement = component.find('strNamePilot');
        var contactList  = component.get("v.projectList");
        var lookupList   = component.find('lookuplistPilot');
        var objectName = component.get("v.objectName");
        var returnValue = component.get("v.returnValue");
        var pickupAdd = component.get("v.pickupAddr");
        var legalAccRec = component.get('v.passingAccount');
        //NK
       var CountryName = component.get('v.CountryName');
    
        var jsonAcc = JSON.stringify(legalAccRec);
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        //test
        var regularExpression;
        //Added regular expression for Basic Latin,Latin-1 Supplement,Latin Extended-A,Latin Extended-B            
        var regex = new RegExp(/^([\u0000-\u007f\u0080-\u00ff\u0100-\u017f\u2000-\u206f]*)$/g);   
        
        if(regex.test(searchString) ){
            component.set("v.isEnglish",true);   
        }
        else{
            component.set("v.isEnglish",false);   
        }                
        //test
        //Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        // Create an Apex action
        var action = component.get('c.searchShiptoParty');   //('c.getContactlistNameBased');
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        //alert("searchString(setting in class)-->"+searchString);
        // Set the parameters
        action.setParams({ "searchKey" : searchString,
                          "objectName" : objectName,
                          "returnValue" : returnValue,
                          "parentAccountValue" : component.get("v.otherValues"),
                          "addrType" : pickupAdd,
                          "selectedAsset" : selectedAsset,
                          "legalAccRec" : jsonAcc,
                          "triggeredFrom" : component.get("v.triggeredFrom"),
                          "lineItemCountry" : component.get("v.shippingCountry"),
                          "isEnglish":component.get("v.isEnglish"),
                          "CountryName" : component.get("v.CountryName")
                         });
        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var projectList = response.getReturnValue();
                
                // If we have no matches, return nothing
                if (projectList.length === 0)
                {
                    component.set('v.projectList', null);
                    return;
                }
                // Store the results
                component.set('v.projectList', projectList);				
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        //this.displayToast('Error', errors[0].message);
                        //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                        //helper.displayToast(component,'Deal Request',errors[0].message,'error');
                        //alert("Error-->"+errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                    //helper.alertTostFun(component,'There is some error, please contact to System Admin.','error');
                    //  helper.displayToast(component,'Deal Request','Unknown error.','error');
                    //alert("Error : Unknown error.");
                }
            }
        });
        
        // Enqueue the action                  
        $A.enqueueAction(action);                
        
    },
	
	// Logic to add communication contact - fix 37940
    selectProjectNameCC:function(component,event,helper){
        
        var objectId = event.currentTarget.dataset.id;
        component.set("v.projectId",objectId);
        var projList =component.get('v.projectList');
        for(var i=0;i<projList.length;i++){
            var projectSelected =projList[i];
            var objectLabel = '';            
            if(projectSelected.currentworkingTitleId==objectId){                
                objectLabel = projectSelected.currentworkingTitleName;
                component.set("v.projectName",objectLabel);
                break;
                // return;
            }
        }
        
        var projectsId = component.get("v.projectsId");
        component.set("v.strSearchProjectName",'');
        component.set("v.projectsId",'');
        var lookupList = component.find('lookuplistPilot');
        $A.util.addClass(lookupList, 'slds-hide');
        
        $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        var projectListResult = component.get("v.projectListResult");
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        projectListResult.push(projectSelected);
        component.set("v.projectListResult",projectListResult);        
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : objectId,
            "objectNameId" : component.get("v.objectName"),
            "shipToPartyAccount" : component.get("v.shipToPartyAccount")
        });
        cmpEvent.fire();
        
    },
    
    
    selectProjectName:function(component,event,helper){
        
        var objectId = event.currentTarget.dataset.id;
        component.set("v.projectId",objectId);
        var projList =component.get('v.projectList');
        
        for(var i=0;i<projList.length;i++){
            var projectSelected =projList[i];
            var objectLabel = '';            
            if(projectSelected.currentworkingTitleId==objectId){                
                objectLabel = projectSelected.currentworkingTitleName;
                component.set("v.projectName",objectLabel);
                component.set("v.projectAddr1", projectSelected.addressLine1);
                component.set("v.projectAddr2", projectSelected.addressLine2);
                component.set("v.projectAddr3", projectSelected.addressLine3);
                component.set("v.projectCity", projectSelected.cityStateCountry);
                //NOKIASC-35951:Display ad hoc address and translated address on the case creation screen                
                component.set("v.showtranslateValue",$A.util.isEmpty(projectSelected.shipToPartyAccount.HWS_AddressLineLocal1__c)?false:true);
                component.set("v.projectAddrLocal1", projectSelected.addressLineLocal1);
                component.set("v.projectAddrLocal2", projectSelected.addressLineLocal2);                                
                component.set("v.projectAddrLocal3", projectSelected.addressLineLocal3);                                
                component.set("v.ShippingCity",projectSelected.shippingcityStateCountry);
                component.set("v.LocalShiptoPartyName",projectSelected.localShiptoPartyName);
                //End
                component.set("v.shipToPartyAccount", projectSelected.shipToPartyAccount);
                break;
                // return;
            }
        }
        
        var projectsId = component.get("v.projectsId");
        component.set("v.strSearchProjectName",'');
        component.set("v.projectsId",'');
        var lookupList = component.find('lookuplistPilot');
        $A.util.addClass(lookupList, 'slds-hide');
        
        $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        var projectListResult = component.get("v.projectListResult");
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        projectListResult.push(projectSelected);
        component.set("v.projectListResult",projectListResult);        
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : objectId,
            "objectNameId" : component.get("v.objectName"),
            "shipToPartyAccount" : component.get("v.shipToPartyAccount")
        });
        cmpEvent.fire();
        
    },
    removeProjectName:function(component,event,helper){
        component.set('v.sldscls', 'slds-hide');//NOKIASC-35962
        $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');  
        var objectId = event.currentTarget.dataset.id;
        var objectLabel = event.currentTarget.innerText;
        //console.log('objectId--'+objectId+'===objectLabel'+objectLabel);
        var projectList = component.get("v.projectListResult");
        
        var projectSelected = new Array();
        var projectSelected = { 'currentworkingTitleId' : objectId, 
                               'currentworkingTitleName' : objectLabel
                              };
        
        //lstTeamMembers.push(teamMemberSelected);
        
        for(var iSelMem=0;iSelMem<projectList.length;iSelMem++){
            var projectSelected =projectList[iSelMem];
            //console.log('teamMemberSelected.contactId:'+teamMemberSelected.contactId+'===objectId:'+objectId);
            if(projectSelected.currentworkingTitleId==objectId){
                projectList.splice(iSelMem,1);
            }
        }
        
        component.set("v.projectListResult",projectList); 
        component.set("v.projectId",'');
        component.set("v.projectName",'');
        component.set("v.projectAddr1",'');
        component.set("v.projectAddr2",'');
        component.set("v.projectAddr3",'');
        component.set("v.projectCity",'');
        //NOKIASC-35951:Display ad hoc address and translated address on the case creation screen
        component.set("v.projectAddrLocal1", '');
        component.set("v.projectAddrLocal3",'');
        component.set("v.projectAddrLocal2",'');
        component.set("v.ShippingCity",'');
        component.set("v.LocalShiptoPartyName",'');
        //NOKIASC-38434:Default value set for parameter(isEnableRight,isTranslationRequired,sldscls)|Start
        component.set("v.isEnableRight",false);
        component.set("v.sldscls",'slds-hide');
        component.set("v.isTranslationRequired",false);
        //NOKIASC-38434:Default value set for parameter(isEnableRight,isTranslationRequired,sldscls)|End        
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : '',
            "objectNameId" : component.get("v.objectName")
        });
        cmpEvent.fire();
        
    },
    handleComponentEvent : function(component, event, helper){
        var objectId = event.getParam("ParentRecordId");
        var objectLabel = event.getParam("ParentRecordName");
        var ObjectnameId = event.getParam("Objectname");
        var shipToPartyAccount = event.getParam("shipToPartyAccount");
        if(objectLabel == 'canceled'){
            component.set("v.createProj",false);
            component.set("v.isOpen", false);
        }
        else{
            component.set("v.createProj",false);
            component.set("v.isOpen", false);
            var addr1 = event.getParam("AddrLine1");
            var addr2 = event.getParam("AddrLine2");
            var addr3 = event.getParam("AddrLine3");
            var citystatecountry = event.getParam("CityStateCountry");
            var objectId1 = component.get('v.projectId');
            var objectLabel1 = component.get('v.projectName');
            var projectList = component.get("v.projectListResult");
            
            var projectSelected = new Array();
            var projectSelected = { 'currentworkingTitleId' : objectId1, 
                                   'currentworkingTitleName' : objectLabel
                                   
                                  };
            
            //lstTeamMembers.push(teamMemberSelected);
            var enableRight = event.getParam("isChecked");
            var isTranslationRequired = event.getParam("translationRequired");
            component.set('v.isEnableRight',enableRight);
            component.set('v.sldscls', 'slds-show');
            component.set("v.isTranslationRequired",isTranslationRequired);
            //helper.isTranslateRequired(component);
            for(var iSelMem=0;iSelMem<projectList.length;iSelMem++){
                var projectSelected =projectList[iSelMem];
                //console.log('teamMemberSelected.contactId:'+teamMemberSelected.contactId+'===objectId:'+objectId);
                if(projectSelected.currentworkingTitleId==objectId1){
                    projectList.splice(iSelMem,1);
                }
            }
            
            component.set("v.projectListResult",projectList); 
            
            component.set("v.projectId",objectId);
            
            var projectsId = component.get("v.projectsId");
            component.set("v.projectName",objectLabel);
            //NOKIASC-35951--Add value from return result 
            component.set("v.projectAddr1",shipToPartyAccount.Hws_Address_Line_1__c);
            component.set("v.projectAddr2",shipToPartyAccount.Hws_Address_Line_2__c);
            component.set("v.projectAddr3",shipToPartyAccount.Hws_Address_Line_3__c);
            //NOKIASC-38448:Check the value of State/Province field for ad hoc address
       		var projectCity=shipToPartyAccount.BillingCity+','+ ((typeof(shipToPartyAccount.BillingState) == "undefined")?'':shipToPartyAccount.BillingState)+','+
                shipToPartyAccount.BillingCountry+','+ shipToPartyAccount.BillingPostalCode; 
            component.set("v.projectCity",projectCity.replace(',,',','));
            component.set("v.strSearchProjectName",'');
            component.set("v.projectsId",'');
            //NOKIASC-35951:Display ad hoc address and translated address on the case creation screen            
            component.set("v.projectAddrLocal1",shipToPartyAccount.HWS_AddressLineLocal1__c);
            component.set("v.projectAddrLocal3",shipToPartyAccount.HWS_AddressLineLocal3__c);
            component.set("v.projectAddrLocal2",shipToPartyAccount.HWS_AddressLineLocal2__c);
            //NOKIASC-38448:Check the value of State/Province field for ad hoc address
       		var ShippingCity=shipToPartyAccount.ShippingCity+','+ ((typeof(shipToPartyAccount.ShippingState) == "undefined")?'':shipToPartyAccount.ShippingState)+','+
                shipToPartyAccount.ShippingCountry+','+ shipToPartyAccount.ShippingPostalCode;
            component.set("v.ShippingCity",ShippingCity.replace(',,',','));            
            component.set("v.LocalShiptoPartyName",shipToPartyAccount.Legal_Name_Ext__c);
            component.set("v.showtranslateValue",$A.util.isEmpty(shipToPartyAccount.HWS_AddressLineLocal1__c)?false:true);
            var lookupList = component.find('lookuplistPilot');
            $A.util.addClass(lookupList, 'slds-hide');
            
            $A.util.addClass(component.find('idSearchboxPilotSeries'),'slds-hide');
            var projectListResult = component.get("v.projectListResult");
            var projectSelected = new Array();
            var projectSelected = { 'currentworkingTitleId' : objectId, 
                                   'currentworkingTitleName' : objectLabel
                                  };
            projectListResult.push(projectSelected);
            component.set("v.projectListResult",projectListResult);
            var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
            
            cmpEvent.setParams({
                "ParentRecordId" : objectId,
                "objectNameId" : ObjectnameId,
                "shipToPartyAccount" : shipToPartyAccount
                
            });
            cmpEvent.fire();
        }
        
    },
    createRecord : function(component, event, helper){
        component.set("v.createProj",true);
        
    },
    
    //added for bug  HWST-3544:
    removeShiptoPartyMethod:function(component,event,helper){
        // alert('removeShiptoPartyMethod');
        $A.util.removeClass(component.find('idSearchboxPilotSeries'),'slds-hide');
        component.set("v.projectListResult",[]); 
        component.set("v.projectId",'');
        component.set("v.projectName",'');
        component.set("v.projectAddr1",'');
        component.set("v.projectAddr2",'');
        component.set("v.projectAddr3",'');
        component.set("v.projectCity",'');
		component.set("v.projectAddrLocal1", '');
        component.set("v.projectAddrLocal3",'');
        component.set("v.projectAddrLocal2",'');
        component.set("v.ShippingCity",'');
        component.set("v.LocalShiptoPartyName",'');
        //NOKIASC-38434:Default value set for parameter(isEnableRight,isTranslationRequired,sldscls)|Start
        component.set("v.isEnableRight",false);
        component.set("v.sldscls",'slds-hide');
        component.set("v.isTranslationRequired",false);
        //NOKIASC-38434:Default value set for parameter(isEnableRight,isTranslationRequired,sldscls)|End
        var cmpEvent = component.getEvent("HWS_LookupReturnValueEvent");
        cmpEvent.setParams({
            "ParentRecordId" : '',
            "objectNameId" : component.get("v.objectName")
        });
        cmpEvent.fire();
    },
    //Ends here
    //NOKIASC-36305
    handleSelectedCountry:function(component,event,helper){
        if(component.get('v.CountryName') !=''){
            component.set("v.disableLink", '');
            component.set("v.shippingCountry",component.get('v.CountryName') );
        }        
        else
        	component.set("v.disableLink", "cursor: not-allowed; color: gray;");
        
    },
    //NOKIASC-36305
    openModelwithCoutry:function(component,event,helper){
        if(component.get("v.CountryName") != undefined && component.get('v.CountryName') !=''){
            component.set("v.createProj",true);
            component.set("v.isOpen", true);
        }        
    }
    
})
({
    getSalutationPickListValues : function(component, event) {
        
        var action = component.get("c.getPickListValues");
        action.setParams({ obj:"Contact",str:"Salutation"});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stringItems = response.getReturnValue();
                
                component.set("v.options", stringItems);
                this.getDefaultvalues(component, event);
                
            }
        });
        $A.enqueueAction(action);
    },    
    getDefaultvalues : function(component, event) {
        if(component.get("v.objectName")=='Contact'){
            var action = component.get("c.getDefaultvalues");
            action.setParams({ accountId : component.get("v.otherValues")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var stringItems = response.getReturnValue();
                    component.find("otherLabel").set("v.value", stringItems.Name);
                    component.set("v.AccountDetails",stringItems.Id);
                    
                }
            });
            $A.enqueueAction(action);
        }
        
        
    },
    getValidation : function(component, event){
        
        var validation = true;
        var lastName = component.find('lastNameId').get("v.value");
        var Email = component.find('EmialId').get("v.value");
        var Phone = component.find('PhoneId').get("v.value");
        
        if(Email == null || Email == '' || Email == undefined){
            validation = false;
            component.find('EmialId').showHelpMessageIfInvalid();
        }
        if(lastName == null || lastName == '' || lastName == undefined){
            validation = false;
            component.find('lastNameId').showHelpMessageIfInvalid();
        }
        if(Phone == null || Phone == '' || Phone == undefined){
            validation = false;
            component.find('PhoneId').showHelpMessageIfInvalid();
        }
        
        return validation;
    },
    //Ship to party creation Screen validation 
    getShiptoPartyValidation : function(component, event){
        var validation = true;
        var shipPtyName = component.find('shipPartyName').get("v.value");
        var addressLine = component.find('addressLine1').get("v.value");
        var billingCity = component.find('Billcityid').get("v.value");
        var postalCode = component.find('postalcodeid').get("v.value");
        if(shipPtyName == null || shipPtyName == '' || shipPtyName == undefined){
            validation = false;
            component.find('shipPartyName').showHelpMessageIfInvalid();
        }
        if(addressLine == null || addressLine == '' || addressLine == undefined){
            validation = false;
            component.find('addressLine1').showHelpMessageIfInvalid();
        }
        if(billingCity == null || billingCity == '' || billingCity == undefined){
            validation = false;
            component.find('Billcityid').showHelpMessageIfInvalid();
        }
        if(postalCode == null || postalCode == '' || postalCode == undefined){
            validation = false;
            component.find('postalcodeid').showHelpMessageIfInvalid();
        }
        this.HandleAddressChange(component, event);       
        return validation;
    },
    //Ship to party Country and State fields logic 
    fetchPicklistValues: function(component,objDetails,controllerField, dependentField) {
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name] -
        // to server side function 
        action.setParams({
            'objDetail' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                
                // create a empty array for store map keys(@@--->which is controller picklist values) 
                var listOfkeys = []; // for store all map keys (controller picklist values)
                var ControllerField = []; // for store controller picklist value to set on lightning:select. 
                
                // play a for loop on Return map 
                // and fill the all map key on listOfkeys variable.
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                
                //set the controller field value for lightning:select
                if (listOfkeys != undefined && listOfkeys.length > 0) {
                    ControllerField.push('--None--');
                }
                
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                
                // set the ControllerField variable values to country(controller picklist field)
                component.set("v.listControllingValues", ControllerField);
                var country=component.get("v.shippingCountry");
                
                if(country!=null){
                    component.find("countryCodeId").set("v.value",country);
                    component.controllerFieldChange();
                }
                else
                    component.find("countryCodeId").set("v.disabled",false);    
            }else{
                //  alert('Something went wrong..');
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push('--None--');
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push(ListOfDependentFields[i]);
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);
        
    },
    //NOKIASC-35956:Add Toggle button with a specific name for Ad hoc ship to address creation  
    isTranslateRequired : function(component, event) {        
        var action = component.get("c.getTranslateRequiredValue");
        action.setParams({countryname:component.get("v.shippingCountry")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var isoCountry = response.getReturnValue();
                component.set("v.isTranslationRequired",isoCountry.Translation_Required__c);
                component.set("v.languageCode",isoCountry.Language_Code__c); 
                this.checkUserAccess(component, event);
            }
        });
        $A.enqueueAction(action);
    },
    //NOKIASC-35956:Add Toggle button with a specific name for Ad hoc ship to address creation    
    //NOKIASC-35958:Ad hoc address input in local characters+ toggle for latin characters input validation
    HandleAddressChange: function(component, event) {
        if(component.get("v.isTranslationRequired")){
            var addline1 =component.find('addressLine1').get("v.value");
            var addline2 =component.find('addressLine2').get("v.value");
            var addline3 =component.find('addressLine3').get("v.value");
            var fullAddr=addline1+addline2+addline3;
            fullAddr=fullAddr.replace(/\s/g, ''); 
            var regularExpression;
            //Added regular expression for Basic Latin,Latin-1 Supplement,Latin Extended-A,Latin Extended-B            
            var regex = new RegExp(/^([\u0000-\u007f\u0080-\u00ff\u0100-\u017f\u2000-\u206f]*)$/g);
            component.set("v.isInputWrong",false);   
            if(component.get("v.translationRequiredTo")=='Latin'){
                if(regex.test(fullAddr) && !$A.util.isEmpty(fullAddr)){
                    component.set("v.isInputWrong",true);   
                }
            }
            else if(component.get("v.translationRequiredTo")=='Local'){                
                if(!regex.test(fullAddr) && !$A.util.isEmpty(fullAddr)){
                    component.set("v.isInputWrong",true);   
                }
            }
        }
        else{
            component.set("v.isInputWrong",false); 
        }
    },
    //NOKIASC-35958:Ad hoc address input in local characters+ toggle for latin characters input
    checkUserAccess : function(component, event) {        
        var action = component.get("c.isPortalUser");
        action.setParams({});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var isPortalUser = response.getReturnValue();
                component.set("v.latinInput",isPortalUser?false:true);
                var translationRequiredTo=component.get('v.latinInput')?'Local':'Latin';
                component.set("v.translationRequiredTo" , translationRequiredTo);
            }
        });
        $A.enqueueAction(action);
    },

})
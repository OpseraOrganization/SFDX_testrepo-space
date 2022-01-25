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
        
    }
    
})
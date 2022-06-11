({
    // load all related accounts in a data table
    myAction : function(component, event, helper) {         
        //helper.getContactType(component, event);
        helper.setTabIcon(component);
		//helper.getContactNameParentAccount(component, event);
        //helper.getContactName(component, event);
        helper.getRelatedAccounts(component, event);
        //helper.getParentAccount(component, event);
        //helper.getFailureOccurrencePickListValues(component, event);
        //helper.getFailureDetectionPickListValues(component, event);
        //helper.getFailureDescriptionPickListValues(component, event);
        
    },
    
    //store selected accounts in a variable
    processSelectedAccount: function (component, event) {       
        var selectedRows = event.getParam('selectedRows');       
        var contactName =  component.get("v.contactName"); 
        //var parentAccountId = component.get("v.parentAccountId");
        component.set("v.selectedAccount", selectedRows);
        var legalEntities = component.get("v.selectedAccount");  
        console.log('legalEntities====>'+legalEntities);
        console.log('legalEntities====>111'+JSON.stringify(legalEntities));
        
        //4125
        console.log('--controller 23 CH_Account_Name_Alias__c--'+legalEntities[0].CH_Account_Name_Alias__c);
        console.log('25'+component.get('v.showAccountNameAlias'));
        if((legalEntities[0].CH_Account_Name_Alias__c !=null && legalEntities[0].CH_Account_Name_Alias__c !='' && legalEntities[0].CH_Account_Name_Alias__c !=undefined)){
            component.set("v.showAccountNameAlias",true);
        }
        else{
            component.set("v.showAccountNameAlias",false);
        }
        
        console.log('30'+component.get('v.showAccountNameAlias'));
        if(component.get('v.showAccountNameAlias')){
            component.set('v.accountNameAlias', (legalEntities[0].CH_Account_Name_Alias__c !=null && legalEntities[0].CH_Account_Name_Alias__c !='' && legalEntities[0].CH_Account_Name_Alias__c !=undefined)?legalEntities[0].CH_Account_Name_Alias__c:'');
        }
        if(legalEntities && legalEntities.length) {
            component.set("v.AccountName", legalEntities[0].Name);
            var test = legalEntities[0].AccountNumber;
            console.log('test==='+test);
            var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
            cmpEvent.setParams({
                "selectedRecId" : legalEntities[0].Id,
                "showSection" : 1,
                "accountName" : legalEntities[0].Name,
                "selectedAccountNumber": legalEntities[0].AccountNumber,
                "legalListAccount" : legalEntities
            });
            cmpEvent.fire();
        }
        else{            
            var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
            cmpEvent.setParams({
                "selectedRecId" : null,
                "showSection" : 1,
                "accountName" : null,
                "selectedAccountNumber": null,
                "legalListAccount" : null
            });
            cmpEvent.fire();
        }
    },
    //Method to Filter Accounts
    filterAccounts: function(component, event, helper) {
        var action = component.get("v.AllAccounts"),
            AccountNameFilter = component.get("v.AccountFilterText"),
            results = action, regex; 
        try {
            regex = new RegExp(AccountNameFilter, "i");
            // filter checks each row, constructs new array where function returns true
            results = action.filter(
                row => regex.test(row.Name) || 
                regex.test(row.AccountNumber) ||
                regex.test(row.CH_ParentAccountName__c) ||
                regex.test(row.OperationalCustomerName__c)
            );
        } catch(e) {
            
            // invalid regex, use full list
        }
        component.set("v.conAccounts", results);
        var selectedAcc = component.get("v.selectedAccount");
        if(selectedAcc == null || selectedAcc == undefined || selectedAcc ==''){
            component.set("v.showAccountNameAlias", false);
            var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");
            cmpEvent.setParams({
                "selectedRecId" : null,
                "showSection" : 1,
                "accountName" : null,
                "legalListAccount" : null
            });
            cmpEvent.fire();
        }
        
    },
    clearSelection : function (component, event, helper) {
        console.log("abcd...");
        var stageNumber = component.get('v.StageNumber');
        if(stageNumber === 1){
            console.log("abcd11...");
            component.find("inputFieldsToCheck").set("v.selectedRows", new Array());            
        }
        var cmpEvent = component.getEvent("HWS_CaseFlowEventPortal");            
        cmpEvent.setParams({                       
            "showSection" : 1,
            "selectedRecId" : null,
        });
        cmpEvent.fire(); 
       
        
    }
})
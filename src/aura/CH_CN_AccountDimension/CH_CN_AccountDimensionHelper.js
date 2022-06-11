({
    //Initialize data table
    setAccountTable : function (component,event,helper){        
        component.set('v.AccountColumns', [
            {label: 'Account Name', fieldName: 'Name', type: 'text',sortable: 'true',searchable: 'true'},
            {label: 'Account Number', fieldName: 'AccountNumber', type: 'text',sortable: 'true',searchable: 'true' }
        ]); 
    },
    initializeDataTable : function(component,event,helper,AccountList){        
        helper.setAccountTable(component, event, helper);                
        component.set("v.allData", AccountList);                         
    },
    //Get account records
    getAccounts : function(component,event,helper) {
        var accountTypeValue;
        var searchString;
        var accountType =component.get("v.accountType");
        if(accountType=="Parent Account"){
            accountTypeValue='customer';
            searchString =component.get("v.searchParentKeyword");            
        }
        else if(accountType=="Legal Account"){
            accountTypeValue='Legal Entity';
            searchString =component.get("v.searchLegalKeyword");            
        }  
        if(searchString==undefined || searchString=='' || searchString.length<3){
           this.showToast('Warning','Warning Message','Please enter minimum 3 characters');
        }
        
        else{    
            component.set("v.isSpinner",true);
            component.set("v.showTable",false);
            var action1 = component.get("c.getAccounts");            
            action1.setParams({
                searchString : searchString,
                accountTypeValue :accountTypeValue,
                legalEntitySearchLimit:component.get("v.LegalEntitySearchLimit")
            });
            action1.setCallback(this, function(response){
                var state1 = response.getState();
                if (state1 === "SUCCESS") {                    
                    //Create array for date table
                    var AccountList=response.getReturnValue();
                    if(AccountList.length>0){
                        if(AccountList.length>component.get("v.LegalEntitySearchLimit")) {                            
                            this.showToast('warning', 'Warning Message','Only the first '+ component.get("v.LegalEntitySearchLimit") + ' records are displayed. Please refine your search, if needed.');                            
                            AccountList.pop();
                        }                       
                        //call data table       
                        this.initializeDataTable(component,event,helper,AccountList); 
                        component.set("v.firstTimeLoad",false);                       
                        component.set("v.showTable",true);
                        // this.initializationPagination(component, helper);                
                    }
                    else{                        
                        this.showToast('warning','Warning Message','There are no Accounts with selected values');
                        component.set("v.showTable",false);
                    }
                }
                else {
                    var errors = response.getError();                
                    this.showToast('error', 'Error','Notification Subscriptions: '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");
                    
                }
                component.set("v.isSpinner",false);
            });
            $A.enqueueAction(action1);
        }
        
        
    },    
    //reset account details
    resetAccDetails: function (component, event, helper) {          
        component.set("v.showTable", false);
        component.set("v.searchLegalKeyword",'');
        component.set("v.FilterText", '');
        component.set("v.selection", []);
        component.set("v.selectedAccount",[]);
        component.set("v.tempSelection",[]);
        component.set("v.allData",[]);
        component.set("v.FilterText",'');
        component.set("v.searchLegalKeyword",'');
        component.set("v.searchParentKeyword",'');
        var accountType =component.get("v.accountType");
        if(accountType=="Parent Account"){
            component.set("v.maxRows",1);
        }
        else if(accountType=="Legal Account"){
            component.set("v.maxRows",10000);
        }  
    },
    //Generic Toast message
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
    displayAlertMessage : function(component, event, helper){
        var msg ='All Selected values will reset if All is checked';        
        if (!confirm(msg)) {
            component.set("v.isLegalChecked",false);
            return false;
        } else {
            
            component.set("v.showTable",false);
            helper.resetAccDetails(component, event, helper);
        }
    },
    resetNewAccDetails : function(component, event, helper){
        //component.set("v.accountType",'Parent Account');
        component.set("v.isLegalChecked",false);
        this.resetAccDetails(component, event, helper);
    }
})
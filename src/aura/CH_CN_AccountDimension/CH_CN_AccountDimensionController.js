({
    
    init: function(component, event, helper) { 
       
        try {
            var recordId=component.get("v.recordId");
           
            if(recordId){
                
                var accountType=component.get("v.accountType");           
                var isLegalChecked=component.get("v.isLegalChecked");
                if(accountType != "Legal Account"){              
                    component.set("v.maxRows",1);
                }  
                var selectedAccount=component.get("v.selectedAccount");
                if(selectedAccount.length){
                    component.set("v.showTable",false);
                    var allSelectedRows=[];
                    var selectedAccountList=[];
                    selectedAccount.forEach(function(row) {
                        allSelectedRows.push(row.CH_AttributeRecordID__c);
                        selectedAccountList.push({"Id":row.CH_AttributeRecordID__c,"Name":row.CH_AttributeName__c,"AccountNumber":row.CH_AttributeCode__c});
                    });
                    component.set("v.selectedAccount", selectedAccountList);
                    component.set("v.selection", allSelectedRows); 
                    helper.initializeDataTable(component,event,helper,selectedAccountList); 
                    //call data table
                    //helper.initializationPagination(component, helper); 
                    component.set("v.showTable",true);
                    // component.find("tblList").set("v.selectedRows",component.get("v.selection"));
                }
                if(isLegalChecked){
                    helper.resetAccDetails(component, event, helper);
                }
            }
            else{
                component.set("v.isSpinner",false);
     
               helper.resetNewAccDetails(component,event,helper);
                
            }
        } catch (e) {
            // Handle error
            console.error(e);
            helper.showToast('error','Error:','Account Dimension - '+e.message);            
        } 
    },
   
    //handle click event when click on All checkbox for Legal Account
    handleAllLegal : function(component, event, helper) {        
        if(component.get("v.isLegalChecked") === true){
            if(component.get("v.showTable") == true){
                helper.displayAlertMessage(component, event, helper);
            }
            else{          
                component.set("v.showTable",false);
            }          
        }       
    },
    //handle event when toggle through legal entity and customer
    onChangeAccountRadioButton: function (component,event, helper) {        
        var btnRadioValue=event.getSource().get("v.value");          
        var isAccountSelected =component.get("v.selectedAccount");
        var isConfirmation =isAccountSelected.length===0?'':"Selected account data will be removed if you toggle to other Account";        
        if(!isConfirmation){
            helper.resetAccDetails(component,event, helper);
        }
        else
        {
            if (!confirm(isConfirmation)) {  
                if(btnRadioValue=="Parent Account"){
                    btnRadioValue="Legal Account";
                }
                else if(btnRadioValue=="Legal Account"){
                    btnRadioValue="Parent Account";
                }                
                component.set("v.accountType",btnRadioValue); 
                return false;
            } 
            else
            {    
                helper.resetAccDetails(component,event, helper);
            }            
        }
    },    
    //method used to search legal account when click search button
    searchAcc: function(component, event, helper){
        
       /* var buttonClickID=null;
        var keyCode = event.keyCode ;
        if(keyCode){
            
            if(keyCode!==13){
                return false;
            }
        }else{
            buttonClickID =event.getSource().getLocalId();     
        }  */                      
        if(event.keyCode === 13){// || buttonClickID=='btnParentSearch' ||buttonClickID== "btnLegalSearch"){
           	component.set("v.FilterText",'');                
            helper.getAccounts(component, event, helper);
         } 
    },
    searchAccount : function(component,event,helper){
        if(component.find("btnParentSearch").get("v.label") == "Search" || component.find("btnLegalSearch").get("v.label") == "Search"){
           component.set("v.FilterText",'');                
            helper.getAccounts(component, event, helper);
        }
    }   
})
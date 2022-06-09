({ 
    //Initialize component when first load or refresh
    init: function (component,event,helper) {  
        component.set("v.dockedSectionClass","panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-open slds-has-focus");
        var SValue='This is default text in body.</br></br></br><b>Escalation Instructions.</b>';
        component.set("v.dockedSectionBody",SValue);         
        
        helper.init(component,event,helper,false);
    },
    //sorting funtion for data table
    updateColumnSorting: function (component, event, helper) {
        component.set('v.isSpinner', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout($A.getCallback(function() {
            var tableId=event.getSource().getLocalId();
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            component.set("v.sortedByValue", fieldName);
            component.set("v.sortedDirectionUser", sortDirection);
            helper.sortData(component,helper, fieldName, sortDirection,tableId);
            component.set('v.isSpinner', false);
        }), 0);
        
    },
    //NOKIASC-31275:Handle Complete Selected button click ,this method will called whenever we click Complete Selected button
    handleCompleteSelected: function(component, event, helper) { 
        var selectionReferral = component.get("v.selectionReferral");
        if(selectionReferral.length===0){
            helper.showToast('error','ERROR','Select at least one row ')  ;
        }
        else{
            component.set("v.isSpinner", true);
            helper.changeInternalStatus(component, event, helper,selectionReferral).then(function(result){
                helper.init(component, event, helper,true);
                component.set("v.isSpinner", false);
            });
        }
    },
    
    //Handle row action ,this method will called whenever we click any button inside datatable
    handleRowAction : function(component, event, helper) {                
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Complete_Action':
                component.set("v.isSpinner", true);
                var selectedRow=[];
                selectedRow.push(row);
                helper.changeInternalStatus(component, event, helper,selectedRow).then(function(result){
                    helper.init(component, event, helper,true);
                    component.set("v.isSpinner", false);
                });
                break;
            case 'View_Action':
                if(row.HWS_LogisticNodeCode__c) {
                    var headerLabel=row.HWS_LogisticNodeName__c +'( '+ row.HWS_LogisticNodeCode__c + ' ) - Escalation Instructions' ;
                    component.set("v.dockedSectionHeader",headerLabel);  
                }
                //NOKIASC-31236:This method is uesd get Escalation Instruction from SOO calout
                helper.GetEscalationInstruction(component, event, helper,row);
                /*.then(function(result){
                    component.set("v.showDocked", true);
                    component.set("v.isSpinner", false);
                });   */             
                
                break;
            default:
                break;
        }
    },
    //Handle row  selection action ,this method will called whenever we click checkbox in datatable.
    handleRowSelectionOnReferral: function(component, event, helper) {  
        var allSelectedRows=[];
        var allSelectionRows =[];        
        var selectedRows = event.getParam('selectedRows');
        
        selectedRows.forEach(function(row) {
            if(row.CH_InternalStatus__c=='Pending Referral Instruction'){
                allSelectionRows.push(row.Id);
                allSelectedRows.push(row);
            }                         
        });   
        
        component.set("v.selection",allSelectionRows); 
        component.set("v.selectionReferral", allSelectedRows);                  
    },
    //This method just for POC purpose,have not used anywhere
    getAllUtilityInfo : function(component, event, helper) {
        try{ 
            var editEvent = $A.get("e.notes:editNote");
            //editEvent.setStorable(false);
            editEvent.setParams({
                "noteId": '0690100000016iQAAQ',
                "editNoteEnabled":"false"
            });
            editEvent.fire();           
        }
        catch (e) {
            // Handle error
          //  console.error(e); NOKIASC-36296
            
        } 
    },
    //handle click on docked panel minimize icon button
    minimizeDocker: function(component, event, helper){        
        component.set("v.dockedSectionClass","panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-closed slds-has-focus");
        component.set("v.isInsideButtonClicked",true);
        component.set("v.isModal",false);
    },
    //handle click on docked panel maximize icon button
    maximizeDocker: function(component, event, helper){           
        var isModal=component.get("v.isModal");
        component.set("v.isModal",isModal?false:true);
        component.set("v.dockedSectionClass",isModal?"panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-open slds-has-focus":"slds-modal slds-fade-in-open slds-docked-composer-modal");
        component.set("v.isInsideButtonClicked",true);        
    },
    //handle click on docked panel Close icon button
    closeDocker: function(component, event, helper){
        component.set("v.showDocked",false);
        component.set("v.isModal",false);
        component.set("v.isInsideButtonClicked",false);
        component.set("v.dockedSectionClass","panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-open slds-has-focus");
    },
    //handle click on docked panel header toggle button
    maximizeMinimizeDocker: function(component, event, helper){        
        if(!component.get("v.isInsideButtonClicked")){            
            var isModal=component.get("v.isModal");
            if(isModal){                
                component.set("v.isModal",false);
                var cmpSection = component.find('dockedSection');
                component.set("v.dockedSectionClass",'panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-open slds-has-focus');            
            }
            else{
                var cmpSection = component.find('dockedSection');
                $A.util.toggleClass(cmpSection, 'panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-open slds-has-focus');
                $A.util.toggleClass(cmpSection, 'panel scrollable slds-docked-composer slds-grid slds-grid_vertical slds-is-closed slds-has-focus');                
            }            
        }
        else{
            component.set("v.isInsideButtonClicked",false);
        }        
    },   
})
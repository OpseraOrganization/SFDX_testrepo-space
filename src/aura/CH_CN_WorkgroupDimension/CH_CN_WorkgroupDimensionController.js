({
      init: function (component,event,helper) {
        var notificationDetailId = component.get("v.recordId");
        var params = event.getParam('arguments');
        
        if(notificationDetailId){          
            helper.resetEditWGDetails(component,event,helper);            
        }
        else{
            
            helper.resetWGDimension(component,event,helper);           
        }
        component.set("v.isSpinner",false);
    },

    searchWorkgroup: function(component, event, helper) {
        if (event.keyCode === 13) {                            
                var tempSelection=component.get("v.tempSelection");
                component.set("v.selection", tempSelection);
                component.set("v.toggleSelectedItem",false);                                                   
            component.set("v.disabledWprkgroup",false);
            //component.set("v.hasPageChanged", false);
            helper.getWorkgroups(component, event, helper);
            
        }
        
    },
    
    handleWorkgroup: function(component,event,helper){
        
        // helper.resetDetails(component,event,helper);
        
        if(component.get("v.isWorkgroup") === true){
            if(component.get("v.showTable")== true){
                helper.displayWorkgroupAlert(component,event,helper);
            }
            else{
                component.set("v.searchWorkgroup",true);
                component.set("v.showSearch",true);
               // component.set("v.isWorkgroup",true);
                
            }
        }
        
        
        
        else{
            component.set("v.searchWorkgroup",false);
            component.set("v.showSearch",false);
        }
    },
    
    
    
    search: function(component, event, helper){
        
        var tempSelection=component.get("v.tempSelection");
        component.set("v.selection", tempSelection);
        //component.set("v.toggleSelectedItem",false); 
        // component.set("v.hasPageChanged", false);
        helper.getWorkgroups(component, event, helper);
    },
    allDataSelectFromTable : function(component, event, helper) {   
        component.set("v.triggeredFromAllPrdCheckBox", true);
        component.set('v.ModalSpinner', true);
        var workgroupList = [];
        if(!component.get("v.toggleSelectedItem")){
            workgroupList = component.get("v.allFilterData");            
        }
        else{                
            workgroupList = component.get("v.seledctedFilterData");
        }
        
        var selectedWorkgroup=component.get("v.selectedWorkgroup");
        var allSelectedRows=component.get("v.selection");            
        //alert('12--'+workgroupList.length);
        workgroupList.forEach(function(row) {
            allSelectedRows.push(row.Id); 
            selectedWorkgroup.push(row);
        });
        helper.initializationPagination(component, helper);
        component.set('v.ModalSpinner', false);
        
    }, 
})
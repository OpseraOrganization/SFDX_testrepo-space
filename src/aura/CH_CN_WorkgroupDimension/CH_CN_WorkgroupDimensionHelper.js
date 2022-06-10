({
    setWorkgroupTable : function (component,event,helper){        
        component.set('v.WorkgroupColumns', [           
            {label: 'Workgroup Name', fieldName: 'Name', type: 'text',sortable: 'true',searchable: 'true' },
            {label: 'Workgroup Type', fieldName: 'CH_Type__c', type: 'text',sortable: 'true',searchable: 'true' },
            {label: 'Level Of Support', fieldName: 'CH_Level_Of_Support__c', type: 'text',sortable: 'true',searchable: 'true' }
        ]); 
    },
   
  setWorkgroups : function(component,event,helper,savedWorkgroupIdsLst){
        var action1 = component.get("c.setWorkgroupList");
        component.set("v.showTable",false);
        action1.setParams({
            workgroupID : savedWorkgroupIdsLst
            
        });
        action1.setCallback(this, function(response){
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                
                component.set("v.isSpinner",false);
                component.set("v.currentPageNumber",1);                
                component.set("v.totalRecords", response.getReturnValue().length);
                //Create array for date table
                var workgroupList=response.getReturnValue();
                if(workgroupList !=null && workgroupList !='' && workgroupList!=undefined){
                    for(var i = 0; i < workgroupList.length; i++) {                       
                        workgroupList.Name=workgroupList[i].Name;
                        workgroupList.CH_Type__c=workgroupList[i].CH_Type__c;
                        workgroupList.CH_Level_Of_Support__c=workgroupList[i].CH_Level_Of_Support__c;
                    } 
                    //call data table                              
                    this.setWorkgroupTable(component,event,helper);
                    //component.set("v.showTable",true);
                    component.set("v.disabledAllworkgroup",false);
                    component.set("v.searchWorkgroup",false);
                    component.set("v.showSearch",false);    
                    component.set("v.allData", workgroupList);
                    if(component.get("v.recordId")){      
                        var allSelectedRows=[];
                        workgroupList.forEach(function(row) {                 
                            allSelectedRows.push(row.Id); 
                            
                        });
                        
                        component.set("v.selectedWorkgroup",workgroupList);
                        component.set("v.selection", allSelectedRows);
                    } 
                    component.set("v.showTable",true);
                }
                
            }
            
        });
        $A.enqueueAction(action1);
        
    },  
    
    getWorkgroups : function(component,event,helper) {
        var searchValue = component.get("v.searchKeyword");
        component.set("v.showTable",false);
        component.set("v.isSpinner",true);
        var action1 = component.get("c.getWorkgroups");        
        action1.setParams({
            searchWorkgroup: searchValue
        });
        action1.setCallback(this, function(response){
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                
                component.set("v.isSpinner",false);

                //Create array for date table
                var workgroupList=response.getReturnValue();
                if(workgroupList !=null && workgroupList !='' && workgroupList!=undefined){
                    for(var i = 0; i < workgroupList.length; i++) {
                        workgroupList.Name=workgroupList[i].Name;
                        workgroupList.CH_Type__c=workgroupList[i].CH_Type__c;
                        workgroupList.CH_Level_Of_Support__c=workgroupList[i].CH_Level_Of_Support__c;                       						
                    } 
                    //call data table                              
                    this.setWorkgroupTable(component,event,helper);
                    component.set("v.allData", workgroupList); 
                    /*if(component.get("v.recordId")){    //  
                        var allSelectedRows=[];
                        workgroupList.forEach(function(row) {                 
                            allSelectedRows.push(row.Id); 
                            
                        });
                        
                        component.set("v.selectedWorkgroup",workgroupList);
                        component.set("v.selection", allSelectedRows);
                    }*/ //
                    component.set("v.firstTimeLoad",false);
                    component.set("v.showTable",true);
                }
                else{
                    
                    this.showToast('info','Info','There are no workgroups with selected values');
                    component.set("v.showTable",false);
                }
            }
            
        });
        $A.enqueueAction(action1);
    },    
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
    displayWorkgroupAlert: function(component,event,helper){
        var msg ='All Selected values will reset if All is checked';
        
        if (!confirm(msg)) {
            component.set("v.isWorkgroup",false);
            console.log('No');
            return false;
        } else {
            
            component.set("v.searchWorkgroup",true);
            component.set("v.showSearch",true);
            component.set("v.showTable",false);
            component.set("v.searchKeyword",'');
            component.set("v.FilterText", '');
            component.set("v.WorkgroupList", []);
            component.set("v.selection", []);
            component.set("v.selectedWorkgroup",[]);
            component.set("v.tempSelection",[]);
            component.set("v.dummySelectedlist",[]);
            component.set("v.allData",[]);
        }
    },
    resetWGDimension : function(component,event,helper){
        	component.set("v.searchWorkgroup",false);
            component.set("v.showSearch",false);
            component.set("v.showTable",false);
            component.set("v.searchKeyword",'');
            component.set("v.FilterText", '');
            component.set("v.WorkgroupList", []);
            component.set("v.selection", []);
            component.set("v.selectedWorkgroup",[]);
            component.set("v.tempSelection",[]);
            component.set("v.dummySelectedlist",[]);
            component.set("v.allData",[]);
            component.set("v.isWorkgroup",false);
    },
    resetEditWGDetails: function(component,event,helper){
        var selectedWorkgroup = component.get("v.selectedWorkgroup");
        
        var savedWorkgroupIdsLst = selectedWorkgroup.map(function(value,index) { 
            return value["CH_AttributeRecordID__c"]; });	
        
        helper.setWorkgroups(component,event,helper,savedWorkgroupIdsLst);
        component.set("v.searchKeyword",'');
        if(component.get("v.isWorkgroup")){
            component.set("v.disabledAllworkgroup",false);
            component.set("v.searchWorkgroup",true);
            component.set("v.showSearch",true);
            component.set("v.showTable",false);
        }
        else{
            component.set("v.searchWorkgroup",false);
            component.set("v.showSearch",false);
           // component.set("v.showTable",true);
        }
    },
    
    
})
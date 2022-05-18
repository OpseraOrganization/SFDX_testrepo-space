({
    init: function(component, event, helper) {
        try {
            
            var data=component.get("v.allData");   
            helper.initializeDataTable(component,event,helper,data);
            helper.initializationPagination(component, helper);
            
            var selectedData=component.get("v.selectedData");            
            var allSelectedRows=[];
            selectedData.forEach(function(row) {
                allSelectedRows.push(row.Id);                    
            });
            component.set("v.selection", allSelectedRows);
            if(component.get("v.recordId") && component.get("v.firstTimeLoad") && allSelectedRows.length>0){
                component.set("v.firstTimeLoad",false); 
                component.set("v.initialLoad",false);
                component.set("v.toggleSelectedItem",true);
                var onToggleSelectedItemTrue = component.get('c.handleBtnChecked');
                $A.enqueueAction(onToggleSelectedItemTrue);
            }
            else{
                component.set("v.toggleSelectedItem",false);
            }
        } catch (e) {
            // Handle error
            console.error(e);
            helper.showToast('error','Error:',+e.message);            
        } 
    },
    //sorting funtion for data table
    updateColumnSorting: function (component, event, helper) {
        component.set('v.isSpinner', true);
        // We use the setTimeout method here to simulate the async
        // process of the sorting data, so that user will see the
        // spinner loading when the data is being sorted.
        setTimeout($A.getCallback(function() {
            var fieldName = event.getParam('fieldName');
            var sortDirection = event.getParam('sortDirection');
            component.set("v.sortedByValue", fieldName);
            component.set("v.sortedDirectionUser", sortDirection);
            helper.sortData(component,helper, fieldName, sortDirection);
            component.set('v.isSpinner', false);
        }), 0);
        
    },
    //data table pagination next button click
    onNext : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");     
        component.set("v.currentPageNumber", pageNumber+1);
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);                
        
    },
    //data table pagination Previous button click
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.currentPageNumber");
        component.set("v.currentPageNumber", pageNumber-1);  
        helper.initializationPagination(component, helper);
        if(component.get("v.currentPageNumber") !=component.get("v.totalPages")){
            component.set("v.NextPageNumber",0);
        }              
    },    
    //data table pagination First button click
    onFirst : function(component, event, helper) {        
        component.set("v.currentPageNumber", 1);        
        helper.initializationPagination(component, helper);           
    },    
    //data table pagination Last button click
    onLast : function(component, event, helper) {        
        component.set("v.currentPageNumber", component.get("v.totalPages"));     
        helper.initializationPagination(component, helper);
        component.set("v.PreviousPageNumber",0);                      
    },
    
    //handle event for filter results from  Data Table
    handleFilterOnDataTable : function(component, event, helper) {              
        var columns=component.get("v.columns");
        var columnName= columns.map(function(value,index) { return value["fieldName"]; });	
        var  data ,results = data;        
        var  searchString= component.get("v.FilterText");
        if(component.get("v.toggleSelectedItem")){           
            data = component.get("v.allSelectedData"); 
        }
        else{            
            data = component.get("v.allData");            
        }        
        try {             
            //filter data with coulmn names
            results = data.filter(row =>
                                  Object.keys(row).some(col =>
                                                        { 
                                                            if(columnName.indexOf(col)!==-1){
                                                            return row[col].toLowerCase().includes(searchString.toLowerCase())
                                                        }
                                                        }));
        }
        catch(e) { 
            results = data; 
        }
        if(component.get("v.toggleSelectedItem")){
            component.set("v.dummySelectedlist",results);
        }else{
            component.set("v.allFilterData", results);
        }
        component.set("v.currentPageNumber",1);
        component.set("v.filteringData",true);
        
        helper.initializationPagination(component, helper);
    },
    //handle wheever data table onrowselection event fired
    handleRowAction: function (component, event, helper) {        
        component.set('v.ModalSpinner', true);
        if(!component.get("v.hasPageChanged") || component.get("v.initialLoad")){
            component.set("v.hasPageChanged",false);
            component.set("v.initialLoad", false);  
            var selectedRows = event.getParam('selectedRows');                        
            var allSelectedRows = component.get("v.selection");
            var selectedDataList = component.get("v.selectedData");            
            component.set("v.tempSelectedData",selectedDataList);
            if(component.get("v.maxRows") == "1"){
                selectedRows.forEach(function(row) {                     
                    component.set("v.selection",row.Id);   
                    component.set("v.selectedData",row);    
                });
            }
            else{
                //Get current page number
                var currentPageNumber = component.get("v.currentPageNumber");
                var dataList =[];                
                dataList=component.get("v.data");                
                
                dataList.forEach(function(row) {
                    var rowDataIndex=allSelectedRows.map(function(e) { return e; }).indexOf(row.Id);
                    if(rowDataIndex!==-1){
                        allSelectedRows.splice(rowDataIndex, 1);
                    }
                    rowDataIndex=selectedDataList.map(function(e) { return e.Id; }).indexOf(row.Id);
                    if(rowDataIndex!==-1){
                        selectedDataList.splice(rowDataIndex, 1);
                    }
                });    
                var isValid= helper.handleMaxRowsSelections(component,event,helper,(selectedDataList.length+selectedRows.length));
                if (isValid){
                    selectedRows.forEach(function(row) {                 
                        allSelectedRows.push(row.Id); 
                        selectedDataList.push(row);
                    });
                    
                    component.set("v.selectedData",selectedDataList);
                    component.set("v.selection", allSelectedRows);
                }
                else{
                    allSelectedRows = [];
                    selectedDataList = []; 
                    var tempSelectedDataList= component.get("v.tempSelectedData");
                    tempSelectedDataList.forEach(function(row) {                 
                        allSelectedRows.push(row.Id); 
                        selectedDataList.push(row);
                    });
                    component.set("v.selectedData",selectedDataList);
                    component.set("v.selection", allSelectedRows);                    
                }
                
            }
            if(component.get("v.toggleSelectedItem")){
                var tempSelection=component.get("v.selection");
                component.set("v.tempSelection", tempSelection);
            }
            //helper.initializationPagination(component, helper); 
            component.set('v.ModalSpinner', false);
        } else{            
            component.set("v.hasPageChanged", false);
            component.set('v.ModalSpinner', false);            
        }        
    },
    //handle event whenever we toggle through my selection
    handleBtnChecked: function (component, event, helper) {
        component.set("v.FilterText",'');        
        component.set("v.allFilterData",component.get("v.allData"));
        component.set("v.toggleClicked",true);         
        if(component.get("v.toggleSelectedItem")){
            
            var tempSelection=component.get("v.selection");
            component.set("v.tempSelection", tempSelection);
            var selectedData=component.get("v.selectedData");
            component.set("v.allSelectedData",selectedData);            
            var allSelectedRows=[];
            selectedData.forEach(function(row) {
                allSelectedRows.push(row.Id);                
            });            
            component.set("v.selection", allSelectedRows);            
            component.set("v.currentPageNumber",1);                
            component.set("v.totalRecords", selectedData.length);   
            component.set("v.dummySelectedlist",selectedData);
            helper.initializationPagination(component, helper);           
        }
        else{            
            var allData = component.get("v.allData");
            var tempSelection=component.get("v.tempSelection");
            component.set("v.selection", tempSelection);            
            component.set("v.currentPageNumber",1);                
            component.set("v.totalRecords", allData.length);            
            helper.initializationPagination(component, helper);             
        }               
    },
    
    handleSelectDeselect: function(component, event, helper){ 
        component.set('v.ModalSpinner', true);
        var filterSelectedData;
        var buttonClickID =event.getSource().getLocalId(); 
        if(component.get("v.toggleSelectedItem")){
            filterSelectedData=   component.get("v.dummySelectedlist");
        }else{
            filterSelectedData=     component.get("v.allFilterData");
        }
        if(buttonClickID=='btnSelectAll') {
            var allSelectedRows = component.get("v.selection");
            var selectedDataList = component.get("v.selectedData");
            component.set("v.tempSelectedData",selectedDataList);
            filterSelectedData.forEach(function(row) {
                var rowDataIndex=allSelectedRows.map(function(e) { return e; }).indexOf(row.Id);
                if(rowDataIndex===-1){
                    allSelectedRows.push(row.Id);
                }
                rowDataIndex=selectedDataList.map(function(e) { return e.Id; }).indexOf(row.Id);
                if(rowDataIndex===-1){                    
                    selectedDataList.push(row);
                }
            });
            var isValid= helper.handleMaxRowsSelections(component,event,helper,selectedDataList.length);
            if (isValid){
                component.set("v.selectedData",selectedDataList);
                component.set("v.selection", allSelectedRows); 
            }
            else{
                allSelectedRows = [];
                selectedDataList = []; 
                var tempSelectedDataList= component.get("v.tempSelectedData");
                tempSelectedDataList.forEach(function(row) {                 
                    allSelectedRows.push(row.Id); 
                    selectedDataList.push(row);
                });
                component.set("v.selectedData",selectedDataList);
                component.set("v.selection", allSelectedRows);                    
            }
            
            component.set("v.initialLoad", false);  

        }
        else if(buttonClickID=='btnDeselectAll') {
            var allSelectedRows = component.get("v.selection");
            var selectedDataList = component.get("v.selectedData");
            filterSelectedData.forEach(function(row) {
                var rowDataIndex=allSelectedRows.map(function(e) { return e; }).indexOf(row.Id);
                if(rowDataIndex!==-1){
                    allSelectedRows.splice(rowDataIndex, 1);
                }
                rowDataIndex=selectedDataList.map(function(e) { return e.Id; }).indexOf(row.Id);
                if(rowDataIndex!==-1){                                        
                    selectedDataList.splice(rowDataIndex, 1);
                }
            });                 
            component.set("v.selectedData",selectedDataList);
            component.set("v.selection", allSelectedRows);            
            component.set("v.initialLoad", false);  
        }
        if(component.get("v.toggleSelectedItem")){
            var tempSelection=component.get("v.selection");
            component.set("v.tempSelection", tempSelection);
        }
        component.set('v.ModalSpinner', false);
    }
    
})
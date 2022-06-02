({
    
    initializeDataTable : function(component,event,helper,dataList){
        var currentStage=component.get("v.currentStageName");
        var accountType=component.get("v.accountType"); 
        component.set("v.currentPageNumber",1);                
        component.set("v.totalRecords", dataList.length);
        component.set("v.allFilterData", dataList);                
        component.set("v.allData", dataList);                         
    },    
    // initialize pagination
    initializationPagination : function(component, helper) {        
        var data = [];
        var allData=[];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        if(!component.get("v.toggleSelectedItem")){
            allData = component.get("v.allFilterData");            
        }
        else{
            allData = component.get("v.dummySelectedlist");     
        }
        var x = (pageNumber-1)*pageSize;
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var count = component.get("v.totalRecords");         
        component.set("v.countofRecords",allData.length);
        if(component.get("v.currentPageNumber")==1){
            component.set("v.PreviousPageNumber",1);
            component.set("v.NextPageNumber",0);
        }
        component.set("v.totalPages", Math.ceil(allData.length/component.get("v.pageSize")));
        console.log('currentPageNumber:'+component.get("v.currentPageNumber")+'totalPages:'+component.get("v.totalPages"));
        if(component.get("v.currentPageNumber") ==component.get("v.totalPages")){
            component.set("v.NextPageNumber",1);
        }    
        //handle onrowselection logic for toggle/filter/pagination
        var oldDataList=component.get("v.data");
        var currentSelectedData=component.get("v.selectedData")
        component.set("v.hasPageChanged", false);
        if(component.get("v.filteringData")){
            if(currentSelectedData.length>0){
                var tempArray=[];
                var tempCheck=[];
                
                oldDataList.forEach(function(row) { 
                    var rowDataIndex=currentSelectedData.map(function(e) { return e.Id; }).indexOf(row.Id);                    
                    if(rowDataIndex!==-1){
                        tempArray.push(row.Id);
                    }
                });
                
                tempArray.forEach(function(row) {                    
                    var rowDataIndex=data.map(function(e) { return e.Id; }).indexOf(row);                    
                    if(rowDataIndex!==-1){
                        tempCheck.push(row.Id)
                    } 
                }); 
                if(tempCheck.length<tempArray.length){                                                        
                    component.set("v.hasPageChanged", true);                    
                }
            }
            component.set("v.filteringData",false);
        }
        else{
            if(!component.get("v.toggleClicked")){
                
                if(currentSelectedData.length>0){   
                    oldDataList.some(function(row){ 
                        var rowDataIndex=currentSelectedData.map(function(e) { return e.Id }).indexOf(row.Id);                    
                        if(rowDataIndex!==-1){
                            component.set("v.hasPageChanged", true);
                            return true;
                        };
                    });                    
                }
            }
            else{
                if(currentSelectedData.length>0){
                    var tempArray=[];
                    var tempCheck=[];
                    oldDataList.forEach(function(row) { 
                        var rowDataIndex=currentSelectedData.map(function(e) { return e.Id; }).indexOf(row.Id);                    
                        if(rowDataIndex!==-1){
                            tempArray.push(row.Id);
                        }
                    });
                    tempArray.forEach(function(row) {    
                        var rowDataIndex=data.map(function(e) { return e.Id; }).indexOf(row);                    
                        if(rowDataIndex!==-1){
                            tempCheck.push(row.Id)
                        } 
                    }); 
                    if(tempCheck.length !== tempArray.length){
                        component.set("v.hasPageChanged", true);                        
                    }
                }
                component.set("v.toggleClicked",false);
            }
        }        
        component.set("v.data", data);
        component.find("datatable").set("v.selectedRows",component.get("v.selection"));                
    },
    //sort data of data table
    sortData: function (component,helper, fieldName, sortDirection) {
        var data=[];
        if(!component.get("v.toggleSelectedItem")){
            data = component.get("v.allFilterData");            
        }
        else{
            data = component.get("v.dummySelectedlist");     
        }        
        var reverse = sortDirection !== 'asc';        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );                
        if(!component.get("v.toggleSelectedItem")){            
            component.set("v.allFilterData", data);
        }
        else{            
            component.set("v.dummySelectedlist", data);
        }        
        this.initializationPagination(component, helper);        
        
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };        
        return function (a, b) {            
            var A = key(a)? key(a).toLowerCase() : '';
            var B = key(b)? key(b).toLowerCase() : '';
            return reverse * ((A > B) - (B > A));
            
        };
    },   
    handleMaxRowsSelections : function(component, event, helper,selectedDataListLength){
        var isValid=true;
        var maxRowsCount=0;
        var currentStage=component.get("v.currentStageName");
        switch(currentStage) {
            case 'Geographic Dimension':
                var maxRowsCount=component.get("v.maxRowsCountry");                
                if (maxRowsCount<selectedDataListLength  && selectedDataListLength>component.get("v.tempSelectedData").length ){
                    isValid=false;
                }
                break;
            case 'Account Dimension':                
                var maxRowsCount=component.get("v.maxRowsAccount");                
                if (maxRowsCount<selectedDataListLength && selectedDataListLength>component.get("v.tempSelectedData").length){
                    isValid=false;
                }                                
                break; 
            case 'Product Dimension':
                var maxRowsCount=component.get("v.maxRowsProduct");                
                if (maxRowsCount<selectedDataListLength  && selectedDataListLength>component.get("v.tempSelectedData").length ){
                    isValid=false;
                }
                break;                
            case 'Workgroup Dimension':
                
                var maxRowsCount=component.get("v.maxRowsWorkgroup");                
                if (maxRowsCount<selectedDataListLength  && selectedDataListLength>component.get("v.tempSelectedData").length ){
                    isValid=false;
                }
                //component.set("v.maxRows",1000);                
                break;               
            default:
                //component.set("v.maxRows",1000);                
        }
        if (!isValid){  
            var currentStage=component.get("v.currentStageName");
            var accountType=component.get("v.accountType");
            if(currentStage==='Account Dimension' && accountType=='Legal Account' ){
                this.showToast('warning',"Warning","You can not select more than "+ maxRowsCount + " rows for "+ accountType + " .") ;
            }
            else
            {
                this.showToast('warning',"Warning","You can not select more than "+ maxRowsCount + " rows for "+ currentStage + " .") ; 
            }
            
        }
        return isValid;
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType,
            "duration":'10000',
            "mode": 'dismissible'
        });
        toastEvent.fire();
    },
    
})
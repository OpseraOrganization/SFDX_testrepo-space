({
    //Geographic Dimention
    // //initialize data table for Search Schedule per User
    setCountryTable : function (component,event,helper){        
        component.set('v.countryColumns', [
            {label: 'Country Name', fieldName: 'Country_Name_c', type: 'text',sortable: 'true',searchable: 'true'},
            {label: 'Country Code', fieldName: 'Name', type: 'text',sortable: 'true',searchable: 'true' },
            {label: 'Market', fieldName: 'Market_c', type: 'text',sortable: 'true',searchable: 'true' }
        ]); 
    },
    setCountries : function(component,event,helper,savedCountryIdsLst){
        var action1 = component.get("c.setCountriesList");
        component.set("v.showTable",false);
        component.set("v.isSpinner",true);
        action1.setParams({
            //  regions : component.get("v.selectedRegion"),
            //notificationId : component.get("v.recordId")
            countriesID : savedCountryIdsLst
            
        });
        action1.setCallback(this, function(response){
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                
                component.set("v.isSpinner",false);
                component.set("v.currentPageNumber",1);                
                component.set("v.totalRecords", response.getReturnValue().length);
                //Create array for date table
                var countryList=response.getReturnValue();
                if(countryList !=null && countryList !='' && countryList!=undefined){
                    for(var i = 0; i < countryList.length; i++) {
                        countryList.Country_Name_c=countryList[i].Country_Name_c;
                        countryList.Name=countryList[i].Name;
                        countryList.Market_c=countryList[i].Market_c;
                    } 
                    //call data table                              
                    this.setCountryTable(component,event,helper);
                    //component.set("v.showTable",true);
                    component.set("v.disabledAllCountry",false);
                    component.set("v.searchCountry",false);
                    component.set("v.showSearch",false);    
                    component.set("v.allData", countryList);
                    if(component.get("v.recordId")){      
                        var allSelectedRows=[];
                        countryList.forEach(function(row) {                 
                            allSelectedRows.push(row.Id); 
                            
                        });
                        
                        component.set("v.selectedCountry",countryList);
                        component.set("v.selection", allSelectedRows);
                    } 
                    component.set("v.showTable",true);
                }
                
            }
            
        });
        $A.enqueueAction(action1);
        
    },
    getCountries : function(component,event,helper) {
        var searchValue = component.get("v.searchKeyword");
     
        component.set("v.isSpinner",true);
        var action1 = component.get("c.getcountries");        
        action1.setParams({
            regions : component.get("v.selectedRegion"),
            searchCountry: searchValue
        });
        action1.setCallback(this, function(response){
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                
                component.set("v.isSpinner",false);
                component.set("v.currentPageNumber",1);
                component.set("v.totalRecords", response.getReturnValue().length);
                //Create array for date table
                var countryList=response.getReturnValue();
                if(countryList !=null && countryList !='' && countryList!=undefined){
                    component.set("v.showTable",false);
                    for(var i = 0; i < countryList.length; i++) {
                        countryList.Country_Name_c=countryList[i].Country_Name_c;
                        countryList.Name=countryList[i].Name;
                        countryList.Market_c=countryList[i].Market_c;
                    } 
                    //call data table                              
                    this.setCountryTable(component,event,helper);
                   // component.set('v.CountryList', countryList);                    
                    component.set("v.allData", countryList); 
                    component.set("v.firstTimeLoad",false);
                    component.set("v.showTable",true);
                }
                else{
                    this.showToast('warning','Warning Message','There are no Countries with selected values');
                    
                }
            }
            
        });
        $A.enqueueAction(action1);
    },
    getCountries2 : function(component,event,helper) {
        var searchValue = component.get("v.searchKeyword");
     
        component.set("v.isSpinner",true);
        var ids=new Array();
        ids.push('All');
        
        
        var action1 = component.get("c.getcountries");        
        action1.setParams({
            regions : ids,
            searchCountry: searchValue
        });
        action1.setCallback(this, function(response){
            var state1 = response.getState();
            if (state1 === "SUCCESS") {
                
                component.set("v.isSpinner",false);
                component.set("v.currentPageNumber",1);
                component.set("v.totalRecords", response.getReturnValue().length);
                //Create array for date table
                var countryList=response.getReturnValue();
                if(countryList !=null && countryList !='' && countryList!=undefined){
                    component.set("v.showTable",false);
                    for(var i = 0; i < countryList.length; i++) {
                        countryList.Country_Name_c=countryList[i].Country_Name_c;
                        countryList.Name=countryList[i].Name;
                        countryList.Market_c=countryList[i].Market_c;
                    } 
                    //call data table                              
                    this.setCountryTable(component,event,helper);
                   // component.set('v.CountryList', countryList);                    
                    component.set("v.allData", countryList); 
                    component.set("v.firstTimeLoad",false);
                    component.set("v.showTable",true);
                }
                else{
                    this.showToast('warning','Warning Message','There are no Countries with selected values');
                    
                }
            }
            
        });
        $A.enqueueAction(action1);
    },
    
    resetDetails: function (component, event, helper) {  
        
        
        component.set("v.searchKeyword",'');
        component.set("v.FilterText", '');
        component.set("v.CountryList", []);
        component.set("v.selection", []);
        component.set("v.selectedCountry",[]);
        component.set("v.tempSelection",[]);
        component.set("v.dummySelectedlist",[]);
        component.set("v.allData",[]);
        component.set("v.allFilterData",[]);
        component.set("v.selectedRows",[]);
        
    },
    resetSelectedTable: function(component, event, helper){
        component.set("v.showTable",false);
        var selectedCountries = component.get("v.selectedCountry");
        var selectedCousToRemove = [];
        var selectedOpsLst = component.get("v.selectedRegion");
        if(selectedCountries != null && selectedCountries !='' && selectedCountries !=undefined){
            var arrayLength=selectedCountries.length;
            for(var i=0;i<arrayLength;i++)
            {
                var rowDataIndex=selectedOpsLst.map(function(e) { return e; }).indexOf(selectedCountries[i].Market_c); 
                if (rowDataIndex !=-1){
                    selectedCousToRemove.push(selectedCountries[i]);
                }
            }
            
            var selectedRows= [];
            selectedCousToRemove.forEach(function(row) {                 
                selectedRows.push(row.Id); 
                //selectedPrdList.push(row);
            });
            
            //Setting new value in selection attribute
            component.set("v.selectedCountry",selectedCousToRemove);
            //component.set("v.selection", selectedRows);
        }
        //component.find("tablePrdList").set("v.selectedRows",selectedRows);
        var removedCountries = component.get("v.allData");
        var couLst = [];
        if(removedCountries != null && removedCountries !='' && removedCountries !=undefined){
            var arrayLength=removedCountries.length;
            for(var i=0;i<arrayLength;i++)
            {
                var rowDataIndex=selectedOpsLst.map(function(e) { return e; }).indexOf(removedCountries[i].Market_c); 
                if (rowDataIndex !=-1){
                    couLst.push(removedCountries[i]);
                }                    
            }
        }
        component.set("v.allData", couLst); 
        component.set("v.showTable",true); 
        component.set("v.FilterText",'');
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
    displayAlertMessage : function(component, event, helper){
        var msg ='All Selected values will reset if All is checked/unchecked';
        
        if (!confirm(msg)) {
            component.set("v.isRegion",false);
            console.log('No');
            return false;
        } else {
            component.set("v.isCountry",false);
            component.set("v.disabledRegion", true);
            component.set("v.disabledAllCountry",false);
            component.set("v.searchCountry",false);
            component.set("v.selectedRegion",[]);
            component.set("v.isSpinner",false);
            component.set("v.showSearch",false);
            component.set("v.searchKeyword",'');
            component.set("v.showTable",false);
            component.set("v.FilterText",'');
            helper.resetDetails(component,event,helper);
            console.log('Yes');
            //Write your confirmed logic
        }
    },
    displayAlertMessage1 : function(component, event, helper){
        var msg ='All Selected values will reset if All is checked/unchecked';
        
        if (!confirm(msg)) {
            component.set("v.isRegion",true);
            console.log('No');
            return false;
        } else {
            component.set("v.isCountry",false);
            component.set("v.disabledRegion", false);
            component.set("v.disabledAllCountry",true);
            component.set("v.searchCountry",true);
            component.set("v.selectedRegion",[]);
            component.set("v.isSpinner",false);
            component.set("v.showSearch",true);
            component.set("v.searchKeyword",'');
            component.set("v.showTable",false);
            component.set("v.FilterText",'');
            helper.resetDetails(component,event,helper);                    
            console.log('Yes');
            //Write your confirmed logic
        }
    },
    displayCountryAlert: function(component,event,helper){
        var msg ='All Selected values will reset if All is checked';
        
        if (!confirm(msg)) {
            component.set("v.isCountry",false);
            console.log('No');
            return false;
        } else {
            
            component.set("v.searchCountry",true);
            component.set("v.showSearch",true);
            component.set("v.showTable",false);
            component.set("v.searchKeyword",'');
            component.set("v.FilterText", '');
            component.set("v.CountryList", []);
            component.set("v.selection", []);
            component.set("v.selectedCountry",[]);
            component.set("v.tempSelection",[]);
            component.set("v.dummySelectedlist",[]);
            component.set("v.allData",[]);
        }
    },
    resetGeo : function(component,event,helper){
        component.set("v.isRegion",false);
        component.set("v.selectedRegion",[]);
        component.set("v.showTable",false);
        component.set("v.showSearch",false);
        component.set("v.disabledAllCountry",true);
        component.set("v.searchCountry",true);
        component.set("v.disabledRegion",false);
        component.set("v.disabledAll",false);
        component.set("v.selectedCountry",[]);
        component.set("v.isCountry",false);
        component.set("v.selection",[]);
        component.set("v.searchKeyword",'');
        component.set("v.FilterText",'');
    },
    resetEditGeoDetails: function(component,event,helper){
        
        var selectedCountry = component.get("v.selectedCountry");
        
        var savedCountryIdsLst = selectedCountry.map(function(value,index) { 
            return value["CH_AttributeRecordID__c"]; });	
        
        helper.setCountries(component,event,helper,savedCountryIdsLst);
        if(component.get("v.selectedRegion").length>0){
            component.set("v.disabledAllCountry",false);
            component.set("v.searchCountry",false);
            component.set("v.showSearch",false); 
            //component.set("v.isCountry",false);
            component.set("v.disabledRegion",false);
            component.set("v.disabledRegion",false);
            component.set("v.isRegion",false);
        }
        if(component.get("v.isRegion")){
            component.set("v.disabledRegion",true);
            component.set("v.selectedRegion",[]);
        }
        
        if(component.get("v.isCountry")){
            component.set("v.disabledAllCountry",false);
            component.set("v.searchCountry",true);
            component.set("v.showSearch",true);
            component.set("v.showTable",false);
            this.resetDetails(component,event,helper);
        }
        else {
            component.set("v.searchCountry",false);
            component.set("v.showSearch",false);
        }
       
    },
    getRegions: function(component,event,helper){
        if(component.get("v.selectedRegion")!=null && component.get("v.selectedRegion") != '' && component.get("v.selectedRegion") != undefined){
            component.set("v.storedRegion",component.get("v.selectedRegion"));
        }  
        var allRecords = [];
        var action = component.get("c.getRegionFromWKRule");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.listOptions", plValues);
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    displayResetMessage : function(component,event,helper,notificationDetailId){
        var msg ='All Selected values will reset';
        alert(notificationDetailId);       
        if (!confirm(msg)) {
            console.log('No');
            return false;
        } else {
            
            if(notificationDetailId){
                this.resetEditGeoDetails(component,event,helper);
                
            }
            else{
                this.resetGeo(component,event,helper);
                
            }
        }
    }
    
})
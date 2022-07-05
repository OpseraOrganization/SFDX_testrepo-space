({
    init: function (component,event,helper) {
        var notificationDetailId = component.get("v.recordId");
        var params = event.getParam('arguments');
      
        if(notificationDetailId){
            component.set("v.isSpinner",true);
            helper.resetEditGeoDetails(component,event,helper);
            helper.getRegions(component,event,helper);
            component.set("v.isSpinner",false);
        }
        else{
            
            helper.resetGeo(component,event,helper);
            helper.getRegions(component,event,helper);
        }
        component.set("v.isSpinner",false);
    },
    handleGeoDimension: function(component,event,helper){
        var params = event.getParam('arguments');
        if (params) {
            
            if(component.get("v.recordId")!=null && component.get("v.recordId") != '' && component.get("v.recordId") != undefined){
                component.set("v.selectedRegion",component.get("v.resetSelectedRegions"));
                component.set("v.isRegion",component.get("v.resetAllRegions"));
                component.set("v.isCountry",component.get("v.resetAllCountries"));
                component.set("v.disabledRegion",component.get("v.resetDisabledRegion"));
                component.set("v.disabledAllCountry",component.get("v.resetDisabledAllCountry"));
                component.set("v.searchCountry",component.get("v.resetSearchCountry"));   
                component.set("v.showSearch",component.get("v.resetShowSearch"));
                component.set("v.searchKeyword",'');
                component.find('btnToggleSelectedItem').set("v.checked",false); 
                component.set("v.selectedCountry",component.get("v.resetSelectedCountries")); 
                component.set("v.selection",[]);
                component.set("v.tempSelection",[]);
                component.set("v.allFilterData",[]);
                component.set("v.allData",[]);
                component.set("v.dummySelectedlist",[]);
                component.set("v.toggleSelectedItem",false);    
                var savedCountryIdsLst = component.get("v.selectedCountry").map(function(value,index) { 
                    return value["CH_AttributeRecordID__c"]; });
                
                helper.setCountries(component,event,helper,savedCountryIdsLst);
                
                
            }
            else{
                helper.resetGeo(component,event,helper);
            }  
        }
    },   
    //Method used to handle Submit button Click
    handleSubmit : function(component,event,helper){
        
        //component.set("v.selectedStage", "stage1");
    },
    
    //handle cancel button click for closing tab
    handleCancel : function(component, event, helper) { 
        helper.closeTab(component);
    },
    //Geographic Dimention
    handleChange: function (component,event,helper) {
        var storedRegionsList = component.get("v.storedRegion");
        var selectedOpsList = component.get("v.selectedRegion");
        
        if(storedRegionsList != null && storedRegionsList !='' && storedRegionsList !=undefined && selectedOpsList != null && selectedOpsList !='' && selectedOpsList !=undefined){
            
            var couLength = storedRegionsList.length;
            var isRemoved = false;
            for(var i=0;i<couLength;i++)
            {
                var rowDataIndex=selectedOpsList.map(function(e) { return e; }).indexOf(storedRegionsList[i]); 
                if (rowDataIndex !=-1){
                  
                }
                else{
                    
                    isRemoved = true;
                }
            }
            var couList = component.get("v.allData");
            if(isRemoved && couList !=null && couList !='' && couList !=undefined){
                
                var msg ='Countries data of related Region will be removed if you remove Selected Region';
                if (!confirm(msg)) {
                    
                    component.set("v.selectedRegion",storedRegionsList);
                    
                    return false;
                } else {
                    
                    helper.resetSelectedTable(component, event, helper);
                    
                    //Write your confirmed logic
                }
            }
        }
        
        //
        // var selectedOptionsList = event.getParam("value");
        if(selectedOpsList != null && selectedOpsList !='' && selectedOpsList !=undefined){
            
            if(component.get("v.isCountry") == false){
                component.set("v.disabledAllCountry",false);
                component.set("v.disabledCountry",false);
                component.set("v.showSearch",false);
                component.set("v.searchCountry",false);}
        }
        else{
            var couList = component.get("v.allData");
            if(couList !=null && couList !='' && couList !=undefined){
                var msg ='Countries data of related Region will be removed if you remove Selected Region';
                
                if (!confirm(msg)) {
                    
                    component.set("v.selectedRegion",storedRegionsList);
                    
                    return false;
                } else {
                   
                    component.set("v.searchCountry",true);
                    component.set("v.showSearch",true);
                    component.set("v.disabledAllCountry",true);
                    component.set("v.disabledCountry",true);
                    component.set("v.showTable", false);
                    
                    helper.resetDetails(component, event, helper);
                    console.log('Yes');
                  
                    
                }
            }
            else{
                
                component.set("v.isCountry",false);
                component.set("v.searchCountry",true);
                component.set("v.showSearch",true);
                component.set("v.disabledAllCountry",true);
                component.set("v.disabledCountry",true);
                component.set("v.showTable", false);
               
                helper.resetDetails(component, event, helper);
               
            }
            
        }
       
        component.set("v.storedRegion", component.get("v.selectedRegion"));
       
        
    },
    handleRegion: function(component,event,helper){
        var listnull= [];
        
        //component.set("v.showTable", false);
        
        if(component.get("v.isRegion") === true){
            if(component.get("v.showTable") == true){
                helper.displayAlertMessage(component, event, helper);
            }
            else{
                
                component.set("v.isCountry",false);  
                component.set("v.disabledRegion", true); 
                component.set("v.selectedRegion",[]);
                component.set("v.disabledAllCountry",false);
                component.set("v.searchCountry",false);
                component.set("v.showSearch",false);
                helper.resetDetails(component,event,helper);
            }
           // helper.getCountries(component,event,helper);
            
        }
        
        else if(component.get("v.isRegion") === false){
            
            if(component.get("v.showTable") == true){
                
                helper.displayAlertMessage1(component, event, helper);
            }
            else{
                
                component.set("v.isCountry",false); 
                component.set("v.disabledRegion", false);
                component.set("v.disabledAllCountry",true);
                component.set("v.searchCountry",true);
                component.set("v.showSearch",true);
                helper.resetDetails(component,event,helper);
            }
        }
    },
    handleCountry: function(component,event,helper){
        
        // helper.resetDetails(component,event,helper);
        if(component.get("v.isCountry") === true){
            if(component.get("v.showTable")== true){
                helper.displayCountryAlert(component,event,helper);
            }
            else{
                component.set("v.searchCountry",true);
                component.set("v.showSearch",true);
                
            }
        }
        
        
        
        else{
            component.set("v.searchCountry",false);
            component.set("v.showSearch",false);
        }
    },   
    searchCountries: function(component, event, helper) {
        if (event.keyCode === 13) {                       
   
            

            component.set("v.disabledCountry",false);
            //component.set("v.hasPageChanged", false);
            helper.getCountries(component, event, helper);
            
        }
        
    },
    
    search: function(component, event, helper){

      
            var tempSelection=component.get("v.tempSelection");
            component.set("v.selection", tempSelection);
        
         if(component.get("v.isRegion")==true)
        {

            helper.getCountries2(component, event, helper);
        }
        else
        {
            helper.getCountries(component, event, helper);
        }
    },
    allDataSelectFromTable : function(component, event, helper) {   
        component.set("v.triggeredFromAllPrdCheckBox", true);
        component.set('v.ModalSpinner', true);
        var countryList = [];
        if(!component.get("v.toggleSelectedItem")){
            countryList = component.get("v.allFilterData");            
        }
        else{                
            countryList = component.get("v.seledctedFilterData");
        }
        
        var selectedCountry=component.get("v.selectedCountry");
        var allSelectedRows=component.get("v.selection");            
        
        countryList.forEach(function(row) {
            allSelectedRows.push(row.Id); 
            selectedCountry.push(row);
        });
        
        helper.initializationPagination(component, helper);
        component.set('v.ModalSpinner', false);
        
    }, 
    
    
})
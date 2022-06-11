({
    getbgbuMap : function(component, event, helper) {
        var action = component.get("c.getBusinessGroupsandUnits");
        action.setParams({ 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var bgbuMap = response.getReturnValue();
                if(bgbuMap !=null && bgbuMap != '' && bgbuMap !=undefined){
                    var bglst = Object.keys(bgbuMap);
                    var items =[];
                    var allBULst =[];
                    let allbgbuMap = [];                    
                    for(var i = 0; i < bglst.length; i++) {
                        var item = {
                            "label": bglst[i],
                            "value": bglst[i],
                        };
                        items.push(item);                        
                        var bulst = bgbuMap[bglst[i]];
                        var eachbuLst = [];
                        for(var j = 0; j < bulst.length; j++) {
                            var bu = {
                                "label": bulst[j],
                                "value": bulst[j],
                            }; 
                            allBULst.push(bu);
                            eachbuLst.push(bu);
                        }  
                        allbgbuMap.push({
                            key: bglst[i],
                            value: eachbuLst,
                        });
                    }
                    component.set("v.bgLst", items);
                    component.set("v.allbuLst", allBULst);
                    component.set("v.bgbuMap", allbgbuMap);
                    component.set("v.showBgDetails", true);
                    component.set("v.isSpinner",false);
                    var recordId = component.get("v.recordId");
                    if(recordId != null && recordId !='' && recordId !=undefined){
                        this.getSavedValues(component, event, helper, false);
                    }
                }                
            }
            else{
                component.set("v.isSpinner",false);
                this.showToast('error','Error Message',JSON.stringify(getReturnValue()));
            }            
        });
        $A.enqueueAction(action);
    },   
    
    getProducts: function(component, event, helper, savedProductIdsLst, isFromUpdateInit){
        var searchValue = component.get("v.searchKeyword");
        if((searchValue==undefined || searchValue=='' || searchValue.length<3) && !isFromUpdateInit){
            this.showToast('Warning','Warning Message','Please enter minimum 3 characters');
        }
        else{
            component.set("v.isSpinner",true);            
            var action = component.get("c.getProducts");
            var prodIdsLst =[];
            var recordId = component.get("v.recordId");            
            if(recordId != null && recordId !='' && recordId !=undefined && isFromUpdateInit){
                prodIdsLst = savedProductIdsLst;                
            }
            var selectedBGLst=[];
            if(component.get("v.selectedAllBGs")){
                var bgLst =component.get("v.bgLst");        
                selectedBGLst = bgLst.map(function(value,index) { return value["value"];});
            }  
            var selectedBULst=[];
            if(component.get("v.selectedAllBUs")){
                var buLst =component.get("v.buLst");  
               selectedBULst =  buLst.map(function(value,index) { return value["value"];});
            } 
            action.setParams({ 
                selectedBGLst:component.get("v.selectedAllBGs")==true?selectedBGLst:component.get("v.selectedBGs"),
                selectedBULst:component.get("v.selectedAllBUs")==true?selectedBULst:component.get("v.selectedBUs"),
                selectedAllBG:component.get("v.selectedAllBGs"),
                selectedAllBU:component.get("v.selectedAllBUs"),
                searchKey:searchValue,
                selectedAllProds:component.get("v.isAllProductsSelected"),
                prodIdsLst : JSON.stringify(prodIdsLst),
                ProductSearchLimit:component.get("v.ProductSearchLimit")
            });
            action.setCallback(this, function(response) {                 
                var state = response.getState();
                component.set("v.isSpinner",false);
                if (state === "SUCCESS") {
                    var prodLst = response.getReturnValue();
                    if(prodLst !=null && prodLst !='' && prodLst!=undefined){
                        component.set("v.showProductTable",false);
                        //component.set("v.currentPageNumber",1); 
                        //component.set("v.totalRecords", response.getReturnValue().length);         
                        var prdList=response.getReturnValue();
                        if(prdList.length>0 && prdList.length>component.get("v.ProductSearchLimit")) {                            
                            this.showToast('warning', 'Warning Message','Only the first '+ component.get("v.ProductSearchLimit") + ' records are displayed. Please refine your search, if needed.');                            
                            prdList.pop();
                        }                       
                        if(recordId != null && recordId !='' && recordId !=undefined && isFromUpdateInit){
                            var selectedRows= [];
                            prdList.forEach(function(row) {                 
                                selectedRows.push(row.Id); 
                            });            
                            component.set("v.selectedProduct",prdList);
                            component.set("v.firstTimeLoad",true);
                        }   
                        else{
                            component.set("v.firstTimeLoad",false);
                        }
                        this.setProductTableColumns(component,event,helper);                                             
                        component.set("v.allData", prdList);
                        component.set("v.showProductTable",true);
                    }
                    else{
                        if(!isFromUpdateInit){
                            this.showToast('warning','Warning Message','There are no Products with selected values');    
                        }
                    }
                }
                else{                    
                    var errors = response.getError();                
                    this.showToast('error', 'Error','Notification Subscriptions: '+ errors && errors[0] && errors[0].message?errors[0].message:"Something went wrong");                                        
                }
                component.set("v.isSpinner",false);
            });
            $A.enqueueAction(action);
        }
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
    
    
    setProductTableColumns : function (component,event,helper){        
        component.set('v.productColumns', [
            {label: 'Product Code', fieldName: 'ProductCode', type: 'text', sortable: 'true', searchable: 'true', "initialWidth": 170},
            {label: 'Product Name', fieldName: 'Name', type: 'text', sortable: 'true', searchable: 'true',"initialWidth": 380},
            {label: 'Product Classification', fieldName: 'PMD_Portfolio_Classification__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Business Unit', fieldName: 'CH_Business_Unit__c', type: 'text', sortable: 'true', searchable: 'true'},
            {label: 'Business Group', fieldName: 'CH_Business_Group__c', type: 'text', sortable: 'true', searchable: 'true'}
            
        ]); 
    },
    
    disableProdDetails: function (component, event, helper) {  
        var nullLst =  [];
        component.set("v.showProductTable", false);
        component.set("v.searchKeyword",'');
        component.set("v.productFilterText", '');
        component.set("v.productList", nullLst);
        component.set("v.selectedProduct",nullLst);
        component.set("v.allData",nullLst);
        component.set("v.isAllProductsSelected", false);        
        var prdAllCheckbox = component.find("productAllCheckbox");
        prdAllCheckbox.set("v.checked", false);
    },
    
    resetSelectedBGProds: function(component, event, helper){
        component.set("v.showProductTable",false);
        var selectedProds = component.get("v.selectedProduct");
        var selectedProdsToRemove = [];
        var selectedBgLst = component.get("v.selectedBGs");
        if(selectedProds != null && selectedProds !='' && selectedProds !=undefined){
            var arrayLength=selectedProds.length;
            for(var i=0;i<arrayLength;i++)
            {
                var rowDataIndex=selectedBgLst.map(function(e) { return e; }).indexOf(selectedProds[i].CH_Business_Group__c); 
                if (rowDataIndex !=-1){
                    selectedProdsToRemove.push(selectedProds[i]);
                }
            }            
            var selectedRows= [];
            selectedProdsToRemove.forEach(function(row) {                 
                selectedRows.push(row.Id); 
            });            
            //Setting new value in selection attribute
            component.set("v.selectedProduct",selectedProdsToRemove);
            
        }
        this.resetSelectedBUProds(component, event, helper);
    },
    
    resetSelectedBUProds: function(component, event, helper){
        component.set("v.showProductTable",false);
        var selectedProds = component.get("v.selectedProduct");
        var selectedProdsToRemove = [];
        var selectedBuLst = component.get("v.selectedBUs");
        if(selectedProds != null && selectedProds !='' && selectedProds !=undefined){
            var arrayLength=selectedProds.length;
            for(var i=0;i<arrayLength;i++)
            {
                var rowDataIndex=selectedBuLst.map(function(e) { return e; }).indexOf(selectedProds[i].CH_Business_Unit__c); 
                if (rowDataIndex !=-1){
                    selectedProdsToRemove.push(selectedProds[i]);
                }
            }
            
            var selectedRows= [];
            selectedProdsToRemove.forEach(function(row) {                 
                selectedRows.push(row.Id); 
            });            
            component.set("v.selectedProduct",selectedProdsToRemove);
        }
        var removedBuProds = component.get("v.allData");
        var prodLst = [];
        if(removedBuProds != null && removedBuProds !='' && removedBuProds !=undefined){
            var arrayLength=removedBuProds.length;
            for(var i=0;i<arrayLength;i++)
            {
                var rowDataIndex=selectedBuLst.map(function(e) { return e; }).indexOf(removedBuProds[i].CH_Business_Unit__c); 
                if (rowDataIndex !=-1){
                    prodLst.push(removedBuProds[i]);
                }                    
            }
        }
        component.set("v.allData", prodLst); 
        component.set("v.showProductTable",true); 
        //call data table
        component.set("v.productFilterText",'');
        
    },    
    
    //get saved values from parent record and set on UI
    getSavedValues: function (component, event, helper, isReset) {
        if(isReset){
            component.set("v.selectedAllBGs", component.get("v.resetSelectedAllBGs"));
            component.set("v.selectedBGs", component.get("v.resetSelectedBGs"));
            component.set("v.selectedBUs", component.get("v.resetSelectedBUs"));
            component.set("v.selectedAllBUs", component.get("v.resetSelectedAllBUs"));
            component.set("v.selectedProduct", component.get("v.resetSelectedProducts"));
            component.set("v.isAllProductsSelected", component.get("v.resetisAllProductsSelected"));            
        }
        
        //This if-else is for selected BGs
        if(component.get("v.selectedAllBGs")){
            var allOptions = [];                
            var buOptions = component.get("v.allbuLst");          
            component.set("v.buLst", buOptions);
            component.set("v.selectedBGs", allOptions);
            component.set("v.storedBGs", allOptions);
            component.find('bgCheckbox').set('v.checked', true);           
        }
        else{
            var selectedBGOptionsList = component.get("v.selectedBGs"); 
            if(selectedBGOptionsList.length > 0){
                component.set("v.storedBGs", selectedBGOptionsList);
                component.set("v.selectedAllBGs",false);
                var bgbuMap = component.get("v.bgbuMap");
                var buOptions = [];
                for(var j=0;j<bgbuMap.length;j++){
                    for(var i=0;i<selectedBGOptionsList.length;i++){                
                        if(bgbuMap[j].key == selectedBGOptionsList[i]){
                            var eachBuOptions = bgbuMap[j].value;
                            buOptions = buOptions.concat(buOptions,eachBuOptions);
                        }
                    }                
                }
                
                buOptions = buOptions.filter((value,index)=> buOptions.indexOf(value)===index);
                component.set("v.buLst", buOptions);                
            }
        }
        //This if-else is for selected BUs
        if(component.get("v.selectedAllBUs")){
            var nullOption = [];
            component.set("v.selectedBUs", nullOption);   
            component.set("v.storedBUs", nullOption);
            component.find('buCheckbox').set('v.checked', true);
        }
        else{
            var selectedBUOptionsList = component.get("v.selectedBUs"); 
            if(selectedBUOptionsList != null && selectedBUOptionsList !='' && selectedBUOptionsList !=undefined){
                component.set("v.storedBUs",component.get("v.selectedBUs"));
                component.set("v.selectedAllBUs",false);
            }
        }
        //This if-else is for selected Products
        if(component.get("v.isAllProductsSelected")){
            var nullLst =  [];        
            component.find('productAllCheckbox').set('v.checked', true);
            component.set("v.showProductTable",false);
            component.set("v.searchKeyword",'');
            component.set("v.productFilterText", '');
            component.set("v.productList", nullLst);
            component.set("v.selectedProduct",nullLst);
        }
        else{
            var selectedProdList = component.get("v.selectedProduct");            
            var savedProductIdsLst = selectedProdList.map(function(value,index) { if(value["CH_AttributeRecordID__c"] != undefined){return value["CH_AttributeRecordID__c"];} });
            if(savedProductIdsLst.length>0){
                this.getProducts(component, event, helper, savedProductIdsLst, true);
            }
        }
    },    
})
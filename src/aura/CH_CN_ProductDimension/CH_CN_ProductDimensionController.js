({
    doInit: function (component, event, helper) {
        helper.getbgbuMap(component, event, helper);
        var recordId = component.get("v.recordId");
        if(recordId != null && recordId !='' && recordId !=undefined){
            component.set("v.resetSelectedAllBGs",component.get("v.selectedAllBGs"));      
            component.set("v.resetSelectedBGs",component.get("v.selectedBGs"));
            component.set("v.resetSelectedBUs",component.get("v.selectedBUs"));		
            component.set("v.resetSelectedAllBUs",component.get("v.selectedAllBUs"));        
            component.set("v.resetSelectedProducts",component.get("v.selectedProduct"));
            component.set("v.resetisAllProductsSelected",component.get("v.isAllProductsSelected"));
        }
    },
    handleProductDimension: function(component,event,helper){
        
        var params = event.getParam('arguments');
        if (params) {            
            component.set("v.storedBGs", []);
            component.set("v.selectedBGs",[]);
            component.set("v.selectedAllBGs", false);
            component.find('bgCheckbox').set('v.checked',false);
            var noOptions = [];
            component.set("v.buLst", noOptions);
            component.set("v.selectedBUs", noOptions);
            component.set("v.storedBUs", noOptions);
            component.set("v.selectedAllBUs", false);
            component.find('buCheckbox').set('v.checked',false);
            helper.disableProdDetails(component, event, helper);
            
            if(component.get("v.recordId")!=null && component.get("v.recordId") != '' && component.get("v.recordId") != undefined){
                helper.getSavedValues(component, event, helper, true);               
            }
            else{
                //create
            }
            
        }
    }, 
    
    bghandleChange: function (component, event, helper) {
        var storedBgOptionsList = component.get("v.storedBGs");
        var selectedBGOptionsList = component.get("v.selectedBGs");
        if(storedBgOptionsList != null && storedBgOptionsList !='' && storedBgOptionsList !=undefined && selectedBGOptionsList != null && selectedBGOptionsList !='' && selectedBGOptionsList !=undefined){
            var bgLength = storedBgOptionsList.length;
            var isRemoved = false;
            for(var i=0;i<bgLength;i++){
                var rowDataIndex=selectedBGOptionsList.map(function(e) { return e; }).indexOf(storedBgOptionsList[i]); 
                if (rowDataIndex !=-1){
                }
                else{
                    isRemoved = true;
                }
            }
            var prdLst = component.get("v.allData");
            if(isRemoved && prdLst !=null && prdLst !='' && prdLst !=undefined){
                var msg = component.get("v.confirmMessage");
                if (!confirm(msg)) {
                    component.set("v.selectedBGs",storedBgOptionsList);
                    return false;
                } else {
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
                    var selectedBuLst = component.get("v.selectedBUs");
                    if(selectedBuLst != null && selectedBuLst !='' && selectedBuLst !=undefined){
                        var updateSelectedBULst = [];
                        for(var i=0;i<selectedBuLst.length;i++){
                            buOptions.forEach(function(row) {                 
                                if(row.value == selectedBuLst[i]){
                                    updateSelectedBULst.push(selectedBuLst[i]);
                                }
                            });
                        }                        
                        if(updateSelectedBULst !=null){
                            updateSelectedBULst = updateSelectedBULst.filter((value,index)=> updateSelectedBULst.indexOf(value)===index);
                        }
                        component.set("v.selectedBUs", updateSelectedBULst);
                        component.set("v.storedBUs", updateSelectedBULst);                        
                    }
                    helper.resetSelectedBGProds(component, event, helper);                    
                }
            }
            if(isRemoved && (prdLst ==null || prdLst =='' || prdLst ==undefined)){
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
                var selectedBuLst = component.get("v.selectedBUs");
                if(selectedBuLst != null && selectedBuLst !='' && selectedBuLst !=undefined){
                    var updateSelectedBULst = [];
                    for(var i=0;i<selectedBuLst.length;i++){
                        buOptions.forEach(function(row) {                 
                            if(row.value == selectedBuLst[i]){
                                updateSelectedBULst.push(selectedBuLst[i]);
                            }
                        });
                    }
                    
                    if(updateSelectedBULst !=null){
                        updateSelectedBULst = updateSelectedBULst.filter((value,index)=> updateSelectedBULst.indexOf(value)===index);
                    }
                    component.set("v.selectedBUs", updateSelectedBULst);
                    component.set("v.storedBUs", updateSelectedBULst);                    
                }
            }            
        }
        
        if(selectedBGOptionsList != null && selectedBGOptionsList !='' && selectedBGOptionsList !=undefined){            
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
        else{
            var prdLst = component.get("v.allData");
            if(prdLst !=null && prdLst !='' && prdLst !=undefined){
                var msg = component.get("v.confirmMessage");                
                if (!confirm(msg)) {
                    component.set("v.selectedBGs",storedBgOptionsList);
                    return false;
                } else {
                    var noOptions = [];
                    component.set("v.buLst", noOptions);
                    component.set("v.selectedBUs", noOptions);
                    component.set("v.storedBUs", noOptions);                    
                    helper.disableProdDetails(component, event, helper);
                }
            }
            else{
                var noOptions = [];
                component.set("v.buLst", noOptions);
                component.set("v.selectedBUs", noOptions);
                component.set("v.storedBUs", noOptions);
                helper.disableProdDetails(component, event, helper);
            }
        }
        component.set("v.storedBGs", component.get("v.selectedBGs"));        
    },
    
    buhandleChange: function (component, event, helper) {        
        var storedBUOptionsList = component.get("v.storedBUs");
        var selectedBUOptionsList = component.get("v.selectedBUs");
        if(storedBUOptionsList != null && storedBUOptionsList !='' && storedBUOptionsList !=undefined && selectedBUOptionsList != null && selectedBUOptionsList !='' && selectedBUOptionsList !=undefined){
            var buLength = storedBUOptionsList.length;
            var isRemvoed = false;
            for(var i=0;i<buLength;i++){
                var rowDataIndex=selectedBUOptionsList.map(function(e) { return e; }).indexOf(storedBUOptionsList[i]); 
                if (rowDataIndex !=-1){
                }
                else{
                    isRemvoed = true;
                }
            }
            var prdLst = component.get("v.allData");
            if(isRemvoed && prdLst !=null && prdLst !='' && prdLst !=undefined){
                
                var msg = component.get("v.confirmMessage");
                if (!confirm(msg)) {
                    component.set("v.selectedBUs",storedBUOptionsList);
                    return false;
                } else {
                    helper.resetSelectedBUProds(component, event, helper);                   
                }
            }
        }        
        
        if(selectedBUOptionsList != null && selectedBUOptionsList !='' && selectedBUOptionsList !=undefined){            
        }
        else{
            var prdLst = component.get("v.allData");
            if(prdLst !=null && prdLst !='' && prdLst !=undefined){
                var msg = component.get("v.confirmMessage");
                
                if (!confirm(msg)) {
                    component.set("v.selectedBUs",storedBUOptionsList);
                    return false;
                } else {
                    helper.disableProdDetails(component, event, helper);
                }
            }
            else{
                helper.disableProdDetails(component, event, helper);
            }            
        }        
        component.set("v.storedBUs", component.get("v.selectedBUs"));
    },
    
    getValue: function (component, event) {
        var selectedOptionsList =component.get("v.selectedArray");
        if(event.getSource().get('v.checked')){
            selectedOptionsList.push(event.getSource().get('v.value'));
            component.set("v.selectedArray", selectedOptionsList);
        }
        else{
            var removedOptionsList = [];
            for(var i=0;i<selectedOptionsList.length;i++){
                if(selectedOptionsList[i] !=event.getSource().get('v.value')){
                    removedOptionsList.push(selectedOptionsList[i]);
                }
            }
            component.set("v.selectedArray", removedOptionsList);
        }        
    },
    
    bgRadioChange: function (component, event, helper) {
        var prdLst = component.get("v.allData");
        if(prdLst !=null && prdLst !='' && prdLst !=undefined){
            var msg = component.get("v.confirmMessage");
            
            if (!confirm(msg)) {
                if(event.getSource().get('v.checked')){
                    component.find('bgCheckbox').set('v.checked',false);
                }
                else{
                    component.find('bgCheckbox').set('v.checked',true);
                }
                return false;
            }else{
                component.set("v.storedBUs", []);
                component.set("v.selectedBUs", []);
                if(event.getSource().get('v.checked')){
                    var allOptions = [];                
                    var buOptions = component.get("v.allbuLst");          
                    component.set("v.buLst", buOptions);
                    component.set("v.selectedBGs", allOptions);
                    component.set("v.storedBGs", allOptions);
                    component.set("v.selectedAllBGs", true);
                    
                }
                else{
                    var noOptions = [];
                    component.set("v.selectedBGs", noOptions);
                    component.set("v.storedBGs", noOptions);
                    component.set("v.selectedAllBGs", false);
                    component.set("v.buLst", noOptions);
                    component.set("v.selectedBUs", noOptions);
                    component.set("v.storedBUs", noOptions);
                    var bgCheckbox = component.find("buCheckbox");
                    bgCheckbox.set("v.checked", false);                     	
                }
                var buCheckbox = component.find("buCheckbox");
                buCheckbox.set("v.checked", false);
                helper.disableProdDetails(component, event, helper);
            }
        }
        else{
            component.set("v.storedBUs", []);
            component.set("v.selectedBUs", []);
            if(event.getSource().get('v.checked')){
                var allOptions = [];                
                var buOptions = component.get("v.allbuLst");          
                component.set("v.buLst", buOptions);
                component.set("v.selectedBGs", allOptions);
                component.set("v.storedBGs", allOptions);
                component.set("v.selectedAllBGs", true);                         
            }
            else{
                var noOptions = [];
                component.set("v.selectedBGs", noOptions);
                component.set("v.storedBGs", noOptions);
                component.set("v.selectedAllBGs", false);
                component.set("v.buLst", noOptions);
                component.set("v.selectedBUs", noOptions);
                component.set("v.storedBUs", noOptions);
                var bgCheckbox = component.find("buCheckbox");
                bgCheckbox.set("v.checked", false);                   	
            }
            var buCheckbox = component.find("buCheckbox");
            buCheckbox.set("v.checked", false);
            helper.disableProdDetails(component, event, helper);
        }
    },
    
    buRadioChange: function (component, event, helper) {
        var prdLst = component.get("v.allData");
        if(prdLst !=null && prdLst !='' && prdLst !=undefined){
            var msg = component.get("v.confirmMessage");            
            if (!confirm(msg)) {
                if(event.getSource().get('v.checked')){
                    component.find('buCheckbox').set('v.checked',false);
                }
                else{
                    component.find('buCheckbox').set('v.checked',true);
                }
                return false;
            } else {
                component.set("v.storedBUs", []);
                helper.disableProdDetails(component, event, helper);
                if(event.getSource().get('v.checked')){                   
                    var nullOption = [];
                    component.set("v.selectedBUs", nullOption);   
                    component.set("v.storedBUs", nullOption);
                    component.set("v.selectedAllBUs", true);
                }
                else{
                    var noOptions = [];
                    component.set("v.selectedBUs", noOptions);
                    component.set("v.storedBUs", nullOption);
                    component.set("v.selectedAllBUs", false);                    
                }
            }
        }
        else{            
            component.set("v.storedBUs", []);
            helper.disableProdDetails(component, event, helper);
            if(event.getSource().get('v.checked')){                
                var nullOption = [];
                component.set("v.selectedBUs", nullOption);   
                component.set("v.storedBUs", nullOption);
                component.set("v.selectedAllBUs", true);
            }
            else{
                var noOptions = [];
                component.set("v.selectedBUs", noOptions);
                component.set("v.storedBUs", nullOption);
                component.set("v.selectedAllBUs", false);               
            }
        }        
    },
    
    onRowAct: function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
    },
    
    onSelectAllChangeProducts: function(component, event, helper) {
        var prdLst = component.get("v.selectedProduct");
        if(prdLst !=null && prdLst !='' && prdLst !=undefined){
            var msg = component.get("v.confirmMessage");
            
            if (!confirm(msg)) {
                if(event.getSource().get('v.checked')){
                    component.find('productAllCheckbox').set('v.checked',false);
                }
                else{
                    component.find('productAllCheckbox').set('v.checked',true);
                }                
                return false;
            }else{                
                var nullLst =  [];                
                component.set("v.showProductTable",false);
                component.set("v.searchKeyword",'');
                component.set("v.productFilterText", '');
                component.set("v.productList", nullLst);
                component.set("v.selectedProduct",nullLst);
                component.set("v.allData",nullLst);
            }
        }
        else{            
            var nullLst =  [];            
            component.set("v.showProductTable",false);
            component.set("v.searchKeyword",'');
            component.set("v.productFilterText", '');
            component.set("v.productList", nullLst);
            component.set("v.selectedProduct",nullLst);
        }
    },    
    
    searchProducts: function(component, event, helper) {
       // if(event.keyCode === 13 || event.getSource().getLocalId()=='productSearchBtn'){   
        if(component.find("productSearchBtn").get("v.label") == "Search"){
        	component.set("v.productFilterText",'');
            helper.getProducts(component, event, helper, [], false);
        }        
    },
    searchProd: function(component, event, helper) {
        if(event.keyCode === 13){
            component.set("v.productFilterText",'');
            helper.getProducts(component, event, helper, [], false);
        }
    }    
})
({ 
    doInit : function(component, event, helper) { 
        // get the fields API name and pass it to helper function  
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");
        var objDetails = component.get("v.objDetail");
        // call the helper function
        helper.fetchPicklistValues(component,objDetails,controllingFieldAPI, dependingFieldAPI);
		helper.loadOptions(component,helper);
    },
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        if (controllerValueKey != '--None--') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", ['--None--']);
            }  
        } else {
            component.set("v.listDependingValues", ['--None--']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    Search : function(component,event) {
        component.set("v.Spinner", true);
        var selectedType = component.find("mySelect").get("v.value");
        if(selectedType==''){
            component.set("v.selectedValue","--None--");
        }
        var workgroupType= component.find("WorkgroupType").get("v.value");
        var serviceType= component.find("ServiceType").get("v.value");
        if(serviceType == 'Hardware Support' && (workgroupType !='Quotation Only' && workgroupType != 'Warranty Only' && workgroupType != 'Warranty and Quotation' && workgroupType != '' && workgroupType != 'Exclusions Quotation Support-OC' && workgroupType != 'Exclusions Quotation Support-CDM') ){
            document.getElementById("workgrouptypeId").innerHTML = 'Please select "Warranty Only" or "Quotation Only" or "Warranty and Quotation" or "Exclusions Quotation Support-OC" or "Exclusions Quotation Support-CDM"';
			component.set('v.workGroupRules', null);
			component.set("v.Spinner", false);
        }else{
            document.getElementById("workgrouptypeId").innerHTML = '';
            var contractType=component.get("v.selectedValue");
            var action = component.get("c.fetchFilterValues");
            var Contract = component.find("contractId").get("v.value");
            var Severity= component.find("severity").get("v.value");
            var Region= component.find("region").get("v.value");
            var Country= component.find("country").get("v.value");
            var levelOfSupportval= component.find("LevelOfSupport").get("v.value");
            var customer = component.find("accLookup").get("v.value");
            var custoGroup = component.find("custoGroupLookup").get("v.value");
            var product = component.find("productLookup").get("v.value");
            var productGroup = component.find("productGroupLookup").get("v.value");
            var Outage = component.find("outageBox").get("v.value");
            /* Chnages w.r.t 17116 starts */
            var active = component.find("activeBox").get("v.value");
            var workgroupType= component.find("WorkgroupType").get("v.value");
            var serviceType= component.find("ServiceType").get("v.value");
            var productModule = component.find("productmoduleLookup").get("v.value");
            var productVariant = component.find("productvariantLookup").get("v.value");
            var productRelease = component.find("productreleaseLookup").get("v.value"); 
            //var productRelease = component.get("v.prodRelSelectedVal");
            var solution = component.find("solutionLookup").get("v.value");
            action.setParams({Contract : Contract, Severity : Severity, Region : Region, Country : Country, levelOfSupport : levelOfSupportval, 
                              Customer : customer, CustomerGroup : custoGroup, Product : product, ProductGroup : productGroup, Outage : Outage , 
                              Active : active, WorkgroupType : workgroupType, ServiceType : serviceType,
                              productModule: productModule,productVariant:productVariant,productRelease:productRelease,solution:solution,contractType:contractType});
            /* Chnages w.r.t 17116 ends */
            action.setCallback(this, function(response) {
                var state = response.getState();
                var rules = response.getReturnValue();
                if (state === "SUCCESS") {                   
                    console.log('rules' + JSON.stringify(rules));
                    component.set('v.workGroupRules', response.getReturnValue());
                }
                component.set("v.Spinner", false);
            });
            $A.enqueueAction(action);
        }
    },
    refresh : function(component,event) {
        $A.get('e.force:refreshView').fire();
    },
    newRecord: function(component, event) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            'entityApiName' : 'CH_Workgroup_Rule__c'
        });
        createRecordEvent.fire();
    },
	typeChanged: function(component,event,helper){
        var selectedType = component.find("mySelect").get("v.value");
        component.set("v.selectedValue", selectedType);
    },
	 editRecord: function(component, event) {
        var rectarget = event.currentTarget;
        var idstr = event.target.getAttribute("data-recId"); 
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": idstr
        });
        editRecordEvent.fire();    
    },
    
    //Below method developed under NOKIASC-32652
    //It gets called on selecting value from Product Release Search items
    prodRelSelected: function(component, event, helper) { 
        var proRelIDandName=(event.currentTarget.id).split(':::'); 
        component.find("productRelLookup").set("v.value", proRelIDandName[1]);
        component.set("v.prodRelSelectedVal", proRelIDandName[0]); 
        component.set("v.optionsProdRel", []);
    },
    
    //Below method developed under NOKIASC-32652
    //It gets called on clikcing Search icon from Product Release Search Box
    prodRelSearch: function(component, event, helper) {   
        var serchedVal = component.find("productRelLookup").get("v.value");
        var action = component.get('c.fetchProductRelRecords');
        action.setParams({            
            'value' : serchedVal,
            'productId': component.get("v.workgroupRule.CH_Product__c")
        });
        action.setCallback(this,function(response){
        	var result = response.getReturnValue();
        	if(response.getState() === 'SUCCESS') {
    			if(result.length > 0) {
                    component.set('v.optionsProdRel',result); 
    			} 
        	}
        });
        $A.enqueueAction(action);
        //Serch and return List
    },
    
    //Below method developed under NOKIASC-32652
    //It gets called on clikcing close icon from Product Release Search box
    prodRelRemove: function(component, event, helper) {
        component.find("productRelLookup").set("v.value", '');
        component.set("v.prodRelSelectedVal", ''); 
        component.set("v.optionsProd", []);
    },
})
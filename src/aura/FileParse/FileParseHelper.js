({
    fetchPickListVal: function(component, event, helper) {
        component.set("v.Spinner", false);
        
        var vObjTypeOpts = [];
        vObjTypeOpts.push({
            class: "optionClass",
            label: "--- None ---",
            value: "None"
        });
        vObjTypeOpts.push({
            class: "optionClass",
            label: "Custom",
            value: "Custom"
        });
        
        component.find('idObjectType').set("v.options", vObjTypeOpts);
        
    },
    
    fetchsObject: function(component, event, helper) {
        
        var vObjType = event.getSource().get("v.value");
        // alert(event.getSource().get("v.value"));
        component.set("v.Spinner", true);
        var action = component.get("c.getObjects");
        action.setParams({
            'strObjectType': vObjType,
        });
        var vObjTypeOpts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var ObjTypeValues = response.getReturnValue();
                component.set("v.Spinner", false);
                if (ObjTypeValues != undefined && ObjTypeValues.length > 0) {
                    vObjTypeOpts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: "None"
                    });
                    
                    for (var i = 0; i < ObjTypeValues.length; i++) {
                        vObjTypeOpts.push({
                            class: "optionClass",
                            label: ObjTypeValues[i].strLabelName,
                            value: ObjTypeValues[i].strApiName
                        });
                    }
                }
                component.find('idObject').set("v.options", vObjTypeOpts);
                if(vObjType == 'None')
                {
                    component.set("v.isDownloadTemplate", true);
                    component.set("v.isUploadFile", true);
                    component.set("v.isDependentDisable", true);
                    
                    component.set("v.isDMLDependable",true);
                }
                else
                    component.set("v.isDependentDisable", false);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    getDMLValues : function(component, event, helper) {
        var vDMLOperation = component.find("idDML").get("v.value");
        
        if(vDMLOperation == 'None')
        {
            component.set("v.isUploadFile", true);
            component.set("v.isDownloadTemplate", true);
            
        }
        else if(vDMLOperation == 'Update')
        {
            
            component.set("v.bOperation", 'Update');
            component.set("v.isDownloadTemplate", false);
            component.set("v.isUploadFile", false);
        }else 
        {	
            component.set("v.bOperation", 'Insert');
            component.set("v.isUploadFile", false);
            component.set("v.isDownloadTemplate", false);
        }
        
    },
    
    getApiValues: function(component, event) {
        
        var vObjectName = component.find("idObject").get("v.value");
        
        console.log('vObjectName is >>> '+vObjectName);
        component.set("v.Spinner", true);        
        
        var action = component.get('c.getFields');
        action.setParams({strObjectType : vObjectName} );
        action.setCallback(this, function(response){
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                
                
                //set response value in ListOfContact attribute on component.
                component.set('v.ListOfField', response.getReturnValue());
                component.set("v.Spinner", false);
                if(vObjectName == 'None')
                {
                    component.set("v.isUploadFile", true);
                    component.set("v.isDownloadTemplate", true);
                    component.set("v.isDMLDependable",true);
                }
                else
                {
                    component.set("v.isDMLDependable",false);
                    // component.set("v.isDownloadTemplate", false);
                    //component.set("v.isUploadFile", false);
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    convertArrayOfObjectsToCSV : function(component,keys){
        
        var csvStringResult, counter, columnDivider, lineDivider;
        columnDivider = ',';
        lineDivider =  '\n';
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        return csvStringResult; 
        
    },
    
    
})
({
    getProductStatusResult : function(component, event, helper) {
        var getStatusCheckResult = component.get("c.getProductStatusResult");
        getStatusCheckResult.setParams({
            "proposalId": component.get("v.recordId")
        });
        getStatusCheckResult.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                console.log('Response>>>'+result);
                console.log('result.length>>>>>'+result.length);
                console.log('component.get("v.orderExportName")>>>'+component.get("v.orderExportName"));
                var flagToProcced;
                /*
                for(var key in result){
                    console.log('Result Values>>>>>>'+result[key]);
                    if(result[key] === undefined){
                        flagToProcced = 'false';                        
                    }
                    else {
                        flagToProcced = 'true';
                        break;
                    }                    
                }
                */
                if(result.length > 0)
                    flagToProcced = 'true';
                else
                    flagToProcced = 'false';
                
                console.log('flagToProcced>>>>'+flagToProcced);
                //if(result != null && result != undefined)
                if(flagToProcced === 'true')
                {
                    /*
                    var arrayMapKeys = [];
                    for(var key in result){
                        arrayMapKeys.push({key: key, value: result[key]});
                    }*/
                    component.set("v.mapProductStatusValues", result);
                    component.set("v.displayModel", true);
                }
                else{
                    console.log('Response>>result.length>>>>'+result.length);
                    this.fireApplicationEvent(component, event, helper);
                }
            }
        });
        $A.enqueueAction(getStatusCheckResult);
    },
    cancelAction : function(component, event, helper) {        
        var urlEvt = $A.get("e.force:navigateToURL");
        urlEvt.setParams({
            "url": '/' + component.get("v.recordId")
        });
        urlEvt.fire();
        component.destroy();        
    },
    fireApplicationEvent : function(component, event, helper) {
        // Get the application event by using the
        var appEvent = $A.get("e.c:CPQ_Evt_ProceedForExport");
        console.log('event>>>'+appEvent);        
        appEvent.setParams({
            "orderExportName": component.get("v.orderExportName")
        });
        appEvent.fire();
        //component.destroy();
        component.set("v.displayModel", false);
    }
})
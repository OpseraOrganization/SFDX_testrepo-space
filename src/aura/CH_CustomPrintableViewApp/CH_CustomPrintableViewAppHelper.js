({
	doInit : function(component, event, helper, selectedDate) {
        var recId = component.get("v.recordid");
        if(recId !=undefined){
            component.set("v.isSpinner", true);
            var action = component.get("c.getMostRelatedList");
            action.setParams({
                recordId : recId,
                selectedDate:selectedDate
                
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log("state::::", state);
                if(state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    console.log("relatedObjects::::", result);
                    var realtedObjs = JSON.parse(result);
                    component.set("v.parentName",realtedObjs.parentName);                   
                    
                    component.set("v.currentCaseRecord",realtedObjs.currentCaseRecord);//NOKIASC-36679 
                    document.title = "Support Ticket "+realtedObjs.parentName; //NOKIASC-36679         
                    component.set('v.startDate',realtedObjs.startDate);
                    //component.set('v.endDate',realtedObjs.currentCaseRecord.LastModifiedDate);
                    var dataMap = realtedObjs.allChildDateSetMap;
                    var relatedObjs = [];
                    var i = 0;
                    var allDates = ['case'];
                    for ( var key in dataMap ) {
                        allDates.push(key);
                        relatedObjs.push({value:dataMap[key], key:key});
                        if(i == 0){
                            component.set('v.endDate',key); //NOKIASC-36679
                            i++;
                        }
                    }
                    component.set('v.relatedObjects',relatedObjs);                    
                    console.log("alllll::::", component.get('v.relatedObjects'));
                    
                }
                component.set("v.allDates",allDates);
                component.set("v.activeSections",allDates);
                component.set("v.showData", true);
                component.set("v.isSpinner", false);
            });
            $A.enqueueAction(action);
        }
    },
  
})
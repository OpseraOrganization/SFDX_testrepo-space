({
    getDefaultAccount: function(component, event, helper) {
        var action = component.get("c.getDefaultAccountFromHierarchy");
        action.setParams({
            "accId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                console.log('==9===='+JSON.stringify(response.getReturnValue()));
                if(response.getReturnValue().length >0){
                    component.set("v.defaultAccntId",response.getReturnValue());
                }else{
                    component.set("v.isOpen",false);
                    sforce.one.showToast({
                    "title": "Warning!",
                    "message":'There is no default Account in Account Hierarchy'
                });
                    sforce.one.navigateToSObject(component.get("v.recordId"));
                }
            }
        });
        $A.enqueueAction(action);
    },
    selectRecordType: function(component, event, helper) {
        component.set("v.spinner",true);
        var action = component.get("c.getRecordTypeInfo");
        action.setParams({
            "recrdTypeName" : component.get("v.recordTypeVal"),
            "objectApiName" : 'Apttus__APTS_Agreement__c'
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set("v.recordTypeId",response.getReturnValue());
                var recTypId = response.getReturnValue();
                component.set("v.spinner",false); 
                var urlToRedirect = '/lightning/o/Apttus__APTS_Agreement__c/new?defaultFieldValues=Apttus__Account__c='+component.get("v.defaultAccntId")+',&recordTypeId='+recTypId+'&backgroundContext=%2Flightning%2Fr%2FAccount%2F'+component.get("v.recordId")+'%2Fview';
                sforce.one.navigateToURL(urlToRedirect,true);
                /*var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url":urlToRedirect
                });
                
                urlEvent.fire(); */
            }
        });
        $A.enqueueAction(action);
    }
})
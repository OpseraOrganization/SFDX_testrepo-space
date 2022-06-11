({
	"type": "standard__component",
    "attributes": {
        "componentName": "c__CH_WorkgroupMember"
    },
    "state": {
        "recordTypeId": "recordTypeId"
        
    },
	
    getRecordTypeName: function(component, recordTypeId){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getRecordTypeName',{ recordTypeId : recordTypeId, objectName : 'CH_Workgroup_Member__c'}));
        });           
        return promise; 
    },
    getDefaultRecordTypeName: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getDefaultRecordTypeName',{ objectName : 'CH_Workgroup_Member__c'}));
        });           
        return promise; 
    },
	getwrkRecordTypeName: function(component){
        var promise = new Promise( function( resolve , reject ) {
            const sharedjs = component.find("sharedJavaScript");
            resolve(sharedjs.apex(component, 'getRecrdTypeNameMember',{ RecordId : component.get("v.recordId")}));
        });  
        return promise; 
    },
})
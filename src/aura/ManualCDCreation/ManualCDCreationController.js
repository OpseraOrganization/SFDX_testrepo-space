({
	openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      //this.handleReset(component, event, helper);
      component.set("v.isOpen", false);  
   },
    
   handleLoad : function(component, event, helper) {
      component.set("v.isOpen", true);
   },
    
   handleSubmit : function(component, event, helper) {
       event.preventDefault(); 
       var eventFields = event.getParam("fields"); 
       eventFields["Case__c"] = component.get('v.recordId');
       //component.find("myAtt").get("v.value")
       eventFields["QTO_Nokia_Legal_Entity_Account__c"] = component.find("field4").get("v.value");
       //eventFields["QTO_Nokia_Legal_Entity_Account__c"] = component.get('v.nokiaLegalEntityAccountValue');
       eventFields["Nokia_Document_Receipt_Date__c"] = new Date();
       component.find('CDCreationForm').submit(eventFields);
       
   },
   handleSuccess : function(component, event, helper) {
      component.set("v.isOpen", false);
      var param = event.getParams();
      var fields = param.response.fields;
      var recordId = param.response.id;
      var navEvt = $A.get("e.force:navigateToSObject");
      navEvt.setParam("recordId", recordId);
      var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'Customer Document saved successfully.',
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire(); 
      navEvt.fire();
   },
   handleReset: function(component, event, helper) {
        component.find('field').forEach(function(f) {
            f.reset();
        });
	}
  
   
    
    
})
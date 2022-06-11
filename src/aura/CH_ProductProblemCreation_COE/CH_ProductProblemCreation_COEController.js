({
    doInit: function(component, event, helper) {
        
        var recordId = component.get("v.recordId");	
        var action = component.get("c.validatePermissionSet");
        helper.helperActionExecute(component, event, action);
        helper.helperActiontoGetProductUsage(component, event, action);
        component.set('v.showSpinner', false); 
        
    },
     handleLoad: function(cmp, event, helper) {
        cmp.set('v.showSpinner', false);
    },
  /* Commented as part of US # 27621
    handleSuccess : function(component, event, helper) {  
        var payload = event.getParams().response;
        var action = component.get("c.updateWorkGroupOnProblem");
        console.log('ID:'+payload.id);
        action.setParams({ 'problemId' : payload.id });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var response = response.getReturnValue(); 
            component.set('v.showSpinner', false);
            var navigationSObject = $A.get("e.force:navigateToSObject");
            navigationSObject.setParams({
                "recordId": payload.id
            });
            $A.get('e.force:refreshView').fire();
            navigationSObject.fire();
            $A.get("e.force:closeQuickAction").fire();
        });
        $A.enqueueAction(action);
        console.log('payload'+JSON.stringify(payload));
    },
    */
    handleError: function(component, event) {
        var errors = event.getParams();
        var errors1 =event.getParam('detail');
        alert(errors1+'@@@' +JSON.stringify(errors));
        console.log("response", JSON.stringify(errors));
        var eventName = event.getName();
        var eventDetails = event.getParam("error");
        console.log('Error Event received' + eventName);
         component.set('v.showSpinner', false);
        
    },
    
    onSubmit :function(component, event, helper) {
        var errorFlag = false;
        component.set('v.showSpinner', true);
        if(component.find('subject').get("v.value") ==null || component.find('subject').get("v.value") ==''){
            $A.util.addClass(component.find('subject'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('subject'), 'slds-has-error');
        }
        if(component.find('status').get("v.value") ==null || component.find('status').get("v.value") =='--None--'){
            $A.util.addClass(component.find('status'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('status'), 'slds-has-error');
        }
        if(component.find('product').get("v.value") ==null ){
            $A.util.addClass(component.find('product'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('product'), 'slds-visible');
        }
        if(component.find('prelease').get("v.value") ==null ){
            $A.util.addClass(component.find('prelease'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('prelease'),'slds-has-error');
        }
        if(component.find('rb').get("v.value") =='--None--'|| component.find('rb').get("v.value") =='' ){
            $A.util.addClass(component.find('rb'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('rb'),'slds-has-error');
        }
        if(component.find('discovered').get("v.value") =='' || component.find('discovered').get("v.value") ==null ){
            $A.util.addClass(component.find('discovered'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('discovered'),'slds-has-error');
        }
        
        if(component.find('repeatability').get("v.value") =='--None--' || component.find('repeatability').get("v.value") =='' ){
            $A.util.addClass(component.find('repeatability'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('repeatability'),'slds-has-error');
        }
        if(component.find('severity').get("v.value") =='--None--' || component.find('severity').get("v.value") ==''){
            $A.util.addClass(component.find('severity'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('severity'),'slds-has-error');
        }
        if(component.find('priority').get("v.value") =='--None--' || component.find('priority').get("v.value") ==''){
            $A.util.addClass(component.find('priority'),'slds-has-error');
            errorFlag = true;
        }else{
            $A.util.removeClass(component.find('priority'),'slds-has-error');
        }
        if(!errorFlag){
            component.find("submitForm").submit();
        }else{
             component.set('v.showSpinner', false);
        }
        
        
    }
    
    
    
})
({
	 handleOnChange : function(component, event, helper) {
        // alert("handleonChange");
         if(event.getParams( "fields" ).value !=null && event.getParams( "fields" ).value !=''){
             component.set( "v.selectedRecordId", event.getParams( "fields" ).value );
             $A.util.removeClass(component.find('lookupField'),'slds-has-error');
         }else{
             if( component.get("v.required")){
                 $A.util.addClass(component.find('lookupField'),'slds-has-error');
                 //component.set( "v.selectedRecordId", null );
             }
             if(component.get("v.fieldName")!='Severity__c' && component.get("v.fieldName")!='CH_Urgency__c' && component.get("v.fieldName")!='Priority') {
                 component.set( "v.selectedRecordId", null );
             }else{
                 component.set( "v.selectedRecordId", event.getParams( "fields" ).value );
                 
                 //component.set( "v.selectedRecordId", "0" );
                 //alert( component.get( "v.selectedRecordId"));
             }
             
         }
        
    }
})
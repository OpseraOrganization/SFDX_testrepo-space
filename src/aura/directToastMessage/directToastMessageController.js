({
    //Lightning Data Service Function on record update.
    recordUpdated: function(component, event, helper) 
    {
        var currentQuoteType = component.get("v.simpleRecord.Quote_Type__c");
        console.log('currentQuoteType >>>'+currentQuoteType);
        // Check field update for Direct Quotes
        if(currentQuoteType === "Direct CPQ")
        {
            helper.checkMaintenanceTypeUpdateForDirectQuote(component,event, helper);
        }        
    }  
    
})
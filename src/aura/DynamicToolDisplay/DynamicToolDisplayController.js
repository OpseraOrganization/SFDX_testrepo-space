({
    myAction : function(component, event, helper) {
        
        var mActionGetMappedValuesURL = component.get("c.getDynamicToolURL");
        mActionGetMappedValuesURL.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.dynamicToolURL", response.getReturnValue());
                //alert(response.getReturnValue()[0].Tool_URL__c);
            }
        }); 
        $A.enqueueAction(mActionGetMappedValuesURL);
        
        
        var mActionGetMappedValues = component.get("c.getDynamicTool");
        var toolName=[];
        //alert('toolName----start'+toolName);
        mActionGetMappedValues.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var country;
                var countryName = $A.get("$Label.c.Dynamic_Tool_Display_Country");
                for(var i=0 ; i<response.getReturnValue().length ;i++){
                    //alert(response.getReturnValue()[i].Additional_Resource__c)
                       if(response.getReturnValue()[0].Partner_Contact__c != undefined)
                    {
                    country=response.getReturnValue()[0].Partner_Contact__r.MailingCountry;
                        //if(response.getReturnValue()[i].Procurement_Status__c == 'Completed' && (!response.getReturnValue()[i].Additional_Resource__c == 'Co-op'))
					if(response.getReturnValue()[i].Procurement_Status__c == 'Completed' )
                        {
                            if(!(response.getReturnValue()[i].Additional_Resource__c == 'Co-op')){
                                toolName.push(response.getReturnValue()[i].Additional_Resource__c);
                               }
                           

                    }
                }
                }
                //alert('toolName 2---- '+toolName);
                //alert('countryName---- '+countryName);
                //alert('country---- '+country);
                var indexofOrderTracking = toolName.indexOf("Order Tracking");
                var indexofInvoiceTracking = toolName.indexOf("Invoice Tracking");
                //alert('indexofInvoiceTracking'+indexofInvoiceTracking);
              //  var indexofCo = toolName.indexOf("Co-op");
             //	   toolName[indexofCo]=$A.get("$Label.c.Co_op_Online_Program_Tool");
                if(countryName == country)
                {
                    if (indexofOrderTracking !== -1 )
                    {
                        toolName[indexofOrderTracking] = $A.get("$Label.c.North_America_Order_Tracking");
                    }
                    if(indexofInvoiceTracking !== -1){
                        toolName[indexofInvoiceTracking] = $A.get("$Label.c.North_America_Invoice_Tracking");
                    }
                    if(!toolName.length > 0){
                        toolName[indexofOrderTracking] = $A.get("$Label.c.Non_USA_Order_Invoice_Status_Tool");
                        toolName[indexofInvoiceTracking+1] = $A.get("$Label.c.Non_USA_Order_Invoice_Status_Tool");
                        //alert('toolName++++++print');
                    }
                }
                else{
                    if (indexofOrderTracking !== -1  &&  indexofInvoiceTracking !== -1){
                      toolName[indexofOrderTracking] = $A.get("$Label.c.Non_USA_Order_Invoice_Status_Tool");
                      toolName.splice(indexofInvoiceTracking, 1);  
                    }
                    if(!toolName.length > 0){
                        toolName[indexofOrderTracking] = $A.get("$Label.c.Non_USA_Order_Invoice_Status_Tool");
                        toolName[indexofInvoiceTracking+1] = $A.get("$Label.c.Non_USA_Order_Invoice_Status_Tool");
                        //alert('toolName++++++print');
                    }
                   //alert('toolName3+++++'+toolName);
                }
                
                component.set("v.dynamicTool", toolName);
                
                
                //alert(toolName.indexOf(v.dynamicTool));
            }
        }); 
        $A.enqueueAction(mActionGetMappedValues);
    },
    ooCLickURL :function(component, event, helper){
        //alert("hi")
        var URL='';
        var whichOne = event.getSource().get("v.name");
        var toolURL= component.get("v.dynamicToolURL");
        for(var i=0 ; i<toolURL.length ;i++)
        {
            if(toolURL[i].ToolName__c === whichOne)
            {
                URL = toolURL[i].Tool_URL__c;
            }
        }
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": URL
        });
        urlEvent.fire();
        
    }
    
}
 })
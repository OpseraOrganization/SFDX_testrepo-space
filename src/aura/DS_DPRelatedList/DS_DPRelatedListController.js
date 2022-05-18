({
         doInit : function(component, event, helper) {
           var actionstatusDetails = component.get("c.getDPAnalyticsSource");
            actionstatusDetails.setParams({
                "currentRecordId":component.get("v.recordId")
            });  
            actionstatusDetails.setCallback(this, function(response) {
                           
              /* if(response.getReturnValue().Analytics_Source__c == 'CCRE') 
                {
                     component.set("v.DPFlag",2);
                        
                }else{ */
                    component.set("v.DPFlag",1);
               // }
                
                });
             $A.enqueueAction(actionstatusDetails);
             var DPType = component.get("v.DPFlag")
         
          helper.getCXMLineItem(component, event, helper)
         
          helper.getCCRELineItem(component, event, helper)
        },
          OpenPage: function(component, event, helper) {
    var id_str = event.srcElement.name
            // var Id = event.getSource().get("v.name");
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/"+id_str,
        });
        urlEvent.fire();
            
            
        },
        
         openBundleProduct: function(component, event, helper) {
    var id_str = event.srcElement.name
            // var Id = event.getSource().get("v.name");
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/"+id_str,
        });
        urlEvent.fire();
            
        },
         OpenSalesItem : function(component, event, helper) {
    var id_str = event.srcElement.name
           //  var Id = event.getSource().get("v.name");
         var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/"+id_str,
        });
        urlEvent.fire();
            
        }
        
    })
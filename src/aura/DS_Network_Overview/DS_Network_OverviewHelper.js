({
        getTechnologyHelper : function(component, event, helper){
          
            var newaction = component.get("c.getTechnology");
             newaction.setCallback(this, function(response) {
                var state = response.getState();
                if (response.getState() === "SUCCESS") {
                    var returnStringVal = response.getReturnValue();
                 
                    component.set("v.technology",returnStringVal);
                }
            });
            
            $A.enqueueAction(newaction);
            
        },
    
     
    showFiles : function(component, event, helper) {
         
              var technology = component.find("tech").get("v.value");	
              var actionstatusDetails = component.get("c.getFiles"); 
              actionstatusDetails.setParams({ "technology": technology});  
            actionstatusDetails.setCallback(this, function(response) {
            component.set('v.fileURL',response.getReturnValue());
            var contacts = component.get("v.fileURL");//Getting Map and Its value
            for(var key in contacts){
            	if(key === "Network Trends"){
                      
                       if(contacts[key] === "NULL"){
                            component.set('v.NetworkTrendFileUrl',1);
                            var contacts22 = component.get("v.NetworkTrendFileUrl");//Getting Map and Its value
                       }
                       else if(contacts[key] === "Blank"){
                            component.set('v.NetworkTrendFileUrl',0);
                            var contacts22 = component.get("v.NetworkTrendFileUrl");//Getting Map and Its value
                       }
                        else{
                                 component.set('v.NetworkTrendFileUrl',contacts[key]);
                                  var contacts1 = component.get("v.NetworkTrendFileUrl");//Getting Map and Its value
                         }
                 }
                    
                 if(key === "Benchmarking"){
                     var i=1;
                     if(contacts[key] === "NULL"){
                            component.set('v.BenchmarkingFileUrl',1);
                            var contacts22 = component.get("v.BenchmarkingFileUrl");//Getting Map and Its value
                        }
                     else if(contacts[key] === "Blank"){
                            component.set('v.BenchmarkingFileUrl',0);
                            var contacts22 = component.get("v.BenchmarkingFileUrl");//Getting Map and Its value
                        }
                     
                         else{
                                 component.set('v.BenchmarkingFileUrl',contacts[key]);
                                  var contacts1 = component.get("v.BenchmarkingFileUrl");//Getting Map and Its value
                         }
                  }
                    
                 if(key === "Installed Base"){
                 	if(contacts[key] === "NULL"){
                    	component.set('v.InstalledBaseFileUrl',1);
                            var contacts22 = component.get("v.InstalledBaseFileUrl");//Getting Map and Its value
                    }
                     else if(contacts[key] === "Blank"){
                    	component.set('v.InstalledBaseFileUrl',0);
                            var contacts22 = component.get("v.InstalledBaseFileUrl");//Getting Map and Its value
                    }
                    else{
                         component.set('v.InstalledBaseFileUrl',contacts[key]);
                         var contacts1 = component.get("v.InstalledBaseFileUrl");//Getting Map and Its value
                       }
                   }
               
                    
                }
                    
            });
            $A.enqueueAction(actionstatusDetails); 
        }
         
    })
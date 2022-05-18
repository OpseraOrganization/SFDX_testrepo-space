({
	download : function(text, name, type) {
	    var a = document.createElement("a");
    	var file = new Blob([text], {type : "application/json"});
    	a.href = URL.createObjectURL(file);
    	a.download = name;
    	a.click();
	},
    InsertJsonFile : function(component, event, helper) {
       // alert('state-----Nik>');
	    var action = component.get("c.InsertJson");
         action.setParams({ recordId: component.get("v.recordId")})
         action.setCallback(this, function(response){
        	var state = response.getState();  
          //alert('state-----Nik>');
        	if(state === "SUCCESS"){  
        
            }
            else{                 
               
            } 
        });
        $A.enqueueAction(action);
         
      
        
	},
    getDPValue : function(component, event, helper){
		var action = component.get("c.getDPInfo");
        var docName; 
        action.setParams({ recordId: component.get("v.recordId")})
        action.setCallback(this, function(response){
        var state = response.getState();  
          
        if (state === "SUCCESS"){  
        	console.info('Successasdasd');                
            docName = response.getReturnValue();  
            console.log('response.getReturnValue()-->'+response.getReturnValue());
            var res = docName.split(",");
            console.log('res[0]-->'+res[0]);
            component.set("v.digitalProposalList", res[0]);
            component.set("v.digitalProposalstatus", res[1]);
           // alert('res[3]--->'+res[3]);
            
            component.set("v.digitalProposalupsellstatus", res[3]);
            //alert('res[4]--->'+res[4]);
            component.set("v.dislayEntitlementStatus", res[4]);
           // alert('res[5]--->'+res[5]);
            component.set("v.deliverySystem", res[5]);
            
            //DSI-1255,Sprint -21
           //Removed RMP dependency ,Sprint 21, DSI-1255
            if(res[4] =='Entitled' && res[5]=='SWMP' ){
                component.set("v.dislayjsonButton", true);
            }
            console.log('res[4]-->'+res[4]);
            if(res[4]==="Can Be Entitled" && res[3]==="Ready For Review"){
                component.set("v.dislayVerifyProposalButton", false);
            }
            }
            else{                 
                var errors = response.getError();
                if (errors){
                    console.info('Inside if of errors');
                    if (errors[0] && errors[0].message){
                        console.info("Error message: " + errors[0].message);
                    }
                }
            } 
        });
        $A.enqueueAction(action);
    }
})
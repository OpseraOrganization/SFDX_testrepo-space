({
	toast : function(component, event, message) {
		 
        console.log('success ?: '+component.get("v.isSuccess"));
        $A.createComponent(
            "c:NOKIACPQ_ToastMessage",
            {
                "success":component.get("v.isSuccess"),
                "message1":message
            },
            function(myModal){
                if (component.isValid()) {
                    var targetCmp = component.find('ModalDiv');
                    var body = targetCmp.get("v.body");
                    body.push(myModal);
                    targetCmp.set("v.body", body); 
                    console.log('modalend');
                }
            }
        );
	},
    
    sendMessage : function(component, configdata) {
        
        var msg = {
            type: "cfg_data",
            data: configdata
        };
        setTimeout(function(){ 
            
   component.find("vueApp").message(msg);
             }, 3000);
    },
    
 getcfgdata : function(component, event, helper){
        component.set("v.Spinner",true);
        console.log('entered getcfgdata');
        try{
        var action = component.get("c.getconfigdata");
           var payload = event.getParam("message");
            console.log("Payload"+payload);
            action.setParams({
                lineitemid :component.get("v.lineitemid") 
            });
            console.log("configId"+component.get("v.configId"));  
            action.setCallback(this, function(response) {
                var state = response.getState();
                var res = response.getReturnValue();
                console.log("response"+res);
                if (state === "SUCCESS") {
             
              
                   this.sendMessage(component,res);
                    //$A.get('e.force:refreshView').fire();
                    console.log('refresh event triggered');
                   component.set("v.isSuccess","true");
                    component.set("v.Spinner",false);
                     
                   helper.toast(component, event, "Configuration loaded");
                   //	helper.showToast(component, event, helper);
                }
                else if (state === "INCOMPLETE") {
                    
                }	
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.Spinner",false);
                                component.set("v.isSuccess","false");
                               // helper.toast(component, event, errors[0].message);
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);
        }catch(e){
            console.log('error: '+e.message);
            component.set("v.Spinner",false);
        }
    },
    
    makecallout : function(component, event, helper,msg){
    var msgPassed = JSON.parse(JSON.stringify(msg));
           //console.log('session Id',msgPassed.data.sessionId);
            //console.log('transactio Id',msgPassed.transactionId);
            var action = component.get("c.getNAIPRespv1");
			action.setParams({
				url: JSON.stringify(msgPassed.type),
                passmsg :JSON.stringify(msgPassed.data),
                urlparam : JSON.stringify(msgPassed.param)
            });
			 action.setCallback(this, function(response) {
                 console.log('entered success');
                 
                var state = response.getState();
                 console.log('get state: '+state);
                var res = response.getReturnValue();
                //console.log("response"+res);
                if (state === "SUCCESS") {
                    //Added by christie
					var tempo = "";
                    if(res.startsWith("{"))
                        tempo = JSON.parse(res);
                    else
                        tempo = res;
                    var msgToSend = {
                        transactionId: msgPassed.transactionId,
                        type: msgPassed.type,
                        param: msgPassed.param,
                        //data: JSON.parse(res)
                        data: tempo
                    }
                     component.find("vueApp").message(JSON.stringify(msgToSend));
					
				}else if (state === "ERROR") {
                    var msgToSend = {
                        transactionId: msgPassed.transactionId,
                        type: msgPassed.type,
                        param: msgPassed.param,
                        data: "error"
                    }
                     component.find("vueApp").message(JSON.stringify(msgToSend));
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                               // component.set("v.Spinner",false);
                                component.set("v.isSuccess","false");
                                helper.toast(component, event, errors[0].message);
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
			 }); 
             $A.enqueueAction(action);
},
    sendbomdata : function(component, event, helper,payload){
        console.log('1');
        var msg = JSON.parse(payload);
        console.log('2');
            var msgPassed = JSON.parse(JSON.stringify(msg));
            component.set("v.Spinner",true);
            var action = component.get("c.insertlineitems");
           // console.log("Payload"+payload);
            action.setParams({
                configId :component.get("v.configId"),
                body : payload,
                lineitemid : component.get("v.lineitemid")
            });
            console.log("configId"+component.get("v.configId"));  
            action.setCallback(this, function(response) {
                var state = response.getState();
                var res = response.getReturnValue();
               // console.log("response"+res);
                console.log("state"+state);
                if (state === "SUCCESS") {
                    
                    var msgToSend = {
                        transactionId: msgPassed.transactionId,
                        type: "bom",
                        param: msgPassed.param,
                        data: "BOM received"
                    };
                    
                    //debugger;
                    component.find("vueApp").message(JSON.stringify(msgToSend));
                    var message;
                    if(res === "success"){
                        component.set("v.isSuccess","true"); 
                        message = "Configuration and items saved successfully";
                    }else{
                        component.set("v.isSuccess","false"); 
                        message = res;
                    }
                    component.set("v.Spinner",false);
                    helper.toast(component, event, message);
                }
                else if (state === "INCOMPLETE") {
                    component.set("v.Spinner",false);
                }	
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        console.log('errors'+JSON.stringify(errors));
                        component.set("v.isSuccess","false");
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.isSuccess","false");
                                component.set("v.Spinner",false);
                                helper.toast(component, event, errors[0].message);
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
            });
            
            $A.enqueueAction(action);

    }
})
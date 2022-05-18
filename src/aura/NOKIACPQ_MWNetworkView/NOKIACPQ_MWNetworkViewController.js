({
    controllerfunctionName : function(c, e,h) {
        jQuery("document").ready(function(){
            //debugger;
        });
    },
    handleMessage : function(component, message, helper) {
        //debugger;
        var payload = message.getParams().payload;
        console.log('payload'+payload);
        var compEvents = component.getEvent("componentEventFired");// getting the Instance of event
        compEvents.setParams({ "message" : payload });// setting the attribute of event
        compEvents.fire();//
    },
    handleMessage1: function(component, event, helper) {
       
        var payload = event.getParam("message");
        var msg = JSON.parse(payload);
        console.log('lineitemid: '+component.get('v.lineitemid'));
        console.log('payload'+payload);
       // console.log('msg'+JSON.stringify(msg));
        if(msg.LOADED == "true"){
            console.log('entered loaded condition');
         
            helper.getcfgdata(component, event, helper);
        }
       if(msg.type === "addStation" || msg.type === "updateStation" || msg.type === "deleteStation" || msg.type === "addLink" || msg.type === "updateLink" || msg.type === "deleteLink" || msg.type === "customReq") {
           
           helper.makecallout(component, event, helper,msg);
                
         }  
         else if(msg.type === "bom") {
             console.log('bom');
             helper.sendbomdata(component, event, helper,payload);
        }
    },
    
    RedirectTocart: function(component, event, helper) {
       //if (confirm("Please make sure you have saved configuration before going back to cart. To stay on same page press cancel"))
       if (confirm('If you have saved your configuration click "OK" to continue to the Cart.\nIf not, click	 "Cancel" and "Save Configuration" before returning to the Cart.'))
         {
            var vars = {};
            var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                vars[key] = value;
                console.log('working'+m);
                console.log('working1'+key);
            });
             var  vURL = '';
			 var changeurlCase = window.location.hostname.toLowerCase();
             if(changeurlCase.includes('partner'))
             {
              vURL = "https://"+window.location.hostname+"/Apttus_Config2__Cart?cartStatus=New&configRequestId="+ vars["configRequestId"]+"&flow="+vars["flow"]+"&id="+vars["id"];
             }
             else
             {
              vURL = "https://"+$A.get("$Label.c.CartURL")+"/apex/Cart?configRequestId="+ vars["configRequestId"]+"&cartStatus=New&id="+vars["id"]+"&flow=";
    
             }
                 window.location = vURL;
             

        } else {
            
        }
        
        
    },
    launch_toast:function(component, event, helper) {
        helper.toast(component, event, helper);
    }
})
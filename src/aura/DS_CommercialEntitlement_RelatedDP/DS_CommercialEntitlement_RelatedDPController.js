({
    getRelatedproducts: function(component,event,helper){
        
        //helper.showProductsHelper(component);
        helper.getRelatedProductsHelper(component);
    },
    
    Expandcollapse : function(component,event,helper)
    {
        var auraid=event.getSource().getLocalId();
         var selectedtablerow=' selectedtablerow';
        if(auraid=='add'){
           
            event.getSource().set("v.value",true);
           var Clasval= event.getSource().get("v.name"); 
            if(!Clasval.includes(selectedtablerow))
            Clasval +=selectedtablerow;
            event.getSource().set("v.name",Clasval);
        }
        
        if(auraid=='remove'){
            event.getSource().set("v.value",false);
         var Clasvalue= event.getSource().get("v.name");
            if(Clasvalue.includes(selectedtablerow)){
             Clasvalue= Clasvalue.replace(selectedtablerow,'  ');
            }
        
        event.getSource().set("v.name",Clasvalue);
        }
    },
    
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    
    onSelectAllChange: function (component, event, helper) {
        var currentval= event.getSource().get("v.checked");
        var MyProductfeatureList = component.get("v.MyProductfeatureList");
        var selectedRow=' selectedRow';
        if(MyProductfeatureList!=null&&MyProductfeatureList!=undefined&&MyProductfeatureList!=''&&MyProductfeatureList.length!=0)
        {
            for (var indexVar = 0; indexVar < MyProductfeatureList.length; indexVar++) {
                if (MyProductfeatureList[indexVar].isactivated==false&&currentval==true&&MyProductfeatureList[indexVar].upsellitems.Acceptance_Initiation__c==true&&MyProductfeatureList[indexVar].upsellitems.Delivery_Completed__c==true)
                {
                    MyProductfeatureList[indexVar].upsellitems.Status_In_Network__c=true;
                     var clasval= MyProductfeatureList[indexVar].selectedRow;
                    if(!clasval.includes(selectedRow))
                      clasval +=selectedRow;
                    MyProductfeatureList[indexVar].selectedRow=clasval;
                }
                if (MyProductfeatureList[indexVar].isactivated==false&&currentval==false)
                {      var Clasvalue=MyProductfeatureList[indexVar].selectedRow;
                     if(Clasvalue.includes(selectedRow))
                 Clasvalue= Clasvalue.replace(selectedRow,'  ');
                    
                     MyProductfeatureList[indexVar].selectedRow=Clasvalue;
                    MyProductfeatureList[indexVar].upsellitems.Status_In_Network__c=false;
                }
            }
            component.set("v.MyProductfeatureList",MyProductfeatureList);
        }
        
        
        var a = component.get('c.openconfirmbuttoncheck');
        $A.enqueueAction(a);
        
        
    },
 

       openconfirmbutton: function (component, event, helper) {
           var selectedRow=' selectedRow';
        var LocalId=event.getSource().getLocalId();
          
        if(LocalId=='singleselect'){
         var currentval= event.getSource().get("v.checked");
          var Clasvalue= event.getSource().get("v.value");
           
            
            if(currentval==true){
                 if(!Clasvalue.includes(selectedRow))
                 Clasvalue +=selectedRow;
                
               event.getSource().set("v.value",Clasvalue);
            }
        
            if(currentval==false){
                if(Clasvalue.includes(selectedRow))
             Clasvalue= Clasvalue.replace(selectedRow,'  ');
                    
               event.getSource().set("v.value",Clasvalue);
            }
    }
            var a = component.get('c.openconfirmbuttoncheck');
        $A.enqueueAction(a);
    },
     openconfirmbuttoncheck: function (component, event, helper) {
         
        var needtouppdatelist= helper.openconfirmbuttonhelper(component, event,helper);
       
        if(needtouppdatelist==null|| needtouppdatelist==undefined|| needtouppdatelist==''){
            component.set("v.showConfirmbuttonSection",true);
            component.set("v.showConfirmmessage",false);
            component.find("selectall").set('v.checked',false);
        }
        
    },
    
    openconfirmmessage: function (component, event, helper) {
        var needtouppdatelist=helper.openconfirmbuttonhelper(component, event,helper);
        
        if(needtouppdatelist!=null&&needtouppdatelist!=undefined&&needtouppdatelist!='')
        {
            component.set("v.showConfirmbuttonSection",false);
            component.set("v.showConfirmmessage",true);
            
        } 
        
    },
    
    addfeedback : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var link = '/';
        	urlEvent.setParams({
            	"url": link+"feedback",
        	});
        // alert(window.location.pathname);
    	urlEvent.fire(); 
	},
    
    updatestatus: function (component, event, helper) {
        var needtouppdatelist=helper.openconfirmbuttonhelper(component, event);
        if(needtouppdatelist==null|| needtouppdatelist==undefined|| needtouppdatelist==''){
            component.set("v.showConfirmmessage",false);
            component.find("selectall").set('v.checked',false);
        }
        if(needtouppdatelist!=null&&needtouppdatelist!=undefined&&needtouppdatelist!='')
        {
            var action = component.get("c.activateproducts"); 
            action.setParams({
                "updateupsellitems": needtouppdatelist,
            });
            action.setCallback(this, function(response) {             
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.showThankyou",true);
                }
                else{
                    var   errors = response.getError();
                    var errorpgmsg=JSON.stringify(errors);
                    alert('Error  ++>'+errorpgmsg);
                    
                }            
            });
            $A.enqueueAction(action);
        }
    },
    
    gotoListView: function (component, event, helper) {
        alert('go to list vew')
        var urlEvent = $A.get("e.force:navigateToComponent");
        alert(urlEvent)
        urlEvent.setParams({
            componentDef:"c:DS_TabRendering"
        });
        alert(urlEvent);
        urlEvent.fire(); 
    },
    
})
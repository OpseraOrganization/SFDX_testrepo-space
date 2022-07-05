({
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if(getInputkeyWord==null || getInputkeyWord==undefined || getInputkeyWord=='')
         getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
        var getInputkeyWord = component.get("v.SearchKeyWord");
 if( getInputkeyWord.length > 0 ){            
     var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            
            
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
          
        }
    },
    
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", null ); 
          component.set("v.selectedrecordid", '' ); 
        var getselectedWrpper = component.get("v.wrapperObject");
    if(getselectedWrpper!=null && getselectedWrpper!=undefined && getselectedWrpper!='')
    {
         var compEvent = component.getEvent("Coloring_Event");
        compEvent.setParams({"wrapperObject" : getselectedWrpper });  
        compEvent.fire(); 
    }
    },
    
    handleComponentEvent : function(component, event, helper) {
      
        var selectedFromEvent = event.getParam("recordByEvent");
    if(selectedFromEvent!=null && selectedFromEvent!=undefined && selectedFromEvent!='')
        {
            //JSON.stringify(selectedFromEvent);   //event.getParam("recordid");
             var selectedidFromEvent =selectedFromEvent.Id;
        component.set("v.selectedRecord" , selectedFromEvent); 
        component.set("v.selectedrecordid" , selectedidFromEvent); 
        }
 
     
        var getsselectedrec = component.get("v.selectedRecord");
        if(getsselectedrec!=null && getsselectedrec!=undefined && getsselectedrec!='')
        {
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
            
     var lookupinputtext = component.find("lookupinputtext").set("v.value",null);
            
        }
          var getselectedWrpper = component.get("v.wrapperObject");
    if(getselectedWrpper!=null && getselectedWrpper!=undefined && getselectedWrpper!='')
    {
         var compEvent = component.getEvent("Coloring_Event");
        compEvent.setParams({"wrapperObject" : getselectedWrpper });  
        compEvent.fire(); 
    }
    },
})
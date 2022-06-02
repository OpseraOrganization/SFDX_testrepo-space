({  
    onfocus : function(component,evt,helper){
        
        /*if (!$A.util.isUndefined(evt)) {
            evt.preventDefault();
            evt.stopPropagation(); 
        }*/
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.isFilterOpened', true);
            }), 10
        );
        
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        //component.set('v.isFilterOpened', true); 
        // Get Default 5 Records order by createdDate DESC
        var getInputkeyWord = '';
        helper.searchHelper(component,evt,getInputkeyWord);
        helper.openFilter(component);
        console.dir("focus");
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and
        // call the helper
        // else close the lookup result List part.
        // 
        
        window.setTimeout(
            $A.getCallback(function() {
                component.set('v.isFilterOpened', true);
            }), 10
        );
        
        if(getInputkeyWord != ""){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
            helper.openFilter(component);
        }else{
            component.set("v.listOfSearchRecords", null );
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            component.set('v.isFilterOpened', false);
            helper.closeFilter(component);
        }
    },
    
    // function for clear the Record Selaction
    clear :function(component,event,helper){

        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        var forclose = component.find("filter");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        helper.closeFilter(component);
        
        console.dir("clear");
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedName", "");
        component.set("v.selectedId", "");
    },
    
    // This function call when the end User Select any record from the result list.
    handleComponentEvent : function(component, event, helper) {
        
        // get the selected Account record from the COMPONETN event
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.dir(selectedAccountGetFromEvent.Name);
        component.set("v.selectedName" , selectedAccountGetFromEvent.Name);
        component.set("v.selectedId" , selectedAccountGetFromEvent.Id);
        component.set("v.disbaledValue",false);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        var forclose = component.find("filter"); 
        $A.util.addClass(forclose, 'slds-hide');
        $A.util.removeClass(forclose, 'slds-show');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
        helper.closeFilter(component);
        
    },
    // automatically call when the component is done waiting for a response to a server request.
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.addClass(spinner, 'slds-hide');
    },
    // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        $A.util.removeClass(spinner, 'slds-hide');
    },
    gotoProduct : function (component, event, helper){        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/product2/"+component.get("v.selectedId")
        });
        urlEvent.fire();      
    }
})
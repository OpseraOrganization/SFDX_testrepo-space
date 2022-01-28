({
    doInit : function(component, event, helper) {           
        //helper.setListViews(component);
        //helper.loadContractsInfo(component);
        helper.setAllMyEntitlements(component);
    },
    toggleVisibility : function(component, event, helper) {       
        component.set("v.ShowListView",true);       
        var ddDiv = component.find('ncp-listViewMenu');
        $A.util.toggleClass(ddDiv,'slds-is-open');
        if (!$A.util.isUndefined(event)) {
            event.stopPropagation(); 
        }
    },
    selectListView : function(component, event, helper) {           
        var selectedItem = event.currentTarget;       
        var currentViewLabel = selectedItem.dataset.name;
        var currentViewId = selectedItem.dataset.id;
        var currentAccount = selectedItem.dataset.account;
        console.log("### currentAccount : "+currentAccount);
        component.set('v.selectedListView',currentViewLabel);
        if(!$A.util.isUndefined(currentAccount)) component.set('v.selectedListView',currentViewLabel+' - '+currentAccount);
        component.set('v.recordId',currentViewId);
        if(component.get('v.selectedListView') == 'All Contracts'){
            helper.setAllMyEntitlements(component);
        }else{
            helper.setMyEntitlements(component);
        }
        //helper.loadContractsInfo(component);
    }
})
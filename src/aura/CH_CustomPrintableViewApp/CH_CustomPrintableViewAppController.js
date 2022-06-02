({
    doInit : function(component, event, helper) { 
        helper.doInit(component, event, helper,null);       
    },
    
    print : function(component, event, helper) {
        var printButton = component.find('printButton');
        $A.util.toggleClass(printButton, 'slds-hide');
        event.preventDefault();
        window.print();
        $A.util.toggleClass(printButton, 'slds-hide');
    },
    /********************************************
	*Method to toglle Accordion
	*********************************************/
    handleSectionToggle: function (component, event, helper) {
        var openSections = event.getParam('openSections');
    },
    closeWindow: function (component, event, helper) {
        window.close();
    },
    collapseAll: function (component, event, helper) {
         component.set("v.activeSections",[]);
    },
    expandAll: function (component, event, helper) {
         component.set("v.activeSections",component.get("v.allDates"));
    },
    /*onDateChange: function (component, event, helper) {
         var d =component.get("v.selectedDate");
        console.log('ddd '+d);
        component.set("v.activeSections",['case',d]);

        // helper.doInit(component, event, helper,d);
        //component.set("v.isDateChanged", true);
    },*/
    
    onstartDateChange: function (component, event, helper) {
         var d =component.get("v.startDate");
        console.log('ddd '+d);
        component.set("v.activeSections",['case',d]);

    },
     onendDateChange: function (component, event, helper) {
         var d =component.get("v.endDate");
        console.log('ddd '+d);
        component.set("v.activeSections",['case',d]);

    },
    
})
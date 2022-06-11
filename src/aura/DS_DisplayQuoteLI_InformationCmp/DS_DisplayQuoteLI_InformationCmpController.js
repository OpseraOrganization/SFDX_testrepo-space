({
    doInit : function(component, event, helper) {
        helper.getQuoteList(component);
        helper.getAttributeList(component);
        helper.getAttributeMap(component);
    },
    Expandcollapse : function(component, event, helper) {
        var auraid = event.getSource().getLocalId();
        var selectedtablerow = ' selectedtablerow';
        if (auraid == 'add') {
            event.getSource().set("v.value", true);
        } else if (auraid == 'remove') {
            event.getSource().set("v.value", false);
        }
    }
})
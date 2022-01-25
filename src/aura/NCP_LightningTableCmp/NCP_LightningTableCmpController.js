({
    doInit: function(component, event, helper) {
        component.set("v.listViewName",component.get("v.listViewName"));
    },   
    sortByName: function(component, event, helper) {
        helper.sortBy(component, "Name");
    },  
    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },        
    onCheck: function(component, event, helper) {
        var isSelected = event.getSource().get("v.checked");
        var id = event.getSource().get("v.value");
        helper.saveFavoriteProducts(component, id, isSelected);
    },
    handleClick:function(component, event, helper) {
        var productId = event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
                "recordId": productId
    });
        navEvt.fire();

    }
})
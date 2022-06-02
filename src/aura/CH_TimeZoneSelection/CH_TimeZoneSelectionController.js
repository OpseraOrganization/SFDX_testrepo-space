({
    init: function (component, event, helper) {
        component.set('v.mapMarkers', [{ location: {} }]);
        component.set('v.zoomLevel', 1);
    },
    handleKeyUp: function (component, event, helper) {
        if(event.keyCode === 13) {
        	helper.search(component);
        }
    },
    search: function (component, event, helper) {
        helper.search(component);
    }
})
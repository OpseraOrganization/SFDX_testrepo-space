({
    emit: function(component, value) {
        component.getEvent("onEvent").setParams({
            valueChoosen: value
        }).fire();
    }
})
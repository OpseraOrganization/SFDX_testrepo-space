({
	doInit : function(component, event, helper) {
		
	},
    onSingleSelectChange: function(component) {
        console.log('onSingleSelectChange');
        var selectCmp = component.find("InputSelectSingle");
        component.set("v.serviceTypeSelection", selectCmp.get("v.value"));
        console.log('pop up selection ###'+ component.get("v.serviceTypeSelection"));
    },
    cancel : function(component, event, helper) {
        component.set("v.visible", false);
	},
    next : function(component, event, helper) {
        component.set("v.visible", false);
        //emit event with the valueChoosen
        helper.emit(component, component.get("v.serviceTypeSelection"));
	}
})
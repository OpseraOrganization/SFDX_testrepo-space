({
	doInit : function(component, event, helper) {
        component.find('search').set('v.value', "");
        let options = component.get('v.options');
        if(options && options.length != 0) {
            helper.preSelect(component, component.get('v.value'), options);
            helper.filter(component, component.find('search').get('v.value'), options);
        }
        else component.set('v.filteredOptions', []);
	},
    selectHandler : function(component, event, helper) {
        var value = event.getSource().get("v.value");
        var label = event.getSource().get("v.label");
        component.set('v.reload', true);
        component.set('v.reload', false);
        component.set('v.value', value);
		component.getEvent("onchange").setParams({
            value: value
        }).fire();
        component.find('search').set('v.value', label);
        helper.filter(component, label, component.get('v.options'));
	},
	searchHandler : function(component, event, helper) {
        var value = component.get('v.selected');
        if(value) {
            component.set('v.value', null);
            component.getEvent("onchange").setParams({
                value: null
            }).fire();
        }
        var search = component.find('search').get('v.value');
        helper.filter(component, search, component.get('v.options'));
	},
    getSelectedValue : function(component, event, helper) {
        return component.get('v.selected');
	},
    setSelectedValue : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) helper.preSelect(component, params.value, component.get('v.options'));
	},
})
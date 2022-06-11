({
	doInit : function(component, event, helper) {
        let columns = component.get('v.columns');
        component.set("v.visibleColumns", columns?columns.filter(cur => cur.type !== 'hidden'):[]);
        component.set("v.columnHeight", columns && columns.filter(cur => cur.type === 'button').length == 0 ? '29px' : '41px');
        helper.filter(component, component.get('v.data'), component.get("v.search"));
        component.set("v.filterConditions", ['equals', 'not equal to', 'less than', 'greater than', 'less or equal', 'greater or equal', 'contains', 'does not contain', 'starts with', 'ends with']);
	},
    sort : function (component, event, helper) {
        var fieldName = event.getParam('fieldName'),
        	sortDirection = event.getParam('sortDirection'),
      		column = component.get('v.columns').filter(cur => cur.fieldName === fieldName)[0];
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", column);
        component.set("v.sortedDirection", sortDirection);
        helper.sort(component, column, sortDirection);
    },
	filter : function(component, event, helper) {
        helper.filter(component, component.get('v.data'), component.get("v.search"));
    },
    handleRowAction : function (component, event, helper) {
        component.getEvent("onrowaction").setParams({
            action: event.getParam('action').name,
            row: event.getParam('row')
        }).fire();
    },
    handleRowSelection : function (component, event, helper) {
        component.getEvent("onrowselection").setParams({
            selectedRows: event.getParam('selectedRows')
        }).fire();
        component.set("v.selectedRowsForGet", event.getParam('selectedRows'));
    },
    handleGlobalAction : function (component, event, helper) {
        component.getEvent("onglobalaction").setParams({
            action: event.getSource().get("v.name"),
        }).fire();
    },
    getSelectedRows : function (component, event, helper) {
        return component.get("v.selectedRowsForGet");
    },
    setSelectedRows : function (component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var selectedList = params.selectedList;
            component.set("v.selectedRows", selectedList);
        	component.set("v.selectedRowsForGet", selectedList);
        }
    },
    reset : function (component, event, helper) {
        component.set("v.filterText", "");
        helper.filter(component, component.get('v.data'), "");
        component.find("searchInput").set("v.value", "");
        component.find("selectionDatatable").set("v.selectedRows", new Array());
        component.set("v.filters", []);
        component.set("v.filterLayout", null);
    },
    clearSelection : function (component, event, helper) {
        component.find("selectionDatatable").set("v.selectedRows", new Array());
        component.getEvent("onrowselection").setParams({
            selectedRows: new Array(),
            action : 'clearSelection'
        }).fire();
    },
    toggleFilter : function (component, event, helper) {
		component.set("v.filterVisible", !component.get("v.filterVisible"));
        component.set("v.filterLayout", null);
    },
    addFilter : function (component, event, helper) {
        var filters = component.get("v.filters"),
        	columns = component.get("v.columns").filter(cur => cur.label != null && cur.label !== ''),
        	newFilter = {
            label : columns[0].label,
            fieldName : columns[0].typeAttributes && columns[0].typeAttributes.label?columns[0].typeAttributes.label.fieldName:columns[0].fieldName,
            condition: "equals",
            value: "",
            index: filters.length,
            column: 0,
            active: false
        };
        filters = filters.length != 0?[...filters, newFilter]:[newFilter];
        component.set("v.filterLayout", newFilter);
        component.set("v.filters", filters);
    },
    editFilter : function (component, event, helper) {
        var filters = component.get("v.filters");
        component.set("v.filterLayout", filters[event.srcElement['name']]);
    },
    removeFilter : function (component, event, helper) {
        var filters = component.get("v.filters");
        filters.splice(event.getSource().get("v.name"), 1);
        component.set("v.filters", filters);
        component.set("v.filterLayout", null);
    },
    removeAllFilter : function (component, event, helper) {
        component.set("v.filters", []);
        component.set("v.filterLayout", null);
    },
    cancelFilter : function (component, event, helper) {
        component.set("v.filterLayout", null);
    },
    saveFilter : function (component, event, helper) {
        var columns = component.get("v.columns"),
        	filters = component.get("v.filters"),
        	filter = component.get("v.filterLayout");
        filter.label = columns[filter.column].label;
        filter.fieldName = columns[filter.column].typeAttributes && columns[filter.column].typeAttributes.label?columns[filter.column].typeAttributes.label.fieldName:columns[filter.column].fieldName;
        filter.value = (columns[filter.column].type.toLowerCase() === 'boolean' && filter.value === '')?false:filter.value;
        filter.active = true;
        filters[filter.index] = filter;
        component.set("v.filters", filters);
        component.set("v.filterLayout", null);
    }
})
({
	doInit : function(component, event, helper) {
        let columns = component.get('v.columns');
        component.set("v.visibleColumns", columns?columns.filter(cur => cur.type !== 'hidden'):[]);
        component.set("v.columnHeight", columns && columns.filter(cur => cur.type === 'button' || cur.type === 'button-icon').length == 0 ? (
            columns && columns.filter(cur => cur.type === 'action').length == 0 ? '1.75rem' : '1.875rem'
        ) : '2.575rem');
        helper.filter(component, component.get('v.data'), component.get("v.filterText"));
        component.set("v.filterConditions", ['equals', 'not equal to', 'less than', 'greater than', 'less or equal', 'greater or equal', 'contains', 'does not contain', 'starts with', 'ends with']);
        helper.filterGlobalActions(component, component.get('v.globalActions'));
	},
    filterGlobalActions : function(component, event, helper) {
        helper.filterGlobalActions(component, component.get('v.globalActions'));
	},
    sort : function (component, event, helper) {
        var fieldName = event.getParam('fieldName'),
        	sortDirection = event.getParam('sortDirection'),
      		column = component.get('v.columns').filter(cur => cur.fieldName === fieldName)[0];
        component.set("v.sortedBy", column);
        component.set("v.sortedDirection", sortDirection);
        helper.sort(component, column, sortDirection);
        helper.updateMetaText(component);
    },
	filter : function(component, event, helper) {
        helper.filter(component, component.get('v.data'), component.get("v.filterText"));
        helper.updateMetaText(component);
    },
    handleRowAction : function (component, event, helper) {
        component.getEvent("onrowaction").setParams({
            action: event.getParam('action').name,
            row: event.getParam('row')
        }).fire();
    },
    handleRowSelection : function (component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        var filteredData = component.get('v.filteredData');
        var visibleData = component.get('v.visibleData');
        selectedRows = selectedRows.length == visibleData.length ? filteredData : selectedRows;
        helper.selectedRows = selectedRows;
        component.getEvent("onrowselection").setParams({
            selectedRows: selectedRows
        }).fire();
    },
    handleGlobalAction : function (component, event, helper) {
        component.getEvent("onglobalaction").setParams({
            action: event.getSource().get("v.name"),
        }).fire();
    },
    viewAll : function (component, event, helper) {
        component.getEvent("onglobalaction").setParams({
            action: 'viewAll',
        }).fire();
    },
    handleMenuGlobalAction : function (component, event, helper) {
        component.getEvent("onglobalaction").setParams({
            action: event.getParam("value"),
        }).fire();
    },
    getSelectedRows : function (component, event, helper) {
        return helper.selectedRows;
    },
    setSelectedRows : function (component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var table = component.find("customTable");
            if(table){
                table.set("v.selectedRows", new Array(params.selectedList));
            }
            else  {
                component.set("v.selectedRows", params.selectedList);
            }
            helper.selectedRows = params.selectedList;
        }
    },
    setFilter : function (component, event, helper) {
        let params = event.getParam('arguments');
        if (params) {
            let columns = component.get("v.columns").filter(cur => cur.label != null && cur.label !== '');
            let filterKeys = Object.keys(params.filter || {});
            let filters = [];
            for(let i = 0, len = filterKeys.length; i < len; i++) {
                const key = filterKeys[i], value = params.filter[key];
                const column = columns.find(cur => cur.typeAttributes && cur.typeAttributes.label?cur.typeAttributes.label.fieldName === key:cur.fieldName === key);
                if(column) {
                    filters = [...filters, {
                        label : column.label,
                        fieldName : key,
                        condition: "equals",
                        value: params.filter[key],
                        index: filters.length,
                        column: 0,
                        active: true
                    }];
                }
            }
            component.set("v.filters", filters);
        }
    },
    reset : function (component, event, helper) {
        component.set("v.filterText", "");
        helper.filter(component, component.get('v.data'), "");
        component.find("searchInput").set("v.value", "");
        component.find("customTable").set("v.selectedRows", new Array());
        component.getEvent("onrowselection").setParams({
            selectedRows: new Array(),
            action : 'clearSelection'
        }).fire();
        helper.selectedRows = new Array();
        component.set("v.filters", []);
        component.set("v.filterLayout", null);
    },
    clearSelection : function (component, event, helper) {
        component.find("customTable").set("v.selectedRows", new Array());
        helper.selectedRows = new Array();
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
    },
    setTableHeight : function (component, event, helper) {
        var filteredData = component.get("v.filteredData"),
        	maxRows = component.get("v.maxRows"),
        	columnHeight = component.get("v.columnHeight"),
            globalActions = component.get('v.globalActions');
        if(component.get("v.type") === 'selection')
            component.set("v.tableHeight", 'calc((' + maxRows + ' * ' + columnHeight + ') + 2rem)');
        else if(component.get("v.type") !== 'fullscreen')
            component.set("v.tableHeight", 'calc((' + (maxRows < filteredData.length ? maxRows : filteredData.length) + ' * ' + columnHeight + ') + 2rem)');
        else component.set("v.tableHeight", 'calc(100% - ' + (component.get('v.hideControls') || (globalActions && globalActions.length == 0) ? '90px' : '102px') + '); position: relative; top: -2px');    
    },
    loadMoreData : function (component, event, helper) {
        if(component.get('v.type') !== 'contained' && component.get('v.infiniteLoading')) {
            var filteredData = component.get('v.filteredData');
            var rowsToLoad = parseInt(component.get('v.rowsLoaded')) + parseInt(component.get('v.rowsToLoad'));
            if(rowsToLoad < filteredData.length) {
                component.set('v.visibleData', filteredData.slice(0, rowsToLoad));
                component.set('v.rowsLoaded', rowsToLoad);
            }
            else {
                component.set('v.visibleData', filteredData);
                component.set('v.rowsLoaded', filteredData.length);
                component.set('v.infiniteLoading', false);
            }
        }
    },
    search : function (component, event, helper) {
        let text = component.get("v.search");
        clearTimeout(helper.timeout);
        helper.timeout = setTimeout(() => component.set("v.filterText", text), 500);
    },
    searchOnEnter: function (component, event, helper) {
        if(event.keyCode == 13) {
            component.set("v.filterText", component.get("v.search"));
            clearTimeout(helper.timeout);
        }
    },
})
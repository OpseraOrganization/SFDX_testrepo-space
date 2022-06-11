({
	doInit : function(component, event, helper){
		component.set('v.columns', [
			{
				label: 'Quote Number',
				fieldName: 'qLink',
				type: 'url',
				initialWidth: 150,
				sortable: true,
				disabled: true,
				typeAttributes: {
					label: {fieldName: 'quoteNumber'},
					tooltip: {fieldName: 'quoteNumber'},
					/*disabled: {fieldName: 'isDisabled'},*/

					target: '_self'
				}
			},
			{
				label: 'ID',
				fieldName: 'name',
				type: 'text',
				initialWidth: 120,
				sortable: true
			},
			{
				type: 'button-icon',
				fixedWidth: 40,
				typeAttributes: {
					iconName: {fieldName: 'extraInfoButton'},
					name: 'showHideAttributes',
					variant: 'bare',
					class: {fieldName: 'displayExtraInfo'}
				}
			},
			{
				label: 'Extra Information',
				fieldName: 'extraInfoText',
				type: 'text',
				wrapText: true,
				typeAttributes: {
					class: {fieldName: 'displayExtraInfo'}
				}
			},
			{
				label: 'PO Number',
				fieldName: 'PONumber',
				type: 'text',
				sortable: true,
				initialWidth: 120
			},
			{
				label: 'PO Date',
				fieldName: 'PODate',
				type: 'date-local',
				sortable: true,
				initialWidth: 120,
				typeAttributes: {month: "2-digit", day: "2-digit"},
			},
			{
				label: 'Grand Total',
				fieldName: 'grandTotal',
				type: 'currency',
				sortable: true,
				initialWidth: 130,
				typeAttributes: {
					currencyCode: {fieldName: 'currencyIsoCode'},
					currencyDisplayAs: "code"
				},
				cellAttributes: {
					alignment: "left"
				}
			},
			{
				label: 'Creation Date',
				fieldName: 'creationDate',
				type: 'date-local',
				sortable: true,
				initialWidth: 130,
				typeAttributes: {month: "2-digit", day: "2-digit"},
			},
			{
				label: 'Stage',
				fieldName: 'quoteStage',
				type: 'text',
				sortable: true,
				initialWidth: 170
			}
		]);
		helper.getQuoteStages(component, event, helper);
		helper.getAllCommercialProposals(component, event, helper);
	},
	filterData: function(component, event, helper) {
		helper.filterData(component);
	},

	handleActions: function(component, event, helper) {
		var row = event.getParam('row');
		switch (event.getParam('action').name) {
			case "viewProposal":
				var urlEvent = $A.get("e.force:navigateToURL");
				urlEvent.setParams({
					"url": "/proposal/"+row.id+"?type=swx",
				});
				urlEvent.fire();
				break;
			case 'showHideAttributes':
				if (row.extraInfoButton == 'utility:add') {
					row.extraInfoButton = 'utility:dash';
					row.extraInfoText = row.extraInfo;
				} else {
					row.extraInfoButton = 'utility:add';
					row.extraInfoText = row.truncExtraInfo;
				}
				var rawData = component.get("v.rawData");
				var indexRaw = rawData.indexOf(event.getParam('row'));
				rawData[indexRaw] = row;
				component.set("v.rawData", rawData);

				var data = component.get("v.data");
				var indexFiltered = data.indexOf(event.getParam('row'));
				data[indexFiltered] = row;
				component.set("v.data", data);
				break;
		}
	},
	updateColumnSorting: function(component, event, helper) {
		var fieldName = event.getParam('fieldName');
		var sortedDirection = event.getParam('sortDirection');
		component.set("v.sortedBy", fieldName);
		component.set("v.sortedDirection", sortedDirection);

		helper.sortData(component, fieldName, sortedDirection);
	},

	filterText: function(component, event, helper) {
		if(event.keyCode == 13) {
			//ENTER
			helper.filterData(component);
		}
	},
	clearFilter: function(component, event, helper) {
		//reset filtering bar
		component.set("v.searchText", undefined);
		component.set("v.searchFromDate", undefined);
		component.find("searchByStage").set("v.value", "All");

		//reset table
		helper.filterData(component);
	},

	next: function(component, event, helper) {
		helper.gotoPage(component, component.get("v.currentPageNumber")+1);
	},

	previous: function(component, event, helper) {
		helper.gotoPage(component, component.get("v.currentPageNumber")-1);
	},

	updatePageSize: function(component, event, helper) {
		component.set("v.pageSize", event.getSource().get("v.value"));
		helper.filterData(component);
	}
})
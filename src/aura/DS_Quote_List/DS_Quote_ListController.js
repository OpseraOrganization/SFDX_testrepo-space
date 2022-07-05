({
	doInit : function(component, event, helper) {
		component.set('v.columns', [
			{
				label: '',
				fieldName: 'selection',
				type: 'button-icon',
				fixedWidth: 40,
				typeAttributes: {
					iconName: {fieldName: 'selectIcon'},
					title: {fieldName: 'selectTitle'},
					name: 'handleSelection',
					variant: 'border-filled'
				}
			},
			{
				label: 'Quote Number',
				fieldName: 'qLink',
				type: 'url',
				initialWidth: 145,
				sortable: true,
				typeAttributes: {
					label: {fieldName: 'quoteNumber'},
					tooltip: {fieldName: 'quoteNumber'},
					target: '_self'
				}
			},
			{
				label: 'ID',
				fieldName: 'name',
				type: 'text',
				sortable: true
			},
			{
				label: 'Account',
				fieldName: 'aLink',
				type: 'url',
				sortable: true,
				typeAttributes: {
					label: {fieldName: 'accountName'},
					tooltip: {fieldName: 'accountName'},
					target: '_self'
				}
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
				initialWidth: 300,
				typeAttributes: {
					class: {fieldName: 'displayExtraInfo'}
				}
			},
			{
				label: 'PO Number',
				fieldName: 'PONumber',
				type: 'text',
				sortable: true
			},
			{
				label: 'PO Date',
				fieldName: 'PODate',
				type: 'date-local',
				sortable: true,
				typeAttributes: {month: "2-digit", day: "2-digit"},
			},
			{
				label: 'Grand Total',
				fieldName: 'grandTotal',
				type: 'currency',
				sortable: true,
				typeAttributes: {
					currencyCode: {fieldName: 'currencyIsoCode'},
					currencyDisplayAs: "code"
				},
				cellAttributes: {
					alignment: 'left'
				}
			},
			{
				label: 'Creation Date',
				fieldName: 'creationDate',
				type: 'date-local',
				sortable: true,
				typeAttributes: {month: "2-digit", day: "2-digit"},
			},
			{
				label: 'Stage',
				fieldName: 'quoteStage',
				type: 'text',
				initialWidth: 180,
				sortable: true
			}
		]);
		helper.getQuoteStages(component, event, helper);
		helper.getValidQuoteStages(component, event, helper);
		helper.getAllCommercialProposals(component, event, helper);

		component.set('v.exportColumnDefaults', [
			{value: 'accountName',          label: 'Account Name',                          description: 'Customer Account Name'},
			{value: 'accountNumber',        label: 'Account Number',                        description: 'Customer Account Number (3xxxxxxxxx)'},
			{value: 'configType',           label: 'Configuration Type',                    description: 'Indicates if the Product Code/External Reference is a Standalone Item or a Bundle'},
			{value: 'currencyIsoCode',      label: 'Currency',                              description: 'Indicates the currency of the related Quote Line Item Net Price. Example: EUR, USD, ...'},
			{value: 'customerGroupingName', label: 'Customer Grouping',                     description: 'Used to re-group Bundle Products or Standalone Products of a Quote under customized labelling to adapt the offer to the Price Book structure specifities of a Customer'},
			{value: 'externalDescription',  label: 'External Description',                  description: 'Indicates the Customer defined description for a Product, as set up in its own environment'},
			{value: 'externalReference',    label: 'External Reference',                    description: 'Indicates the Customer defined code for a Product, as set up in its own environment'},
			{value: 'lineType',             label: 'Line Type',                             description: 'Indicates "Product/Service" for a Bundle top code or a Standalone Item, and indicates "Option" for the items that are part of a Bundle.'},
			{value: 'netPrice',             label: 'Net Price',                             description: 'Indicates the net price of the related Quote Line Item. Currency is in a separate column.'},
			{value: 'PODate',               label: 'PO Date',                               description: 'Indicates the creation date of the Purchase Order, as set on the Customer Purchase Order associated to the Quote. It is populated upon the acceptance of the Quote.'},
			{value: 'PONumber',             label: 'PO Number',                             description: 'Indicates the Purchase Order reference, as set on the Customer Purchase Order associated to the Quote. It is populated upon the acceptance of the Quote.'},
			{value: 'productCode',          label: 'Product Code (Internal Reference)',     description: 'Internal reference of a Product as used in Nokia referential'},
			{value: 'productDescription',   label: 'Product Name (Internal Description)',   description: 'Internal description of a Product as used in Nokia referential'},
			{value: 'quantity',             label: 'Quantity',                              description: 'The quantity/number of cells quoted on the Bill of Quantity'},
			{value: 'quoteId',              label: 'Quote Id',                              description: 'The internal and unique identifier of the Quote in Salesforce (Q-xxxxxxxx)'},
			{value: 'quoteLineItemId',      label: 'Quote Line Item',                       description: 'The internal and unique identifier of the Quote Line Item in Salesforce (QL-xxxxxxxx)'},
			{value: 'quoteNumber',          label: 'Quote Number',                          description: 'Quote reference as exchanged with the Customer'},
			{value: 'soldToPartyName',      label: 'Sold-To Account Name',                  description: 'The Account name used for order execution activity'},
			{value: 'soldToPartyNumber',    label: 'Sold-To Account Number',                description: 'Sold-To Party Number (1xxxxxxxxx) used for order execution activity'},
			{value: 'stage',                label: 'Stage',                                 description: 'Indicates the status of the Quote (Approved, Published - In Progress, Published - Ready, Accepted, Rejected, ...)'}
		]);

		helper.loadExportValuesFromCache(component);
	},

	doFilter: function(component, event, helper) {
		component.set("v.selectButtonState", true);
		//helper.getAllCommercialProposals(component, event, helper);
		helper.handleSelectAllOrNone(component);
		helper.filterData(component, false, true);
	},

	filterText: function(component, event, helper) {
		if(event.keyCode == 13) {
			//ENTER
			component.set("v.selectButtonState", true);
			helper.handleSelectAllOrNone(component);
			helper.filterData(component, false, true);
		}
	},

	clearFilter: function(component, event, helper) {
		//reset filtering bar
		component.set("v.searchText", undefined);
		component.set("v.searchFromDate", undefined);
		component.find("searchByStage").set("v.value", "All");
		component.find("searchByAccount").set("v.value", "All");
		component.set("v.matchAll", false);

		component.set("v.selectButtonState", true);
		helper.handleSelectAllOrNone(component);

		//reset table
		helper.filterData(component, false, true);
	},

	handleActions: function(component, event, helper) {
		console.time('handleActions');
		var row = event.getParam('row');
		var selectedRowsCount = component.get("v.selectedRowsCount");

		switch (event.getParam('action').name) {
			case 'showHideAttributes':
				if (row.extraInfoButton == 'utility:add') {
					row.extraInfoButton = 'utility:dash';
					row.extraInfoText = row.extraInfo;
				} else {
					row.extraInfoButton = 'utility:add';
					row.extraInfoText = row.truncExtraInfo;
				}
				break;
			case "handleSelection":
				if (row.selected) {
					row.selectIcon = null;
					row.selectTitle = 'Add to selection';
					selectedRowsCount--;
				} else {
					row.selectIcon = 'utility:check';
					row.selectTitle = 'Remove from selection';
					selectedRowsCount++;
				}
				row.selected = !row.selected;
				break;
			default:
				console.log("Handle Actions - invalid action: " + event.getParam('action').name );
				break;
		}

		//find it in the table and update the selected row
		var rawData = component.get("v.rawData");
		var indexRaw = rawData.indexOf(event.getParam('row'));
		//var index = rawData.findIndex((item) => item.id === event.getParam('row').id); /*workaround*/
		rawData[indexRaw] = row;
		component.set("v.rawData", rawData);

		component.set("v.selectedRowsCount", selectedRowsCount);
		//instead of re-filtering, modify the filteredData list also...   helper.filterData(component, true);

		var data = component.get("v.data");
		var index = data.indexOf(event.getParam('row'));
		data[index] = row;
		component.set("v.data", data);

		console.timeEnd('handleActions');
	},

	selectAllOrNone: function(component, event, helper) {
		helper.handleSelectAllOrNone(component);
	},

	updateColumnSorting: function(component, event, helper) {
		var fieldName = event.getParam('fieldName');
		var sortedDirection = event.getParam('sortDirection');
		component.set("v.sortedBy", fieldName);
		component.set("v.sortedDirection", sortedDirection);

		helper.sortData(component, fieldName, sortedDirection);
	},

	next: function(component, event, helper) {
		helper.gotoPage(component, component.get("v.currentPageNumber")+1);
	},

	previous: function(component, event, helper) {
		helper.gotoPage(component, component.get("v.currentPageNumber")-1);
	},

	updatePageSize: function(component, event, helper) {
		component.set("v.pageSize", event.getSource().get("v.value"));
		helper.filterData(component, false, true);
	},

	handleIntermediateStageChange: function(component, event, helper) {
		var newStage = event.getSource().get("v.value");
		var selectedRows = helper.getSelectedRows(component);
		var validStages = component.get("v.validStages");

		// change stage in the Quote/Proposal table
		var action = component.get("c.updateIntermediateStageForQuotes");
		action.setParams({
			"quoteIdsStr": helper.getSelectedQuotes(component).join(','),
			"approvalStage": newStage
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var successCount = response.getReturnValue();
				console.log('MASS UPDATE for '+ successCount +' record(s) - Response Time: '+((new Date().getTime())-requestInitiatedTime));
				var message = successCount + " of " + selectedRows.length; /* example: 5 of 10 */
				message += (selectedRows.length > 1) ?  " records" : " record";
				message += (successCount > 1) ? " have been successfully updated." : " has been successfully updated.";
				helper.showToast(newStage + ": Quote/Proposal", "success", message, "dismissible");
				// reload Quote List View to update the stage displayed in the table
				//$A.get('e.force:refreshView').fire();
				//let's set the stage in our table manually
				var rawData = component.get("v.rawData");
				var rowsCount = selectedRows.length;

				for (let i = 0; i < rowsCount; i++) {
					var index = rawData.indexOf(selectedRows[i]);
					if (validStages != undefined && validStages.indexOf(rawData[index].quoteStage) >= 0) {
						rawData[index].quoteStage = newStage;
					}
				}
				component.set("v.rawData", rawData);
				component.set("v.selectButtonState", true);
				helper.handleSelectAllOrNone(component);
				helper.filterData(component, true, false);
				component.set("v.isSpinnerVisible", false);
			} else if (state === "ERROR") {
				var errors = action.getError();
				console.log('MASS UPDATE failure for record(s) - Response Time: '+((new Date().getTime())-requestInitiatedTime));
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log('Errors = ' + JSON.stringify(errors));
						helper.showToast(newStage + ": Quote/Proposal", "error", errors[0].message, "sticky");
					}
				}
				component.set("v.isSpinnerVisible", false);
			} else if (state === "INCOMPLETE") {
				helper.showToast(newStage + ": Quote/Proposal", "error", "No response from server or client is offline.", "sticky");
				component.set("v.isSpinnerVisible", false);
			}
		});
		var requestInitiatedTime = new Date().getTime();
		component.set("v.isSpinnerVisible", true);
		$A.enqueueAction(action);
	},

	exportQuoteList: function(component, event, helper) {
		helper.saveExportValuesToCache(component);

		/* prepare content for CSV */
		var action = component.get("c.getQuoteLineItemList");
		action.setParams({
			"quoteIdsStr": helper.getSelectedQuotes(component).join(','),
			"addOptions": component.get("v.toggleOptionValue")
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var csvContent = helper.handleExportQuoteList(component, response.getReturnValue(), component.get("v.exportColumnOptions"), component.get("v.exportColumnValues"));

				if (component.isValid() && csvContent != null) {
					var fileNamePostfix = component.get("v.exportFilePostfix");
					if (fileNamePostfix != '') {
						// trimmed text, without accents, only allowed characters are a-z, A-Z, 0-9, - and _. Spaces are replaced by _
						fileNamePostfix = '_' + fileNamePostfix.trim()/*.normalize("NFD")*/.replace(/[\u0300-\u036f]/g, "").replace(/[^a-zA-Z0-9\s\_\-]/g, "").replace(/\s/g, '_');
					}

					var today = new Date();
					//example: 2019-08-17_181602
					var currentDate = today.getFullYear().toString() + '-' + helper.getTwoDigitDateFormat((today.getMonth()+1).toString()) + '-' + helper.getTwoDigitDateFormat(today.getDate().toString()) + '_'
									+ helper.getTwoDigitDateFormat(today.getHours().toString()) + helper.getTwoDigitDateFormat(today.getMinutes().toString()) + helper.getTwoDigitDateFormat(today.getSeconds().toString());
					var fileName = 'MassExportProposal_' + currentDate + fileNamePostfix + '.csv';  // CSV file Name* you can change it.[only name not .csv]

					if (navigator.msSaveBlob) { // IE 10+
						console.log('----------------if-----------');
						var blob = new Blob([csvContent],{type: "text/csv;charset=utf-8;"});
						console.log('----------------if-----------'+blob);
						navigator.msSaveBlob(blob, fileName);
					} else {

						var universalBOM = "\uFEFF";
						var hiddenElement = document.createElement('a');
						hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURIComponent(universalBOM + csvContent);
						hiddenElement.target = '_self';
						hiddenElement.download = fileName;
						document.body.appendChild(hiddenElement); // Required for FireFox browser
						hiddenElement.click(); // using click() js function to download csv file
					}
					helper.showToast("Export Selected Quote/Proposal", "success", "The selected records have been successfully exported.", "dismissible");
				} else {
					helper.showToast("Export Selected Quote/Proposal", "error", "Unable to create Export.", "dismissible");
				}
				helper.showHideExportDialog(component);
				component.set("v.selectButtonState", true);
				helper.handleSelectAllOrNone(component);
				helper.filterData(component, true, false);

			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Export Selected Quote/Proposal", "error", errors[0].message, "dismissible");
					}
				}
			} else if (state === "INCOMPLETE") {
				helper.showToast("Export Selected Quote/Proposal", "error", "No response from server or client is offline.", "dismissible");
			}
			//return null;
		});
		$A.enqueueAction(action);
	},

	exportDialog: function(component, event, helper) {
		var action = component.get("c.getAvailableAttributeLabelsForQuotes");
		action.setParams({
			"quoteIdsStr": helper.getSelectedQuotes(component).join(',')
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var labelList = response.getReturnValue();
				// export columns are default columns + attributes sorted by label
				var expCol = [];
				var defCol = component.get("v.exportColumnDefaults");
				var defColCount = defCol.length;
				var labelsCount = labelList.length;
				for (var i = 0; i < defColCount; i++) {
					expCol.push(defCol[i]);
				}
				for (var i = 0; i < labelsCount; i++) {
					expCol.push(labelList[i]);
				}
				expCol.sort(helper.sortBy('label', false));
				component.set("v.exportColumnOptions", expCol);

				helper.showHideExportDialog(component);
			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.showToast("Export Selected Quote/Proposal", "error", errors[0].message, "dismissible");
					}
				}
			} else if (state === "INCOMPLETE") {
				helper.showToast("Export Selected Quote/Proposal", "error", "No response from server or client is offline.", "dismissible");
			}
			//return null;
		});
		$A.enqueueAction(action);
	},

	handleCloseExportDialog: function(component, event, helper) {
		helper.saveExportValuesToCache(component);
		helper.showHideExportDialog(component);
	},

	handleClickHelp: function(component, event, helper) {
		helper.showHideHelp(component);
	}
})
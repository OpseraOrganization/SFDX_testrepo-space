({
	getAllCommercialProposals: function(component, event, helper) {
		var action = component.get("c.getCommercialProposalList");
		//action.setStorable();
		action.setBackground();
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('Get Commercial Proposals - Response Time: '+((new Date().getTime())-requestInitiatedTime)+' msec');
				component.set("v.rawData", response.getReturnValue());
				component.set("v.totalPageNumber", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
				component.set("v.currentPageNumber", 1);
				component.set("v.recordCount", response.getReturnValue().length);
				component.set('v.isSpinnerVisible', false);
				this.getAvailableAccounts(component);
				component.set("v.filteredData", response.getReturnValue()); //no need to do additional filtering on initial load
				this.gotoPage(component, 1); //show the first page
			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						this.showToast("Unable to fetch Quote/Proposal records", "error", errors[0].message, "sticky");
					}
				}
			} else if (state === "INCOMPLETE") {
				this.showToast("", "error", "No response from server or client is offline.", "sticky");
			}
		});
		component.set('v.isSpinnerVisible', true);
		var requestInitiatedTime = new Date().getTime();
		$A.enqueueAction(action);
	},
	getQuoteStages: function(component, event, helper) {
		var action = component.get("c.getQuoteStages");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.searchStage", response.getReturnValue());
			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						this.showToast("Unable to fetch Quote Stages", "error", errors[0].message, "dismissible");
					}
				}
			} else if (state === "INCOMPLETE") {
				this.showToast("", "error", "No response from server or client is offline.", "sticky");
			}
		});
		$A.enqueueAction(action);
	},
	getValidQuoteStages: function(component, event, helper) {
		//List of stages among the transition is available
		var action = component.get("c.getValidQuoteStages");
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.validStages", response.getReturnValue());
			} else if (state === "ERROR"){
				var errors = action.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						this.showToast("Unable to fetch valid Quote Stages", "error", errors[0].message, "dismissible");
					}
				}
			} else if (state === "INCOMPLETE") {
				this.showToast("", "error", "No response from server or client is offline.", "sticky");
			}
		});
		$A.enqueueAction(action);
	},
	getAvailableAccounts: function(component) {
		var rawData = component.get("v.rawData");
		var accountIdSet = new Set();
		var accounts = [];
		accounts.push({value: 'All', label: '---None---'});
		var rawDataCount = rawData.length;
		for (let i = 0; i < rawDataCount; i++) {
			if(!accountIdSet.has(rawData[i].aId)) {
				accountIdSet.add(rawData[i].aId);
				accounts.push({value: rawData[i].aId, label: rawData[i].accountName});
			}
		}
		component.set("v.accounts", accounts);
	},
	filterData: function(component, keepCurrentPageNumber, showToastFlag) {
		console.time('filterData');

		//filtering
		var results = component.get("v.rawData");
		var searchText = component.get("v.searchText");
		var searchFromDate = component.get("v.searchFromDate");
		var searchStage = component.find("searchByStage").get("v.value");
		var searchAccount = component.find("searchByAccount").get("v.value");

		try {
			if (searchAccount != 'All') {
				results = results.filter(function(row) {
					if (searchAccount == row.aId) {
						return row;
					}
				});
			}

			if (searchText != undefined) {
				// all the terms in searchText are searched in a case insensitive way
				var searchKeys = searchText.trim().toLowerCase().split(' ');

				if( !component.get("v.matchAll") ) {
					// criteria1 OR criteria 2 ... OR criteria n
					var rep = "(" + searchText.split(" ").join("|") + ")";
					regex = new RegExp(rep, "i");
					results = results.filter( row =>    regex.test(row.name) ||
														regex.test(row.quoteNumber) ||
														regex.test(row.technology) ||
														regex.test(row.useCase) ||
														regex.test(row.PONumber) ||
														regex.test(row.extraInfo) ||
														regex.test(row.proposalName) ||
														regex.test(row.agreementName) ||
														regex.test(row.nokiaReferenceId));

				} else {
					// criteria1 AND criteria 2 ... AND criteria n
					var intermedResults = [];
					var resultsCount = results.length;
					for (let i = 0; i < resultsCount; i++) {
						var searchArray = [results[i].name,
										results[i].quoteNumber,
										results[i].technology,
										results[i].useCase,
										results[i].PONumber,
										results[i].extraInfo,
										results[i].proposalName,
										results[i].agreementName
										];
						var searchRow = searchArray.join(" ").toLowerCase();
						var allFound = true;
						var searchKeysCount = searchKeys.length;
						for (let j = 0; j < searchKeysCount; j++) {
							var regex = new RegExp(searchKeys[j]);
							if (!regex.test(searchRow)) {
								allFound = false;
							}
						}
						if (allFound) {
							intermedResults.push(results[i]);
						}
					}
					results = intermedResults;
				}
			}

			if (searchFromDate != undefined) {
				results = results.filter(function(row) {
					if(searchFromDate <= row.creationDate) {
						return row;
					}
				});
			}

			if (searchStage != 'All') {
				results = results.filter(function(row) {
					if (searchStage == row.quoteStage) {
						return row;
					}
				});
			}

		} catch (e) {
			alert(e);
		}

		component.set("v.filteredData", results);
		var totalPageNumber;
		if (component.get("v.pageSize") == 0 || results.length == 0) {
			totalPageNumber = 1;
		} else {
			totalPageNumber = Math.ceil(results.length/component.get("v.pageSize"));
		}
		component.set("v.totalPageNumber", totalPageNumber);

		if (!keepCurrentPageNumber || totalPageNumber == 1) {
			component.set("v.currentPageNumber", 1);
		}
		component.set("v.recordCount", results.length);
		this.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"), showToastFlag);
		console.timeEnd('filterData');
	},
	sortData: function (component, fieldName, sortDirection, showToastFlag) {
		console.time('sortData');
		var filteredData = component.get("v.filteredData");
		var reverse = sortDirection !== 'asc';
		//sorts the rows based on the column header that's clicked
		filteredData.sort(this.sortBy(fieldName, reverse));
		component.set("v.filteredData", filteredData);
		this.gotoPage(component, component.get("v.currentPageNumber"));
		if (showToastFlag) {
			this.showToast("", "info", "List view has been updated successfully!", "dismissible");
		}
		console.timeEnd('sortData');
	},
	sortBy: function (field, reverse, primer) {
		var key = primer ?
			function(x) {
				return primer(x[field])
			} :
			function(x) {
				return x[field]
			};
		//checks if the two rows should switch places
		reverse = !reverse ? 1 : -1;
		return function (a, b) {
			//secondary sort for Quote Id DESC
			var c = a.name;
			var d = b.name;

			a = key(a) ? key(a) : '';
			b = key(b) ? key(b) : '';
			if ( a === b) {
				return (-1) * ((c > d) - (d > c));
			}
			return reverse * ((a > b) - (b > a));
		}
	},
	gotoPage: function(component, actPageNumber) {
		var pageNumber = actPageNumber;
		var pageSize = component.get("v.pageSize");
		var buildData = [];
		var data = component.get("v.filteredData");

		if( pageSize > 0) {
			//pagination
			var i = (pageNumber-1)*pageSize;

			for (;i<(pageNumber)*pageSize; i++) {
				if(data[i]) {
					buildData.push(data[i]);
				}
			}
		} else {
			//pageSize is set to All
			buildData = data;
		}
		component.set("v.currentPageNumber", pageNumber);
		component.set("v.data", buildData);
	},
	handleSelectAllOrNone: function(component) {
		var selectButtonState = component.get("v.selectButtonState");
		var rawData = component.get("v.rawData");
		var data = component.get("v.data");
		var selectedRowsCount = 0;

		var rawDataCount = rawData.length;
		for (var i = 0; i < rawDataCount; i++) {
			var row = rawData[i];
			if (!selectButtonState) {
				row.selectIcon = 'utility:check';
				row.selectTitle = 'Remove from selection';
				row.selected = true;
				selectedRowsCount++;
			} else {
				row.selectIcon = null;
				row.selectTitle = 'Add to selection';
				row.selected = false;
			}
			//update in data as well, instead of filtering again
			var index = data.indexOf(rawData[i]);
			if (index >= 0) {
				data[index] = row;
			}
		}

		component.set("v.selectButtonState", !selectButtonState);
		component.set("v.data", data);
		component.set("v.rawData", rawData);
		component.set("v.selectedRowsCount", selectedRowsCount);
	},
	getSelectedQuotes: function(component) {
		var filteredData = component.get("v.filteredData");
		var selectedQuotes = [];
		var filteredDataCount = filteredData.length;
		for (var i = 0; i < filteredDataCount; i++){
			if (filteredData[i].selected) {
				selectedQuotes.push(filteredData[i].id);
			}
		}
		return selectedQuotes;
	},
	getSelectedRows: function(component) {
		var filteredData = component.get("v.filteredData");
		var selectedRows = [];
		var filteredDataCount = filteredData.length;
		for (var i = 0; i < filteredDataCount; i++) {
			if(filteredData[i].selected) {
				selectedRows.push(filteredData[i]);
			}
		}
		return selectedRows;
	},
	handleExportQuoteList: function(component, lineItemList, exportColumnOptions, exportColumnValues) {
		// declare variables
		var csvStringResult, counter, columnDivider, lineDivider;
		var header = [];

		// store ,[comma] in columnDivider variable for sparate CSV values and
		// for start next line use '\n' [new line] in lineDivider varaible
		//columnDivider = ',';
		columnDivider = component.get("v.columnSeparatorValue");
		lineDivider =  '\n';
		var exportColumnValuesCount = exportColumnValues.length;
		var exportColumnOptionsCount = exportColumnOptions.length;

		//header of the CSV
		for(let j=0; j<exportColumnValuesCount; j++) {
			for(let i=0; i<exportColumnOptionsCount; i++) {
				  if (exportColumnOptions[i]['value'] == exportColumnValues[j]) {
					header.push(exportColumnOptions[i]['label']);
				}
			}
		}

		//csvStringResult = 'SEP=' + columnDivider + lineDivider;
		//csvStringResult += header.join(columnDivider);
		csvStringResult = "COMPANY CONFIDENTIAL" + lineDivider + lineDivider;
		csvStringResult += header.join(columnDivider).toUpperCase();
		csvStringResult += lineDivider;


		// check if "lineItemList" parameter is null, then return from function
		if (lineItemList == null || !lineItemList.length) {
			return null;
		}

		var lineItemCount = lineItemList.length;
		for (let i=0; i < lineItemCount; i++) {
			var first = true;
			var cfaList = lineItemList[i]['itemAttributes'];
			var cfaCount = cfaList.length;
			for ( let j=0; j<exportColumnOptionsCount; j++) {
				var skey = exportColumnValues[j];
				if (!first) {
					csvStringResult += columnDivider;
				}
				var lineItemValue = '';
				if (lineItemList[i][skey] != undefined) {
					lineItemValue = '"'+ lineItemList[i][skey] +'"';
				} else {
					for(let k = 0; k < cfaCount; k++) {
						if (cfaList[k].label == skey && cfaList[k].value != undefined) {
							lineItemValue = '"'+ cfaList[k].value +'"';
						}
					}
				}
				csvStringResult += lineItemValue;
				first = false;
			}
			csvStringResult += lineDivider;
		}
		return csvStringResult;
	},
	getTwoDigitDateFormat: function(monthOrDate) {
		return (monthOrDate < 10) ? '0' + monthOrDate : '' + monthOrDate;
	},
	showHideExportDialog: function(component) {
		var exportDialog = component.find("exportDialog");
		$A.util.toggleClass(exportDialog, "slds-hide");
		var overlay = component.find("overlay");
		$A.util.toggleClass(overlay, "slds-hide");
	},
	showHideHelp: function(component) {
		var helpCard = component.find("helpCard");
		$A.util.toggleClass(helpCard, "slds-hide");
		component.set("v.selectedHelpButton", !component.get("v.selectedHelpButton"));
	},
	saveExportValuesToCache: function(component) {
		/* cache export settings */
		window.localStorage.setItem('cachedExportColumnValues', component.get("v.exportColumnValues"));
		window.localStorage.setItem('cachedToggleOptionValue', component.get("v.toggleOptionValue"));
		window.localStorage.setItem('cachedColumnSeparatorValue', component.get("v.columnSeparatorValue"));
		window.localStorage.setItem('cachedExportFilePostfix', component.get("v.exportFilePostfix"));
	},
	loadExportValuesFromCache: function(component) {
		/* read export settings from cache */
		var cachedExportColumnValues = window.localStorage.getItem('cachedExportColumnValues');
		if (cachedExportColumnValues === null || cachedExportColumnValues === undefined || cachedExportColumnValues .length === 0) {
			component.set('v.exportColumnValues', ['quoteNumber', 'externalReference', 'quantity']);
		} else {
			component.set('v.exportColumnValues', cachedExportColumnValues.split(','));
		}
		var cachedToggleOptionValue = window.localStorage.getItem('cachedToggleOptionValue');
		if (cachedToggleOptionValue === null || cachedToggleOptionValue === undefined || cachedToggleOptionValue.length === 0) {
			component.set('v.toggleOptionValue', false);
		} else {
			//alert('Toggle Value=' + JSON.stringify(cachedToggleOptionValue));
			component.set('v.toggleOptionValue', cachedToggleOptionValue == "true");
		}
		var cachedColumnSeparatorValue = window.localStorage.getItem('cachedColumnSeparatorValue');
		if (cachedColumnSeparatorValue === null || cachedColumnSeparatorValue === undefined || cachedColumnSeparatorValue.length === 0) {
			component.set('v.columnSeparatorValue', ',');
		} else {
			component.set('v.columnSeparatorValue', cachedColumnSeparatorValue);
		}
		var cachedExportFilePostfix = window.localStorage.getItem('cachedExportFilePostfix');
		if (cachedExportFilePostfix === null || cachedExportFilePostfix === undefined || cachedExportFilePostfix.length === 0) {
			component.set('v.exportFilePostfix', '');
		} else {
			component.set('v.exportFilePostfix', cachedExportFilePostfix);
		}
	},
	// Generic Toast Message
	showToast: function(title, type, message, mode) {
		$A.get("e.force:showToast").setParams({
			"title": title,
			"type": type,
			"message": message,
			"mode": mode
		}).fire();
	}
})
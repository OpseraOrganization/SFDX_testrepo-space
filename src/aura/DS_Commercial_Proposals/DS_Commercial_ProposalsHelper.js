({
	getAllCommercialProposals: function(component, event, helper) {
		var action = component.get("c.getCommercialProposalList");
		//action.setStorable();
		action.setBackground();
		action.setCallback(this,function(response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log('Get Commercial Proposals - Response Time: '+((new Date().getTime())-requestInitiatedTime)+' msec');
				component.set("v.rawData", response.getReturnValue());
				component.set("v.totalPageNumber", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
				component.set("v.currentPageNumber", 1);
				component.set("v.recordCount", response.getReturnValue().length);
				component.set('v.isSpinnerVisible', false);
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
	filterData: function(component, keepCurrentPageNumber) {
		//filtering
		var results = component.get("v.rawData");
		var searchText = component.get("v.searchText");
		var searchFromDate = component.get("v.searchFromDate");
		var searchStage = component.find("searchByStage").get("v.value");

		try {
			if (searchText != undefined) {
				// all the terms in searchText are searched in a case insensitive way
				var searchKeys = searchText.trim().toLowerCase().split(' ');

				// criteria1 OR criteria 2 ... OR criteria n
				/*var rep = "(" + searchText.split(" ").join("|") + ")";
				regex = new RegExp(rep, "i");
				results = results.filter( row =>    regex.test(row.name) ||
													regex.test(row.quoteNumber) ||
													regex.test(row.technology) ||
													regex.test(row.useCase) ||
													regex.test(row.PONumber) ||
													regex.test(row.extraInfo) ||
													regex.test(row.proposalName) ||
													regex.test(row.agreementName) ||
													regex.test(row.nokiaReferenceId));*/

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
		this.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
	},
	sortData: function (component, fieldName, sortDirection) {
		var filteredData = component.get("v.filteredData");
		var reverse = sortDirection !== 'asc';
		//sorts the rows based on the column header that's clicked
		filteredData.sort(this.sortBy(fieldName, reverse));
		component.set("v.filteredData", filteredData);
		this.gotoPage(component, component.get("v.currentPageNumber"));
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
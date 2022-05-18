({
	getEntitlementReport : function(component, event) {
        this.incrementActionCounter(component);
		var action = component.get("c.getLineItemReport");      
        action.setParams({ 
            caseId : component.get("v.caseId"),
            reportType : component.get("v.selectedValue")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var returnList = response.getReturnValue();
                for(var i = 0; i < returnList.length; i++) { 
                    // Set LineItem URL
                    returnList[i].LineItemURL = this.getLightningURL(returnList[i].Id);
                    // Set default values
                    returnList[i].ContractName = '';
                    returnList[i].ContractProject = '';
                    returnList[i].ContractExtStatus = '';
                    returnList[i].AssetName = '';   
                    // Set Contract Fields
                    if(returnList[i].ServiceContractId) {
                        returnList[i].ContractURL = this.getLightningURL(returnList[i].ServiceContractId);
                        returnList[i].ContractName = returnList[i].ServiceContract.Name;
                        returnList[i].ContractProject = returnList[i].ServiceContract.CH_Project__c;
                        returnList[i].ContractExtStatus = returnList[i].ServiceContract.NCP_External_Status__c;
                    }
                    // Set Asset Fields
                    if(returnList[i].AssetId) {
                    	returnList[i].AssetName = returnList[i].Asset.Name;
                    }
                }
                component.set("v.data", returnList);
            } else if (state === "INCOMPLETE") {
                console.log('Inc');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            this.decrementActionCounter(component);
        });
        $A.enqueueAction(action);
	},
    incrementActionCounter: function(component) {        
        var counter = component.get("v.actionCounter") + 1;
        if(counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);        
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if(counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);    
    },
    // Sort data
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.data");
        var reverse = sortDirection !== 'asc';
        //sorts the rows based on the column header that's clicked
        if(fieldName == 'ContractURL') {
            data.sort(this.sortBy('ContractName', reverse));
        } else if(fieldName == 'LineItemURL') {
            data.sort(this.sortBy('LineItemNumber', reverse));
        } else {
            data.sort(this.sortBy(fieldName, reverse));
        }
        cmp.set("v.data", data);
    },      
    // Sort By Algorithm
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },
    // Set Tab Icon
    setTabIcon : function(component) {
        //Js Controller
        var workspaceAPI = component.find("ContractWorkspace");        
        workspaceAPI.getEnclosingTabId().then(function(response) {
            workspaceAPI.setTabLabel({
                tabId: response,
                label: "Service Contract Report", //set label you want to set
                title: "Service Contract Report"
            });
            workspaceAPI.setTabIcon({
                tabId: response,
                icon: "standard:service_contract", //set icon you want to set
                iconAlt: "Service Contract Report" //set label tooltip you want to set
            });
            workspaceAPI.focusTab({
                tabId : response
            }); 
        })
    },
    // Generic Lightning URL Formation
    getLightningURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    }
})
({
    getCases : function(component, event, helper) { 
        component.set("v.Spinner", true);
        //Added Country column For NOKIASC-34934
        if((component.get('v.caseType') == 'Incident') && component.get('v.serviceType') == 'Customer Support'){       
            component.set('v.tableColumns', [
                {label: 'Support Ticket Number', fieldName: 'TicketURL',          type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'TicketID' }, target: '_self'}},
                {label: 'Account Name',          fieldName: 'AccountURL',         type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'AccountName' }, target: '_self'}},
                {label: 'Product Name',          fieldName: 'ProductURL',         type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'ProductName' }, target: '_self'}},
                {label: 'Country',              fieldName: 'Country',        type: 'text', sortable: 'true'},
                {label: 'Created By',            fieldName: 'CreatedByURL', 	  type: 'url',      sortable: 'true',typeAttributes: {label: { fieldName: 'CreatedById' }, target: '_self'}},
                {label: 'Severity',              fieldName: 'Severity__c',        type: 'picklist', sortable: 'true'},
                {label: 'Outage',                fieldName: 'CH_Outage__c',       type: 'picklist', sortable: 'true'},
                {label: 'Status',                fieldName: 'Status',             type: 'picklist', sortable: 'true'},
                {label: 'Queue Name',            fieldName: 'CH_CurrentQueue__c', type: 'text',     sortable: 'true'},
                {label: 'Subject',               fieldName: 'Subject',            type: 'text',     sortable: 'true'},
                {label: 'Target Date',           fieldName: 'TargetDate', 	      type: 'datetime', sortable: 'true'},
                {label: 'Date/Time Opened',      fieldName: 'CreatedDate',        type: 'datetime', sortable: 'true'},
                {label: 'Current Workgroup',     fieldName: 'WorkgroupURL',       type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'WorkgroupName' }, target: '_self'}}
            ]);
        }
        //Added Country Column For NOKIASC-34934
        else if ((component.get('v.caseType') == 'Incident') && component.get('v.serviceType') == 'Internal Support'){
            component.set('v.tableColumns', [
                {label: 'Support Ticket Number', fieldName: 'TicketURL',          type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'TicketID' }, target: '_self'}},
                {label: 'Account Name',          fieldName: 'AccountURL',         type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'AccountName' }, target: '_self'}},
                {label: 'Product Name',          fieldName: 'ProductURL',         type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'ProductName' }, target: '_self'}},
                {label: 'Country',              fieldName: 'Country',        type: 'text', sortable: 'true'},
                {label: 'Created By',            fieldName: 'CreatedByURL', 	  type: 'url',      sortable: 'true',typeAttributes: {label: { fieldName: 'CreatedById' }, target: '_self'}},
                {label: 'Severity',              fieldName: 'Severity__c',        type: 'picklist', sortable: 'true'},
                {label: 'Outage',                fieldName: 'CH_Outage__c',       type: 'picklist', sortable: 'true'},
                {label: 'Status',                fieldName: 'Status',             type: 'picklist', sortable: 'true'},
                {label: 'Queue Name',            fieldName: 'CH_CurrentQueue__c', type: 'text',     sortable: 'true'},
                {label: 'Subject',               fieldName: 'Subject',            type: 'text',     sortable: 'true'},
                {label: 'Target Date',           fieldName: 'TargetDate', 	      type: 'datetime', sortable: 'true'},
                {label: 'Date/Time Opened',      fieldName: 'CreatedDate',        type: 'datetime', sortable: 'true'},
                {label: 'Contract Type',    	 fieldName: 'CH_Rep_CDBContractType__c',  type: 'text', sortable: 'true'},
                {label: 'Current Workgroup',     fieldName: 'WorkgroupURL',       type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'WorkgroupName' }, target: '_self'}}
                
                
                
            ]);
        }
        else if ((component.get('v.caseType') == 'Incident') && component.get('v.serviceType') == 'Hardware Services'){
            component.set('v.tableColumns', [
                {label: 'Support Ticket Number', fieldName: 'TicketURL',          			type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'TicketID' }, target: '_self'}},
                {label: 'Account Name',          fieldName: 'AccountURL',           		type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'AccountName' }, target: '_self'}},
                {label: 'Internal Status',       fieldName: 'CH_InternalStatus__c', 		type: 'picklist', sortable: 'true'},
                {label: 'Ship to Party Address', fieldName: 'shipToPartyURL', 				type: 'url', 	  sortable: 'true',typeAttributes: {label: { fieldName: 'shipToPartyName'}, target: '_self'}},
                {label: 'Service Type',          fieldName: 'ServiceType',       	        type: 'text',     sortable: 'true'},
                {label: 'Date/Time Opened',      fieldName: 'CreatedDate',        			type: 'datetime', sortable: 'true'},
                {label: 'Last Modified By',      fieldName: 'LastModifiedURL', 				type: 'url',      sortable: 'true',typeAttributes: {label: { fieldName: 'LastModifiedById' }, target: '_self'}},
                
            ]);
        }
        else{
            	//Added Country & Created By Column & removed CR Status Column For NOKIASC-34958
                component.set('v.tableColumns', [
                    {label: 'Problem Number',  fieldName: 'TicketURL',                  type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'TicketID' }, target: '_self'}},
                    {label: 'Product Name',    fieldName: 'ProductURL',                 type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'ProductName' }, target: '_self'}},
                    {label: 'Product Release', fieldName: 'CH_Product_Release_Name__c', type: 'formula',  sortable: 'true'},
                    {label: 'Country',         fieldName: 'Country',        type: 'text', sortable: 'true'},
                    {label: 'Created By',  fieldName: 'CreatedByURL',                  type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'CreatedById' }, target: '_self'}},
                    {label: 'Status',          fieldName: 'Status',                     type: 'picklist', sortable: 'true'},
                    {label: 'Subject',         fieldName: 'Subject',                    type: 'text',     sortable: 'true'},
                    {label: 'Queue Name',      fieldName: 'CH_CurrentQueue__c',         type: 'text',     sortable: 'true', typeAttributes: {label: { fieldName: 'QueueName' }, target: '_self'}},
                    {label: 'Created Date',    fieldName: 'CreatedDate',                type: 'datetime', sortable: 'true'},
                	{label: 'Workgroup Name',  fieldName: 'WorkgroupURL',               type: 'url',      sortable: 'true', typeAttributes: {label: { fieldName: 'WorkgroupName' }, target: '_self'}}
                ]);
            }
        var action = component.get("c.getCases");
        action.setParams({caseType : component.get('v.caseType'), 
                          serviceType : component.get('v.serviceType')});
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log("state "+state);
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("result "+result);
				//component.set("v.totalPages", Math.ceil(response.getReturnValue().length/component.get("v.pageSize")));
                component.set("v.currentPageNumber",1);
                component.set("v.allData", response.getReturnValue());
                component.set("v.totalRecords", response.getReturnValue().length);
                for(var i = 0; i < result.length; i++) {
                    var targetDate = result[i].targetDate;
                    var Country = result[i].Country;
                    result[i] = result[i].oCase;
                    result[i].Country = Country;
                    result[i].TargetDate = targetDate;
                    if (typeof(result[i].CreatedById) != 'undefined') {
                        result[i].CreatedByURL = this.getLightningURL(result[i].CreatedById);
                        result[i].CreatedById = result[i].CreatedBy.Name;
                    }
                    if (typeof(result[i].CaseNumber) != 'undefined') {
                        result[i].TicketURL = this.getLightningURL(result[i].Id);
                        result[i].TicketID = result[i].CaseNumber;
                    }
                    if (typeof(result[i].AccountId) != 'undefined') {
                        result[i].AccountURL = this.getLightningURL(result[i].AccountId);
                        result[i].AccountName = result[i].CH_Account_Name__c;
                    }
                    if (typeof(result[i].ProductId) != 'undefined') {
                        result[i].ProductURL = this.getLightningURL(result[i].ProductId);
                        result[i].ProductName = result[i].CH_Product_Name__c;
                    }
                    if (typeof(result[i].CH_Workgroup__c) != 'undefined') {
                        result[i].WorkgroupURL = this.getLightningURL(result[i].CH_Workgroup__c);
                        result[i].WorkgroupName = result[i].CH_Workgroup__r.Name;
                    }
                    if (typeof(result[i].Hws_Ship_to_Party_Address__c) != 'undefined') {
                        result[i].shipToPartyURL = this.getLightningURL(result[i].Id);
                        result[i].shipToPartyName = result[i].Hws_Ship_to_Party_Address__r.Name;
                    }
                    if (typeof(result[i].LastModifiedById) != 'undefined') {
                        result[i].LastModifiedURL = this.getLightningURL(result[i].Id);
                        
						result[i].LastModifiedById = result[i].LastModifiedBy.Name;
                    }
                     if (typeof(result[i].Cases) != 'undefined') {
                        result[i].ServiceType = result[i].Cases[0].HWS_ServiceType__c;
                    }
                }
                result.sort(this.sortBy('WorkgroupName', false));
                component.set("v.unassignedCases", result);
                component.set("v.allData", result);
				 component.set("v.allFilterData", result);
                helper.buildData(component, helper);
            }
        });
        $A.enqueueAction(action);
    },
	/*
    sortCases: function (component, fieldName, sortDirection) {
        var data = component.get("v.unassignedCases");
        var reverse = sortDirection !== 'asc';
        if(fieldName == 'TicketURL') {
            data.sort(this.sortBy('TicketID', reverse));
        } else if(fieldName == 'AccountURL') {
            data.sort(this.sortBy('AccountName', reverse));
        } else if(fieldName == 'ProductURL') {
            data.sort(this.sortBy('ProductName', reverse));
        } else if(fieldName == 'WorkgroupURL') {
            data.sort(this.sortBy('WorkgroupName', reverse));
        } else {
            data.sort(this.sortBy(fieldName, reverse));
        }
        component.set("v.unassignedCases", data);
    },
	*/
    acceptCases: function (component, event, helper) {
        var casesList = component.get("v.selectedCases");
        var caseListToUpdate = [];
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        casesList.forEach(function(c){
            caseListToUpdate = [...caseListToUpdate, {
                                Id: c.Id}];
        });
        let action = component.get('c.saveCases');        
        this.incrementActionCounter(component);
        action.setParams({casesList: JSON.stringify(caseListToUpdate), 
                          caseType : component.get('v.caseType'), 
                          serviceType : component.get('v.serviceType')});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                if(casesList.length == 1){
                    var workspaceAPI = component.find("workspace");
                    workspaceAPI.openTab({
                        pageReference: {
                            "type": "standard__recordPage",
                            "attributes": {
                                "recordId": casesList[0].Id,
                                "actionName":"view"
                            },
                            "state": {}
                        },
                        focus: true});
                }
                else if(response.getReturnValue() != ''){
                    this.showToast(component, "SUCCESS", response.getReturnValue());
                }
                this.getCases(component, event, helper);
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.showToast(component, "ERROR", errors[0].message ? errors[0].message : "Something went wrong. Please try again.");
            }
            this.decrementActionCounter(component);
        });
        $A.enqueueAction(action);
    },
    getLightningURL: function(recordId) {
        return '/one/one.app?#/sObject/' + recordId + '/view';
    },
    incrementActionCounter : function(component) {        
        var counter = component.get("v.actionCounter") + 1;
        if(counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);        
    },
    decrementActionCounter : function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if(counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);    
    },
    /*sortBy : function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
        function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },*/
    showToast : function(component, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
	buildData : function(component, helper) {
        var data = [];
        var pageNumber = component.get("v.currentPageNumber");
        var pageSize = component.get("v.pageSize");
        var allData = component.get("v.allFilterData");
        var x = (pageNumber-1)*pageSize;
        //creating data-table data
        for(; x<(pageNumber)*pageSize; x++){
            if(allData[x]){
                data.push(allData[x]);
            }
        }
        var count = component.get("v.totalRecords"); 
        console.log('@@:'+allData.length);
        component.set("v.countofRecords",allData.length);
        if(component.get("v.currentPageNumber")==1){
            component.set("v.PreviousPageNumber",1);
            component.set("v.NextPageNumber",0);
        }
        component.set("v.totalPages", Math.ceil(allData.length/component.get("v.pageSize")));
        console.log('currentPageNumber:'+component.get("v.currentPageNumber")+'totalPages:'+component.get("v.totalPages"));
        if(component.get("v.currentPageNumber") ==component.get("v.totalPages")){
            component.set("v.NextPageNumber",1);
        }
        component.set("v.unassignedCases", data);
       
    },
    //Initialize dispatch modal
    dispatchCases: function (component, event, helper) {
        var caseId = '';
        var workgroupId='';                    
        var casesList = component.get("v.selectedCases");
        if(casesList.length > 1){            
            //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
            this.showToast(component,"ERROR",$A.get("$Label.c.CH_Case_Dispatch_Limit_One"));
            return false;
        }
        component.set("v.selectedCase", JSON.parse(JSON.stringify( casesList)));        
        
        casesList.forEach(function(c){
            caseId = c.Id;
            workgroupId= c.CH_Workgroup__c;                      
        });
        component.set("v.ModalSpinner", true);        
        let action = component.get('c.getValidWorkgroupMembers');        
        action.setParams({caseId: caseId, 
                          workgroupId : workgroupId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                this.setUserTable(component,event,helper); 
                component.set("v.workgroupUser", response.getReturnValue());
                component.set("v.ModalSpinner", false);
            }else{
                var Error=  response.getError();
                this.showToast(component,"ERROR",Error[0].message) ;                
                component.set("v.ModalSpinner", false);
            }
            component.set("v.isModalOpen", true);
        });        
        $A.enqueueAction(action);
    },
    //Create workgroup members table
    setUserTable : function (component,event,helper){
        component.set('v.tableColumnsforUser', [
            {label: 'Assign', type: 'button', initialWidth: 135, typeAttributes: { label: 'Assign',iconName: 'utility:change_owner', name: 'Assign_User', title: 'Click to Assign User'}},
            {label: 'User Name', fieldName: 'Name',type: 'text', sortable: 'true'},
            {label: 'Country', fieldName: 'Country', type: 'text',sortable: 'true'},
            {label: 'Last Case Assigned', fieldName: 'LastCaseAssigned',type: 'date',sortable: 'true',typeAttributes: {day: 'numeric',month: 'short', year: 'numeric',hour: '2-digit',minute: '2-digit',second: '2-digit',hour12: false}},
            {label: 'No of cases owned by user in Workgroup', fieldName: 'TotalCaseAssignedInWorkgroup', type: 'number',sortable: 'true', cellAttributes: { alignment: 'center' }}, 
            {label: 'No of cases owned by user cross Workgroup', fieldName: 'TotalCaseAssigned', type: 'number',sortable: 'true', cellAttributes: { alignment: 'center' }}, 
            {label: 'No of cases owned by this user cross Workgroup in pending customer status', fieldName: 'TotalCaseAssignedOnPendingCustomer', type: 'number',sortable: 'true', cellAttributes: { alignment: 'center' }} 
        ])           
    },
    //Dispatch Case to User
    assignUser : function (row,component, event, helper) {
        var caseDetails = component.get("v.selectedCase");
        var caseId = '';
        var memId =row.Id;
        var workgroupId='';              
        caseDetails.forEach(function(c){
            caseId = c.Id;          
        });
        component.set("v.ModalSpinner", true);
        let action = component.get('c.updateSupportTicketOwner');        
        action.setParams({caseId: caseId, 
                          memId : memId,
                          caseType : component.get('v.caseType'), 
                          serviceType : component.get('v.serviceType')});        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ModalSpinner", false);
                this.showToast(component,"SUCCESS"," User assigned to the case.") ;
                component.set("v.isModalOpen", false);
                $A.get('e.force:refreshView').fire();
            }
            else{               
                var Error=  response.getError();
                this.showToast(component,"ERROR",Error[0].message) ;                
                component.set("v.ModalSpinner", false);
            }
        });        
        $A.enqueueAction(action);
    }, 
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.workgroupUser");
        var reverse = sortDirection !== 'asc';
        
        data = Object.assign([],
                             data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                            );
        cmp.set("v.workgroupUser", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        
        return function (a, b) {
            if (field=='TotalCaseAssignedInWorkgroup' ||field=='TotalCaseAssigned' || field=='TotalCaseAssignedOnPendingCustomer' || field=='TicketID')
            {
                var A = key(a)? key(a) : '';
                var B = key(b)? key(b) : '';
                return reverse * ((A > B) - (B > A));  
            }
            else{
                var A = key(a)? key(a).toLowerCase() : '';
                var B = key(b)? key(b).toLowerCase() : '';
                return reverse * ((A > B) - (B > A));
            }            
        };
    }
})
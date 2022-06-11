({
	getAuthorizedContacts : function(component, event, helper) {
        helper.apexAction(component, 'c.getAuthorizedContacts', {recordId : component.get('v.recordId')}, true)
        .then(result => component.set('v.authorizedContacts', result.map(cur => {
        	return {
                Id : cur.Id,
                ContactId : cur.ContactId,
                ContactName : cur.Contact.Name,
                ContactURL : '/one/one.app?#/sObject/' + cur.ContactId + '/view',
                Email : cur.Contact.Email,
                Phone : cur.Contact.Phone,
                MobilePhone : cur.Contact.MobilePhone,
                Country__c : cur.Contact.Country__c,
                CH_ContactTimeZone__c : cur.Contact.CH_ContactTimeZone__c,
                LegalEntityName : cur.Contact.CH_Legal_Entity_Name__c,
                CreatedBy : cur.CreatedBy.Name,
                CreatedDate : cur.CreatedDate,
                Contact_Status__c : cur.Contact.Contact_Status__c,
                ServiceContract: cur.Entitlement.ServiceContract.Name,
                ServiceContraclUrl: '/one/one.app?#/sObject/' + cur.Entitlement.ServiceContract.Id + '/view',
                AccountName: cur.Entitlement.Account.Name,
                AccountNameUrl: '/one/one.app?#/sObject/' + cur.Entitlement.Account.Id + '/view',
                AccountNumber: cur.Entitlement.Account.AccountNumber
        	};
        })),(component.get('v.newPopUpVisible')?helper.searchContacts(component, true):null));
	},
    searchContacts : function(component, research) {
        var helper = this;
        var contactId = component.find("cContactId").get("v.value");
        var cGlobalSearch = component.find("cGlobalSearch").get("v.value");
        var email = component.find("cEmail").get("v.value");
        var accountName = component.find("cAccountName").get("v.value"); 
        
		//exclusion of retrofit contracts and retrieve employee types
        var RetrofitScId = false;
        var EmployeeTypes = [];
        helper.apexAction(component, 'c.getServiceContractRetrofit', {
            oContractId : component.get('v.recordId'),
        }, true).then(result => {
            this.RetrofitScId = result;
        });

        helper.apexAction(component, 'c.getEmployeeType', {}, true).then(result => {
            this.EmployeeTypes = result;
        });
		//
		
        if(cGlobalSearch.length > 2 || accountName.length > 2 || contactId.length > 2 || email.length > 2) {
            helper.apexAction(component, 'c.searchContacts', {
                oContractId : component.get('v.recordId'),
                contactGlobalSearch : cGlobalSearch,
                contactId : contactId,
                email : email,
                accountName : accountName
            }, true).then(result => {
                let authorizedContacts = component.get('v.authorizedContacts');
                component.set('v.newContacts', result.map(cur => {
                    for(let i = 0; i < authorizedContacts.length; i++) {
						cur.ContactURL = '/one/one.app?#/sObject/' + cur.Id + '/view';
                        if(authorizedContacts[i].ContactId === cur.Id) {
                        	cur.actionDisabled = true;
                			break;
                   		}
                	}
                    if(this.RetrofitScId == true){
            			var flag = false;
            			for(let i = 0;i < this.EmployeeTypes.length;i++){
                            if(cur.CH_ContactType__c == this.EmployeeTypes[i]){
                               flag = true;
                            }
                        }
            			if(flag == false){
                            cur.actionDisabled = true;
                        }
        			}
               		return cur;
            	}));
                component.set('v.searched', research && result.length === 0 ? false : true);
            });
         } 
		 //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
    else helper.showToast('error', 'Error', $A.get("$Label.c.CH_Not_Valid_Search_Parameter"));
    
    },
    // Tab
    setTabIcon : function(component) {
        if(component.get('v.viewAll')) {
            var workspaceAPI = component.find("Workspace");
            var sObjectName = component.get('v.sObjectName');
            workspaceAPI.getEnclosingTabId().then(function(response) {
                workspaceAPI.setTabLabel({
                    tabId: response,
                    label: "Authorized " + (sObjectName == "Contact"?"Contracts":"Contacts"),
                    title: "Authorized " + (sObjectName == "Contact"?"Contracts":"Contacts")
                });
                workspaceAPI.setTabIcon({
                    tabId: response,
                    icon: "standard:contact",
                    iconAlt: "Authorized " + (sObjectName == "Contact"?"Contracts":"Contacts")
                });
            });
        }
    },
    //
    apexAction: function(component, method, params, handleError) {
        let helper = this, action = component.get(method);
        helper.incrementActionCounter(component);
        return new Promise(function(resolve, reject) { 
        	if(params) action.setParams(params);
        	action.setCallback(helper, function(response) {
                let state = response.getState();
                helper.decrementActionCounter(component);
                if (state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    if(handleError) {
                        var error = response.getError();
                        var message =  error && error[0] && error[0].message ? error[0].message : "Something went wrong";
                        helper.showToast('error', 'Error', message);
                    }
                    else reject(response.getError());
                }
            });
            $A.enqueueAction(action);
        });
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        $A.get("e.force:showToast").setParams({
            "title": title,
            "message": message,
            "type": sType
        }).fire();
    },
    // Loading Framework
    isLoading: function(component) {
        return component.get("v.showSpinner");
    },
    incrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") + 1;
        if (counter === 1) {
            component.set("v.showSpinner", true);
        }
        component.set("v.actionCounter", counter);
    },
    decrementActionCounter: function(component) {
        var counter = component.get("v.actionCounter") - 1;
        if (counter === 0) {
            component.set("v.showSpinner", false);
        }
        component.set("v.actionCounter", counter);
    }
})
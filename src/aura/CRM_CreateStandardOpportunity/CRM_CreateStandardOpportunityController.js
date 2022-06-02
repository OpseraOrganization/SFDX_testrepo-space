({
    doInit : function(component, event, helper)
    {
        component.set('v.loading', true);
        var action = component.get("c.getFormData");
        action.setParams({"recordId": component.get("v.recordId")});
		action.setCallback(this, function(response)
		{
            var state = response.getState();
            if(state === "SUCCESS")
            {
 				var wrapper = response.getReturnValue();
                if(!wrapper.canCreate)
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Access Denied.",
                        "message": "User profile does not have the rights to create an indirect opportunity."
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();//handleCancel();
                }
                if(wrapper.contactRec != null)
                {
                    component.set("v.con", wrapper.contactRec);
                }
                component.set("v.account",wrapper.accountRec);
                component.set("v.accountId",wrapper.accountRec.Id);

                var campdata = wrapper.campaignRec;
                component.set("v.cmpg", campdata);
                if(campdata != null)
                {
                    component.set("v.has_camp",true);
                }

                var currencies = [];
                var currencyList = wrapper.currencyValues;
                for (var key in currencyList )
                {
                    currencies.push({value:currencyList[key], key:key});
                }
                component.set("v.currencyValues", currencies);

                var oppTypes = [];
                var oppTypeList = wrapper.oppTypeValues;
                for (var key in oppTypeList )
                {
                    oppTypes.push({value:oppTypeList[key], key:key});
                }
                component.set("v.oppTypes", oppTypes);
                var oppyTypeCmp = component.find("opportunity_type");
                oppyTypeCmp.set("v.value",oppTypes[0].value);

                //Set End Customer Information Values
                var oppEndCustomerInfoValues = [];
                var oppEndCustomerInfoValuesList = wrapper.oppEndCustomerInfoValues;

                for (var key in oppEndCustomerInfoValuesList )
                {
                    oppEndCustomerInfoValues.push({value:oppEndCustomerInfoValuesList[key], key:key});
                }
                component.set("v.oppEndCustomerInfoValues", oppEndCustomerInfoValues);

                var endCustInfoCmp = component.find("end_customer_information");
                if(!helper.isNullOrBlank(endCustInfoCmp))
                {
                    endCustInfoCmp.set("v.value",oppEndCustomerInfoValues[0].value);
                    component.set("v.mktSegInitialValue", oppEndCustomerInfoValues[0].value);
                }

                //Set End Customer Marketing Segment Values
                var oppECmktSegValues = [];
                var oppECmktSegValuesList = wrapper.oppECMarketSegValues;

                for (var key in oppECmktSegValuesList )
                {
                    oppECmktSegValues.push({value:oppECmktSegValuesList[key], key:key});
                }
                component.set("v.oppECMktSegValues", oppECmktSegValues);

                //Set End Customer Country Values
                var oppECCountriesValues = [];
                var oppECCountriesValuesList = wrapper.oppECCountryValues;

                for (var key in oppECCountriesValuesList )
                {
                    oppECCountriesValues.push({value:oppECCountriesValuesList[key], key:key});
                }
                component.set("v.oppECCountriesValues", oppECCountriesValues);

                //Set End Customer Activity Sector Values
                component.set("v.depnedentFieldMap",wrapper.oppECActSecValues);
                var listOfkeys = [];
                var ControllerField = [];

                for (var singlekey in wrapper.oppECActSecValues) {
                    listOfkeys.push(singlekey);
                }

                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }

                component.set("v.listControllingValues", ControllerField);

                //
                var contractSigningValues = [];
                var contractSigningEntities = wrapper.contractSigningValues;
                for (var key in contractSigningEntities )
                {
                    contractSigningValues.push({value:contractSigningEntities[key], key:key});
                }
                component.set("v.contractSigningValues", contractSigningValues);

                var accountRoleValues = [];
                var accountRoles = wrapper.accountRoleValues;
                for (var key in accountRoles )
                {
                    accountRoleValues.push({value:accountRoles[key], key:key});
                }
                component.set("v.accountRoleValues", accountRoleValues);

                if(!helper.isNullOrBlank(wrapper.defaultCurrency))
                {
                	var currencyCmp = component.find("opportunity_currency");
                  	currencyCmp.set("v.value",wrapper.defaultCurrency);
                }
                if(!helper.isNullOrBlank(wrapper.defaultAccountRole))
                {
                	var accountRoleCmp = component.find("account_role");
                    if(!helper.isNullOrBlank(accountRoleCmp))
                    {
                  		accountRoleCmp.set("v.value",accountRoles[wrapper.defaultAccountRole]);
                    }
                }
                component.set("v.contractSigningHelpText", wrapper.contractSigningHelpText);
                component.set("v.winDecDateHelpText", wrapper.winDecDateHelpText);
            }
            else
            {
                console.log('Problem getting form data. Response state: ' + state);

            }
        	component.set('v.loading', false);
        });
        $A.enqueueAction(action);
    },

    saveOpportunity: function(component, event, helper)
    {
        try {

        var contactId = component.get("v.con");
        var isDirect = component.get("v.directOpp");
        helper.fillRecordEditFormFields(component);
        if(isDirect)
        {
            if(contactId == "" || contactId == null)
            {
               helper.saveDirectOppFromAccount(component, event, helper);
            }
            else
            {
               helper.saveDirectOppFromContact(component, event, helper);
            }
        }
        else
        {
            if(contactId == "" || contactId == null)
            {
               helper.saveIndirectOppFromAccount(component, event, helper);
            }
            else
            {
               helper.saveIndirectOppFromContact(component, event, helper);
            }
        }
        } catch (error) {
            console.log(error);
        }
    },

	handleCancel: function(component, event, helper)
    {
	    $A.get("e.force:closeQuickAction").fire();
    },

    onControllerECInformationChange: function(component, event, helper)
    {
        helper.checkECInformationChange(component, event, helper);
    },

    onControllerECMktSegChange: function(component, event, helper)
    {
        helper.checkECMktSegChange(component, event, helper);
    },

})
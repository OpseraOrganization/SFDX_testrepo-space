({
    doInit: function(component, event, helper) {
        /*NOKIASC-25121*/
        helper.helperValidateUserPermission(component, event, helper);
        helper.helperCheckCreateNEAButton(component, event, helper);
        helper.init(component, event, helper);
        //NOKIASC-29426
        if(component.get("v.tabMode")!==false)
            helper.setTabInfo(component);
    },
    handleLookupEvent: function(component, event, helper) {
        var objectId = event.getParam("ParentRecordId");
        var ObjectnameId = event.getParam("objectNameId");
        if (ObjectnameId == "Account") {
            component.set("v.ShiptopartyAddress", objectId);
        } else if (ObjectnameId == "Contact") {
            component.set("v.communicationContact", objectId);
        } else if (ObjectnameId == "Address") {
            component.set("v.Address", objectId);
        }
    },
    handleProductSelection: function(component, event, helper) {
        var message = event.getParam("message");
        switch (message) {
            default:
                if (event.getParam("target") != null) {
                    var target = (event.getParam("target")).split(' ').join('');
                    var object = JSON.parse((event.getParam("object") == null ? null : event.getParam("object")));
                    component.set('v.' + target.charAt(0).toLowerCase() + target.slice(1), object);
                }
                break;
        }
    },
    handleReleaseToggle: function(component, event, helper) {
        if (component.find("inputReleaseToggle").get('v.checked')) {
            let productRelease = component.get('v.assetProductRelease');
            component.set('v.productRelease', productRelease);
            component.set('v.preDefProductFields.productRelease', productRelease);
        } else {
            component.set('v.productRelease', null);
            component.set('v.preDefProductFields.productRelease', null);
        }
    },
    handleToggleChanged: function(component, event, helper) {
        var getAttributeValue = component.get("v.checkbox");
        component.find("assetAddress").set("v.value", '');
        if (getAttributeValue == true) {
            component.set("v.checkbox", false);
            component.set('v.locationId', null);
            if (component.get("v.Asset.AccountId") != null) {
                component.set("v.Asset.AccountId", null);
            }
			component.find("inputSelectCountry").set("v.value", '');//NOKIASC-36196
			component.set('v.countryPicklistFlag', false);//NOKIASC-36208
        } else {
            component.set("v.checkbox", true);

            if (component.get("v.accountNumberWhenSelected") != null) {
                component.set("v.accountNumberWhenSelected", null);
            }

            helper.init(component, event, helper);
        }
    },
    saveNEA: function(component, event, helper) {
        var addr = component.find("assetAddress").get("v.value");
        component.set("v.Address", addr);
        if (!helper.isLoading(component)) {
            helper.incrementActionCounter(component);
            var oNEA = component.get("v.Asset");
            if (component.get("v.checkbox") == true) {
                component.set("v.Asset.AccountId", component.get("v.AccountId"));
                component.set("v.Asset.CH_ContractLineItem__c", component.get("v.recordId"));
            }
            oNEA.Product2Id = component.get('v.product') ? component.get('v.product').Id : null;
            oNEA.CH_ProductRelease__c = component.get('v.productRelease') ? component.get('v.productRelease').Id : null;
            oNEA.CH_ProductVariant__c = component.get('v.productVariant') ? component.get('v.productVariant').Id : null;
            oNEA.CH_Solution__c = component.get('v.solution') ? component.get('v.solution').Id : null;
            oNEA.Address__c = component.get('v.Address') ? component.get('v.Address') : null;
			// Changes strat for NOKIASC-36196
            oNEA.CH_SWComponent__c = component.get('v.swComponent') ? component.get('v.swComponent').Id : null;
            oNEA.CH_SWRelease__c = component.get('v.swRelease') ? component.get('v.swRelease').Id : null;
            oNEA.CH_SWModule__c = component.get('v.swModule') ? component.get('v.swModule').Id : null;
            oNEA.CH_SWBuild__c = component.get('v.swBuild') ? component.get('v.swBuild').Id : null;
            
            var codesMap= component.get("v.countryCodeMap");            
            if(oNEA.CH_CountryISOName__c !='--None--' && oNEA.CH_CountryISOName__c !=null && oNEA.CH_CountryISOName__c != '' &&( oNEA.CH_CountryISO2__c ==null || oNEA.CH_CountryISO2__c == '') ){
            
                oNEA.CH_CountryISO2__c=codesMap.get(oNEA.CH_CountryISOName__c);
            }// Changes end for NOKIASC-36196

            var accountId = component.get("v.Asset.AccountId");
            var assetName = component.get("v.Asset.Name");
            var networkEleId = component.find("inputNetworkElementId").get("v.value");
            var errorMessage = false;
            var errorMessage1 = '';
            var errorMessage2 = '';
            if (accountId == undefined || accountId == null) {
                helper.showToast('error', 'Error', "Account cannot be blank!");
                component.set("v.showSpinner", false);
                errorMessage = true;
            }
            if ((assetName == undefined || assetName == '') && (networkEleId == undefined || networkEleId == '')) {

                helper.showToast('error', 'Error', "Asset Name & Network Element Id both cannot be blank!");
                component.set("v.showSpinner", false);
                errorMessage = true;
            }
			
            var cli_Address = component.get("v.CountryISOName");
            var asset_Address = component.get("v.Asset.CH_CountryISOName__c");
            var addressId = component.find("assetAddress").get("v.value");
			 //NOKIASC-36208 Added Validation For Country On Non CLI NEAs
            if ((asset_Address == undefined || asset_Address == '' || asset_Address == null||asset_Address == '--None--')&&(component.get("v.checkbox") == false)) {
                helper.showToast('error', 'Error', "Please select the Country!");
                component.set("v.showSpinner", false);
                errorMessage = true;
            } 
            // Commented Below Code For NOKIASC-36208
            /*else
            if (component.get("v.checkbox") == true && ((asset_Address?asset_Address.toLowerCase():asset_Address) != (cli_Address?cli_Address.toLowerCase():cli_Address))) {
                helper.showToast('error', 'Error', "Country on the Contract Line Item is different from the country on the asset address.");
                component.set("v.showSpinner", false);
                errorMessage = true;
            }*/
			
            if (errorMessage == false) {
                helper.apexAction(component, 'c.saveNEARecord', {
                    asset: oNEA,
                    checkbox: component.get("v.checkbox")
                }, (error, result) => {
                    helper.decrementActionCounter(component);
                    if (error) {
                        helper.showToast('error', 'Error', error && error[0] && error[0].message ? error[0].message : "Something went wrong");
                        return console.log(error);
                    }
                    helper.redirectWindow(component, component.get("v.checkbox")?component.get("v.recordId"):result);
    				helper.closeWindow(component);
                });
            }
        }
    },
    cancelQuickAction: function(component, event, helper) {
    	helper.closeWindow(component);
    },
    handleApplicationEvent: function(component, event, helper) {
        var acId = event.getParam("AccountId");
        var accNum = event.getParam("AccountNumber");
        component.set('v.Asset.AccountId', acId);
        component.set('v.accountNumberWhenSelected', accNum);
		helper.apexAction(component, "c.getAccountLocation", {
            "accountId": acId,
            "accountNumber": accNum,
        }, (error, result) => result?component.set('v.locationId', result.Id):null);
    },
    matchCountryToCountryCode: function(component, event, helper) {
        if (component.get("v.checkbox") == true) {
            var countryNameFromCLI = component.get("v.CountryISOName");
            var countryNameFromAddress = component.find("assetAddress").get("v.value");
        }
    },
    /* Rajeshwari NOKIASC-25067*/
    onChangeAddress: function(component, event, helper) {
        helper.onChangeAddress(component, component.find("assetAddress").get("v.value"));
    },
    /* Tiago NOKIASC-29426 */
    createAddress : function(component, event, helper) {
        helper.incrementActionCounter(component);
        var workspaceAPI = component.find("workspace");
        var locationId = component.get('v.locationId');
        workspaceAPI.openSubtab({
            url: '/lightning/o/Address/new'+(locationId?'?defaultFieldValues=ParentId='+component.get('v.locationId'):'')
        }).then(function(response) {
            const check = () => workspaceAPI.getTabURL({ tabId: response }).then((result) => {
                var recordId = (result.indexOf('/lightning/r/Address/') != -1 ? result.split('/lightning/r/Address/')[1].split("/")[0]: null);
                if(!recordId) setTimeout(() => check(), 250);
            	else {
                    component.find("assetAddress").set("v.value", recordId);
                	helper.decrementActionCounter(component);
                    workspaceAPI.closeTab({tabId: response});
            		workspaceAPI.getEnclosingTabId().then((main) => {
                        workspaceAPI.focusTab({tabId : main});
        			});
        			helper.onChangeAddress(component, recordId);
                }
            }).catch((error) => { helper.decrementActionCounter(component) });
            check();
        })
        .catch(function(error) {
            console.log(error);
        });
	},
})
({
    initialiseData: function(cmp) {
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        if (userId) {
            cmp.set('v.isAuth', true);
            // check for an entitlement relationship
            // internal users have this implicitly
            this.checkForEntitlementRelationship(cmp);
        } else {
            cmp.set('v.isInitialised', true);
        }
    },
    checkForEntitlementRelationship: function(cmp) {
        var action = cmp.get('c.hasEntitlementRelationship');
        action.setCallback(this, function (resp) {
            var hasEntitlementRelationship = resp.getReturnValue();
            cmp.set('v.hasEntitlementRelationship', hasEntitlementRelationship);
            if (hasEntitlementRelationship) {
                // continue the initialisation process
                this.hasAuthorisation(cmp);
            } else {
                // cmp should take care of this
                cmp.set('v.isInitialised', true);
            }
        });
        $A.enqueueAction(action);
    },
    hasAuthorisation: function(cmp) {
        this.setApprovedServices(cmp);
        this.setUserType(cmp);
        this.setOtherServices(cmp);
        this.setAvailableServiceOther(cmp);
        // this should be done with a promise
        cmp.set('v.isInitialised', true);
    },
    setApprovedServices: function(cmp) {
        var action = cmp.get('c.getSelectedServices');
        action.setStorable();
        action.setCallback(this, function(resp) {
            var services = resp.getReturnValue();
            services.sort(function(a, b) {
                var serviceA = a.toUpperCase();
                var serviceB = b.toUpperCase();
                if (serviceA < serviceB) {
                    return -1;
                }
                if (serviceA > serviceB) {
                    return 1;
                }
                return 0;
            });
            cmp.set('v.approvedServices', services);
            this.setAvailableServices(cmp);
        });
        $A.enqueueAction(action);
    },
    setUserType: function(cmp) {
        var action = cmp.get('c.getUserType');
        action.setStorable();
        action.setCallback(this, function(resp) {
            cmp.set('v.isInternal', resp.getReturnValue());
            // cmp.set('v.isInternal', true);
            // console.dir('### AES isInternal: ' + resp.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    setAvailableServices: function(cmp) {
        var action = cmp.get('c.getNonSelectedServices');
        action.setStorable();
        action.setParams({
            selectedServicesList: cmp.get('v.approvedServices')
        });
        action.setCallback(this, function(resp) {
            var services = resp.getReturnValue();
            services.sort(function(a, b) {
                var serviceA = a.service.NCP_Title__c.toUpperCase();
                var serviceB = b.service.NCP_Title__c.toUpperCase();
                if (serviceA < serviceB) {
                    return -1;
                }
                if (serviceA > serviceB) {
                    return 1;
                }
                return 0;
            });
            cmp.set('v.availableServices', services);
            cmp.set('v.allDataLoaded', true);
        });
        $A.enqueueAction(action);
    },
    setOtherServices: function(component) {
        var action = component.get('c.getOtherServices');
        action.setBackground();
        action.setCallback(this, function(actionResult) {
            var otherServices = actionResult.getReturnValue();
            // augment data with isChecked value
            otherServices.sort(function(a, b) {
                var serviceA = a.title.toUpperCase();
                var serviceB = b.title.toUpperCase();
                if (serviceA < serviceB) {
                    return -1;
                }
                if (serviceA > serviceB) {
                    return 1;
                }
                return 0;
            });
            otherServices.forEach(function(anOtherService) {
                if (!anOtherService.disabled) {
                    anOtherService.isChecked = false;
                }
            });
            component.set('v.otherServices', otherServices);
        });
        $A.enqueueAction(action);
    },
    setAvailableServiceOther: function(cmp) {
        var availableServiceOther = {};
        // reset the product search
        cmp.set('v.availableOtherSelectedProducts', []);
        availableServiceOther.productId = '';
        availableServiceOther.contractId = '';
        cmp.set('v.availableServicesOther', availableServiceOther);
    },
    canSubmitAvailableServiceOther: function(cmp, comment) {
        var availableServicesOther = cmp.get('v.availableServicesOther');
        var availableOtherSelectedProducts = cmp.get('v.availableOtherSelectedProducts');
        if (
            availableServicesOther.productId ||
            availableServicesOther.contractId ||
            availableOtherSelectedProducts.length ||
            comment
        ) {
            cmp.set('v.showSubmissionRequirements', false);
            return true;
        } else {
            cmp.set('v.showSubmissionRequirements', true);
            return false;
            // show errors
            // if (!availableOtherSelectedProducts.length) {
            //     var productSearch = cmp.find('productSearch');
            //     productSearch.showErrorState();
            // }
            // var inputCmp = cmp.find('availableServiceOtherField');
            // inputCmp.showHelpMessageIfInvalid();

            // var commentCmp = cmp.find('commentId');
            // commentCmp.showHelpMessageIfInvalid();

            // cmp.find('availableServiceOtherField').forEach(function(inputCmp) {
            //     inputCmp.showHelpMessageIfInvalid();
            // });
        }
    },
    checkSubmitStatus: function(cmp, isOther) {
        var services = isOther ? cmp.get('v.otherServices') : cmp.get('v.availableServices');
        var isSubmittable = false;
        isSubmittable = services.some(function(aService) {
            if (aService.isChecked) {
                return true;
            }
        });
        // need to check if the 'Other' checkbox has been checked
        // but only if it is not already submittable
        if (!isSubmittable && !isOther) {
            // needs some more work here - when is this section submittable?
            // when either the product or the contract field is not null
            // probably should be a function
            if (cmp.get('v.showOther')) {
                // need to make it submittable in order to show the errors on submit
                isSubmittable = true;
            } else {
                // clear the availableServicesOther error when unchecked
                cmp.set('v.showSubmissionRequirements', false);
            }
        }
        isOther ? cmp.set('v.isOtherServicesSubmittable', isSubmittable) : cmp.set('v.isSubmittable', isSubmittable);
    },
    getSelectedServices: function(cmp, isOther) {
        var services = isOther ? cmp.get('v.otherServices') : cmp.get('v.availableServices');
        var selectedServices = [];
        services.forEach(function(aService) {
            if (aService.isChecked) {
                selectedServices.push(isOther ? aService.title : aService.service.NCP_Title__c);
            }
        });
        return selectedServices.join();
    },
    clearSectionSelections: function(cmp, isOther) {
        var serviceName = isOther ? 'v.otherServices' : 'v.availableServices';
        var commentName = isOther ? 'v.otherServicesComment' : 'v.availableServicesComment';
        var services = cmp.get(serviceName);
        services.forEach(function(aService) {
            aService.isChecked = false;
        });
        cmp.set(serviceName, services);
        cmp.set(commentName, '');
        if (!isOther) {
            cmp.set('v.showOther', false);
            // need to clear comment, product, contract etc
            this.setAvailableServiceOther(cmp);
        }
        // check submission status to reset button, etc
        this.checkSubmitStatus(cmp, isOther);
    },
    submitRequest: function(cmp, isOther) {
        var selectedServices = this.getSelectedServices(cmp, isOther);
        var contractNumber = '';
        var productName = '';
        var comment = isOther ? cmp.get('v.otherServicesComment') : cmp.get('v.availableServicesComment');
        // if its not the other section check that the AvailableServiceOther isn't open
        // If it is then make sure at least one field has been filled
        if (!isOther && cmp.get('v.showOther')) {
            if (!this.canSubmitAvailableServiceOther(cmp, comment)) {
                return false;
            } else {
                // need to add the product and/or service id to the request
                var availableServicesOther = cmp.get('v.availableServicesOther');
                var availableOtherSelectedProducts = cmp.get('v.availableOtherSelectedProducts');
                if (availableOtherSelectedProducts.length) {
                    // just submit the first item in the list for now
                    // otherwise need to update the api to accept an array of products
                    availableServicesOther.productId = availableOtherSelectedProducts[0].Id;
                }
                productName = availableServicesOther.productId ? availableServicesOther.productId : '';
                contractNumber = availableServicesOther.contractId ? availableServicesOther.contractId : '';
            }
        }
        var action = cmp.get('c.submitCase');
        action.setParams({
            selectedElmt: selectedServices,
            contractNum: contractNumber,
            prName: productName,
            comment: comment,
            other: cmp.get('v.showOther')
        });
        action.setCallback(this, function(response) {
            if (isOther) {
                cmp.set('v.isOtherServicesSubmitting', false);
            } else {
                cmp.set('v.isSubmitting', false);
            }
            var state = response.getState();
            if (state === 'SUCCESS') {
                // console.log('Case created');
                // Hide the form
                var whichForm = isOther ? 'v.isOtherServicesSubmitted' : 'v.isSubmitted';
                cmp.set(whichForm, true);
            } else {
                var toastEvent = $A.get('e.force:showToast');
                toastEvent.setParams({
                    mode: 'sticky',
                    title: 'Problem creating case',
                    type: 'error',
                    message: response.getError()[0].message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        // need to clear sections fields here
        this.clearSectionSelections(cmp, isOther);
        if (isOther) {
            cmp.set('v.isOtherServicesSubmitting', true);
        } else {
            cmp.set('v.isSubmitting', true);
        }
    }
});
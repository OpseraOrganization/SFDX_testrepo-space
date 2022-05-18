({
    allItems: null,
    getSupportLinks: function(cmp) {
        this.allItems = [];
        var action = cmp.get('c.getLinks');
        action.setStorable();
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (result) {
                    // create the category object;
                    for (var category in result.categories) {
                        var newCategory = {};
                        newCategory.title = result.categories[category].label;
                        newCategory.value = result.categories[category].value;
                        newCategory.isOpen = false;
                        newCategory.links = [];
                        this.allItems.push(newCategory);
                    }
                    for (var link in result.links) {
                        // need to fix the URL for the CH links
                        if (result.links[link].NCP_CH_authorised_contact_only__c) {
                            if (result.links[link].NCP_URL__c === 'case') {
                                result.links[link].NCP_URL__c = '/case/Case/' + result.viewId;
                            } else {
                                result.links[link].NCP_URL__c = '/' + result.links[link].NCP_URL__c;
                            };
                        }
                        var type = result.links[link].NCP_Support_type__c;
                        // add this to the correct category
                        for (var item in this.allItems) {
                            if (this.allItems[item].value === type) {
                                this.allItems[item].links.push(result.links[link]);
                            }
                        }

                        // this.allItems[type].push(result.links[link]);
                    }
                    for (var group in this.allItems) {
                        this.allItems[group].links.sort(function(a, b) {
                            var aTier = parseInt(a.NCP_Tier__c, 10);
                            var bTier = parseInt(b.NCP_Tier__c, 10);
                            if (aTier !== bTier) {
                                return aTier - bTier;
                            } else {
                                var aName = a.NCP_Title__c.toUpperCase();
                                var bName = b.NCP_Title__c.toUpperCase();
                                if (aName > bName) {
                                    return 1;
                                }
                                if (aName < bName) {
                                    return -1;
                                }
                                return 0;
                            }
                        });
                    }
                }
                // sort by tier (lower number is more important)
                cmp.set('v.allItems', this.allItems);
            }
            this.doneInitialising(cmp);
        });
        $A.enqueueAction(action);
    },
    initialiseData: function(cmp) {
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        if (userId) {
            cmp.set('v.isAuth', true);
            // if authenticated then check for entitlements
            this.checkEntitlements(cmp);
        } else {
            this.getSupportLinks(cmp);
        }
    },
    checkEntitlements: function(cmp) {
        // We dont care about the products themselves just if the user has entitled products
        // This api returns a boolean for entitled products for both internal and external users
        var action = cmp.get('c.checkForEntitledProducts');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                // result is a boolean
                if (result) {
                    // if the user has entitled products then they must be authenticated
                    cmp.set('v.hasEntitledProducts', true);
                }
            }
            this.getSupportLinks(cmp);
        });
        $A.enqueueAction(action);
    },
    doneInitialising: function(cmp) {
        cmp.set('v.itemsReady', true);
        cmp.set('v.isInitialised', true);
    },
    toggleCategory: function(cmp, aValue) {
        for (var item in this.allItems) {
            if (this.allItems[item].value === aValue) {
                this.allItems[item].isOpen = !this.allItems[item].isOpen;
            }
        }
        cmp.set('v.allItems', this.allItems);
    },
    goToProductsListView: function() {
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({ url: '/product-list-view' });
        urlEvent.fire();
    }
});
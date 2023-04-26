({
    items: [
        {
            label: 'My Profile',
            value: 'profile',
            href: '/profile/',
            show: true
        },
        {
            label: 'My Settings',
            value: 'settings',
            href: '/settings/',
            show: false
        },
        {
            label: 'Request Access to Resources',
            value: 'services',
            href: '/upgrade-my-services',
            hrefError: '/upgrade-my-services',
            show: true
        },
        {
            label: 'My Entitlements',
            value: 'entitlements',
            href: '/my-entitlements/',
            show: true
        },
        {
            label: 'Manage Subscriptions',
            value: 'subscriptions',
            href: '',
            show: true
        },
        {
            label: 'Contact Support',
            value: 'support',
            href: '/general-support-faq',
            show: true
        },
        {
            label: 'Secondary Account',
            value: 'secondaryAccount',
            hrefTest: 'https://qa-online.networks.nokia.com/nam/customerAccReqForm.faces',
            href: 'https://online.networks.nokia.com/nam/customerAccReqForm.faces',
            show: true
        },
        {
            label: 'Admin',
            value: 'admin',
            href: '',
            show: false
        },
        {
            label: 'Change Password',
            value: 'changePassword',
            hrefTest: 'https://qa-online.networks.nokia.com/entry/Do?action=volpwchange',
            href: 'https://online.networks.nokia.com/entry/Do?action=volpwchange',
            show: true
        },
        {
            label: 'Log Out',
            value: 'logout',
            href: '/secur/logout.jsp',
            show: true
        }
    ],
    getLinkFromValue: function(cmp, aValue) {
        var targetItem;
        this.items.forEach(function(menuItem) {
            if (menuItem.value === aValue) {
                targetItem = menuItem;
            }
        }, this);
        if (targetItem.value === 'secondaryAccount' && cmp.get('v.isSandbox')) {
            return targetItem.hrefTest;
        }
        if (targetItem.value === 'changePassword' && cmp.get('v.isSandbox')) {
            return targetItem.hrefTest;
        }
        if (targetItem.value === 'services' && !cmp.get('v.hasEntitlementRelationship')) {
            return targetItem.hrefError;
        }
        return targetItem.href;
    },
    toggleMenu: function(cmp, evt) {
        if (evt) {
            evt.preventDefault();
            evt.stopPropagation();
        }
        if (!cmp.get('v.isMenuShowing')) {
            // check the user is still authenticated before showing menu
            var action = cmp.get('c.isAuthenticated');
            cmp.set('v.isMenuShowing', true);
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var isAuth = response.getReturnValue();
                    if (isAuth) {
                        // show the menu items
                        cmp.set('v.isCheckingAuth', false);
                    } else {
                        // reset the menu and direct the user to the log in page
                        cmp.set('v.isAuth', isAuth);
                        window.open(window.location.origin + '/customers/login', '_self');
                    }
                }
            });
            cmp.set('v.isCheckingAuth', true);
            $A.enqueueAction(action);
        } else {
            // hide it
            cmp.set('v.isMenuShowing', false);
        }
    },
    checkAuth: function(cmp) {
        var action = cmp.get('c.checkForGuestUser');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let guestUserFlag = response.getReturnValue();
                var userId = $A.get('$SObjectType.CurrentUser.Id');
                if (guestUserFlag != true) {
                    cmp.set('v.userId', userId);
                    cmp.set('v.isAuth', true);
                    this.getAllProfileDetails(cmp);
                } else {
                    cmp.set('v.isAuth', false);
                    cmp.set('v.isInitialised', true);
                }
            }
        });
        $A.enqueueAction(action);
        
    },

    checkIfUserIsCompetitorUser : function(cmp){
        var action = cmp.get('c.checkCompetitorUser');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                cmp.set('v.horizontalUser', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    getLoginURL:function(cmp){
        var action = cmp.get('c.getLoginRedirectURL');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                cmp.set('v.loginRedirectURL',result);
            }
        });
        $A.enqueueAction(action);
    },


    getAllProfileDetails: function(cmp) {
        var action = cmp.get('c.getAllProfileDetails');
        action.setCallback(this, function(response) {
            var state = response.getState();
            var profileLoader = cmp.find('userProfileLoader');
            var toastEvent = $A.get('e.force:showToast');
            var toastTitle = 'Profile menu data error';
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                if (result) {
                    if (!result.manageSubscriptionURLs.ambiguousURLs) {
                        cmp.set('v.manageSubscriptionURL', result.manageSubscriptionURLs.candidateURL.Target_URL__c);
                    } else {
                        toastEvent.setParams({
                            mode: 'sticky',
                            title: toastTitle,
                            type: 'error',
                            message: result.manageSubscriptionURLs.errorMsg
                        });
                        toastEvent.fire();
                    }
                    cmp.set('v.isSandbox', result.isSandbox);
                    cmp.set('v.isInternalUser', result.isInternalUser);
                    cmp.set('v.isAuthorisedEmployee', result.isAuthorisedEmployee);
                    cmp.set('v.hasEntitlementRelationship', result.hasEntitlementRelationship);
                    cmp.set('v.adminHref', result.orgUrl);
                }
            } else {
                // This prevents this warning showing in community builder
                if (window.location === window.parent.location) {
                    toastEvent.setParams({
                        mode: 'sticky',
                        title: toastTitle,
                        type: 'error',
                        message: response.getError()[0].message
                    });
                    toastEvent.fire();
                }
            }
            profileLoader.reloadRecord();
        });
        $A.enqueueAction(action);
    },
    makeInitials: function(cmp) {
        var userDetails = cmp.get('v.userDetails');
        var firstInitial = userDetails.FirstName[0].toUpperCase();
        var secondInitial = userDetails.LastName[0].toUpperCase();
        cmp.set('v.userInitials', firstInitial + secondInitial);
    },
    checkProfileImage: function(cmp) {
        var userDetails = cmp.get('v.userDetails');
        var imageSrc = userDetails.SmallPhotoUrl;
        var communityName = window.location.pathname.split('/')[1];
        // hide the default image in favour of the initials
        if (imageSrc !== '/' + communityName + '/profilephoto/005/T') {
            cmp.set('v.userThumbnail', imageSrc);
        }
    },
    makeMenu: function(cmp) {
        this.items.forEach(function(item) {
            if (item.value === 'entitlements') {
                // if isInternal remove myEntitlements
                if (cmp.get('v.isInternalUser')) {
                    item.show = false;
                }
            }
            if (item.value === 'changePassword') {
                // if isInternal remove myEntitlements
                if (cmp.get('v.isInternalUser')) {
                    item.show = false;
                }
            }
            if (item.value === 'subscriptions') {
                var targetURL = cmp.get('v.manageSubscriptionURL');
                if (targetURL) {
                    item.href = targetURL;
                    item.show = true;
                } else {
                    // its undefined so hide it
                    item.show = false;
                }
            }
            // if (item.value === 'services') {
            // if the user has an entitlement relationship show with correct link to page
            // Otherwise show link but show error when clicked instead.
            // only show if user has an entitlement relationship
            // if (cmp.get('v.hasEntitlementRelationship')) {
            //     item.show = true;
            // }
            // }
            if (item.value === 'admin') {
                // if isAuthorisedEmployee show the admin link
                if (cmp.get('v.isAuthorisedEmployee')) {
                    item.show = true;
                    item.href = cmp.get('v.adminHref');
                }
            }
            if (item.value === 'profile' || item.value === 'settings') {
                let link = item.href, userIdStr = cmp.get('v.userId');
                if(link.indexOf(userIdStr) <= -1){
                	item.href += cmp.get('v.userId');
                }
            }
            if(item.value === 'secondaryAccount'){
                // if User is a Horizontal User
                if (cmp.get('v.horizontalUser')) {
                    item.show = false;
                }
            }
        });
        cmp.set('v.menuItems', this.items);
    },
    fullyInitialised: function(cmp) {
        this.checkProfileImage(cmp);
        this.makeInitials(cmp);
        this.makeMenu(cmp);
        cmp.set('v.isInitialised', true);
    },
    attachEventMenu: function(cmp) {
        // events should only reach here if they are not from the menu
        document.addEventListener(
            'click',
            function() {
                var isMenuOpened = cmp.get('v.isMenuShowing');
                if (isMenuOpened) {
                    this.toggleMenu(cmp);
                }
            }.bind(this)
        );
    }
});
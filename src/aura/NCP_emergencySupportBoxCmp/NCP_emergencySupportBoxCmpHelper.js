({
    setDefaultCountry: function (cmp) {
        function isInCountryList (aCountry) {
            var isInList = false;
            var countries = cmp.get('v.countryOptions');
            countries.forEach(function (item) {
                if (item.value === aCountry) {
                    isInList = true;
                }
            });
            return isInList;
        }
        var chosenCountry = sessionStorage.getItem('chosenCountry');
        // the user has previously chosen a country, use that
        // otherwise test the user details
        if (!chosenCountry) {
            var userDetails = cmp.get('v.userDetails');
            var country = userDetails.CountryCode;
            // test to see if this country is included in the list of countries available
            if (country && isInCountryList(country)) {
                sessionStorage.setItem('chosenCountry', country);
                cmp.set('v.countryName', country);
                cmp.set('v.disabledValue', false);
            }
        } else {
            cmp.set('v.countryName', chosenCountry);
            cmp.set('v.disabledValue', false);
        }
    },
    loadUserId : function(cmp) {
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        if (userId) {
            // there is an authenticated user
            cmp.set('v.user', userId);
            var profileLoader = cmp.find('userProfileLoader');
            profileLoader.reloadRecord();
        }
    },
    sortCountryOptions: function(aCountries) {
        aCountries.sort(function (a, b) {
            var countryA = a.label.toUpperCase();
            var countryB = b.label.toUpperCase();
                if (countryA < countryB) {
                    return -1;
                }
                if (countryA > countryB) {
                    return 1;
                }
            return 0;
        });
    },
    asyncCall: function (cmp, apexAction, params, isBackground) {
        var promise = new Promise($A.getCallback(function (resolve, reject) {
            var action = cmp.get('c.' + apexAction + '');
            action.setParams(params);
            if (isBackground) {
                action.setBackground();
            }
            action.setCallback(this, function (result) {
                if (result.getState() === 'SUCCESS') {
                    resolve(result.getReturnValue());
                } else if (result.getState() === 'ERROR') {
                    // console.log('ERROR', result.getError());
                    reject(result.getError());
                }
            });
            $A.enqueueAction(action);
        }));
        return promise;
    }
})
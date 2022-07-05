({
    loadOptions: function (cmp) {
        if (!$A.util.isEmpty(cmp.get('v.country'))) {
            cmp.set('v.disabledValue', false);
        }
        this.loadCountries(cmp);
        var country = cmp.get('v.country');
        if (country) {
            country = country.toUpperCase();
            this.loadEmergencyContactSupport(cmp, country);
            this.loadUserId(cmp);
        }
        //this.loadEmergencyContactSupport(cmp, cmp.get('v.country').toUpperCase());
        //this.loadEmergencyContactSupport(cmp, country);
        //this.loadUserId(cmp);
    },
    loadCountries: function (cmp) {
        var action = cmp.get('c.getCountries');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var results = response.getReturnValue();
                this.sortCountryOptions(results);
                cmp.set('v.countryOptions', results);
            }
        });
        $A.enqueueAction(action);
    },
    loadEmergencyContactSupport: function (cmp, aCountryCode) {
        var action = cmp.get('c.getEmergencyContactSupport');
        // set the global
        // country codes are always 2 characters so ignore anything longer
        // this can occur if the user puts an argument on the URL
        // eg. https://ccport-nokiapartners.cs21.force.com/customers/s/contactsupport?country=france
        if (aCountryCode.length === 2) {
            sessionStorage.setItem('chosenCountry', aCountryCode);
            cmp.set('v.country', aCountryCode);
        }
        if (aCountryCode) {
            action.setParams({
                countryCode: aCountryCode
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var results = response.getReturnValue();
                    cmp.set('v.contactSupportData', results);
                }
            });
            $A.enqueueAction(action);
        }
    },
    loadUserId: function (cmp) {
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        cmp.set('v.user', userId);
    },
    sortCountryOptions: function (aCountries) {
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
    }
})
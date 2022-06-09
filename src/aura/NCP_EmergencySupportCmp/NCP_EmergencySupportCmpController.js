({
    doInit: function (cmp, evt, hlp) {
        // check for param
        var country = cmp.get('v.country');
        // if there is a param this is a deep link
        // eg. https://ccport-nokiapartners.cs21.force.com/customers/s/contactsupport?country=france
        // so there shouldn't be a user country
        if (!country) {
            // if no param check for a user selection
            // note that this is using the country code
            if (sessionStorage.getItem('chosenCountry')) {
                country = sessionStorage.getItem('chosenCountry');
                cmp.set('v.country', country);
            }
        }
        hlp.loadOptions(cmp);
    },
    handleChangeCountry: function (cmp, evt, hlp) {
        cmp.set('v.disabledValue', false);
        var country = cmp.find('selectItem').get('v.value');
        hlp.loadEmergencyContactSupport(cmp, country);
    }
})
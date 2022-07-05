({
    doInit: function (cmp, evt, hlp) {
        hlp.asyncCall(cmp, 'getCountries', {}, true)
            .then(function (result) {
                hlp.sortCountryOptions(result);
                cmp.set('v.countryOptions', result);
                hlp.loadUserId(cmp);
            })
            .catch($A.getCallback(function (err) {
                var toastEvent = $A.get('e.force:showToast');

                toastEvent.setParams({
                    title: 'Error',
                    type: 'error',
                    message: err.message
                });

                toastEvent.fire();
            }))
            .then($A.getCallback(function () {
                // console.log('Finally');
            }));
    },
    setDefaultCountry: function (cmp, evt, hlp) {
        var evtParams = evt.getParams();
        if (evtParams.changeType === 'LOADED') {
            hlp.setDefaultCountry(cmp);
        } else {
            // console.log('Problem with loading user country');
        }
    },
    handleGoToPage: function (cmp) {
        var countryName = cmp.find('selectItem').get('v.value');
        sessionStorage.setItem('chosenCountry', countryName);
        if (cmp.get('v.countryName') === 'Please choose a country') {
            countryName = '';
        }
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': '/contactsupport'
        });
        urlEvent.fire();
        // window.open('/customers/s/contactsupport?country='+countryName, '_self');
    },
    handleChange: function (cmp) {
        var countryCode = cmp.find('selectItem').get('v.value');
        cmp.set('v.disabledValue', false);
        sessionStorage.setItem('chosenCountry', countryCode);
    }
})
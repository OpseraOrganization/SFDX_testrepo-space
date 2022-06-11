({
    doInit : function(component, event, helper) {
        //  helper.LoadDefaultCountryName(component);
    },
    showSupportPage: function () {
        // Note we are not using the country name here
        // Because we need to verify that it is a country on the approved list
        // And also because it doesn't work with $A.get('e.force:navigateToURL')
        // It should work with the Winter 19 release - safe harbour
        // If we need to set it we can use
        // sessionStorage.setItem('chosenCountry', countryName);
        // var countryName = component.get('v.countryName');
        var urlEvent = $A.get('e.force:navigateToURL');
        urlEvent.setParams({
            'url': '/contactsupport'
        });
        urlEvent.fire();
    }
})
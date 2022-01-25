({
    search : function(component) {
        var helper = this;
        helper.incrementActionCounter(component);
        var fullAddress = {
            address 	: component.find('address').get('v.value'),
            city 		: component.find('city').get('v.value'),
            postalCode 	: component.find('postalCode').get('v.value'),
            state 		: component.find('state').get('v.value'),
            country 	: component.find('country').get('v.value')
        };
        if(fullAddress != '') {
            helper.action(component, 'c.getTimeZone', fullAddress, function(location, error) {
                helper.decrementActionCounter(component);
                if(error)
                    return console.log(error), helper.showToast('error', 'Error', error);
                //
                helper.select(component, location['timezone']);
                for(let i in location['address_components']) {
                    switch(location['address_components'][i]['types'][0]) {
                        case 'administrative_area_level_1':
                            component.find('state').set('v.value', location['address_components'][i]['long_name']);
                            break;
                        case 'locality':
                            component.find('city').set('v.value', location['address_components'][i]['long_name']);
                            break;
                    }
                }
                component.set('v.mapMarkers', [{
                    location: { Latitude: location['lat'], Longitude: location['lng'] }
                }]);
                component.set('v.zoomLevel', 10);
            });
        }
    },
    select : function(component, object) {
        component.set('v.timeZone', object);
        this.emit(component, 'select', object);
    },
    emit: function(component, event, args) {
        component.getEvent("onEvent").setParams({
            message	: event,
            target	:'TimeZone',
            object	: JSON.stringify(args)
        }).fire();
    },
    //
    action : function(component, method, args, callback) {
        let action = component.get(method);
        if(args) action.setParams(args);
        action.setCallback(this,function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(response.getReturnValue(), null);
            } else if (state === "INCOMPLETE") {
                callback(null, 'Incomplete');
            } else if (state === "ERROR") {
                var errors = response.getError();
                callback(null, errors && errors[0] && errors[0].message?("Error message: " + errors[0].message):"Unknown error");
            }
        });
        $A.enqueueAction(action);
    },
    incrementActionCounter: function(component) {        
        component.getEvent("onEvent").setParams({
            message: 'incrementActionCounter'
        }).fire();
    },
    decrementActionCounter: function(component) {
        component.getEvent("onEvent").setParams({
            message: 'decrementActionCounter'
        }).fire();
    },
    // Generic Toast Message
    showToast: function(sType, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": sType
        });
        toastEvent.fire();
    }
})
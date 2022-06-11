({
    checkAuth: function(cmp) {
        var userId = $A.get('$SObjectType.CurrentUser.Id');
        if (userId) {
            cmp.set('v.isAuth', true);
        } else {
            cmp.set('v.isAuth', false);
        }
    },
    serviceTilesAction: function(cmp) {
        var action = cmp.get('c.getTiles');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var results = response.getReturnValue();

                if (results.length < 1) {
                    cmp.set('v.noServices', true);
                }
                var tempServices = [];
                results.forEach(function(service) {
                    // debugger;
                    if (!service.iconName) {
                        service.iconName = 'knowledge_base';
                    }
                    if (service.iconName.substr(0, 9) === 'ncp_icon_') {
                        service.iconName = service.iconName.substr(9);
                    }
                    if (!service.priority) {
                        service.priority = 99999;
                    }
                    service.fullDescription = service.description;
                    if (service.description && service.description.length > 160) {
                        service.description = _.truncate(service.description, {
                            'length': 160,
                            'separator': ' ',
                            'omission': ' [...]'
                        });
                    }
                    tempServices.push(service);
                });
                // need to do the services sort here
                tempServices.sort(function(a, b) {
                    return a.priority - b.priority;
                });
                if (tempServices.length) {
                    cmp.set('v.myServices', tempServices);
                }
                cmp.set('v.servicesLoaded', true);
            }
        });
        $A.enqueueAction(action);
    }
});
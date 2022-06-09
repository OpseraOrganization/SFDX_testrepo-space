({
	LoadDefaultCountryName : function(component) {
        var action = component.get("c.getDefaultCounry");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var country = response.getReturnValue();
                if(country !== null){
                    component.set("v.countryName", country);
                }else{
                    component.set("v.countryName", "USA");
                }
            }else{
                component.set("v.countryName", "USA");
            }
        });
        $A.enqueueAction(action);
    }
})
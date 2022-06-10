({
    baseURL : function(component) {
        var action = component.get("c.getCommunityURL");
        var urlString = window.location.href;
        var baseURL = "";
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                baseURL = urlString.substring(0, urlString.indexOf(result));
                if(urlString.includes(result)){
                    baseURL+=result;
                }else{
                    baseURL = urlString.substring(0, urlString.indexOf("/s"));
                }
                baseURL+='/s';
            }
            component.set("v.cbaseURL", baseURL);
        });
        $A.enqueueAction(action);
    }
})
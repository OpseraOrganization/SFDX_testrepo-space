({
    doInit : function(component, event, helper)
    {
        var accId = component.get("v.recordId");
        var action = component.get("c.fetchNCIBUrl");
        action.setParams({ accId : accId });
        action.setCallback(this, function(response) 
    	{
        	var state = response.getState();
            if (state === "SUCCESS")
            {
                var wrapper = response.getReturnValue();
                if(wrapper.errorMsg==null)
                {
                    component.set('v.ncibUrl', wrapper.ncibUrl);
                    console.log(wrapper.ncibUrl);
                }
                else
                {
                    helper.showToast('Error', wrapper.errorMsg, 'error');
                }
            }
            else
            {
                helper.showToast('Error', 'Error retrieving data', 'error');
            }
        });
        $A.enqueueAction(action);
    },
    gotoNCIB : function(component, event, helper)
    {
        var url = component.get('v.ncibUrl');
        window.open(url);
    }
})
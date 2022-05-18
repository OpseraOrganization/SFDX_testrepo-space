({
	checkSuccess : function(component, event, helper, response) 
    {
        var success;
        component.set('v.loaded', true);
        if(typeof response.getReturnValue().errorMessage === 'undefined' || response.getReturnValue().errorMessage == '' || response.getReturnValue().errorMessage == null)
        {
            success = true;
        }
        else
        {
            success = true;
            component.set('v.errorMessage',response.getReturnValue().errorMessage);
        }
        return success;
	}
})
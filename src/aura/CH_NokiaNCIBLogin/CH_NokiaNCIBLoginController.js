({
	doInit : function(component, event, helper) {  
        var pageReference = component.get("v.pageReference");
        var param1 = pageReference.state.c__ncibUR;
        if(param1 == null)
        {
             console.log('Error');
        }
        else{
            component.set("v.ncibUrl",param1);
        }
       
    }

})
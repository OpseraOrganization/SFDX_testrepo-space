({
    myAction : function(component, event, helper) {
        var Id = component.find("Id");
        $A.util.toggleClass(Id, "toggle");
        var country = component.find("country").get("v.value");
        var stateValue = component.get("c.getStateValues");
        var optsstate=[];
        stateValue.setParams({
            "country" : country
        });       
        stateValue.setCallback(this, function(a) {
            var pickVal = component.find('state').get('v.value');
            var isError = false;
            for(var i=0;i< a.getReturnValue().length;i++){
                try{
                    if(pickVal.indexOf("undefined") == -1) {
                    }
                }catch(err) {
                    isError=true
                    optsstate.push({value:a.getReturnValue()[i],label:a.getReturnValue()[i],selected:''});
                }
                if(!isError) {
                    optsstate.push({value:a.getReturnValue()[i],label:a.getReturnValue()[i],selected:pickVal.includes(a.getReturnValue()[i])});
                }
            }
            component.set("v.optState",optsstate);
        });
        $A.enqueueAction(stateValue);
        var distributor = component.get("c.getDistributors");
        var optsdist=[];
        distributor.setParams({
            "countryDis" : country
        });
        distributor.setCallback(this, function(a) {
            var pickVal = component.get('v.sectionLabels.distributor');
            for(var i=0;i< a.getReturnValue().length;i++){
                optsdist.push({value:a.getReturnValue()[i],label:a.getReturnValue()[i],selected:pickVal.includes(a.getReturnValue()[i])});
            }	
            component.set("v.optDistributor",optsdist);
      	});
        $A.enqueueAction(distributor);
        
    }  ,
})
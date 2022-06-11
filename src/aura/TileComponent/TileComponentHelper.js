({
	getTileDetail : function(component, event, helper) {
        var action = component.get("c.getTiles");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                
                var firstTileRec=[];
                var secondTileRec=[];
                firstTileRec.push(results[0]);
                secondTileRec.push(results[1]);
                component.set("v.Newtile", firstTileRec);
                component.set("v.Secondtile",secondTileRec);
                
                var oldTileRec=[];
                oldTileRec.push(results[2]);
                oldTileRec.push(results[3]);
                component.set("v.Oldtile", oldTileRec);
            }
        });
        $A.enqueueAction(action);
	}
})
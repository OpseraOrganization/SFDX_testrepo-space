({
    // Generic method for apex calls
    apex : function( component, event, helper ) {
        const inputParams = event.getParam( 'arguments' );
        var callingComponent = inputParams.component;
        var apexAction = inputParams.apexAction;
        var params = inputParams.parameters;
        
        return helper.apex(callingComponent, apexAction, params);
	},
    // Get picklist values
    fetchPicklistValues: function(component, event, helper) {
        const inputParams = event.getParam( 'arguments' );
        var callingComponent = inputParams.component;
        var apexAction = inputParams.apexAction;
        var params = inputParams.parameters;
        var addNone = inputParams.addNone;
        
        var promise = new Promise(function( resolve , reject ) {
            helper.apex(callingComponent, apexAction, params)
            .then(function(result){
                var StoreResponse = result;
                var listOfkeys = [];
                var ControllerField = [];
                for (var singlekey in StoreResponse) {
                    listOfkeys.push(singlekey);
                }
                if (listOfkeys != undefined && listOfkeys.length > 0 && addNone) {
                    ControllerField.push('--- None ---');
                }
                for (var i = 0; i < listOfkeys.length; i++) {
                    ControllerField.push(listOfkeys[i]);
                }  
                resolve( ControllerField );
            });
		});            
        return promise; 
    },
})
({
    // Generic method for apex calls
    apex : function( callingComponent, apexAction, params ) {
        var promise = new Promise( $A.getCallback( function( resolve , reject ) { 
            var action = callingComponent.get("c."+apexAction+"");
            action.setParams( params );
            action.setCallback( this , function(callbackResult) {
                if(callbackResult.getState()=='SUCCESS') {
                    resolve( callbackResult.getReturnValue() );
                }
                if(callbackResult.getState()=='ERROR') {
                    console.log('ERROR', callbackResult.getError() );
                    
                    var errors = action.getError();
                    var errorMessage;
                    if (errors) {
                    	if (errors[0] && errors[0].message) {
                            // System error
                        	errorMessage = errors[0].message;
                    	}
                        else if (errors[0] && errors[0].pageErrors) {
                        	// DML Error
                        	errorMessage = errors[0].pageErrors[0].message;
                    	}
                	}
                    reject( errorMessage );
                }
            });
            $A.enqueueAction(action);
        }));            
        return promise; 
	},
})
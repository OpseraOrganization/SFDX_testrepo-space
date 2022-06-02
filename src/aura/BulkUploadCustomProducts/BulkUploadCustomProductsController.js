({
	doInit:  function(component, event, helper) 
    {
        helper.init(component, event, helper);
        
    },
    handleFilesChange : function(component, event, helper) {
       helper.handleFilesChange(component, event, helper);
            
		
	},
    handleClickImport : function(component, event, helper) {
        helper.upload(component, event, helper);
		
	},
    handleClickCart : function(component, event, helper) {
        helper.redirectToCart(component, event, helper);
		
	}
})
({
	tableOnLoad: function(component, event, helper) {
        console.log('function here');
        
    		var myCustomComponent = component.find('contentSecondRow');
    		$A.util.addClass(myCustomComponent, 'reportTechRec');
		 
        
        
        
        
		
        console.log('after target');
         
        
     }, 
})
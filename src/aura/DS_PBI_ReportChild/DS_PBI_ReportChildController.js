({
    onRender : function(component, event, helper) {    
            var link = component.get("v.link");             
            console.log('link is'+link);            
            var rectarget = event.currentTarget;
            console.log('rectarget>>'+rectarget);
            var reportURL = link; 
            console.log('******reportURL*********'+reportURL);
            var sPageURL = reportURL;
            var reportId  = '';
            console.log('***sPageURL****'+sPageURL);
            var sURLVariables = sPageURL.split('&');
            var reportURLSubPart =  sURLVariables[0].split('reportId=');
            reportId =  reportURLSubPart[1];
			console.log('*****reportId********'+reportId);
           
			
            var  techUseCase = component.find('techUseCaseList'); 
            console.log('*****techUseCaseList found*******');
            $A.util.addClass(techUseCase,'slds-hide');
			$A.util.removeClass(techUseCase,'slds-show');
            console.log('Before calling loadReport Data');
          	console.log('test hide section completed')
            var reportSection = component.find('reportSection');
            console.log('*****reportSection found*******');
			$A.util.addClass(reportSection,'slds-show');
			$A.util.removeClass(reportSection,'slds-hide');
            console.log('******before finding myreport**********');
            var report = component.find('myReport');
			$A.util.addClass(report,'slds-show');
			$A.util.removeClass(report,'slds-hide');  
            helper.loadReportDataNew(component, event, helper,window.localStorage.getItem("v.accesstoken"),reportId,reportURL);       
    },

    handleClick : function(component, event, helper) {        
        var element = component.find('myReport').getElement();
        console.log('****Element found********'+element);
        element = '';
        console.log('****Element set with null value********');
        var report = component.find('reportSection');
        $A.util.addClass(report,'slds-hide');
        $A.util.removeClass(report,'slds-show');
        
         var compEvent = component.getEvent("sampleComponentEvent"); 
         compEvent.fire();
         component.destroy();
    }
})
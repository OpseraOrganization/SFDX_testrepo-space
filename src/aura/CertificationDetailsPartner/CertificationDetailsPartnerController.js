({
	init : function(component, event, helper) 
    {    
        var certifServerCall = component.get("c.getCertificationsValuesforComponent");
        certifServerCall.setParams({
            "parentId": component.get("v.recordId"),
        }); 
        certifServerCall.setCallback(this, function(response) 
		{
            component.set("v.CertificationDetails", response.getReturnValue().certificationWrapperList);
            component.set("v.partnerDroplistValues", response.getReturnValue().droplistValues.partnerList);
            component.set("v.partnerTypeDroplistValues", response.getReturnValue().droplistValues.partnerTypeList);
            component.set("v.portfolioDroplistValues", response.getReturnValue().droplistValues.portfolioList);
            component.set("v.jobFunctionDroplistValues", response.getReturnValue().droplistValues.jobFunctionList);
            component.set("v.statusDroplistValues", response.getReturnValue().droplistValues.statusValuesList);
            
            //Set initial default filter values
            window.setTimeout(
                $A.getCallback( function() 
				{
                    component.find("partnerFilter").set("v.value", response.getReturnValue().droplistValues.defaultPartnerValue);
					helper.filterCertificationRecord(component, event, helper);      
            	}
			));
            
        }); 
       	$A.enqueueAction(certifServerCall);
	},
        
    filterResults : function(component,event, helper)
    {
        helper.filterCertificationRecord(component,event, helper);
    },
    
    mOpenCertification : function(component,event, helper)
    {
        window.open("/NokiaPRM/s/detail", '_blank');
    }
})
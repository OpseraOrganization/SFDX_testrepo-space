({
	init : function(component, event, helper)
	{   
		var apexCall = component.get("c.getCertifAndAccredforComponent");
		apexCall.setParams(
		{
			"parentId": component.get("v.recordId")
		}); 
		apexCall.setCallback(this, function(response) 
		{			
			//Set Lists to display
			component.set("v.AccreditationValuesforComponent", response.getReturnValue().accreditationWrapper);
			component.set("v.CertificationName", response.getReturnValue().certificationWrapper);
			helper.setPortfolioCounters(component.get("v.CertificationName"), '', '', '', component, event, helper);
			component.set("v.SumInp", response.getReturnValue().certificationCounterWrapper);
		   	
			//Set dropdown list selectable values
            component.set("v.partnerDroplistValues", response.getReturnValue().droplistValues.partnerList);
            component.set("v.partnerTypeDroplistValues", response.getReturnValue().droplistValues.partnerTypeList);
            component.set("v.portfolioDroplistValues", response.getReturnValue().droplistValues.portfolioList);
            component.set("v.accrLevelDroplistValues", response.getReturnValue().droplistValues.accrLevelList);
            component.set("v.marketDroplistValues", response.getReturnValue().droplistValues.marketValuesList);	  

            //Set initial default filter values
			window.setTimeout(
				$A.getCallback( function() 
				{
					component.find("partnerTypeFilter").set("v.value", response.getReturnValue().droplistValues.defaultPartnerTypeValue);
                    helper.filterResults(component, event, helper);
				}
			));
		}); 
		$A.enqueueAction(apexCall);
	},  
	
	filterResults : function(component, event, helper)
	{	
		helper.filterResults(component, event, helper);
	}	
});
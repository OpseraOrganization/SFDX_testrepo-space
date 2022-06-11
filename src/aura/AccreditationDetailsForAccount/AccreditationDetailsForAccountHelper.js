({
	filterResults : function(component, event, helper)
	{	
		var certifCountersCall = component.get("c.getCertifCounterWrapper");
		certifCountersCall.setParams(
		{
			"parentId": component.get("v.recordId"),
			"partnerFilter" : component.find("partnerFilter").get("v.value"),
			"partnerTypeFilter" : component.find("partnerTypeFilter").get("v.value"),
			"portfolioFilter" : component.find("portfolioFilter").get("v.value")
		});
		certifCountersCall.setCallback(this, function(response) 
		{
			helper.setFilter(component, event, helper);
			component.set("v.SumInp", response.getReturnValue());
			var rec = component.get("v.SumInp");
		});
		$A.enqueueAction(certifCountersCall);
	},

	setFilter : function(component, event, helper) 
	{
		var portfolioValue=  component.find("portfolioFilter").get("v.value");
		var partnerValue=  component.find("partnerFilter").get("v.value");
		var partnerTypeValue=  component.find("partnerTypeFilter").get("v.value");
		var accrLevelValue=  component.find("accrLevelFilter").get("v.value");
		helper.filterAccreditationList(component.get("v.AccreditationValuesforComponent"), partnerValue, partnerTypeValue, portfolioValue, accrLevelValue, component, event, helper);
		helper.setPortfolioCounters(component.get("v.CertificationName"), partnerValue, partnerTypeValue, portfolioValue, component, event, helper);
	},
	
   	setPortfolioCounters : function(certifData, partnerValue, partnerTypeValue, portfolioValue, component, event, helper) 
	{
		var Details=JSON.stringify(certifData);
		var bookingLocations = certifData;			 
		var count = 0;
		var len = bookingLocations.length - 1;
		var leng = bookingLocations.length;
		var portf = [];
		
		//Get filter values
		if(leng == 1)
		{
			if(helper.filterCertificationRecord(portfolioValue, partnerValue, partnerTypeValue, bookingLocations[0]))//Checks Partner type filter
			{
				portf.push(bookingLocations[0].portfolio);
			}
		}
		else
		{
			for(var a=0; a<len; a++)
			{
				if(bookingLocations[a].portfolio != bookingLocations[a+1].portfolio)
				{
					if(helper.filterCertificationRecord(portfolioValue, partnerValue, partnerTypeValue, bookingLocations[a]))
					{
						portf.push(bookingLocations[a].portfolio);
					}
				}
				if(a == len-1 )
				{
					if(helper.filterCertificationRecord(portfolioValue, partnerValue, partnerTypeValue, bookingLocations[a+1]))
					{
				   		portf.push(bookingLocations[a+1].portfolio);
					}
				}
			}
		}
		component.set("v.portfolio",portf);
	},
		
	filterAccreditationList : function(accreditationList, partnerValue, partnerTypeValue, portfolioValue, accrLevelValue, component, event, helper) 
	{		   
		for(var i = 0, len = accreditationList.length; i < len; i++) 
		{
			accreditationList[i].visible = false;//By default we will not show the row in the partner list. If the filter is not applicable we will out the row visible
			if((portfolioValue == '' ||  portfolioValue == accreditationList[i].portfolio)//Checks portfolio filter
			&& (partnerValue == '' ||  partnerValue == accreditationList[i].partnerName)//Checks Partner filter
			&& (accrLevelValue == '' ||  accrLevelValue == accreditationList[i].accreditationLevel)//Checks Accreditation Level filter
			&& (partnerTypeValue == '' ||  partnerTypeValue == accreditationList[i].partnerType))//Checks PartnerType filter
			{
			   accreditationList[i].visible = true;
			}
		}
		component.set("v.AccreditationValuesforComponent", accreditationList);		
	},
	
	filterCertificationRecord : function(portfolioValue, partnerValue, partnerTypeValue, bookingLocation) 
	{
		var showCertRec = false;
		if((portfolioValue == '' ||  portfolioValue == bookingLocation.portfolio))
		{
		   showCertRec = true;
		}
		return showCertRec;
	}
})
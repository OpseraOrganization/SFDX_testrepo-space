({
    filterPartnerCompanyList : function(component, event, helper) 
    {
        var partnerList = component.get("v.PartnerCompaniesDetail");
        var countryValue=  component.find("countryFilter").get("v.value");
		var partnerValue=  component.find("partnerFilter").get("v.value");
		var partnerTypeValue=  component.find("partnerTypeFilter").get("v.value");
        
        for(var i = 0, len = partnerList.length; i < len; i++) 
        {
            partnerList[i].visible = false;//By default we will not show the row in the partner list. If the filter is not applicable we will out the row visible
            if((countryValue == '' ||  countryValue == partnerList[i].countryHeadquarters)//Checks country filter
            && (partnerValue == '' ||  partnerValue == partnerList[i].name)//Checks Partner filter
            && (partnerTypeValue == '' ||  partnerTypeValue == partnerList[i].partnerType))//Checks Partner type filter
            {
				partnerList[i].visible = true;  
            }
		}
        component.set("v.PartnerCompaniesDetail", partnerList);    	
	}
})
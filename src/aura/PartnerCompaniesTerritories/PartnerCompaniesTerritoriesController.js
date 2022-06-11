({
	init : function(component, event, helper) 
    {
		var getPartnerCompList = component.get("c.getPartnerCompforComponent");
        getPartnerCompList.setParams(
        {
            "parentId": component.get("v.recordId"),
        }); 
        getPartnerCompList.setCallback(this, function(response) 
		{
            component.set("v.PartnerCompaniesDetail", response.getReturnValue().territoriesList);
            component.set("v.partnerDroplistValues", response.getReturnValue().droplistValues.partnerList);
           	component.set("v.marketDroplistValues", response.getReturnValue().droplistValues.marketList);
           	component.set("v.countryDroplistValues", response.getReturnValue().droplistValues.countryList);
           	component.set("v.partnerTypeDroplistValues", response.getReturnValue().droplistValues.partnerTypeList);
            
            //Set initial default filter values
            window.setTimeout(
                $A.getCallback( function() 
				{
                    component.find("partnerTypeFilter").set("v.value", response.getReturnValue().droplistValues.defaultPartnerValue);
            		helper.filterPartnerCompanyList(component, event, helper);
            	})
            );
        }); 
        $A.enqueueAction(getPartnerCompList);
	},
    
    filterPartnerCompanyList : function(component, event, helper) 
    {
        helper.filterPartnerCompanyList(component, event, helper);
    }
})
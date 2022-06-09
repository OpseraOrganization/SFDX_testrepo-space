({
	filterCertificationRecord : function(component, event, helper) 
    {
        var certificationList = component.get("v.CertificationDetails")
        var portfolioValue=  component.find("portfolioFilter").get("v.value");
        var partnerValue=  component.find("partnerFilter").get("v.value");
        var statusValue=  component.find("statusFilter").get("v.value");
        var jobFunctionValue=  component.find("jobFunctionFilter").get("v.value");
        console.log(certificationList);
        for(var i = 0, len = certificationList.length; i < len; i++) 
        {
            certificationList[i].visible = false;//By default we will not show the row in the partner list. If the filter is not applicable we will out the row visible
            if((portfolioValue == '' ||  portfolioValue == certificationList[i].portfolio)//Checks portfolio filter
            && (partnerValue == '' ||  partnerValue == certificationList[i].partnerName)//Checks Partner filter
            && (jobFunctionValue == '' ||  jobFunctionValue == certificationList[i].jobFunction)
            && (statusValue == '' ||  statusValue == certificationList[i].certificationStatus))//Checks PartnerType filter
			{
               certificationList[i].visible = true;
			}
		}
        component.set("v.CertificationDetails", certificationList);  
    }
})
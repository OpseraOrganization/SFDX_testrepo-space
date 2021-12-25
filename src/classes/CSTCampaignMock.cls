@isTest
global class CSTCampaignMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		//System.assertEquals('callout:CST_Login/api/GetCampaignList', req.getEndpoint());
		//System.assertEquals('GET', req.getMethod());
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');	   
		res.setBody('[{"CampaignId":"M0036K","CampaignName":"Nokia-Jul-3","NamingConvention":"17-Nokia-Jul-3-M0036K","IsTargetedOutreach":false,"ProgramView":[{"ProgramId":"C002DX","ProgramName":"Nokia-Jul-3-Sub-BGLE","PNamingConvention":"17-Nokia-Jul-3-Nokia-Jul-3-Sub-BGLED-C002DX","TacticView":[{"TacticId":"T001LT","TacticCampaign":"Nokia-Jul-Sub-BGL","TNamingConvention":"17-Nokia-Jul-3-Nokia-Jul-3-Sub-BGLED-Digital-Nokia-Jul-Sub-BGLED-Tac1-T001LT","tacticType":"Postal Mail"}]},{"ProgramId":"C002DZ","ProgramName":"Nokia-Jul-Sub6","PNamingConvention":"17-Nokia-Jul-3-Nokia-Jul-Sub6-C002DZ","TacticView":[]}]}]');				
		res.setStatusCode(200);			   
	   // return res;
	 // }
	
	   if(req.getEndpoint().contains('callout:CST_Login/api/GetCampaignList')){
			return res;
		}
		
		//System.assertEquals('callout:CST_Login/api/GetCampaignBulk?MasterId=M005G3', req.getEndpoint());
		//System.assertEquals('GET', req.getMethod());
		HttpResponse res1 = new HttpResponse();
		res1.setHeader('Content-Type','application/json');
		res1.setstatuscode(200);
		res1.setBody('[{"CampaignId":"M005G3","CampaignName":"Sirius UAT","CampaignDescription":"Sirius UAT","CampaignManager":"gernot.kohler.ext@nokia.com","NamingConvention":"18-Sirius UAT-M005G3","CampaignStartDate":"2017-10-01T00:00:00","CampaignEndDate":"2018-12-31T00:00:00","IsTargetedOutreach":false,"BusinessGroupList":[{"Id":5,"Name":"Fixed Networks"},{"Id":9,"Name":"Global Services"}],"BusinessTypeList":[{"Id":89,"Name":"Cable Operator"}],"ProgramList":[{"ProgramId":"C002L1","Name":"Sirius Program UAT","ProgramDescription":"Sirius Program UAT","CampaignManager":"gernot.kohler.ext@nokia.com","PNamingConvention":"18-Sirius UAT-Sirius Program UAT-C002L1","StartDate":"2017-10-01T00:00:00","EndDate":"2018-12-31T00:00:00","TacticList":[{"TacticId":"T001U6","Name":"Sirius UAT PS","TacticDescription":"Sirius UAT PS","CampaignManager":null,"TNamingConvention":"18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT PS-T001U6","TacticType":70,"StartDate":"2017-11-01T00:00:00","EndDate":"2018-01-31T00:00:00","BusinessGroupList":[{"Id":9,"Name":"Global Services"}],"BusinessLineList":[{"Id":44,"Name":"Nokia Corp GS"}],"BusinessTypeList":[{"Id":89,"Name":"Cable Operator"}],"IndustryList":[{"Id":25,"Name":"Cable MSOs"}]},{"TacticId":"T001U7","Name":"Sirius UAT DEV","TacticDescription":"Sirius UAT DEV","CampaignManager":null,"TNamingConvention":"18-Sirius UAT-Sirius Program UAT-Paid Search-Sirius UAT DEV-T001U7","TacticType":70,"StartDate":"2017-11-01T00:00:00","EndDate":"2018-01-31T00:00:00","BusinessGroupList":[{"Id":9,"Name":"Global Services"}],"BusinessLineList":[{"Id":44,"Name":"Nokia Corp GS"}],"BusinessTypeList":[{"Id":89,"Name":"Cable Operator"}],"IndustryList":[{"Id":25,"Name":"Cable MSOs"}]}],"BusinessGroupList":[{"Id":9,"Name":"Global Services"}],"BusinessLineList":[{"Id":44,"Name":"Nokia Corp GS"},{"Id":71,"Name":"BBA 7343"}],"BusinesstypeList":[],"IndustryList":[]},{"ProgramId":"C002L5","Name":"Sirius 3","ProgramDescription":"Sirius 3","CampaignManager":"gernot.kohler.ext@nokia.com","PNamingConvention":"18-Sirius UAT-Sirius 3-C002L5","StartDate":"2017-11-01T00:00:00","EndDate":"2018-01-31T00:00:00","TacticList":[{"TacticId":"T001UG","Name":"Metric 2","TacticDescription":"Metric 2","CampaignManager":null,"TNamingConvention":"18-Sirius UAT-Sirius 3-Public Event-Metric 2-T001UG","TacticType":81,"StartDate":"2017-11-01T00:00:00","EndDate":"2018-01-31T00:00:00","BusinessGroupList":[{"Id":5,"Name":"Fixed Networks"}],"BusinessLineList":[{"Id":158,"Name":"Care Ext Life Services"}],"BusinessTypeList":[{"Id":89,"Name":"Cable Operator"}],"IndustryList":[{"Id":25,"Name":"Cable MSOs"}]},{"TacticId":"T001UI","Name":"xx","TacticDescription":"xx","CampaignManager":null,"TNamingConvention":"18-Sirius UAT-Sirius 3-Email-xx-T001UI","TacticType":66,"StartDate":"2017-11-01T00:00:00","EndDate":"2018-01-31T00:00:00","BusinessGroupList":[{"Id":5,"Name":"Fixed Networks"}],"BusinessLineList":[{"Id":158,"Name":"Care Ext Life Services"}],"BusinessTypeList":[],"IndustryList":[]}],"BusinessGroupList":[],"BusinessLineList":[{"Id":158,"Name":"Care Ext Life Services"}],"BusinesstypeList":[],"IndustryList":[]}]}]');
		if(req.getEndpoint().contains('callout:CST_Login/api/GetCampaignBulk?CampaignID=M005G3')){
			return res1;
		}
		
		else{
			return null;
		}
	}
}
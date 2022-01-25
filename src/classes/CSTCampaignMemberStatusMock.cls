@isTest
global class CSTCampaignMemberStatusMock implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {

		system.debug('In Mockup');
			 DateTime dateValue = date.today();
		string batchdate = '2019-10-10';
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');	   
		res.setBody('[{"TacticId": "T0047J","NamingConvention": "string1","UpdatedDate": "2019-10-10","CreatedDate": "2019-09-02","MemberStatus": [{"Label": "Sent1","IsDefault": "true","HasResponded": "true", "SortOrder":4}]}]');
	 	res.setStatusCode(200);			   
		system.debug('res:'+res);   
		if(req.getEndpoint().contains('callout:CST_Login/api/sfdcmember?filtertype=GreaterThanEqualTo&updateddate='+batchDate)){
		   system.debug('Inside Res'); 
		   return res;
		}
			   
		HttpResponse res1 = new HttpResponse();
		res1.setHeader('Content-Type','application/json');
		res1.setstatuscode(200);
		system.debug('Res1:'+res1);
		res1.setBody('[{"TacticId": "T001U6","NamingConvention": "string1","UpdatedDate": "2019-10-07","CreatedDate": "2019-09-02","MemberStatus": [{"Label": "Test1","IsDefault": "true","HasResponded": "true", "SortOrder": 5}]}]');
	 	if(req.getEndpoint().contains('callout:CST_Login/api/sfdcmember?filtertype=EqualTo&tacticid=T001U6'))   
		{
			system.debug('Inside res1');
			return res1;
		}
		
		HttpResponse res2 = new HttpResponse();
		res2.setHeader('Content-Type','application/json');
		res2.setstatuscode(200);
		res2.setBody('[{"TacticId": "T0047L","NamingConvention": "string1","UpdatedDate": "2019-10-07","CreatedDate": "2019-09-02","MemberStatus": [{"Label": "Sent1","IsDefault": "true","HasResponded": "true", "SortOrder": 3}]}]');
	 	if(req.getEndpoint().contains('callout:CST_Login/api/sfdcmember?filtertype=EqualTo&tacticid=T0047L'))  
		{
			return res2;
		}
		
		else{
			return null;
		}
	}
}
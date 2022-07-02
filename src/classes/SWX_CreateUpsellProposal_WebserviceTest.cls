@isTest
public class SWX_CreateUpsellProposal_WebserviceTest {

	public testmethod static void UpsertUpsellProposalTest(){
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/upsertUpsellProposal/*';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		test.startTest();
		SWX_CreateUpsellProposal_Webservice.UpsertUpsellProposal();
		test.stopTest();
	}
	
	public testmethod static void UpsertUpsellProposalTestCCRE(){
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
		
		req.requestURI = '/services/apexrest/ccreCreateUpsellProposal/*';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		test.startTest();
		CCRE_CreateUpsellProposal.CCRE_UpsertProposal();
		test.stopTest();
	}
}
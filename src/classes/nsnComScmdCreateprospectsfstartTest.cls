@isTest
public class nsnComScmdCreateprospectsfstartTest {
	
private static testMethod void  nsnComScmdCreateprospectsfTest() {
	try{
		Test.setMock(HttpCalloutMock.class, new ProspectCreationMockResponseTest());
	//Test.setMock(HttpCalloutMock.class, new createProspectSFStartProcessSOAP_soaphttps_CLUSTER_FRINTEAI_MED_DMZ());
		nsnComScmdCreateprospectsfstartproces.createProspectSFStartProcessSOAP_soaphttps_CLUSTER_FRINTEAI_MED_DMZ prospectCreation = new nsnComScmdCreateprospectsfstartproces.createProspectSFStartProcessSOAP_soaphttps_CLUSTER_FRINTEAI_MED_DMZ();
		prospectCreation.clientCertName_x = 'nokia_salesforce_certificate';
		prospectCreation.timeout_x =120000;
		nsnComScmdCreateprospectsfstartproces.StartProcessType resp = new nsnComScmdCreateprospectsfstartproces.StartProcessType();
		resp = prospectCreation.StartProcessOperation('Test Prospect Creation','Unassigned','http://test.com','S7_BHARTI','Direct Customer','Laxmi Road','Pune','69097298','0010v000006iKKx','ALTERNATE SERVICE PROVIDERS','Maharashtra','India','PROSPECT','412114','test123','vishal.d.taware@accenture.com');
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.NSN_TEST_CLASS ,GlobalConstants.NSN_TEST_METHOD );
		}
	}	
	
private static testMethod void  AscNsnComScmdCreateprospectsfstartprocesTest() {
	try{
		AscNsnComScmdCreateprospectsfstartproces.AsynccreateProspectSFStartProcessSOAP_soaphttps_CLUSTER_FRINTEAI_MED_DMZ prospectCreation = new AscNsnComScmdCreateprospectsfstartproces.AsynccreateProspectSFStartProcessSOAP_soaphttps_CLUSTER_FRINTEAI_MED_DMZ();
		prospectCreation.clientCertName_x = 'nokia_salesforce_certificate';
		prospectCreation.timeout_x =120000;
		AscNsnComScmdCreateprospectsfstartproces.StartProcessTypeFuture resp123 = new AscNsnComScmdCreateprospectsfstartproces.StartProcessTypeFuture();
		resp123 = prospectCreation.beginStartProcessOperation(new System.Continuation(60),'Test Prospect Creation','Unassigned','http://test.com','S7_BHARTI','Direct Customer','Laxmi Road','Pune','69097298','0010v000006iKKx','ALTERNATE SERVICE PROVIDERS','Maharashtra','India','PROSPECT','412114','test123','vishal.d.taware@accenture.com'); 
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.NSN_TEST_CLASS ,GlobalConstants.ASC_TEST_METHOD );
		}	
	}	
	
}
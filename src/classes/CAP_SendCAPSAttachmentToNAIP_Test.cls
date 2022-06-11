@isTest
private class CAP_SendCAPSAttachmentToNAIP_Test {
	
	public static final String otherinfoStr='Other Information';
	
	@testSetup static void setup() {
		insert new CH_Integration__c(EnableIntegration__c = true);  
		Product2 tempProduct = new Product2(
			Name = 'Test Product 1',
			NokiaCPQ_State__c = 'Implement',
			NCP_CAREACTIVATE__c = 'test',
			PMD_Portfolio_Classification__c = 'Product'
		);
		Insert tempProduct;
		
		CH_UTIL_TEST.setupCase();
	}
	
	private static Case createTestCase() {
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		
		return CH_UTIL_TEST.getS2SCase();
	}
	
	@IsTest
	private static void sendAttachmentId_Test() {
		CAPS_TestDataUtil.createCustomSettingsData();
		
		String attachmentId;
		Case testCase = createTestCase();
		insert testCase;
		
		List<CH_Attachment__c> attachments = new List<CH_Attachment__c>();
		attachments.addAll(CAPS_TestDataUtil.createCHAttachmentRecord(1, otherinfoStr, testCase.Id));
		insert attachments;
		
		for(CH_Attachment__c attachment : attachments){
			attachmentId = attachment.Id;
		}
		
		Test.startTest();
		
		CAP_SendCAPSAttachmentToNAIP.sendAttachmentId(testCase, 'TEST Attachment Name', attachmentId, 'Test Attachment Desc', 100);
		
		Test.stopTest();
	}
}
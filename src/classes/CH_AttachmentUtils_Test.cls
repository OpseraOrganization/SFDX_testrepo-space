/** 
 * About 
 * ----- 
 * @Description	  : Case Handling Attachment Object Utility Test Class.
 * @Project	: Case Handling.
 * @Modification Log :
 *  Created : 2021 06 09 – tiago.almeida@nokia.com
 * -----
**/
@isTest 
public class CH_AttachmentUtils_Test {
	private static Case oCase;

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		Contact oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		List<Entitlement> oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
		insert oEntitlementList;
		//
		List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
		insert oEntitlementContactList;
		//
		oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
	}
	
	public static testMethod void testDownload() {
		setupTestData();
		//
		test.startTest();
		insert oCase;
		//
		CH_AttachmentUtils.getRelated(oCase.Id);
		CH_AttachmentUtils.getUserActionsAuthorization(oCase.Id, true);
		CH_AttachmentUtils.getUserActionsAuthorization(oCase.Id, null);
		List<CH_Attachment__c> oAttachmentList = new List<CH_Attachment__c>();
		oAttachmentList.add(CH_AttachmentUtils.createAttachment(oCase.Id,new Map<String, Object>(), '31234213sd', true, false));
		insert oAttachmentList;
		CH_AttachmentUtils.download(oAttachmentList);
		CH_AttachmentUtils.updateVisibility(oAttachmentList, 'Customer', true);
		CH_AttachmentUtils.updateVisibility(oAttachmentList, 'Problem', true);
		CH_AttachmentUtils.markForDelete(oCase.Id, oAttachmentList);
		CH_AttachmentUtils.shareWithRND(oCase.Id, 'JIRA', 'Test', 'Test', 'Test', oAttachmentList);
		test.stopTest();
	}
	
	public static testMethod void testUpload() {
		setupTestData();
		//
		test.startTest();
		insert oCase;
		CAPS_TestDataUtil.createCustomSettingsData();
		//
		Map<String, Object> file = new Map<String, Object>{
			'Filename' => 'Test.png',
			'Size' => 1100,
			'Classification' => CAPS_ConstantHandler.OTHER_DATA,
			'Description' => 'Test',
			'CustomerVisible' => true
		};
		CH_AttachmentUtils.initiateUpload(oCase.Id, file);
		//
		Map<String, String> partToETagMap = new Map<String,String>();
		Map<String, Object> response = new Map<String, Object>{
			'attachmentId' => 'df330b2ea42b4e55b61f2647eb710f89',
			's3keyname' => 'df330b2ea42b4e55b61f2647eb710f89/test.txt',
			'fileid' => '411952',
			'signer' => 'bdc7f90cef7345c984f9e34d25e0c192',
			'user' => 'app_salesforce',
			'signtoken' => '63823fceca9aeed2-842e632dcc8ae6348177520d00057bd975e949cccd4791fde62e28b494a5e386',
			'expiration' => '1532757105',
			'permission' => 'RW',
			'acl' => 'private',
			'aws_url' => 'https://s3.capsv.nokia.com/a848be61/us2',
			'bucket' => 'capsvtest1',
			'aws_key' => 'RZZVJKQRQUBLHMVWYTJ_',
			'uploadId' => '2~ijxcVVOnMUT7dCtnf6WEvREyldaGng-',
			'partNumVsEtagMap' => partToETagMap
		};
		Map<String, String> initialMap = CH_AttachmentUtils.parseResponse(JSON.serialize(response));
		try {
			CH_AttachmentUtils.completeUpload(oCase.Id, file, initialMap, partToETagMap, 'df330b2ea42b4e55b61f2647eb710f89', 'df330b2ea42b4e55b61f2647eb710f89/test.txt', false);
		} catch(Exception e) { /* Do Nothing */ }
		try {
			CH_AttachmentUtils.callAPI(
	CAPS_ConstantHandler.SYSTEM_URL + 'df330b2ea42b4e55b61f2647eb710f89',
	CAPS_ConstantHandler.PUT_METHOD,
	CH_AttachmentUtils.getJsonToChangeStatus('411952', 1100, 'Test.png'),
	CAPS_ConstantHandler.CAPS_ENDUSER
			);
		} catch(Exception e) { /* Do Nothing */ }
		try { CH_AttachmentUtils.signURLForS3(initialMap, 'df330b2ea42b4e55b61f2647eb710f89'); } catch(Exception e) { /* Do Nothing */ }
		try { CH_AttachmentUtils.encode(''); } catch(Exception e) { /* Do Nothing */ }
		test.stopTest();
	}
}
@isTest
/***
* Test Class created for the CertificationRecords class
* Created By: Accenture IDC
* Created Date: 22/4/2017
***/
public class CertificationRecordsTest
{
	/**
* Description : Test data to be created.
* @param Id NA 
* @return NA
**/
	@testSetup static void datasetup()
	{
		User u = TestDataFactory.createUser(GlobalConstants.DATALOADER_PROFILE,'running testuser');
		Database.insert(u);
		
		Account partnerAcc = PRM_TestDataFactory.createPartnerAccount(1, GlobalConstants.PARTNER_TYPE_IR)[0];
		Database.insert(partnerAcc);
		
		Contact con = TestDataFactory.createContact2(1,partnerAcc)[0];
		Database.insert(con);
		
		Curriculum_Certification_Mapping__c ccm = PRM_TestDataFactory.createCurriculumCertifMap(1)[0];
		Database.insert(ccm);
		
		Certification_Matrix__c cm = PRM_TestDataFactory.createCertifMatrix(1, ccm.Id , GlobalConstants.PORTF_MICROWAVE)[0];
		Database.insert(cm);
		
		Certification__c cert = PRM_TestDataFactory.createCertification(1, con.id, cm.id, partnerAcc.id, u.Id, GlobalConstants.CERTIF_STATUS_APPROVED)[0];
		Database.insert(cert);
	}
	/**
	* Description : Test method to cover functionality.
	* @param Id NA 
	* @return NA
	**/
	public static testmethod void testAsDataloader()
	{
		Account acc = [SELECT Id FROM Account WHERE BusinessPartnerRole__c = :GlobalConstants.PARTNER_TYPE_IR LIMIT 1];
		User u=[select id from User where lastName='running testuser' LIMIT 1];
		System.runAs(u)
		{
			Test.startTest();
			CertificationRecords.WrapperFull lst = CertificationRecords.getCertificationsValuesforComponent(acc.id);
			System.assertEquals(1 , lst.certificationWrapperList.size(), 'Certifications Retrieved');
			Test.stopTest();
		}
	}

}
/************************************
*Class Name: PRM_TestDataFactory
*Author: Miguel Silva
*Description: Data creation
************************************/
@isTest
public without sharing class PRM_TestDataFactory {
	public static List<Partner> createPartnerRelation(integer nbrRec, Id accountFromId, String partnerRole)
	{	
		List<Partner> partnerRelList = new List<Partner>();
		for(integer i = 0; i < nbrRec; i++)
		{
			Partner partnerRelRec = new Partner();
			partnerRelRec.AccountFromId = accountFromId;
			partnerRelRec.Role = partnerRole;
			partnerRelList.add(partnerRelRec);
		}
		return partnerRelList;
	}
	
	public static User createSystemAdminUser() {	
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		User adminUser = new User(Alias = 'newUser', Email='newuser@testorg.com',
								EmailEncodingKey='UTF-8', LastName='Admin user', LanguageLocaleKey='en_US',
								LocaleSidKey='en_US', ProfileId = adminProfile.Id, TimeZoneSidKey='America/Los_Angeles',
								UserName='newuser1018@testorg1.com'); 
		return adminUser;
	}
	
	public static List<Account> createPartnerAccount(integer nbrRec, String partnerRole)
	{	
		List<Account> partnerAccList = new List<Account>();
		for (integer i = 0; i < nbrRec; i++) 
		{
			Account accRec = new Account();
			accRec.BusinessPartnerRole__c = partnerRole;
			accRec.Partner_Program__c = 'GPP 3.0';
			accRec.Name = 'Test Account -' + i + Utils.generateRandomInteger(2)+Utils.generateRandomString(2);
			accRec.BillingStreet = '1660 International Dr';
			accRec.BillingCity = 'Lisboa';
			accRec.BillingPostalCode = '22102';
			accRec.BillingCountry = 'portugal';
			accRec.AccountStatusInCRMOM__c = 'Active';
			accRec.Industry='Enterprise';
			accRec.Market__c='Market Europe';
			accRec.Country__c='Portugal';
			accRec.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CUSTOMER).getRecordTypeId();
			partnerAccList.add(accRec);
		}
		return partnerAccList;
	}

	public static List<Curriculum_Certification_Mapping__c> createCurriculumCertifMap(integer nbrRec)
	{	
		List<Curriculum_Certification_Mapping__c> ccmList = new List<Curriculum_Certification_Mapping__c>();
		for(integer i = 0; i < nbrRec; i++)
		{
			Curriculum_Certification_Mapping__c ccmRec = new Curriculum_Certification_Mapping__c();
			ccmRec.name = 'Test CCM -' + i + Utils.generateRandomInteger(2);
			ccmRec.Certification_Name__c = 'Test CCM -' + i + Utils.generateRandomInteger(2);
			ccmList.add(ccmRec);
		}
		return ccmList;
	}
	
	public static List<Certification_Matrix__c> createCertifMatrix(integer nbrRec, Id CurriculumCertifMapgId, String portfolio)
	{	
		List<Certification_Matrix__c> certifMatrixList = new List<Certification_Matrix__c>();
		for(integer i = 0; i < nbrRec; i++)
		{
			Certification_Matrix__c certifMatrixRec = new Certification_Matrix__c();
			certifMatrixRec.Certification_Number__c = CurriculumCertifMapgId;
			certifMatrixRec.Portfolio__c = portfolio;
			certifMatrixList.add(certifMatrixRec);
		}
		return certifMatrixList;
	}
	
	public static List<Certification__c> createCertification(integer nbrRec, Id contactId, Id certifMatrixId, Id accountId, Id approverUserId, String status)
	{	
		List<Certification__c> certifList = new List<Certification__c>();
		for(integer i = 0; i < nbrRec; i++)
		{
			Certification__c certRec = new Certification__c();
			certRec.Name__c = contactId;
			certRec.Certification_Matrix_Number__c = certifMatrixId;
			certRec.Partner__c = accountId;
			certRec.Certification_Status__c = status;
			certRec.ABA_Certification_Approver__c = approverUserId;
			certifList.add(certRec);
		}
		return certifList;
	}
	
	public static List<Partner_Company__c> createrPartnerCompany(integer nbrRec, Id accountId, String partnerType, String market, String countries)
	{	
		List<Partner_Company__c> partnerCompList = new List<Partner_Company__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Partner_Company__c pc1 = new Partner_Company__c();
			pc1.Partner_Name__c = accountId;
			pc1.Country_Headquarters__c = countries;
			pc1.Market__c = market;
			pc1.Partner_Type__c = partnerType;
			partnerCompList.add(pc1);
		}
		return partnerCompList;
	}
	
	public static List<Accreditation__c> createrAccreditation(integer nbrRec, Id accountId, Id accredRecTypeId)
	{   
		if(accredRecTypeId == null)
		{
			accredRecTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.ACCREDITATION_RECTYPE_GPP0).getRecordTypeId();
		}	
		List<Accreditation__c> accredList = new  List<Accreditation__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Accreditation__c accred = new Accreditation__c();
	 	accred.RecordTypeid = accredRecTypeId;
			accred.Partner__c = accountId;
			accredList.add(accred);
		}
		return accredList;
	}
	
	/*public static List<Co_Op_Invoice__c> createCoOpInvoice(integer nbrRec, Id coopClaimId, Id activityId)
	{   
		List<Co_Op_Invoice__c> invoiceList = new  List<Co_Op_Invoice__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Co_Op_Invoice__c invoice = new Co_Op_Invoice__c();
	invoice.Description__c = 'Invoice number ' + i;
	invoice.Claim__c = coopClaimId;
	invoice.Co_op_Activity__c = activityId;
			invoiceList.add(invoice);
		}
		return invoiceList;
	}
	 
	public static List<Co_Op_Invoice_Line_Item__c> createCoOpLineItem(integer nbrRec, Id invoiceId)
	{   
		List<Co_Op_Invoice_Line_Item__c> lineItemList = new  List<Co_Op_Invoice_Line_Item__c>();
		for(integer i = 0; i < nbrRec; i++)
		{ 
			Co_Op_Invoice_Line_Item__c lineItem = new Co_Op_Invoice_Line_Item__c();
	lineItem.Description__c = 'Line Item number ' + i;
			lineItem.Co_op_Invoice__c = invoiceId;
			lineItem.Amount__c = 100;
			lineItemList.add(lineItem);
		}
		return lineItemList;
	}
	
	public static List<Co_Op_Allocation__c> createCoOpAllocation(integer nbrRec, Id fundId)
	{	
		List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
		// List<Co_Op_Allocation__c> allocationList2 = new List<Co_Op_Allocation__c>();
		Co_Op_Allocation__c all = new Co_Op_Allocation__c();
		all.Fund_Id__c = fundId;
		all.Co_Op_Allocation_Amount__c = 400.00;
		all.Transfers_in_Amount__c = 100.00;
		all.Transfers_out_Amount__c = 50.00;
		all.Status__c = 'Active';
		all.CurrencyIsoCode='EUR';
		all.Allocation_Month__c='May';
		all.Allocation_Year__c='2020';
		allocationList.add(all);
		return allocationList;   
	}
	
	public static List<Claim__c> createCoOpClaim(integer nbrRec, Id partnerId, Id fundId, Id activityId)
	{	
		List<Claim__c> claimList = new List<Claim__c>();
		Claim__c claim = new Claim__c(Partner_Account__c = partnerId, Fund__c= fundId, Activity_Number__c = activityId, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100);
		claimList.add(claim);
		return claimList;   
	}*/

}
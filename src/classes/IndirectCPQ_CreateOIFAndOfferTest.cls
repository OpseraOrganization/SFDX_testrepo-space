@isTest
public class IndirectCPQ_CreateOIFAndOfferTest {

	 private static Id oppINDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	
/******************************
*Method Name: createOIFandOfferTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	public testmethod static void createOIFandOfferTest(){
		Set<Id> accId = new Set<Id>();
			Map<Id,Opportunity> upsellProposalToOppty = new Map<Id,Opportunity>();
			user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
			insert userCreation;
	 
			system.runAs(userCreation){
			Test.startTest();
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '3011234';
			accountCreation[1].AccountNumber = '3011235';
			database.insert(accountCreation);
			accId.add(accountCreation[0].Id);
			accId.add(accountCreation[1].Id);
	
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='1000068431';
			accLegalEntity.ParentId=accountCreation[0].ID;
			accLegalEntity.Default_Legal_Entity__c = True ;
			accLegalEntity.Active__c = true;
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_RECORD_TYPE).getRecordTypeId();
			database.insert(accLegalEntity);
			
	
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
	
			optyCreation[0].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[0].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[0].G2_Approval_Date__c = System.now();
			optyCreation[0].G3_Approval_Date__c = System.now();
			optyCreation[0].RecordTypeId=oppINDirectRecordTypeId;
			optyCreation[0].Account_Role__c = 'Alliance Partner';	
			optyCreation[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[0].Phase_Status__c ='Submitted for G3 Approval';
			optyCreation[0].End_Customer_LE__c = accLegalEntity.Id;  
	 
	  
			optyCreation[1].Apttus_Approval__Approval_Status__c = CSWXGlobalConstant.Approval_stage_approved;
			optyCreation[1].ApprovalStatusTechField__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[1].Approvals_Current_Status__c = CSWXGlobalConstant.Approved_G2;
			optyCreation[1].G2_Approval_Date__c = System.now();
			optyCreation[1].G3_Approval_Date__c = System.now();
			optyCreation[1].RecordTypeId=oppINDirectRecordTypeId;
			optyCreation[1].Account_Role__c = 'Alliance Partner';  
			optyCreation[1].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation[1].Phase_Status__c ='Submitted for G3 Approval';
			optyCreation[1].End_Customer_LE__c = accLegalEntity.Id;
			database.insert(optyCreation);
			Apttus_Approval__Approval_Request__c approvalData = new Apttus_Approval__Approval_Request__c();
			approvalData.Apttus_Approval__Related_Opportunity__c = optyCreation[0].id;   
			database.insert(approvalData);	
			
			system.debug('optyCreation[0]--->'+optyCreation[0]);
			system.debug('optyCreation[0].SWx_Upsell_Proposal__c]--->'+optyCreation[0].SWx_Upsell_Proposal__c);
			system.debug('optyCreation[0].RecordType.DeveloperName--->'+optyCreation[0].RecordType.DeveloperName);
			system.debug('optyCreation[0].StageName--->'+optyCreation[0].StageName);
	
			Product2 prod = new Product2();
			prod.Name = 'test';
			prod.ProductCode = 'IPROUTING';
			insert prod;
			
			Nokia_Financial_Calendar__c calendar = new Nokia_Financial_Calendar__c();
			calendar.name = '2019 - P03';
			calendar.End_Date__c =System.today();
			calendar.Start_Date__c=System.today().addmonths(2);
			calendar.Period_Number__c='12';
			insert calendar;
	 
			Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
			insert Aprocess;
			
	Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=CSWXGlobalConstant.G2_Approvals_New,Apttus_Approval__BusinessObjectId__c=optyCreation[0].id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
	insert processinstance;
	IndirectCPQ_CreateOIFAndOffer.createOIFandOffer(optyCreation);
	
	 IndirectCPQ_CreateOIFAndOffer job = new IndirectCPQ_CreateOIFAndOffer(optyCreation);
			ID jobID = System.enqueueJob(job);

			IndirectCPQ_CreateOIFAndOffer.UpdateApprovalHistoryData(optyCreation[0].Id);  
			Test.stopTest();
			} 
	}  
}
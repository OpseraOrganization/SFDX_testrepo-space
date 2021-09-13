/*******************************
Class Name: OpptyGateInfoControllerTest
Created by: Accenture
Description: 
Req.:  sales process
*******************************/
@isTest
public class OpptyGateInfoControllerTest {
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId();
	public static testmethod void getOpptyGateInfoTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];			 
		insert accountCreation;		   
		List<Opportunity> optyList = TestDataFactory.OpportunityCreation(5,accountCreation);
		optyList[0].RecordTypeId = inDirectRecordTypeId;
		optyList[0].Advanced_PO_Booking__c = true;
		
		optyList[1].RecordTypeId = inDirectRecordTypeId;
		optyList[1].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
		optyList[1].Advanced_PO_Booking__c = false;
		
		optyList[2].RecordTypeId = inDirectRecordTypeId;
		optyList[2].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
		optyList[2].Phase_Status__c = 'Submitted for G5 Approval' ; 
		optyList[2].Advanced_PO_Booking__c = false;
		
		optyList[3].RecordTypeId = inDirectRecordTypeId;
		optyList[3].StageName = GlobalConstants.HANDOVER_OPPTY;
		optyList[3].Phase_Status__c = 'Submitted for G6 Approval' ; 
		optyList[3].Advanced_PO_Booking__c = false;
		
		optyList[4].RecordTypeId = inDirectRecordTypeId;
		optyList[4].StageName = GlobalConstants.COMPLETED_OPPTY;
		optyList[4].Phase_Status__c = 'Closed' ; 
		optyList[4].Advanced_PO_Booking__c = false;
		
		insert optyList;
		OpptyGateInfoController.getOpptyGateInfo(optyList[0].id);
		OpptyGateInfoController.getOpptyGateInfo(optyList[1].id);
		OpptyGateInfoController.getOpptyGateInfo(optyList[2].id);
		OpptyGateInfoController.getOpptyGateInfo(optyList[3].id);
		OpptyGateInfoController.getOpptyGateInfo(optyList[4].id);
		OpptyGateInfoController.getOpptyGateInfo(null);
	}
	
	public static testmethod void getOpptyGateInfoCOSaleOpsTest()
	{
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			Sales_Role__c objsalesrole = new Sales_Role__c();
			objsalesrole.User__c = userCreation.Id;
			objsalesrole.Organisation__c = 'TEPS Market Unit GCHN';
			objsalesrole.Role_Code__c = 'NSND_KUS';
			objsalesrole.Role_Name__c = '5 - CO Market Sales Ops';
			objsalesrole.User__c = UserInfo.getUserId();
			
			insert objsalesrole;
			Account accountCreation = TestDataFactory.createAccount(1)[0];			 
			insert accountCreation;		   
			List<Opportunity> optyList = TestDataFactory.OpportunityCreation(5,accountCreation);
			optyList[0].RecordTypeId = inDirectRecordTypeId;
			optyList[0].Advanced_PO_Booking__c = true;
			
			optyList[1].RecordTypeId = inDirectRecordTypeId;
			optyList[1].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			optyList[1].Advanced_PO_Booking__c = false;
			
			optyList[2].RecordTypeId = inDirectRecordTypeId;
			optyList[2].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			optyList[2].Phase_Status__c = 'Submitted for G5 Approval' ; 
			optyList[2].Advanced_PO_Booking__c = false;
			
			optyList[3].RecordTypeId = inDirectRecordTypeId;
			optyList[3].StageName = GlobalConstants.HANDOVER_OPPTY;
			optyList[3].Phase_Status__c = 'Submitted for G6 Approval' ; 
			optyList[3].Advanced_PO_Booking__c = false;
			
			optyList[4].RecordTypeId = inDirectRecordTypeId;
			optyList[4].StageName = GlobalConstants.COMPLETED_OPPTY;
			optyList[4].Phase_Status__c = 'Closed' ; 
			optyList[4].Advanced_PO_Booking__c = false;
			
			insert optyList;
			OpptyGateInfoController.getOpptyGateInfo(optyList[0].id);
			OpptyGateInfoController.getOpptyGateInfo(optyList[1].id);
			OpptyGateInfoController.getOpptyGateInfo(optyList[2].id);
			OpptyGateInfoController.getOpptyGateInfo(optyList[3].id);
			OpptyGateInfoController.getOpptyGateInfo(optyList[4].id);
			OpptyGateInfoController.getOpptyGateInfo(null);
		}
	}
	
	public static testmethod void confirmPOBookingCtrlTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];			 
		insert accountCreation;		   
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.RecordTypeId = inDirectRecordTypeId;
		optyCreation.StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
		optyCreation.Phase_Status__c = 'Submitted for G5 Approval' ;
		optyCreation.PO_Reference__c = 'Test';
		insert optyCreation;
		OpptyGateInfoController.confirmPOBookingCtrl(optyCreation.PO_Reference__c, optyCreation.id);
		OpptyGateInfoController.confirmPOBookingCtrl(null, null);
	}
}
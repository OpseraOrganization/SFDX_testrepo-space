/*
 * This class is used to Test Apex class 'DS_Toast_Message_Apex'.
*/
@isTest
public class DS_Toast_Message_Apex_Test {
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId();
	public testmethod static void checkApprovalStageTest(){
		
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			Account acct = TestDataFactory.createAccount(1)[0];
			acct.AccountNumber='8990767834';  
			database.insert(acct);
			
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			
			Profile prof=[Select Id,Name from Profile where Name='Nokia Sales Profile'];
			
			User userAM = new User(alias = 'abc', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
		   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = prof.id ,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
		   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00');
			
			database.insert(userAM);
			System.debug('UserAM>>'+userAM);
			//PermissionSet ps = [SELECT ID From PermissionSet WHERE Label = 'SWX/CCRE Account manager'];
			//insert new PermissionSetAssignment(AssigneeId = userAM.id, PermissionSetId = ps.Id );
			
			SWx_Upsell_Proposal__c DigitalProposal = TestDataFactory.upsellList(1,acct)[0];
			DigitalProposal.Account_ID__c=acct.id;
			DigitalProposal.Analytics_Source__c='CXM';
			DigitalProposal.Upsell_Status__c='Draft';
			DigitalProposal.CurrencyIsoCode='INR';
			DigitalProposal.Sold_To_Party__c=acct.id;
			insert DigitalProposal; 
			system.debug('Digital Proposal----------->>>>>>'+DigitalProposal);
			Set <Id> dpSet = new set<Id>();
			dpSet.add(DigitalProposal.Id);
			
			
			CCRE_UpSell_LineItem__c ccreLineItem= new CCRE_UpSell_LineItem__c();
			ccreLineItem = TestDataFactory.createCCRELineItems(dpSet,1)[0];
			insert ccreLineItem;
			
			SWx_Upsell_Items__c swxLineItem= new SWx_Upsell_Items__c();
			swxLineItem = TestDataFactory.createSWXLineItems(dpSet,1)[0];
			insert swxLineItem;
			
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
			oppty.StageName = 'Develop Opportunity';//
			oppty.Phase_Status__c = 'Opportunity in Progress';
			oppty.Lead_BG__c = 'MN';
			oppty.SWx_Upsell_Proposal__c=DigitalProposal.id;
			//insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
			
			database.insert(oppty);
			system.debug('oppty----------->>>>>>'+oppty);
			
			Apttus_Proposal__Proposal__c quoteProposal= TestDataFactory.createProposal(1)[0];
			quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal.Apttus_Proposal__Approval_Stage__c='Draft';
	quoteProposal.Changed_Approval_Stage__c=True;
			quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
			quoteProposal.SWx_Upsell_Proposal__c=DigitalProposal.id;
			quoteProposal.Prices_Aligned__c = true;
			quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
			quoteProposal.Contract_Start_Date__c = system.today();
			system.debug('BeforeQuoTEpROPOSAL----------->>'+quoteProposal);
			database.insert(quoteProposal); 
			system.debug('QuoTEpROPOSAL----------->>'+quoteProposal);
			
			quoteProposal.Apttus_Proposal__Approval_Stage__c='In Review';
			//quoteProposal.Apttus_Proposal__Approval_Stage__c='Approved';
			quoteProposal.LOA_Status__c='G4 Submission';
			system.debug('beforeQuoTEpROPOSAL--->>'+quoteProposal);
			
			database.update(quoteProposal);
			system.debug('AfterQuoTEpROPOSAL---7706>>'+quoteProposal);
			
			/*quoteProposal.Apttus_Proposal__Approval_Stage__c='Approved';
			quoteProposal.LOA_Status__c='Approved'; 
			quoteProposal.Changed_Approval_Stage__c =True;
			// To fix the SeeAllData=True to false */
			
	//Throwing Process Builder error,Update Approval Stage from Quote to CFE
			//database.update(quoteProposal); 
			system.debug('FinalQuoTEpROPOSAL>>'+quoteProposal);
			//edited
			Apttus_Proposal__Proposal__Share objPropShare = new Apttus_Proposal__Proposal__Share();
		objPropShare.ParentId = quoteProposal.Id;
		objPropShare.UserOrGroupId = userAM.Id;
		objPropShare.AccessLevel = 'Edit';
		insert objPropShare;
		
			
			Test.startTest();  
			System.runAs(userAM){   
	DS_Toast_Message_Apex.checkApprovalStage(quoteProposal.id);  
			}
			Test.stopTest();
			
		} 
		
	}
}
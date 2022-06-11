/****************************************
* Name : APTS_CustomAgreementLCCallbackTestclass
*****************************************/
@isTest
public class APTS_CustomAgreementLCCallbackTestclass {
	public static final String OLD_BG = 'MN';
	public static final String NEW_BG = 'NI';
	
	@testSetup
	static void testSetup() {
		User u = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert u;
		System.runAs(u) {
			List<Account> accounts = TestDataFactory.createAccount(6);
			for(Integer i = 0; i < accounts.size(); i++) {
				accounts[i].AccountNumber = '301030999' + i;
			}
			accounts[5].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DS_legalEntity).getRecordTypeId();
			insert accounts;
			
			//OPPORTUNITIES
			List<Opportunity> opportunities = new List<Opportunity>();
			// direct Opportunity
			Opportunity o1 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o1.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o1.Lead_BG__c = OLD_BG;
			o1.Description = 'Test Description 1';
			o1.Amount = 111111;
			o1.End_Customer__c = accounts[1].Id;
			o1.Indirect_Reseller_Account__c = accounts[2].Id;
			o1.Account_Role__c = 'GPP Distributor Partner';
			o1.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			opportunities.add(o1);
			
			// indirect Opportunity
			Opportunity o2 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o2.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.INDIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o2.Lead_BG__c = 'MN';
			o2.Description = 'Test Description 2';
			o2.Amount = 222222;
			o2.End_Customer__c = accounts[3].Id;
			o2.Indirect_Reseller_Account__c = accounts[4].Id;
			o2.Account_Role__c = 'GPP Distributor Partner';
			o2.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			o2.End_Customer_LE__c = accounts[5].Id;
			opportunities.add(o2);
			insert opportunities;
		}
	}
	
	private static List<Apttus__APTS_Agreement__c> createAgreements(Account account, List<Opportunity> opportunities) {
		// AGREEMENTS
		List<Apttus__APTS_Agreement__c> agreements = new List<Apttus__APTS_Agreement__c>();
		for (Integer i = 0; i < opportunities.size(); i++) {
			Apttus__APTS_Agreement__c a = new Apttus__APTS_Agreement__c();
			a.Name = 'Test Agreement ' + (i+1);
			a.Apttus__Account__c = account.Id;
			a.CurrencyIsoCode = 'EUR';
			a.Delivery_System__c = 'Scratch Order via P20';
			a.ERP__c = 'P20';
			a.Sales_Mode__c = 'Corporate Sales Mode';
			a.Confidence_Level__c = 'Low Level';
			a.Lead_BG__c = 'MN';
			a.Apttus__Related_Opportunity__c = opportunities[i].Id;
			a.Apttus__Total_Contract_Value__c = opportunities[i].Amount;
			a.Apttus__Description__c = opportunities[i].Description;
			agreements.add(a);
		}
		return agreements;
	}
	
	static testMethod void APTS_CustomAgreementTestmethod(){
		APTS_CustomAgreementLifecycleCallback callback = new APTS_CustomAgreementLifecycleCallback();
		Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c();
		callback.afterTerminate(agreement);
		callback.afterCancel(agreement);
		callback.afterClone(agreement,agreement);
		callback.afterCreate(agreement);
		callback.afterCreateChild(agreement, agreement);
		callback.afterCreateExecuted(agreement);
		callback.afterCreateFromOpportunity(agreement);
		callback.afterCreateOffline(agreement);
		callback.afterExpire(agreement);
		
		Account account = [SELECT Id FROM Account LIMIT 1];
		List<Opportunity> opportunities = [SELECT Id, Lead_BG__c, Description, Amount, Account_Role__c, End_Customer__c FROM Opportunity];
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		agreements[0].ERP__c = 'P20';
		agreements[0].Confidence_Level__c = 'Low Level';
		agreements[1].ERP__c = 'Blue Planet';
		agreements[1].Confidence_Level__c = 'Low Level';
		insert agreements;
		
		agreements[0].CLM_Reference_Contract_Request__c = agreements[0].id;
		update agreements[0]; 
		system.assert(agreements.size()>0);
		callback.afterRenew(agreements[0], agreement);
		callback.afterAmend(agreements[0], agreement);
	}
}
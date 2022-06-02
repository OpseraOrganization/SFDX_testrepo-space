@isTest
public class DS_SWxItemTriggerHelperTest{

	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();

public testmethod static void updateEntitlementActiveQuantitytest(){
			List<Account> accountCreation = TestDataFactory.createAccount(1);
			database.insert(accountCreation);
			Account acc = new Account();
			acc.Name='Legal Entinty Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			acc.ParentId = accountCreation[0].Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);
		   
			List<product2> productObj = TestDataFactory.productCreation(2);
			productObj[0].ProductCode = 'Test';
			productObj[1].ProductCode = 'Test123';
			database.insert(productObj);
			
			Commercial_Entitlement__c  comEnt = new Commercial_Entitlement__c();
			comEnt.Product_Name__c=productObj[0].id;
			comEnt.Sold_To_Party__c=acc.id;
			comEnt.Consumed_Quantity__c=0;
			comEnt.Authorised_Quantity__c=9;  
			comEnt.Activated_Quantity__c=0;	 
			
			comEnt.Parent_Account__c=accountCreation[0].Id;
			database.insert(comEnt);
			
			List<SWx_Upsell_Proposal__c> upsellObjList = new List<SWx_Upsell_Proposal__c>();
			List<SWx_Upsell_Proposal__c> upsellObj = TestDataFactory.upsellList(3,accountCreation[0]);
			upsellObj[0].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[0].Ready_to_Convert__c = false;
			upsellObj[0].Account_ID__c = accountCreation[0].id;
			upsellObj[0].Sold_To_Party__c = acc.Id;
			upsellObj[0].Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource;
			upsellObj[0].RecordTypeId = swxRecordTypeId ; 
			upsellObj[1].Upsell_Status__c = CSWXGlobalConstant.readyForConversion;
			upsellObj[1].Ready_to_Convert__c = false;
			upsellObj[1].Account_ID__c = accountCreation[0].id;
			upsellObj[1].Sold_To_Party__c = acc.Id;
			upsellObj[1].Analytics_Source__c = 'CXM';
			 upsellObj[1].RecordTypeId = swxRecordTypeId ; 
			upsellObjList.add(upsellObj[0]);
			upsellObjList.add(upsellObj[1]);
			database.insert(upsellObjList);
			
		   
		
			List<SWx_Upsell_Items__c> insertItems = new List<SWx_Upsell_Items__c>();
			SWx_Upsell_Items__c upsellItem = TestDataFactory.createUpsellItem(1,upsellObj[0])[0];
			upsellItem.Bundle_ID__c = productObj[0].id;
			upsellItem.Sales_Item_Code__c = productObj[0].id;
			upsellItem.SWx_Upsell_Proposal__c = upsellObj[0].id;
			upsellItem.Commercial_Entitlement__c=comEnt.Id;
			upsellItem.Quantity__c=5;
			upsellItem.Entitlement_Status__c=CSWXGlobalConstant.Entitled;
			upsellItem.Status_In_Network__c=false;
			insertItems.add(upsellItem);
			database.insert(insertItems);
			
			upsellItem.Status_In_Network__c = true;
			
			update upsellItem;
		



}



}
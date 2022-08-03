/****************************************
 * Name : UpsellOppUtility_TEST 
 * Author : Accenture
 * Modified By: HCL Technologies  
 * Modified Date: 19-Jan-2021
 * Description : Test class for UpsellOppUtility
 *****************************************/
@isTest 
public class UpsellOppUtility_TEST
{   
	Private static User userObj = new User();
	Private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList; 
	Private static List<Account> accountList = new List<Account>();
	Private static List<Opportunity> opportunityList = new List<Opportunity>();
	Private static List<Offer__c> offerList = new List<Offer__c>();
	Private static Set<Id> parentOppIdSet = new Set<Id>();
	Private static Upsell_Container__c upsellContainerRec = new Upsell_Container__c();
	Private static Product2 productRec = new Product2();
	Private static Nokia_Financial_Calendar__c nokia_fin_Cal_Rec = new Nokia_Financial_Calendar__c();
	  
	 @isTest
	static void toCreateUpsellOpportunityTest()
	{
		userObj = TestDataFactory.userCreation(1, 'System Administrator')[0];	   
		database.insert(userObj);  
		System.assertNotEquals(userObj, Null);	  
		system.runAs(userObj)
		{
			//Insert an File_Sharing_Custom_Setting
			fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			Database.insert(fileSharingCustomSettingList);
			
			//Account Creation
			accountList = TestDataFactory.createAccount(1);	 
			Database.insert(accountList);
			
			//Opportunity Creation
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);   
			database.insert(opportunityList);
			Test.startTest();
			//Offer Creation 
			offerList = TestDataFactory.OfferCreation(1, opportunityList[0]);   
			offerList[0].ActiveOffer__c = true;
			database.insert(offerList);
			
			//Product Creation
			productRec.Name = 'Optics Optical M.S. Networks';
			//productRec.Business_Group__c = 'ION';
			productRec.Business_Group__c = 'MN';
			Database.insert(productRec);
			
			//Nokia_Financial_Calendar__c creation
			nokia_fin_Cal_Rec.End_Date__c = Date.today()+10;
			nokia_fin_Cal_Rec.Start_Date__c = Date.today();
			nokia_fin_Cal_Rec.Name = '2017- P01';
			nokia_fin_Cal_Rec.Period_Number__c = '1';
			Database.insert(nokia_fin_Cal_Rec);
			
			//Upsell Creation
			upsellContainerRec.Upsell_Opportunity_Type__c = GlobalConstants.COMMITTED_UPSELL;
			upsellContainerRec.Quarter1_Period_Value__c = 1747.96;
			upsellContainerRec.Quarter2_Period_Value__c = 1425235.0;
			upsellContainerRec.Quarter3_Period_Value__c = 4509.28;
			upsellContainerRec.Quarter4_Period_Value__c = 45061.9;
			upsellContainerRec.Quarter1_Period__c = '2017- P01';
			upsellContainerRec.Quarter2_Period__c = '2017- P04';
			upsellContainerRec.Quarter3_Period__c = '2017- P07';
			upsellContainerRec.Quarter4_Period__c = '2017- P10';
			upsellContainerRec.Quarter1_Reverse_Period__c = '2017- P03';
			upsellContainerRec.Quarter2_Reverse_Period__c = '2017- P06';
			upsellContainerRec.Quarter3_Reverse_Period__c = '2017- P09';
			upsellContainerRec.Quarter4_Reverse_Period__c = '2017- P12';
			upsellContainerRec.Upsell_Opportunity_Main_BG__c = 'ION';
			upsellContainerRec.Upsell_Opportunity_Main_BL__c = 'Optics Optical M.S. Networks';
			upsellContainerRec.Upsell_Opportunity_Main_BU__c = 'ION Optics';
			upsellContainerRec.Template_Identifier__c ='G4';
			upsellContainerRec.Parent_Offer__c = offerList[0].Id;
			upsellContainerRec.Parent_Opportunity__c = opportunityList[0].Id;
			upsellContainerRec.Upsell_Opportunity_Name__c = 'Com ups3 EUR - no ID';
			database.insert(upsellContainerRec);
			
			//Opportunity Update
			opportunityList[0].StageName = 'Win the Case (Negotiate)';		  
			opportunityList[0].Phase_Status__c = 'Pending Win/Loss Declaration';
			database.update(opportunityList);
		}
	}   
	
	//TEST METHOD FOR APEX CLASS: UpsellOppUtility
	@isTest
	static void toCreateUpsellOppUtility()
	{
		UpsellOppUtility.toCreateUpsellOpportunity(Null);
		UpsellOppUtility.upsellDealCreation(Null);
		UpsellOppUtility.groupOpptyCreation(Null);
		UpsellOppUtility.createUpsellOppty(Null,Null);  
		UpsellOppUtility.createUpsellOpptyRecord(Null,Null);
		UpsellOppUtility.updateUpsellContainerRec(Null,Null);
		UpsellOppUtility.createOIFforUpsellOpp(Null);
		UpsellOppUtility.returnConstructedOIFList(Null,Null,Null);  
		UpsellOppUtility.sendChatterToUpsellOppOwner(null, null, null, null);   
	}
	
	/******************************
	*Method Name: toCreateUpsellOpportunityTest
	*Description: Test Method to cover toCreateUpsellOpportunity Method
	********************************/
	@isTest
	static void toCheckUpsellOppUtility()
	{
		userObj = TestDataFactory.userCreation(1, 'System Administrator')[0];	   
		database.insert(userObj);  
		System.assertNotEquals(userObj, Null);	  
		system.runAs(userObj)
		{
			//Insert an File_Sharing_Custom_Setting
			fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>(); 
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			Database.insert(fileSharingCustomSettingList);
			
			//Account Creation
			accountList = TestDataFactory.createAccount(1);	 
			Database.insert(accountList);
			
			//Opportunity Creation
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);   
			database.insert(opportunityList);
			parentOppIdSet.add(opportunityList[0].Id);
			
			//Product Creation
			productRec.Name = 'Optics Optical M.S. Networks';
	 // productRec.Business_Group__c = 'ION';
			productRec.Business_Group__c = 'MN';
			Database.insert(productRec);
			
			//Nokia_Financial_Calendar__c creation
			nokia_fin_Cal_Rec.End_Date__c = Date.today()+10;
			nokia_fin_Cal_Rec.Start_Date__c = Date.today();
			nokia_fin_Cal_Rec.Name = '2017- P01';
			nokia_fin_Cal_Rec.Period_Number__c = '1';
			Database.insert(nokia_fin_Cal_Rec);
			
			//Upsell Creation
			upsellContainerRec.Upsell_Opportunity_Type__c = GlobalConstants.COMMITTED_UPSELL;
			upsellContainerRec.Quarter1_Period_Value__c = 1747.96;
			upsellContainerRec.Quarter2_Period_Value__c = 1425235.0;
			upsellContainerRec.Quarter3_Period_Value__c = 4509.28;
			upsellContainerRec.Quarter4_Period_Value__c = 45061.9;
			upsellContainerRec.Quarter1_Period__c = '2017- P01';
			upsellContainerRec.Quarter2_Period__c = '2017- P04';
			upsellContainerRec.Quarter3_Period__c = '2017- P07';
			upsellContainerRec.Quarter4_Period__c = '2017- P10';
			upsellContainerRec.Quarter1_Reverse_Period__c = '2017- P03';
			upsellContainerRec.Quarter2_Reverse_Period__c = '2017- P06';
			upsellContainerRec.Quarter3_Reverse_Period__c = '2017- P09';
			upsellContainerRec.Quarter4_Reverse_Period__c = '2017- P12';
			upsellContainerRec.Upsell_Opportunity_Main_BG__c = 'ION';
			upsellContainerRec.Upsell_Opportunity_Main_BL__c = 'Optics Optical M.S. Networks';
			upsellContainerRec.Upsell_Opportunity_Main_BU__c = 'ION Optics';
			upsellContainerRec.Template_Identifier__c ='G4';
			upsellContainerRec.Parent_Opportunity__c = opportunityList[0].Id;
			upsellContainerRec.Upsell_Opportunity_Name__c = 'Com ups3 EUR - no ID';
			database.insert(upsellContainerRec);
			
			//---------- CODE FOR UpsellOppUtility APEX CLASS -----------
			Test.startTest();
			
			UpsellOppUtility.toCreateUpsellOpportunity(parentOppIdSet);
			UpsellOppUtility.upsellDealCreation(parentOppIdSet);
			
			Map<Id,Id> mapOpptyDealID = new Map<Id,Id>();
			mapOpptyDealID.put(opportunityList[0].Id, opportunityList[0].Id);
			UpsellOppUtility.groupOpptyCreation(mapOpptyDealID);
			
			List<Upsell_Container__c> upsellContainerRecList = new List<Upsell_Container__c>();
			upsellContainerRecList.add(upsellContainerRec);
			UpsellOppUtility.createUpsellOppty(upsellContainerRecList, mapOpptyDealID);
			
			UpsellOppUtility.createOIFforUpsellOpp(upsellContainerRecList);
			
			UpsellOppUtility.updateUpsellContainerRec(opportunityList, parentOppIdSet);
			
			UpsellOppUtility.createOIFforUpsellOpp(upsellContainerRecList);
			
			Map<Id,String> upsellWithInvalidOppIdMap = new Map<Id,String>();
			upsellWithInvalidOppIdMap.put(upsellContainerRec.Id, upsellContainerRec.Upsell_Opportunity_Number__c);
			UpsellOppUtility.sendChatterToUpsellOppOwner(upsellContainerRecList, upsellWithInvalidOppIdMap, upsellWithInvalidOppIdMap, upsellWithInvalidOppIdMap);
	
			Test.stoptest();
		}
	} 
}
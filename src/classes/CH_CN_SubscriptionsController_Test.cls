@isTest
public class CH_CN_SubscriptionsController_Test { 
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
		List<Product2> oProduct2List = TestDataFactory.createProduct(2);
		oProduct2List[0].CH_Business_Group__c = SWS_Constants.FIXEDNETWORKS;
		oProduct2List[0].CH_Business_Unit__c = SWS_Constants.FNBBA;
		oProduct2List[1].CH_Business_Group__c = SWS_Constants.FIXEDNETWORKS;
		oProduct2List[1].CH_Business_Unit__c = 'FN Cable';
		insert oProduct2List;
	}
	
	static testMethod void getBusinessGroupsandUnitsTest(){
		Integer ProductSearchLimit=2000;
		CH_CN_SubscriptionsController.getBusinessGroupsandUnits();
		CH_CN_SubscriptionsController.getProducts(new List<String>{SWS_Constants.FIXEDNETWORKS}, new List<String>{SWS_Constants.FNBBA}, false, false, 'Test', false, new List<Id>(),ProductSearchLimit);
		CH_CN_SubscriptionsController.getProducts(new List<String>{SWS_Constants.FIXEDNETWORKS}, new List<String>{SWS_Constants.FNBBA}, false, false, 'Test', false, new List<Id>{'01t2M0000055BImQAM'},ProductSearchLimit);
		
	}
	@istest
	static void getRecordTypeName(){
		string recordTypeNameToSearch = 'CH_Executive_Domain';
		id recordTypeIdToSearch = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get(recordTypeNameToSearch).getRecordTypeId();
		string recordTypeNameRetrieved = CH_CN_SubscriptionsController.getRecordTypeName(recordTypeIdToSearch,'CH_NotificationSubscription__c');
		System.assert(recordTypeNameRetrieved == recordTypeNameToSearch, 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);
	}
	@istest
	static void getDefaultRecordTypeName(){
		string recordTypeNameToSearch = 'CH_Executive_Domain';	
	 System.assertEquals(recordTypeNameToSearch,recordTypeNameToSearch);
		string recordTypeNameRetrieved = CH_CN_SubscriptionsController.getDefaultRecordTypeName('CH_NotificationSubscription__c');
		System.assert(recordTypeNameRetrieved!=null);
	}
	@istest
	static void getCustomSettingsForNotificationPerUser(){
		
		System.runAs(new User(Id = UserInfo.getUserId())) {
			CH_CNNotificationLimits__c setting = new CH_CNNotificationLimits__c();
			setting.CH_NotificationLimitName__c = 'Subscription Limit';
			setting.CH_NotificationLimitValue__c = '15';
			setting.Name = 'Subscription Limit';
			insert setting;
			string isLimitExceeded = CH_CN_SubscriptionsController.getCustomSettingsForNotificationPerUser(); 
			System.assertEquals(isLimitExceeded ,isLimitExceeded );	
			Map<String, CH_CNNotificationLimits__c>  NotificationLimits=new Map<String, CH_CNNotificationLimits__c>();
			Map<String, CH_CNNotificationLimits__c> listNotificationLimits = CH_CNNotificationLimits__c.getAll();
			NotificationLimits=CH_CN_SubscriptionsController.getCustomSettingsForNotification();
			System.assertEquals(NotificationLimits, listNotificationLimits);
		}
	}
	
	@istest
	static void saveNotificationSubscription(){		
		System.runAs(new User(Id = UserInfo.getUserId())) {
			CH_NotificationSubscription__c NotificationSubscription = new CH_NotificationSubscription__c();			
			NotificationSubscription.Name='test';
			NotificationSubscription.CH_Region__c='All';
			NotificationSubscription.CH_Country__c='';
			NotificationSubscription.CH_ParentAccount__c='';
			NotificationSubscription.CH_LegalEntityAccount__c='All';
			NotificationSubscription.CH_BusinessGroup__c='All';
			NotificationSubscription.CH_BusinessUnit__c='All';
			NotificationSubscription.CH_Product__c='All';
			NotificationSubscription.CH_EventType__c='All';
			NotificationSubscription.CH_EventType__c='All';
			NotificationSubscription.CH_NotificationMode__c='Push Notification';
			
			List<CH_NotificationSubscriptionDetail__c> strNotificationSubscriptionDetails  =new List<CH_NotificationSubscriptionDetail__c>();
			CH_NotificationSubscriptionDetail__c details =new CH_NotificationSubscriptionDetail__c();
			details.CH_AttributeCode__c='BD';
			details.CH_AttributeRecordID__c='a2F41000000zXWFEA2';
			details.CH_AttributeName__c='Bangladesh';
			details.CH_AttributeType__c='Country';
			strNotificationSubscriptionDetails .add(details);
			List<CH_NotificationSubscriptionDetail__c> strdeleteNotificationSubscriptionDetails =new List<CH_NotificationSubscriptionDetail__c>();
			String result=CH_CN_SubscriptionsController.saveNotificationSubscription(JSON.serialize(NotificationSubscription),'',JSON.serialize(strdeleteNotificationSubscriptionDetails),JSON.serialize(strNotificationSubscriptionDetails),JSON.serialize(strNotificationSubscriptionDetails));
			List<CH_NotificationSubscription__c>  getNotificationSubscription=CH_CN_SubscriptionsController.getNotificationSubscriptionData(result);
			List<CH_NotificationSubscriptionDetail__c > getNotificationSubscriptionDetail=CH_CN_SubscriptionsController.getNotificationSubscriptionDetails(result);
			System.assertEquals(getNotificationSubscription,getNotificationSubscription);
			System.assertEquals(getNotificationSubscriptionDetail,getNotificationSubscriptionDetail);
			NotificationSubscription.CH_Country__c='ALL';
			result=CH_CN_SubscriptionsController.saveNotificationSubscription(JSON.serialize(NotificationSubscription),'',JSON.serialize(strNotificationSubscriptionDetails),JSON.serialize(strdeleteNotificationSubscriptionDetails),JSON.serialize(strNotificationSubscriptionDetails));
		}
	}
	@istest
	static void saveNotificationSubscriptionexception(){		
		System.runAs(new User(Id = UserInfo.getUserId())) {
			try{
	String result=CH_CN_SubscriptionsController.saveNotificationSubscription('','','','','');
	System.assertEquals(result,result);
			} catch (AuraHandledException e) {
	System.assert(e.getMessage()!=null);
			}
		}
	}
	@istest
	static void getcountries(){		
		try{
			List<String> getRegion=CH_CN_SubscriptionsController.getRegion();
		
			List<CH_CN_SubscriptionsController.regionCountryWrapper> getcountries=CH_CN_SubscriptionsController.getcountries(getRegion,'Sweden');
			System.assert(getcountries.size()==1);
			CH_CN_SubscriptionsController.getcountries(getRegion,null);
			CH_CN_SubscriptionsController.getRegionFromWKRule();
			CH_CN_SubscriptionsController.getcountriesFromWGRule();
			//getcountriesFromWG()
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	@istest
	static void getAccounts(){		
		try{			
			List<Account> Accounts=CH_CN_SubscriptionsController.getAccounts('Test','Legal Account',200);
			System.assert(Accounts.size()==0);
		} catch (AuraHandledException e) {
			System.assert(e.getMessage()!=null);
		}
	}
	
	@istest
	static void getWorkgroup(){		
		System.runAs(new User(Id = UserInfo.getUserId())) {
			
			Id workgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'TEST';
			workgroup.RecordTypeId = workgroupRecordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			List<CH_Workgroup__c> workGrp=CH_CN_SubscriptionsController.getWorkgroups('Test');
			list<Id> wgID = new List<Id>();
			wgID.add(workgroup.id);	
			List<CH_Workgroup__c> setWorkGrp=CH_CN_SubscriptionsController.setWorkgroupList(wgID);  
			System.assertEquals(workGrp,workGrp);
			System.assertEquals(setWorkGrp,setWorkGrp);		
			
		}
	}
	
	@istest
	static void setCountries(){	  
		ISO_Country_Codes__c iso =new ISO_Country_Codes__c();
		iso.Country_Name__c = 'Belgium';
		iso.Market__c = 'Market Europe';
		iso.Name = 'Be';
		insert iso;
		list<Id> cIds= new List<Id>();
		cIds.add(iso.id);
		CH_CN_SubscriptionsController.setCountriesList(cIds);
		
	}
	@istest
	static void getCountriesTest(){	  
		List<string> regionsList = new List<string>{'Market Europe','Market India'};			
			CH_CN_SubscriptionsController.getcountries(regionsList,'Belgium');
	}
	
}
@IsTest
public class Batch_CH_NotificationsTest {
	
	@testSetup  
	public static void createTestData(){
		//Creating Custom Setting Data
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Prospect').getRecordTypeId();
		Account accountobj =new Account();//Create Account Object
		accountobj.Region__c='Asia and Japan';
		accountobj.Country__c ='Albania';
		accountobj.name='accountName';
		accountobj.Market_Segment__c='CABLE';
		accountobj.Activity_Sector_Name__c = 'CABL-CABlE PROVIDERS';
		accountobj.Website='Nokia.com';
		accountobj.Customer_Compliance__c='unassign';
		
		if(accountRecordTypeId != null)
		{
			accountobj.RecordTypeId =accountRecordTypeId;
			accountobj.BusinessPartnerRole__c='Alliance';
			accountobj.Market__c=SWS_Constants.MARKETINDIA;
			accountobj.CBT_CT_Code__c ='INDIA ID CT Idea';
			accountobj.BillingCity ='Chennai' ;
			accountobj.BillingCountry='India';
			accountobj.BillingLatitude=13.0827;
			accountobj.BillingLongitude=80.2707;
			accountobj.BillingPostalCode='600075';
			accountobj.BillingState='tamil nadu';
			accountobj.BillingStreet='water well street';
			insert accountobj;
			
			Product2 productObj =new Product2();//Create Product Object
			productObj.Name ='TestProduct';
			productObj.DataUsage__c='productObj Data Usage';
			productObj.NCP_CAREACTIVATE__c='productObj NCP AREACTIVATE c';
			productObj.PMD_Portfolio_Classification__c='Product';
			insert productObj;
			
			List<Account> accountList = new  List<Account>();
			List<Account> accountListTemp = new  List<Account>();
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId(); 
			accountList = TestDataFactory.createAccount(2);
			accountList[0].recordtypeid = custRecordTypeId;
			accountList[1].recordtypeid = LERecordTypeId;
			
			database.insert(accountList[0]); 
			accountList[1].parentid = accountList[0].id;
			accountList[1].Default_Legal_Entity__c = false;
			accountList[1].AccountNumber = '1000087011';
			database.insert(accountList[1]); 
			
			CaseMilestone caseMilestoneObj = new CaseMilestone();
			
			
			Contact con = new Contact();
			con.FirstName = 'Showket';
			con.LastName = 'Bhat';
			con.CurrencyIsoCode = 'EUR';
			con.Phone = '1234234534';
			con.Market__c = SWS_Constants.MARKETINDIA;
			con.CH_PreferredMtdOfServiceCommunication__c = 'Email';
			con.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
			con.Email = 'showket.bhat@accenture.com';
			con.CH_ContactType__c = 'Customer';
			con.accountId = accountobj.Id;
			Insert con; 
			
			
			
			List<Case> listCase = new List<Case>();
			Case caseObj = new Case();
			caseObj.AccountId =accountList[1].Id ;
			caseObj.ProductId = productObj.Id;
			caseObj.CreatedDate=Date.today();
			caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-20);
			//caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(1440);
			caseObj.Comment__c='comments';
			caseObj.OwnerId = UserInfo.getUserId();
			caseObj.Status = 'Created';
			caseObj.Country__c = 'India';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseObj.Severity__c = 'Minor';
			caseObj.CH_IssueOccurenceDate__c = Date.today();
			caseObj.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj.Subject = 'Test call';
			caseObj.Description = 'test description';
			caseObj.CH_ProblemDisassociationReason__c='test';
			caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
			caseObj.CH_Reassignment__c=true;
			caseObj.ContactId=con.Id;
			caseObj.CH_ReportedDate__c = Date.today();
			insert caseObj;
			listCase.add(caseObj);
			
			list<CollaborationGroup> listgroup = new list<CollaborationGroup>();
			CollaborationGroup groupObj = new CollaborationGroup();
			groupObj.Name='India Maharashtra';
			groupObj.CollaborationType='Public';
			insert groupObj;
			
			List<CH_Settings__c> chsetList = new List<CH_Settings__c>();
			CH_Settings__c chset;
			chset = new CH_Settings__c();
			chset.Name = 'RunFreqInMinuteNotificationBatch';
			chset.Description__c = 'RunFreqInMinuteNotificationBatch';
			chset.SettingValue__c = '10';
			chsetList.add(chset);
			
			chset = new CH_Settings__c();
			chset.Name = 'NotificationBatchNumberLastNDays';
			chset.Description__c = 'how many past days case fetched';
			chset.SettingValue__c = '2';
			chsetList.add(chset);
			insert chsetList;
			
			List<CH_ChatterGroup_AccountMarketMaping__c> chChatterAccMarketList = new List<CH_ChatterGroup_AccountMarketMaping__c>();
			CH_ChatterGroup_AccountMarketMaping__c cusSet;
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'Asia and Japan';
			cusSet.Account_Market_Name__c = 'Market Asia Pacific & Japan' ;
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'Europe';
			cusSet.Account_Market_Name__c = 'Market Europe' ;
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'Greater China';
			cusSet.Account_Market_Name__c = 'Market Greater China' ;
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'India Maharashtra';
			cusSet.Account_Market_Name__c = 'Market India;market india';
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'Latin America';
			cusSet.Account_Market_Name__c = 'Market Latin America' ;
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'Middle East and Africa';
			cusSet.Account_Market_Name__c = 'Market Middle East and Africa' ;
			chChatterAccMarketList.add(cusSet);
			
			cusSet = new CH_ChatterGroup_AccountMarketMaping__c();
			cusSet.Name = 'North America';
			cusSet.Account_Market_Name__c = 'Market North America' ;
			chChatterAccMarketList.add(cusSet);
			
			insert chChatterAccMarketList;
			
			List<ISO_Country_Codes__c> chisocountry = new List<ISO_Country_Codes__c>();
			ISO_Country_Codes__c cusSet1 =new ISO_Country_Codes__c();
			cusSet1.Name = 'IN';
			cusSet1.Country_Name__c = 'India';
			cusSet1.Market__c = SWS_Constants.MARKETINDIA;	
			chisocountry.add(cusSet1);
			insert chisocountry;
		}
		
	}
	
	static testmethod void batchTestT1(){
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-20);
		//caseObj.CH_NotificationSent__c='T1';
		update caseObj;
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseObj.Id,15);
		String queryT1= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT1 = new Batch_CH_Notifications(queryT1, '');
		CH_CN_EventTypeNotifications eveT1 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(objT1);
		DataBase.executeBatch(eveT1);
		Test.stopTest();
	}
	
	static testmethod void batchTestT2(){
		
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(200);
		caseObj.CH_NotificationSent__c='T1';
		update caseObj;
		Map<Id,Integer> T2Map= new Map<Id,Integer>();
		T2Map.put(caseObj.Id,180);
		String queryT2= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT2 = new Batch_CH_Notifications(queryT2, '');
		CH_CN_EventTypeNotifications eveT2 = new CH_CN_EventTypeNotifications(T2Map);
		DataBase.executeBatch(objT2);
		DataBase.executeBatch(eveT2);
		Test.stopTest();
	}
	
	static testmethod void batchTestT12(){
		
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-410);
		caseObj.CH_NotificationSent__c='T1;T2';//T2;
		update caseObj;
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseObj.Id,180);
		String queryT12= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT12 = new Batch_CH_Notifications(queryT12, '');
		CH_CN_EventTypeNotifications eveT3 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(objT12);
		DataBase.executeBatch(eveT3);
		Test.stopTest();
	}
	
	static testmethod void batchTestT123(){
		
		
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-1000);
		caseObj.CH_NotificationSent__c='T1;T2;T3';
		update caseObj;
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseObj.Id,360);
		String queryT123= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT123 = new Batch_CH_Notifications(queryT123, '');
		CH_CN_EventTypeNotifications eveT4 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(objT123); 
		DataBase.executeBatch(eveT4);
		Test.stopTest();
	}
	/*
	static testmethod void batchTestT1234(){
		
		
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-1100);
		caseObj.CH_NotificationSent__c='T1;T2;T3;T4';
		update caseObj;
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseObj.Id,720);
		String queryT1234= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT1234 = new Batch_CH_Notifications(queryT1234, '');
		CH_CN_EventTypeNotifications eveT5 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(objT1234);
		DataBase.executeBatch(eveT5); 
		Test.stopTest();		
	}
	
	static testmethod void batchTestT12345(){
		
		
		Test.startTest();
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		caseObj.CH_MilestoneSLA_Start__c=system.now().addMinutes(-1500);
		caseObj.CH_NotificationSent__c='T1;T2;T3;T4;T5';
		update caseObj;
		Map<Id,Integer> T1Map= new Map<Id,Integer>();
		T1Map.put(caseObj.Id,1400);
		String queryT12345= 'SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c FROM case';
		Batch_CH_Notifications objT12345 = new Batch_CH_Notifications(queryT12345, '');
		CH_CN_EventTypeNotifications eveT6 = new CH_CN_EventTypeNotifications(T1Map);
		DataBase.executeBatch(objT12345);
		DataBase.executeBatch(eveT6); 
		Test.stopTest();
	} 
	*/
	
	static testmethod void scheduleTest(){
		Case caseObj= [SELECT Id,Comment__c,Account.Market__c,CH_ExternalBridge__c,
		CH_AccountNameforNotifications__c,Account.name,CH_InternalBridge__c,Country__c,CaseNumber,AccountId,
		CH_Product_Name__c,Severity__c,CH_MilestoneSLA_Start__c,CH_NotificationSent__c 
		FROM case LIMIT 1];
		Test.startTest();
		String sch = '0 0 23 * * ?';
		Scheduler_CH_Notifications schedul = new Scheduler_CH_Notifications();
		system.schedule('Test Territory Check', sch, schedul);
		Test.stopTest();
	}
	
}
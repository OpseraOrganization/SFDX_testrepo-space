/****************************************
* Name : EditSitePopControllerTest
* Author : Accenture
* Description : Test class for EditSitePopController
*****************************************/

@istest()
private class EditSitePopControllerTest{
	
	@testSetup 
	static void methodData() {
		Id sp = [SELECT Id FROM profile WHERE name =: 'System Administrator' limit 1].id;
		
		
		String orgId = UserInfo.getOrganizationId();
		
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = /* orgId + */ dateString + randomInt;
		list<user> listUser = new list<user>();
		User user1 = new User(alias = 'XYZW', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'qwerttest', lastname = 'asdfgtest',
							  languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',NSA_Compliant__c=False,
							  timezonesidkey = 'America/Los_Angeles',  Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		listUser.add(user1);
		User user2 = new User(alias = 'XYZ', email = uniqueName + '@nokia.com1' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'qwert', lastname = 'asdfg',
							  languagelocalekey = 'en_US', localesidkey = 'uk_UA', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',NSA_Compliant__c=False,
							  timezonesidkey = 'America/Los_Angeles',  Username = uniqueName + '@nokia.com1' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		listUser.add(user2);
		
		insert listUser;
		
	}
	
	static testmethod void EditSitePopControllerTest(){
		
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities1; 
		system.debug('Record type++++++++'+'--'+opportunities1[0].RecordTypeId);
		
		//Insert record for Site
		list<NokiaCPQ_Site__c> listSite = new list<NokiaCPQ_Site__c>();
		NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
		site.name = 'Test';
		site.Opportunity__c = opportunities1[0].id;
		site.NokiaCPQ_Address__c = 'Test Description';
		listSite.add(site);
		insert listSite;
		
		//Create PriceList
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		//Create Proposals
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].isCQ__c=false;
		proposals[0].NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING; //MN airscale wifi portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();//direct draft quote
		insert proposals;		
		system.debug('quote type++++++++'+proposals[0].Quote_Type__c +'--'+proposals[0].RecordTypeId);
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Quote_Type__c='Direct CPQ'
			
		);
		insert ProdConfig;
		
		system.debug('record type++++++++'+ProdConfig.NokiaCPQ_Quote_Type__c );  
		
		List<Product2> prodList = new List<Product2>(); 
		
		//Creating a Product prod1
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '1231', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 1.00,
			
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			IsActive = true); 
		
		prodList.add(prod1);
		
		//Creating a product prod2
		Product2 prod2 = new product2(
			Name = 'Test2', 
			ProductCode = '1232', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 2.00,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			IsActive = true); 
		
		prodList.add(prod2);
		
		//Creating a product prod3
		Product2 prod3 = new product2(
			Name = 'Test3', 
			ProductCode = '1233', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 3.00,
			//Apttus_Config2__ConfigurationType__c = 'Standalone',
			IsActive = true); 
		
		prodList.add(prod3);
		
		//Creating a product prod4
		Product2 prod4 = new product2(
			Name = 'Test4', 
			ProductCode = '1234', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Fixed Access - FBA',
			Apttus_Config2__Version__c = 4.00,
			//Apttus_Config2__ConfigurationType__c = 'Standalone',
			IsActive = true); 
		
		prodList.add(prod4);
		
		//inserting the products created above
		insert prodList;  
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prodList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		
		insert plistItems;
		
		Test.startTest();
		
		//Product2 productTest2 = new Product2();
		//productTest2 = [select Id, Apttus_Config2__Version__c from Product2 where Id=:prod1.Id];
		
		prodList[0].Apttus_Config2__Version__c =11.10;
		update prodList[0];
		
		//Insert Line Item record
		
		List<Apttus_Config2__LineItem__c> li = NOKIA_CPQ_TestDataFactory.createLineItem(1);//[select Id,Apttus_Config2__LineType__c,Apttus_Config2__NetPrice__c,NokiaCPQ_Is_SI__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__ExtendedPrice__c,NokiaCPQ_Extended_Partner_Price__c,NokiaCPQ_ExtendedPrice_CNP__c from Apttus_Config2__LineItem__c where (NokiaCPQ_Extended_Partner_Price__c!=null OR NokiaCPQ_Extended_Partner_Price__c!=0) AND NokiaCPQ_Opportunity_Site__c!=null limit 1];
		li[0].Apttus_Config2__ExtendedPrice__c =111.50;
		li[0].Apttus_Config2__ExtendedQuantity__c=1052.23;
		li[0].Apttus_Config2__NetPrice__c=10.000;
		li[0].Apttus_Config2__Quantity__c=5;
		li[0].Apttus_Config2__ProductId__c= prodList[0].id; 
		li[0].Apttus_Config2__LineType__c='Option';
		li[0].Apttus_Config2__GroupAdjustmentPercent__c=10.000;
		li[0].NokiaCPQ_Extended_CUP__c=.000;
		li[0].NokiaCPQ_Extended_CNP__c=.000;	
		li[0].Apttus_Config2__ConfigurationId__c=ProdConfig.id;
		li[0].NokiaCPQ_Opportunity_Site__c = listSite[0].id;
		li[0].Apttus_Config2__LineSequence__c = 1;
		li[0].Apttus_Config2__LineStatus__c='New';
		li[0].Apttus_Config2__PriceListId__c = ApttusTestPriceList.id;
		li[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		li[0].Apttus_Config2__PriceListItemId__c = plistItems[0].id;
		li[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		li[0].Apttus_Config2__Frequency__c = 'One Time';
		li[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		li[0].Apttus_Config2__ListPrice__c = 200;
		li[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		li[0].Apttus_Config2__AddedBy__c = 'added by code';
		insert li;
		//update li[0];
		
		list<Apttus_Config2__LineItem__c> lineItem = new list<Apttus_Config2__LineItem__c>([select Id,Apttus_Config2__LineType__c,Apttus_Config2__NetPrice__c,NokiaCPQ_Is_SI__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__ExtendedPrice__c,NokiaCPQ_Extended_Partner_Price__c,NokiaCPQ_ExtendedPrice_CNP__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__c,Apttus_Config2__GroupAdjustmentPercent__c,NokiaCPQ_Extended_CUP__c,NokiaCPQ_Extended_CNP__c,Apttus_Config2__ConfigurationId__c,NokiaCPQ_Opportunity_Site__c,Apttus_Config2__LineSequence__c,Apttus_Config2__LineStatus__c,Apttus_Config2__PriceListId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__ListPrice__c,Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__AddedBy__c,Quote_Type__c from Apttus_Config2__LineItem__c where id=:li[0].id limit 1]);
		
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
		insert PA1; 
		//EditSitePopController espc = new EditSitePopController();
		//espc.currentRecordId = proposals[0].Id;
		//EditSitePopController.assignSitesToOptions(li);
		
		//	EditSitePopController.updateAssociatSite('','-1');
		list<user> listUser = new list<user>([select id,localesidkey from user where firstName =:'qwert' AND lastname =:'asdfg' Limit 1]);
		system.runAs(listUser[0]){
			EditSitePopController objjj = new EditSitePopController();
			objjj.currentRecordId = proposals[0].Id;
			objjj.opportunityId = opportunities1[0].id;
			EditSitePopController.assignSitesToOptions(li);
			objjj.getSiteWrapperList();
			objjj.getSiteWrapper();
			//objjj.getLineItem();
			objjj.getSitesOptions();
			//objjj.updateAssociatSite('test','-1');
			
			
			EditSitePopController.LineItemSiteWrapper empW = new EditSitePopController.LineItemSiteWrapper(false,lineItem[0]);
			
			EditSitePopController.OptionItem op=new EditSitePopController.OptionItem('-None-','-1');
			
			EditSitePopController controller = new EditSitePopController();
			controller.selectedSite = 'Pune';
			//EditSitePopController.updateAssociatSite('test1,test2,test3', '-1');
			
			/* List<OptionItem> sitesOptions = new List<OptionItem>();
			sitesOptions.add(new OptionItem('-None-','-1')); 

			controller.optionItemList = sitesOptions;  */
			Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
			PageReference pageRef = controller.prepareSiteWrapper();
			//li[0].Apttus_Config2__ExtendedPrice__c =.0;
			//update li;
		}
		list<user> listUser1 = new list<user>([select id,localesidkey from user where firstName =:'qwerttest' AND lastname =:'asdfgtest' Limit 1]);
		system.runAs(listUser1[0]){
			EditSitePopController objjj = new EditSitePopController();
			objjj.currentRecordId = proposals[0].Id;
			objjj.opportunityId = opportunities1[0].id;
			EditSitePopController.assignSitesToOptions(li);
			objjj.getSiteWrapperList();
			objjj.getSiteWrapper();
			//objjj.getLineItem();
			objjj.getSitesOptions();
			//objjj.updateAssociatSite('test','-1');
			
			
			EditSitePopController.LineItemSiteWrapper empW = new EditSitePopController.LineItemSiteWrapper(false,lineItem[0]);
			
			EditSitePopController.OptionItem op=new EditSitePopController.OptionItem('-None-','-1');
			
			EditSitePopController controller = new EditSitePopController();
			controller.selectedSite = 'Pune';
			//EditSitePopController.updateAssociatSite('2', '-1');
			
			/* List<OptionItem> sitesOptions = new List<OptionItem>();
			sitesOptions.add(new OptionItem('-None-','-1')); 

			controller.optionItemList = sitesOptions;  */
			Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
			PageReference pageRef = controller.prepareSiteWrapper();
			//li[0].Apttus_Config2__ExtendedPrice__c =.0;
			//update li;
		}
		Test.stopTest();
		
		
	}
	
	static testmethod void EditSitePopControllerTest1(){
		Id sp = [SELECT Id FROM profile WHERE name =: 'System Administrator' limit 1].id;
		
		
		String orgId = UserInfo.getOrganizationId();
		
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = /* orgId + */ dateString + randomInt;
		User user2 = new User(alias = 'XYZ', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'qwert', lastname = 'asdfg',
							  languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',NSA_Compliant__c=False,
							  timezonesidkey = 'America/Los_Angeles',  Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		insert user2;
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities1; 
		system.debug('Record type++++++++'+'--'+opportunities1[0].RecordTypeId);
		
		//Insert record for Site
		list<NokiaCPQ_Site__c> listSite = new list<NokiaCPQ_Site__c>();
		NokiaCPQ_Site__c site = new NokiaCPQ_Site__c();
		site.name = 'Test';
		site.Opportunity__c = opportunities1[0].id;
		site.NokiaCPQ_Address__c = 'Test Description';
		listSite.add(site);
		insert listSite;
		
		//Create PriceList
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		//Create Proposals
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		proposals[0].isCQ__c=false;
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //IP Routing portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();//direct draft quote
		insert proposals;		
		system.debug('quote type++++++++'+proposals[0].Quote_Type__c +'--'+proposals[0].RecordTypeId);
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Quote_Type__c='Direct CPQ'
			
		);
		insert ProdConfig;
		
		system.debug('record type++++++++'+ProdConfig.NokiaCPQ_Quote_Type__c );  
		
		List<Product2> prodList = new List<Product2>(); 
		
		//Creating a Product prod1
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '1231', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 1.00,
			
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			IsActive = true); 
		
		prodList.add(prod1);
		
		//Creating a product prod2
		Product2 prod2 = new product2(
			Name = 'Test2', 
			ProductCode = '1232', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 2.00,
			Apttus_Config2__ConfigurationType__c = 'Bundle',
			IsActive = true); 
		
		prodList.add(prod2);
		
		//Creating a product prod3
		Product2 prod3 = new product2(
			Name = 'Test3', 
			ProductCode = '1233', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			Apttus_Config2__Version__c = 3.00,
			//Apttus_Config2__ConfigurationType__c = 'Standalone',
			IsActive = true); 
		
		prodList.add(prod3);
		
		//Creating a product prod4
		Product2 prod4 = new product2(
			Name = 'Test4', 
			ProductCode = '1234', 
			Business_Group__c = 'NSW', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Fixed Access - FBA',
			Apttus_Config2__Version__c = 4.00,
			//Apttus_Config2__ConfigurationType__c = 'Standalone',
			IsActive = true); 
		
		prodList.add(prod4);
		
		//inserting the products created above
		insert prodList;  
		
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prodList[0].Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		
		insert plistItems;
		
		Test.startTest();
		
		//Product2 productTest2 = new Product2();
		//productTest2 = [select Id, Apttus_Config2__Version__c from Product2 where Id=:prod1.Id];
		
		prodList[0].Apttus_Config2__Version__c =11.10;
		update prodList[0];
		
		//Insert Line Item record
		
		List<Apttus_Config2__LineItem__c> li = NOKIA_CPQ_TestDataFactory.createLineItem(1);//[select Id,Apttus_Config2__LineType__c,Apttus_Config2__NetPrice__c,NokiaCPQ_Is_SI__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__ExtendedPrice__c,NokiaCPQ_Extended_Partner_Price__c,NokiaCPQ_ExtendedPrice_CNP__c from Apttus_Config2__LineItem__c where (NokiaCPQ_Extended_Partner_Price__c!=null OR NokiaCPQ_Extended_Partner_Price__c!=0) AND NokiaCPQ_Opportunity_Site__c!=null limit 1];
		li[0].Apttus_Config2__ExtendedPrice__c =111.50;
		li[0].Apttus_Config2__ExtendedQuantity__c=1052.23;
		li[0].Apttus_Config2__NetPrice__c=10.000;
		li[0].Apttus_Config2__Quantity__c=5;
		li[0].Apttus_Config2__ProductId__c= prodList[0].id; 
		li[0].Apttus_Config2__LineType__c='Option';
		li[0].Apttus_Config2__GroupAdjustmentPercent__c=10.000;
		li[0].NokiaCPQ_Extended_CUP__c=.000;
		li[0].NokiaCPQ_Extended_CNP__c=.000;	
		li[0].Apttus_Config2__ConfigurationId__c=ProdConfig.id;
		li[0].NokiaCPQ_Opportunity_Site__c = listSite[0].id;
		li[0].Apttus_Config2__LineSequence__c = 1;
		li[0].Apttus_Config2__LineStatus__c='New';
		li[0].Apttus_Config2__PriceListId__c = ApttusTestPriceList.id;
		li[0].Apttus_Config2__ChargeType__c = 'Standard Price';
		li[0].Apttus_Config2__PriceListItemId__c = plistItems[0].id;
		li[0].Apttus_Config2__PriceMethod__c = 'Per Unit';
		li[0].Apttus_Config2__Frequency__c = 'One Time';
		li[0].Apttus_Config2__AdjustmentAmount__c = 100.00;
		li[0].Apttus_Config2__ListPrice__c = 200;
		li[0].Apttus_Config2__PrimaryLineNumber__c = 1;
		li[0].Apttus_Config2__AddedBy__c = 'added by code';
		insert li;
		//update li[0];
		
		list<Apttus_Config2__LineItem__c> lineItem = new list<Apttus_Config2__LineItem__c>([select Id,Apttus_Config2__LineType__c,Apttus_Config2__NetPrice__c,NokiaCPQ_Is_SI__c,Apttus_Config2__ExtendedQuantity__c,Apttus_Config2__ExtendedPrice__c,NokiaCPQ_Extended_Partner_Price__c,NokiaCPQ_ExtendedPrice_CNP__c,Apttus_Config2__Quantity__c,Apttus_Config2__ProductId__c,Apttus_Config2__GroupAdjustmentPercent__c,NokiaCPQ_Extended_CUP__c,NokiaCPQ_Extended_CNP__c,Apttus_Config2__ConfigurationId__c,NokiaCPQ_Opportunity_Site__c,Apttus_Config2__LineSequence__c,Apttus_Config2__LineStatus__c,Apttus_Config2__PriceListId__c,Apttus_Config2__ChargeType__c,Apttus_Config2__PriceListItemId__c,Apttus_Config2__PriceMethod__c,Apttus_Config2__Frequency__c,Apttus_Config2__AdjustmentAmount__c,Apttus_Config2__ListPrice__c,Apttus_Config2__PrimaryLineNumber__c,Apttus_Config2__AddedBy__c,Quote_Type__c from Apttus_Config2__LineItem__c where id=:li[0].id limit 1]);
		
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
		insert PA1; 
		//EditSitePopController espc = new EditSitePopController();
		//espc.currentRecordId = proposals[0].Id;
		//EditSitePopController.assignSitesToOptions(li);
		
		//	EditSitePopController.updateAssociatSite('','-1');
		list<user> listUser = new list<user>([select id,localesidkey from user where firstName =:'qwert' AND lastname =:'asdfg' Limit 1]);
		system.runAs(listUser[0]){
			EditSitePopController objjj = new EditSitePopController();
			objjj.currentRecordId = proposals[0].Id;
			objjj.opportunityId = opportunities1[0].id;
			EditSitePopController.assignSitesToOptions(li);
			objjj.getSiteWrapperList();
			objjj.getSiteWrapper();
			//objjj.getLineItem();
			objjj.getSitesOptions();
			//objjj.updateAssociatSite('test','-1');
			
			
			EditSitePopController.LineItemSiteWrapper empW = new EditSitePopController.LineItemSiteWrapper(false,lineItem[0]);
			
			EditSitePopController.OptionItem op=new EditSitePopController.OptionItem('-None-','-1');
			
			EditSitePopController controller = new EditSitePopController();
			controller.selectedSite = 'Pune';
			//  EditSitePopController.updateAssociatSite('', '-1');
			
			/* List<OptionItem> sitesOptions = new List<OptionItem>();
			sitesOptions.add(new OptionItem('-None-','-1')); 

			controller.optionItemList = sitesOptions;  */
			Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
			PageReference pageRef = controller.prepareSiteWrapper();
			li[0].Apttus_Config2__ExtendedPrice__c =.0;
			update li;
		}
		
		list<user> listUser1 = new list<user>([select id,localesidkey from user where firstName =:'qwerttest' AND lastname =:'asdfgtest' Limit 1]);
		system.runAs(listUser1[0]){
			EditSitePopController objjj = new EditSitePopController();
			objjj.currentRecordId = proposals[0].Id;
			objjj.opportunityId = opportunities1[0].id;
			EditSitePopController.assignSitesToOptions(li);
			objjj.getSiteWrapperList();
			objjj.getSiteWrapper();
			//objjj.getLineItem();
			objjj.getSitesOptions();
			//objjj.updateAssociatSite('test','-1');
			
			
			EditSitePopController.LineItemSiteWrapper empW = new EditSitePopController.LineItemSiteWrapper(false,lineItem[0]);
			
			EditSitePopController.OptionItem op=new EditSitePopController.OptionItem('-None-','-1');
			
			EditSitePopController controller = new EditSitePopController();
			controller.selectedSite = 'Pune';
			//  EditSitePopController.updateAssociatSite('', '-1');
			
			/* List<OptionItem> sitesOptions = new List<OptionItem>();
			sitesOptions.add(new OptionItem('-None-','-1')); 

			controller.optionItemList = sitesOptions;  */
			Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
			PageReference pageRef = controller.prepareSiteWrapper();
			li[0].Apttus_Config2__ExtendedPrice__c =.0;
			update li;
		}
		Test.stopTest();
		
		
	}
	
	static testmethod void prepareSiteWrapperTest(){
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities1; 
		test.startTest();
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true
		); 
		prods.add(prod1);
		//Create PriceList
		
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		//Create Proposals
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'MN GS TSS Basic';
		proposals[0].NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING; //MN airscale wifi portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();//direct draft quote
		insert proposals;		
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'Saved', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Quote_Type__c='Direct CPQ'
			
		);
		insert ProdConfig;
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI1);
		
		//Create Line items 
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__ExtendedPrice__c=120,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		// allLineItems.add(LineItem1);
		insert LineItem1;
		PageReference pageRef = Page.SitePop;
		Test.setCurrentPage(pageRef);
		pageRef.getParameters().put('id',opportunities1[0].id);
		EditSitePopController controller = new EditSitePopController();
		controller.selectedSite = 'Pune';
		PageReference ObjpageRef = controller.prepareSiteWrapper();
		
		//Test.setCurrentPage(pageRef);
		//pageRef.getParameters().put('id',currentRecordId);
		System.assertNotEquals(null,pageRef);
		controller.getSiteWrapper();
		controller.getSiteWrapperList();
		//	 EditSitePopController.LineItemSiteWrapper(true,LineItem1);
		test.stopTest();
		
	}
	
	
}
//Test Class for BusinessPlanning Batch
@IsTest
public class BusinessPlanningBatchTest 
{
	 //create Test Data  
	
	@TestSetup
	static void createTestData()
	{   
		  /*  NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
		*/
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			List<User> userList = new List<User>();
		String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
		User userPSM = new User(alias = 'bppsm', Nokia_ID__c = randomInt + '0',email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', 
										lastname = 'Testing',
									 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential');
			
			userList.add(userPSM);
			Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
			accountCreationPRM.Partner_Type__c = 'Distributor'; 
			Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
			accountCreationPSM.Partner_Type__c = 'Value Added Reseller'; 
			List<Account> accountList = new List<Account>();
			accountList.add(accountCreationPRM);
			accountList.add(accountCreationPSM);
			database.insert(accountList);
						
			Contact conPRM = new Contact(Job_Function__c ='Executive Management',lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
			database.insert(conPRM);
			
			User userPRM = new User(alias = 'bpprm', Nokia_ID__c = randomInt + '0', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
									 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
									 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
			
			userList.add(userPRM);
			database.insert(userList);
			List<Account_Member__c> acMemberList = new List<Account_Member__c>();
			Account_Member__c member1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Relationship Manager', 
												Type__c = 'External', Name__c = userPRM.Id);
			Account_Member__c member2 = new Account_Member__c(Account__c = accountCreationPSM.Id, Account_Role__c = 'Partner Sales Manager', 
											Type__c = 'Internal', Name__c = userPSM.Id);
			acMemberList.add(member1);
			acMemberList.add(member2);
			database.insert(acMemberList);
			String currentYearStr = String.valueOf(System.Today().year());
			List<Business_Plan__c> BPList= new List<Business_Plan__c>();
			Business_Plan__c businessPlan1= new Business_Plan__c(Account_BP__c=accountCreationPRM.id,Year__c =currentYearStr, Primary_Partner_Program_Contact_s_PRM__c = userPRM.Id,
																 Nokia_Partner_Primary_Partner__c = userPSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
																 Executive_Sponsor_Partner__c=conPRM.Id,Nokia_Product_Portfolio_represented__c='Optics',
																 Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='< 5M',
																 Do_you_measure_Customer_Satisfaction__c='No',															 
																 Expected_YY_Growth_by_ION__c='<10%',
																 Expected_YY_Growth_by_FN__c='<10%',
																 Expected_YY_Growth_by_MN__c='<10%',
																 Expected_YY_Growth_by_A_A__c='<10%',
																 Expected_YY_Growth_by_GS__c='<10%',
																 Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
																 Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other');
		
			BPList.add(businessPlan1);
			insert BPList;
		}
	}
	
	private static testMethod void businessPlanningNotificationTest() 
	{
		database.executeBatch(new BusinessPlanningBatch('BPN'));
	}
  
	
	private static testMethod void businessPlanningReminder()
	{
		database.executeBatch(new BusinessPlanningBatch('BPR'));
	}
		
	
	@IsTest
	static void testSchedular()
	{
	
		Test.StartTest();
		BusinessPlanningScheduler bpscheduler = new BusinessPlanningScheduler('BPN');
		String bps='0 0 23 * * ?';
		system.schedule('Test Business plan', bps, bpscheduler);
		Test.stopTest(); 
	}


		

}
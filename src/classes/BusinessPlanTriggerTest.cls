//Test Class for BusinessPlan Triggers
@isTest
public class BusinessPlanTriggerTest 
{
	
	@testSetup static void testDataCreation()
	{   
		/*NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
cs.Name = 'Default';
cs.Customer_Account__c = 'Customer - test';
cs.Customer_Account_Number__c = '12345';
cs.Customer_User_Profile__c = 'Customers';
insert cs;	*/	  
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
			accountCreationPRM.AccountNumber = '1234'; 
			Account accountCreationPSM = TestDataFactory.createAccount(1)[0];
			accountCreationPSM.AccountNumber = '12345'; 
	accountCreationPSM.Partner_Type__c='Value Added Reseller';
			accountCreationPSM.Partner_Program__c ='GPP 3.0';
			List<Account> accountList = new List<Account>();
			accountList.add(accountCreationPRM);
			accountList.add(accountCreationPSM);
			database.insert(accountList);
			
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			Contact conPSM = new Contact(Job_Function__c ='Executive Management',lastName=PRMGlobalConstants.ContactNamePSM,AccountId=accountCreationPSM.id,Email=PRMGlobalConstants.EmailContactNamePSM);
			database.insert(conPSM);
			
			User userPRM = new User(alias = 'bpprm', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org', Restriction_Level__c = 'Confidential', ContactId  = conPSM.Id);
			User managerUser = new User(alias = 'manager', email = 'managerEmail' + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id, Country__c= 'Canada', Market__c='MARKET NORTH AMERICA', timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'ab' + '@nokia.com' + orgId + '.org', Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			insert managerUser;
			User userPSM = new User(alias = 'bppsm', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id, Country__c= 'Canada', Market__c='MARKET NORTH AMERICA', timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org', Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			userPSM.ManagerID = managerUser.id;
			List<User> userList = new List<User>();
			userList.add(userPRM);
			userList.add(userPSM);
			insert userList;
		}
	}
	
	@isTest
	private static void approvalION()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c b1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Service',
			   FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='Enter Service',
			   GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='Enter Service',
			   ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='Enter Service',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Enter Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b1);
		Business_Plan__c b2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='dd',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b2);
		Business_Plan__c b3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100,Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='Enter Service',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b3);
		Business_Plan__c b4 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100,Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='Enter Service',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b4);
		Business_Plan__c b5 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='Enter Service',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b5);
		Business_Plan__c b6 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='Enter Service',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b6);
		Business_Plan__c b7 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='dd',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b7);
		Business_Plan__c b8 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_Amount_ION_Services_Revenue__c = 100,
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='Enter',ION_service_s_you_intend_to_sell__c='dd',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b8);
		Business_Plan__c b9 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b9);
		Business_Plan__c b10 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				Do_you_measure_Customer_Satisfaction__c='No',
				Expected_YY_Growth_by_FN__c='<10%',
				Expected_YY_Growth_by_MN__c='<10%',
				Expected_YY_Growth_by_A_A__c='<10%',
				Expected_YY_Growth_by_GS__c='<10%',
				Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
				Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
				Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
				Expected_Amount_ION_Services_Revenue__c=100,
				Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
				A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
				FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
				GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
				ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='aa',
				MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
				Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			   );
		BPList.add(b10);
		Business_Plan__c b11 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				Do_you_measure_Customer_Satisfaction__c='No',
				Expected_YY_Growth_by_FN__c='<10%',
				Expected_YY_Growth_by_MN__c='<10%',
				Expected_YY_Growth_by_A_A__c='<10%',
				Expected_YY_Growth_by_GS__c='<10%',
				Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
				Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
				Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
				Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
				A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
				FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
				GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
				ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='aa',
				MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
				Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			   );
		BPList.add(b11);
		database.insert(BPList);
		b1.Business_Plan_Status__c = 'Submitted';
		b2.Business_Plan_Status__c = 'Submitted';
		b3.Business_Plan_Status__c = 'Submitted';
		b4.Business_Plan_Status__c = 'Submitted';
		b5.Business_Plan_Status__c = 'Submitted';
		b6.Business_Plan_Status__c = 'Submitted';
		b7.Business_Plan_Status__c = 'Submitted';
		b8.Business_Plan_Status__c = 'Submitted';
		b9.Business_Plan_Status__c = 'Submitted';
		b10.Business_Plan_Status__c = 'Submitted';
		b11.Business_Plan_Status__c = 'Submitted';
		try{
			update b1;
		}catch(Exception e) {}
		try{
			update b2;
		}catch(Exception e) {}
		try{
			update b3;
		}catch(Exception e) {}
		try{
			update b4;
		}catch(Exception e) {}
		try{
			update b5;
		}catch(Exception e) {}
		try{
			update b6;
		}catch(Exception e) {}
		try{
			update b7;
		}catch(Exception e) {}
		try{
			update b8;
		}catch(Exception e) {}
		try{
			update b9;
		}catch(Exception e) {}
		try{
			update b10;
		}catch(Exception e) {}
		try{
			update b11;
		}catch(Exception e) {}
	}
	
	@isTest
	private static void approvalFN()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c b1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='Enter Service',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b1);
		Business_Plan__c b2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='Enter',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b2);
		Business_Plan__c b3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='ss',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b3);
		Business_Plan__c b4 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b4);
		Business_Plan__c b5 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='Enter Service',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b5);
		Business_Plan__c b6 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b6);
		Business_Plan__c b7 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b7);
		Business_Plan__c b8 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='Enter Service',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b8);
		Business_Plan__c b9 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='EnService',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b9);
		insert BPList;
		b1.Business_Plan_Status__c = 'New';
		b2.Business_Plan_Status__c = 'Submitted';
		b3.Business_Plan_Status__c = 'Submitted';
		b4.Business_Plan_Status__c = 'Submitted';
		b5.Business_Plan_Status__c = 'Submitted';
		b6.Business_Plan_Status__c = 'Submitted';
		b7.Business_Plan_Status__c = 'Submitted';
		b8.Business_Plan_Status__c = 'Submitted';
		b9.Business_Plan_Status__c = 'Submitted';
		try
		{
			update b1;
		}catch(Exception e){}
		try
		{
			update b2;
		}catch(Exception e){}
		try
		{
			update b3;
		}catch(Exception e){}
		try
		{
			update b4;
		}catch(Exception e){}
		try
		{
			update b5;
		}catch(Exception e){}
		try
		{
			update b6;
		}catch(Exception e){}
		try
		{
			update b7;
		}catch(Exception e){}
		try
		{
			update b8;
		}catch(Exception e){}
		try
		{
			update b9;
		}catch(Exception e){}
	}
	
	@isTest
	private static void approvalMN()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c b1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='Enter Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b1);
		Business_Plan__c b2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='Enter',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b2);
		Business_Plan__c b3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b3);
		Business_Plan__c b4 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='ss',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b4);
		Business_Plan__c b5 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Expected_Amount_MN_Product_Revenue__c = 100, Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b5);
		Business_Plan__c b6 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b6);
		Business_Plan__c b7 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Enter Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b7);
		Business_Plan__c b8 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b8);
		Business_Plan__c b9 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Expected_YY_Growth_by_MN__c = '<10%', Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Service',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b9);
		insert BPList;
		b1.Business_Plan_Status__c = 'Submitted';
		b2.Business_Plan_Status__c = 'Submitted';
		b3.Business_Plan_Status__c = 'Submitted';
		b4.Business_Plan_Status__c = 'Submitted';
		b5.Business_Plan_Status__c = 'Submitted';
		b6.Business_Plan_Status__c = 'Submitted';
		b7.Business_Plan_Status__c = 'Submitted';
		b8.Business_Plan_Status__c = 'Submitted';
		b9.Business_Plan_Status__c = 'Submitted';
		try
		{
			update b1;
		}catch(Exception e){}
		try
		{
			update b2;
		}catch(Exception e){}
		try
		{
			update b3;
		}catch(Exception e){}
		try
		{
			update b4;
		}catch(Exception e){}
		try
		{
			update b5;
		}catch(Exception e){}
		try
		{
			update b6;
		}catch(Exception e){}
		try
		{
			update b7;
		}catch(Exception e){}
		try
		{
			update b8;
		}catch(Exception e){}
		try
		{
			update b9;
		}catch(Exception e){}
	}
	@isTest
	private static void approvalAA()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c b1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='Enter Service',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b1);
		Business_Plan__c b2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='Enter',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b2);
		Business_Plan__c b3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Services',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b3);
		Business_Plan__c b4 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter',A_A_service_s_you_intend_to_sell__c='Enter Services',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b4);
		Business_Plan__c b5 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c = 100,
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Services',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b5);
		Business_Plan__c b6 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter Productd',A_A_service_s_you_intend_to_sell__c='Enter Services',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b6);
		Business_Plan__c b7 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Service',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b7);
		Business_Plan__c b8 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b8);
		Business_Plan__c b9 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='Enter',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b9);
		insert BPList;
		b1.Business_Plan_Status__c = 'Submitted';
		b2.Business_Plan_Status__c = 'Submitted';
		b3.Business_Plan_Status__c = 'Submitted';
		b4.Business_Plan_Status__c = 'Submitted';
		b5.Business_Plan_Status__c = 'Submitted';
		b6.Business_Plan_Status__c = 'Submitted';
		b7.Business_Plan_Status__c = 'Submitted';
		b8.Business_Plan_Status__c = 'Submitted';
		b9.Business_Plan_Status__c = 'Submitted';
		try
		{
			update b1;
		}catch(Exception e){}
		try
		{
			update b2;
		}catch(Exception e){}
		try
		{
			update b3;
		}catch(Exception e){}
		try
		{
			update b4;
		}catch(Exception e){}
		try
		{
			update b5;
		}catch(Exception e){}
		try
		{
			update b6;
		}catch(Exception e){}
		try
		{
			update b7;
		}catch(Exception e){}
		try
		{
			update b8;
		}catch(Exception e){}
		try
		{
			update b9;
		}catch(Exception e){}
	}
	@isTest
	private static void approvalGS()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c b1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='Enter Service',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b1);
		Business_Plan__c b2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b2);
		Business_Plan__c b3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Expected_Amount_GS_Services_Revenue__c = 100, Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Product_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b3);
		Business_Plan__c b4 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_YY_Growth_by_GS__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_GS_Services_Revenue__c = 100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='Enter Service',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b4);
		Business_Plan__c b5 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_Amount_GS_Product_Revenue__c = 100,
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b5);
		Business_Plan__c b6 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b6);
		Business_Plan__c b7 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_Amount_GS_Services_Revenue__c = 100,
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='Enter Service',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b7);
		Business_Plan__c b8 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
			   Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
			   Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
			   Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
			   Do_you_measure_Customer_Satisfaction__c='No',
			   Expected_YY_Growth_by_ION__c='<10%',
			   Expected_YY_Growth_by_FN__c='<10%',
			   Expected_YY_Growth_by_MN__c='<10%',
			   Expected_YY_Growth_by_A_A__c='<10%',
			   Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
			   Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
			   Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
			   Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
			   A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
			   FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
			   GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='aa',
			   ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
			   MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
			   Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
			   Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
			  );
		BPList.add(b8);
		insert BPList;
		b1.Business_Plan_Status__c = 'Submitted';
		b2.Business_Plan_Status__c = 'Submitted';
		b3.Business_Plan_Status__c = 'Submitted';
		b4.Business_Plan_Status__c = 'Submitted';
		b5.Business_Plan_Status__c = 'Submitted';
		b6.Business_Plan_Status__c = 'Submitted';
		b7.Business_Plan_Status__c = 'Submitted';
		b8.Business_Plan_Status__c = 'Submitted';
		
		try
		{
			update b1;
		}catch(Exception e){}
		try
		{
			update b2;
		}catch(Exception e){}
		try
		{
			update b3;
		}catch(Exception e){}
		try
		{
			update b4;
		}catch(Exception e){}
		try
		{
			update b5;
		}catch(Exception e){}
		try
		{
			update b6;
		}catch(Exception e){}
		try
		{
			update b7;
		}catch(Exception e){}
		try
		{
			update b8;
		}catch(Exception e){}
		
	}
	
	@isTest
	private static void beforeUpdateOperation()
	{	 
		Account accountCreationPSM = [SELECT Id FROM account WHERE AccountNumber = '12345'];
		User PRM = [SELECT Id FROM user WHERE alias = 'bpprm' LIMIT 1];
		User PSM = [SELECT Id FROM user WHERE alias = 'bppsm' LIMIT 1];
		Contact executiveSponser = [SELECT Id FROM contact WHERE Job_Function__c = 'Executive Management' and Email=: PRMGlobalConstants.EmailContactNamePSM LIMIT 1];
		
		List<Business_Plan__c> BPList= new List<Business_Plan__c>();
		Business_Plan__c businessPlanvalid = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2021', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				  Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				  Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				  Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				  Do_you_measure_Customer_Satisfaction__c='No',
				  Expected_YY_Growth_by_ION__c='<10%',
				  Expected_YY_Growth_by_FN__c='<10%',
				  Expected_YY_Growth_by_MN__c='<10%',
				  Expected_YY_Growth_by_A_A__c='<10%',
				  Expected_YY_Growth_by_GS__c='<10%',
				  Expected_Amount_A_A_Product_Revenue__c=100, Expected_Amount_A_A_Services_Revenue__c=100,
				  Expected_Amount_FN_Product_Revenue__c=100, Expected_Amount_FN_Services_Revenue__c=100,
				  Expected_Amount_GS_Product_Revenue__c=100, Expected_Amount_GS_Services_Revenue__c=100,
				  Expected_Amount_ION_Product_Revenue__c=100, Expected_Amount_ION_Services_Revenue__c=100,
				  Expected_Amount_MN_Product_Revenue__c=100, Expected_Amount_MN_Services_Revenue__c=100,
				  A_A_product_s_you_intend_to_sell__c='aa',A_A_service_s_you_intend_to_sell__c='aa',
				  FN_product_s_you_intend_to_sell__c='aa',FN_service_s_you_intend_to_sell__c='aa',
				  GS_product_s_you_intend_to_sell__c='aa',GS_service_s_you_intend_to_sell__c='aa',
				  ION_product_s_you_intend_to_sell__c='aa',ION_service_s_you_intend_to_sell__c='aa',
				  MN_product_s_you_intend_to_sell__c='aa',MN_service_s_you_intend_to_sell__c='aa',
				  Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				  Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
				 );
		Business_Plan__c bpDefault = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2022', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				Do_you_measure_Customer_Satisfaction__c='No',
				Expected_YY_Growth_by_ION__c='<10%',
				Expected_YY_Growth_by_FN__c='<10%',
				Expected_YY_Growth_by_MN__c='<10%',
				Expected_YY_Growth_by_A_A__c='<10%',
				Expected_YY_Growth_by_GS__c='<10%',
				Expected_Amount_A_A_Product_Revenue__c=0, Expected_Amount_A_A_Services_Revenue__c=0,
				Expected_Amount_FN_Product_Revenue__c=0, Expected_Amount_FN_Services_Revenue__c=0,
				Expected_Amount_GS_Product_Revenue__c=0, Expected_Amount_GS_Services_Revenue__c=0,
				Expected_Amount_ION_Product_Revenue__c=0, Expected_Amount_ION_Services_Revenue__c=0,
				Expected_Amount_MN_Product_Revenue__c=0, Expected_Amount_MN_Services_Revenue__c=0,
				A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='aa',
				FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='aa',
				GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='aa',
				ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='aa',
				MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='aa',
				Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
					 );
		
		Business_Plan__c bpDefault1 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2023', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				 Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				 Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				 Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				 Do_you_measure_Customer_Satisfaction__c='No',
				 Expected_YY_Growth_by_ION__c='<10%',
				 Expected_YY_Growth_by_FN__c='<10%',
				 Expected_YY_Growth_by_MN__c='<10%',
				 Expected_YY_Growth_by_A_A__c='<10%',
				 Expected_YY_Growth_by_GS__c='<10%',
				 Expected_Amount_A_A_Product_Revenue__c=0, Expected_Amount_A_A_Services_Revenue__c=0,
				 Expected_Amount_FN_Product_Revenue__c=0, Expected_Amount_FN_Services_Revenue__c=0,
				 Expected_Amount_GS_Services_Revenue__c=0, Expected_Amount_GS_Product_Revenue__c=0,
				 Expected_Amount_ION_Product_Revenue__c=0, Expected_Amount_ION_Services_Revenue__c=0,
				 Expected_Amount_MN_Product_Revenue__c=0, Expected_Amount_MN_Services_Revenue__c=0,
				 A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Service',
				 FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='Enter Service',
				 GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='Enter Service',
				 ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='Enter Service',
				 MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Enter Service',
				 Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				 Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
				);
		Business_Plan__c bpDefault2 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2024', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				 Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				 Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				 Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				 Do_you_measure_Customer_Satisfaction__c='No',
				 Expected_YY_Growth_by_ION__c='<10%',
				 Expected_YY_Growth_by_FN__c='<10%',
				 Expected_YY_Growth_by_MN__c='<10%',
				 Expected_YY_Growth_by_A_A__c='<10%',
				 Expected_YY_Growth_by_GS__c='<10%',
				 Expected_Amount_A_A_Product_Revenue__c=0, Expected_Amount_A_A_Services_Revenue__c=0,
				 Expected_Amount_FN_Product_Revenue__c=0, Expected_Amount_FN_Services_Revenue__c=0,
				 Expected_Amount_GS_Product_Revenue__c=0, Expected_Amount_GS_Services_Revenue__c=0,
				 Expected_Amount_ION_Product_Revenue__c=0, Expected_Amount_ION_Services_Revenue__c=0,
				 Expected_Amount_MN_Product_Revenue__c=0, Expected_Amount_MN_Services_Revenue__c=0,
				 A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='Enter Service',
				 FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='Enter Service',
				 GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='Enter Service',
				 ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='Enter Service',
				 MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='Enter Service',
				 Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				 Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
				);
		Business_Plan__c bpDefault3 = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2025', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, 
				 Nokia_Partner_Primary_Partner__c = PSM.Id,Territory_Covered_in_Business_Plan__c='Afghanistan',
				 Executive_Sponsor_Partner__c=executiveSponser.Id,Nokia_Product_Portfolio_represented__c='Optics',
				 Is_the_company_Public_or_Private__c='Public',Company_Annual_Revenue_attributed_to_IT__c='100M - 500M',
				 Do_you_measure_Customer_Satisfaction__c='No',
				 Expected_YY_Growth_by_ION__c='<10%',
				 Expected_YY_Growth_by_FN__c='<10%',
				 Expected_YY_Growth_by_MN__c='<10%',
				 Expected_YY_Growth_by_A_A__c='<10%',
				 Expected_YY_Growth_by_GS__c='<10%',
				 Expected_Amount_A_A_Product_Revenue__c=0, Expected_Amount_A_A_Services_Revenue__c=0,
				 Expected_Amount_FN_Product_Revenue__c=0, Expected_Amount_FN_Services_Revenue__c=0,
				 Expected_Amount_GS_Product_Revenue__c=0, Expected_Amount_GS_Services_Revenue__c=0,
				 Expected_Amount_ION_Product_Revenue__c=0, Expected_Amount_ION_Services_Revenue__c=0,
				 Expected_Amount_MN_Product_Revenue__c=0, Expected_Amount_MN_Services_Revenue__c=0,
				 A_A_product_s_you_intend_to_sell__c='Enter Product',A_A_service_s_you_intend_to_sell__c='aa',
				 FN_product_s_you_intend_to_sell__c='Enter Product',FN_service_s_you_intend_to_sell__c='aa',
				 GS_product_s_you_intend_to_sell__c='Enter Product',GS_service_s_you_intend_to_sell__c='aa',
				 ION_product_s_you_intend_to_sell__c='Enter Product',ION_service_s_you_intend_to_sell__c='aa',
				 MN_product_s_you_intend_to_sell__c='Enter Product',MN_service_s_you_intend_to_sell__c='aa',
				 Joint_Business_Objectives_by_Industry__c='Agriculture',Which_Business_Segments_do_you_serve__c='SMB',
				 Competitive_Portfolio_you_represent__c='Cisco',Complementary_Portfolio_you_represent__c='Other'
				);
		
		
		Business_Plan__c businessPlan = new Business_Plan__c(Account_BP__c = accountCreationPSM.id, Year__c = '2026', Primary_Partner_Program_Contact_s_PRM__c = PRM.Id, Nokia_Partner_Primary_Partner__c = PSM.Id);
		
		BPList.add(businessPlanvalid);
		BPList.add(businessPlan);
		BPList.add(bpDefault);
		BPList.add(bpDefault1);
		BPList.add(bpDefault2);
		BPList.add(bpDefault3);
		database.insert(BPList);
		
		List<sObject> sobjectList = new List<sObject>();
		
		Marketing_Plan_and_Industry_Events__c marketingPlan = new Marketing_Plan_and_Industry_Events__c(Campaign_or_Activity_Type__c = 'Other (please specify)', Specify_Other__c = 'abcd' , Target_Market_Segments_Project__c = '1', Provide_the_Campaign_or_Activity_Details__c = 'Other',Identify_Product_Related_to_the_Activity__c='abc',Expected_Cost_of_the_Activity__c=100,Marketing_Plan_and_Industry_Events_BP__c=businessPlanvalid.Id);
		Investments_in_Lab_and_Demo_Equipment__c investmentPlan = new Investments_in_Lab_and_Demo_Equipment__c(Technology_area__c='Fixed Access - FBA',Do_you_wish_to_invest_in_a_Lab_Equipment__c='Yes',Do_you_wish_to_invest_in_Demo_Equipment__c='Yes',Do_you_already_have_Nokia_equipment__c='No',Business_Plan_ID__c=businessPlanvalid.Id);
		Training_Certification_Plan__c trainingPlan= new Training_Certification_Plan__c( Technology_BG_product__c='Fixed Access - POL', Accreditation_Desired__c='Base', Sales_of_People__c=2.0, Quarter_Sales__c='Q1', Sales_Engineer_of_People__c=2.0, Quarter_Sales_Engineer__c='Q1', Field_Technician_of_People__c=2.0, Quarter_Field_Technician__c='Q1', Network_Integration_Engineer_of_People__c=2.0, Quarter_Network_Integration_Engineer__c='Q1', Service_Desk_Clerk_of_People__c=2.0, Quarter_Service_Desk_Clerk__c='Q1', Business_Plan_Training_Certification__c = businessPlanvalid.Id);
		
		Marketing_Plan_and_Industry_Events__c marketingPlandef1 = new Marketing_Plan_and_Industry_Events__c(Campaign_or_Activity_Type__c = 'Other (please specify)', Specify_Other__c = 'abcd',Target_Market_Segments_Project__c = '1', Provide_the_Campaign_or_Activity_Details__c = 'Other',Identify_Product_Related_to_the_Activity__c='abc',Expected_Cost_of_the_Activity__c=100,Marketing_Plan_and_Industry_Events_BP__c=bpDefault1.Id);
		Investments_in_Lab_and_Demo_Equipment__c investmentPlandef1 = new Investments_in_Lab_and_Demo_Equipment__c(Technology_area__c='Fixed Access - FBA',Do_you_wish_to_invest_in_a_Lab_Equipment__c='Yes',Do_you_wish_to_invest_in_Demo_Equipment__c='Yes',Do_you_already_have_Nokia_equipment__c='No',Business_Plan_ID__c=bpDefault1.Id);
		Training_Certification_Plan__c trainingPlandef1= new Training_Certification_Plan__c( Technology_BG_product__c='Fixed Access - POL', Accreditation_Desired__c='Base', Sales_of_People__c=2.0, Quarter_Sales__c='Q1', Sales_Engineer_of_People__c=2.0, Quarter_Sales_Engineer__c='Q1', Field_Technician_of_People__c=2.0, Quarter_Field_Technician__c='Q1', Network_Integration_Engineer_of_People__c=2.0, Quarter_Network_Integration_Engineer__c='Q1', Service_Desk_Clerk_of_People__c=2.0, Quarter_Service_Desk_Clerk__c='Q1', Business_Plan_Training_Certification__c = bpDefault1.Id);
		
		Marketing_Plan_and_Industry_Events__c marketingPlandef3 = new Marketing_Plan_and_Industry_Events__c(Campaign_or_Activity_Type__c = 'Other (please specify)', Specify_Other__c = 'abcd',Target_Market_Segments_Project__c = '1', Provide_the_Campaign_or_Activity_Details__c = 'Other',Identify_Product_Related_to_the_Activity__c='abc',Expected_Cost_of_the_Activity__c=100,Marketing_Plan_and_Industry_Events_BP__c=bpDefault1.Id);
		Investments_in_Lab_and_Demo_Equipment__c investmentPlandef3 = new Investments_in_Lab_and_Demo_Equipment__c(Technology_area__c='Fixed Access - FBA',Do_you_wish_to_invest_in_a_Lab_Equipment__c='Yes',Do_you_wish_to_invest_in_Demo_Equipment__c='Yes',Do_you_already_have_Nokia_equipment__c='No',Business_Plan_ID__c=bpDefault1.Id);
		Training_Certification_Plan__c trainingPlandef3 = new Training_Certification_Plan__c( Technology_BG_product__c='Fixed Access - POL', Accreditation_Desired__c='Base', Sales_of_People__c=2.0, Quarter_Sales__c='Q1', Sales_Engineer_of_People__c=2.0, Quarter_Sales_Engineer__c='Q1', Field_Technician_of_People__c=2.0, Quarter_Field_Technician__c='Q1', Network_Integration_Engineer_of_People__c=2.0, Quarter_Network_Integration_Engineer__c='Q1', Service_Desk_Clerk_of_People__c=2.0, Quarter_Service_Desk_Clerk__c='Q1', Business_Plan_Training_Certification__c = bpDefault3.Id);
		//modified by deeksha
		Accreditation__c accrd = new Accreditation__c();
		accrd.RecordTypeId = '01241000000v9mE';
		accrd.Manual_Accreditation_Level_Update__c = true;
		accrd.Evaluated_Accreditation__c = true;
		accrd.Partner__c = accountCreationPSM.Id;
		accrd.Accreditation_Date__c = System.today();	  
		accrd.Accreditation_Type__c='Product';
		accrd.Accreditation_Level__c = 'Advanced';
		accrd.Meets_Lab_Equipment_Requirements__c=true;
		
		sobjectList.add(marketingPlan);
		sobjectList.add(investmentPlan);
		sobjectList.add(trainingPlan);
		sobjectList.add(marketingPlandef1);
		sobjectList.add(investmentPlandef1);
		sobjectList.add(trainingPlandef1);
		sobjectList.add(marketingPlandef3);
		sobjectList.add(investmentPlandef3);
		sobjectList.add(trainingPlandef3);
		sobjectList.add(accrd);		
		database.insert(sobjectList);
		
		accrd.Meets_Lab_Equipment_Requirements__c=false;
		database.update(accrd);
		
		BPList.get(5).Business_Plan_Status__c = 'Submitted';
		BPList.get(4).Business_Plan_Status__c = 'Submitted';
		BPList.get(3).Business_Plan_Status__c = 'Submitted';
		BPList.get(2).Business_Plan_Status__c = 'Submitted';
		BPList.get(1).Business_Plan_Status__c = 'Submitted';
		BPList.get(0).Business_Plan_Status__c = 'Submitted';
		try
		{
			update BPList;	  
		}
		catch(Exception e)
		{
			//e.getMessage()
			System.assert(e.getMessage().contains(System.Label.Business_Plan_Approval_Criteria_Error_Msg));
		}
	}
	/*@isTest
private static void bpShareTest(){
Test.startTest();
Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
accountCreationPRM.AccountNumber = '12304'; 
database.insert(accountCreationPRM);

String orgId = UserInfo.getOrganizationId();
String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
String uniqueName =   dateString + randomInt;

Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
database.insert(conPRM);
User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' + orgId '.org' , emailencodingkey = 'UTF-8', firstName = 'test',		 lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );

User userPSM = new User(alias = 'abc', email = uniqueName + '@nokia.com' + orgId '.org' , emailencodingkey = 'UTF-8', firstName = 'test', 
lastname = 'Testing',
languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential');
database.insert(userPRM);
database.insert(userPSM);
List<User> userList = new List<User>();
userList.add(userPRM);
userList.add(userPSM);

List<Account_Member__c> AccountMemList = new List<Account_Member__c>();
Account_Member__c AccountMemPRM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Relationship Manager', 
Type__c = 'External', Name__c = userPRM.Id );
Account_Member__c AccountMemPSM = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner Sales Manager', 
Type__c = 'Internal', Name__c = userPSM.Id );

Account_Member__c AccountMem1 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Training Manager', 
Type__c = 'External', Name__c = userPRM.Id );
Account_Member__c AccountMem2 = new Account_Member__c(Account__c = accountCreationPRM.Id, Account_Role__c = 'Partner User', 
Type__c = 'External', Name__c = userPRM.Id );

AccountMemList.add(AccountMemPRM);
AccountMemList.add(AccountMemPSM);
AccountMemList.add(AccountMem1);
AccountMemList.add(AccountMem2);
Database.insert(AccountMemList);
List<Business_Plan__c> bpList = new List<Business_Plan__c>();
Business_Plan__c bpInstance1 = new Business_Plan__c(Account_BP__c = accountCreationPRM.id, Primary_Partner_Program_Contact_s_PRM__c = userPRM.Id, Nokia_Partner_Primary_Partner__c = userPSM.Id, Year__c = '2030', CurrencyIsoCode = 'USD');
bpList.add(bpInstance1);
Database.Insert(bpList);
Test.stopTest();
}*/
}
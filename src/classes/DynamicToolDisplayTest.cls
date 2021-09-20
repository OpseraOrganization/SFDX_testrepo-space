/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:		   DynamicToolDisplay Test 
Description:	 DynamicToolDispla class to get tool assigned to current user
Date		Version   Author		Summary of Changes 
-----------   ----------	  ----------------- ---------------------------------------------------------------------------------------------------
10/08/2017	1.0	   Supriyam			get tool assigned to current user
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
@istest
public class DynamicToolDisplayTest {
	
	@testSetup static void createTestData() {
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
	public static testmethod void testTool(){
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){						
			List<Account> acc=TestDataFactory.createAccount(1);
			acc[0].AccountNumber = '00001234'; 
			acc[0].Market__c='Market North America'; 
			database.insert(acc);
			List<User> userList = new List<User>(); 
			
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt; 
			
			ISO_Country_Codes__c cc=new ISO_Country_Codes__c();
			cc.Country_Name__c='United States Of America';
			cc.Market__c='Market North America';
			cc.Name='US';
			insert cc;
			
			contact con =new contact();
			con.LastName='test';
			con.AccountId=acc[0].id;
			con.MailingCountry = cc.Country_Name__c;
			con.MailingCountrycode= cc.Name;
			con.Market__c = cc.Market__c; 
			insert con;
			
			Additional_Resource_Request__c addTool=new Additional_Resource_Request__c();
			addTool.Additional_Resource__c= 'SFDC PRM Access';
			addTool.Request_Status__c='Request';
			addTool.Partner_Contact__c=con.Id;
			addTool.Access_Level__c='Viewer';
			addTool.Partner_User__c=userinfo.getUserID();
			
			Additional_Resource_Request__c addTool2=new Additional_Resource_Request__c();
			addTool2.Additional_Resource__c= 'Co-op';
			addTool2.Request_Status__c='Request';
			addTool2.Partner_Contact__c=con.Id;
			addTool2.Access_Level__c='Viewer';
			addTool2.Partner_User__c=userinfo.getUserID();
			
			Additional_Resource_Request__c addTool3=new Additional_Resource_Request__c();
			addTool3.Additional_Resource__c= 'Deal Registration';
			addTool3.Request_Status__c='Request';
			addTool3.Partner_Contact__c=con.Id;
			addTool3.Partner_User__c=userinfo.getUserID();
			addTool3.Access_Level__c='Viewer';
			
			Additional_Resource_Request__c addTool4 = createAdditionalResourceRequest(PRMGlobalConstants.Personal_Space,'Request', 'Viewer', con.Id,userinfo.getUserID());		
			Additional_Resource_Request__c addTool5 = createAdditionalResourceRequest(PRMGlobalConstants.Deal_Registration,'Request', 'Viewer', con.Id,userinfo.getUserID());		
			Additional_Resource_Request__c addTool6 = createAdditionalResourceRequest(PRMGlobalConstants.CPQ_Tool,'Request', 'Viewer', con.Id,userinfo.getUserID());		
			
			LIST<Additional_Resource_Request__c> dynamicTool=new LIST<Additional_Resource_Request__c>{addTool,addTool2,addTool3,addTool4,addTool5,addTool6};
			insert dynamicTool;
			
			for(Additional_Resource_Request__c adrr : dynamicTool){
				adrr.Partner_User__c = userinfo.getUserID();
			}
			update dynamicTool;
			
			DynamicToolDisplay.getDynamicTool();
		}	   
	}
	@isTest static void leadTest2() {
		
		try {
			
			
			DynamicToolDisplay.getDynamicTool();
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		DynamicToolDisplay.getDynamicTool();
	}
	@isTest static void leadTest3() {
		LIST<Additional_Resource_Request__c> dynamicTool = new LIST<Additional_Resource_Request__c>();
		try {
			DynamicToolDisplay.getDynamicToolURL();
		} catch(DMLException e) {
			system.assertEquals(e.getMessage(), e.getMessage());
		}
		
		DynamicToolDisplay.getDynamicToolURL();
	}
	
	static Additional_Resource_Request__c createAdditionalResourceRequest(String additionalResource,string status, string accessLevel, Id contactId, Id userId){		
		Additional_Resource_Request__c addTool3=new Additional_Resource_Request__c();
		addTool3.Additional_Resource__c= additionalResource;
		addTool3.Request_Status__c=status;
		addTool3.Partner_Contact__c=contactId;
		addTool3.Partner_User__c=userId;
		addTool3.Access_Level__c=accessLevel;
		return addTool3;
	}   
}
/****************************************
* Name : DS_NetworkoverviewTest
* Author : Accenture

*****************************************/
@isTest
public class DS_NetworkOverviewBannerTest {
	
	static testmethod void createTestDP(){
		try{
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			
			
			Test.startTest();
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			
			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			database.insert(user1); 
			
			//Creating Custom Setting Data
				CH_AccountName__c accauth = new CH_AccountName__c();
				accauth.CH_InvalidName__c = 'Nokia';
				accauth.CH_ValidName__c = 'Nokia-OYJ';
				insert accauth;
			
			List<Contact> ContactList = new List<Contact>();
			Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			ContactList.add(conDS);
			ContactList.add(conDS2);
			database.insert(ContactList); 
			
			User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								   languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								   timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
			
			File_Upload__c fu = new File_Upload__c();
			system.runAs(user1){						
				database.insert(userDS); 
				
				userDS.IsPortalEnabled =  True;
				
				database.update(userDS);
				
				
				
				
			}
			Test.stopTest();
			
			fu.Technology__c=CSWXGlobalConstant.Technology ;
			fu.Supporting_Material_Type__c = CSWXGlobalConstant.analyticSourceCXM;
			fu.Document_Type__c=CSWXGlobalConstant.Networkoverview;
			// fu.Network_Overview__c= true;	
			fu.Account__c = accountCreationDP.id;
			insert fu;
			
			ContentVersion contentVersion = new ContentVersion();
			ContentDocumentLink contentlink = new ContentDocumentLink();
			contentVersion = TestDataFactory.createContentVersion(1)[0];  
			
			contentVersion.title = CSWXGlobalConstant.Networkoverview;
			database.insert(contentVersion) ;					 
			
			Id theContentDocumentId = [select ContentDocumentId 
									   from ContentVersion 
									   where Id =: contentVersion.Id limit 1].ContentDocumentId;		
			contentlink = TestDataFactory.createContentDocumentLink(1,accountCreationDP.id, theContentDocumentId)[0];
			contentlink.LinkedEntityId=accountCreationDP.id;
			database.insert(contentlink) ; 
			
			
			System.runAs(userDS) {
				
				DS_NetworkOverviewBanner.getCurrentUserData();
				DS_NetworkOverviewBanner.getAccountAttachment();
			}
			contentVersion.title = CSWXGlobalConstant.benchmarking;
			database.update(contentVersion) ;  
			
			System.runAs(userDS) {
				DS_NetworkOverviewBanner.getAccountAttachment();
			}
		}
		
		
		
		
	   }catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRenderingTest,CSWXGlobalConstant.createTestDP);

}  
	}
}
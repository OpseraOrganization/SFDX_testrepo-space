@istest()
public class ShareSupportAssetTest {
	
	private static testmethod void Test_ShareSupportAsset()
	{
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
		ContentVersion contentVersion_1 = new ContentVersion();
		contentVersion_1.Title = 'Penguins';
		contentVersion_1.PathOnClient = 'Penguins.jpg';
		contentVersion_1.VersionData = Blob.valueOf('Test Content');
	   contentVersion_1.IsMajorVersion = true;
		insert contentVersion_1;
		ContentVersion contentVersion_2 = [SELECT Id, LastModifiedDate,Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
		List<ContentDocument> documents = [SELECT Id,ParentId, Title, LatestPublishedVersionId FROM ContentDocument];
		contentdocument cd=new contentdocument();
	  //  cd.ParentId = cd.Id;
		documents.add(cd);
		Account accountCreationPRM = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreationPRM);
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.Nokia_Sales_Profile_Id,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		List<Contact> ContactList = new List<Contact>();
		Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		Contact conPRM2 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=accountCreationPRM.id,Email=PRMGlobalConstants.EmailContactNamePRM );
		ContactList.add(conPRM);
		ContactList.add(conPRM2);
		database.insert(ContactList); 
		User userPRM = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
								 
		database.insert(userPRM); 
		userPRM.IsPortalEnabled =  True;
		system.runAs(runAsUSer[0]){ 
		database.update(userPRM);
		}
		system.debug('USER1' + userPRM);   
		system.debug('USERPRM' + userPRM.IsPortalEnabled);  
		List<DocumentShare__c> recordList=new  List<DocumentShare__c>();
		DocumentShare__c DocShare =new DocumentShare__c();
		DocShare.SharingUser__c=userPRM.Id;
		DocShare.Document_Id__c=contentVersion_2.Title;
		DocShare.Time_When_Shared__c=System.now(); 
		 DocShare.Support_Asset_Last_Modified_Date__c=contentVersion_2.LastModifiedDate;
		DocShare.Content_Document_ID__c=contentVersion_2.Id;
		DocShare.Article_URL__c='test';
		DocShare.User__c ='External';
		recordList.add(DocShare);
		List<string> emailList = new List<string>();
		emailList.add('abc@nokia.com' );
		
		ShareSupportAsset.getContentDetails(documents.get(0).Id);
	ShareSupportAsset.getuserDetail(userPRM.Id,contentVersion_2.Title);
		ShareSupportAsset.sendMailToUser(emailList,'subject','body',cd,user1,'test');
		ShareSupportAsset.sendMailToUser(emailList,'subject','body',cd,userPRM,'test@?Id');
		ShareSupportAsset.setLikeRecord(userPRM.Id,cd,True,contentVersion_2.Title,'test','External',userPRM);
		ShareSupportAsset.getCurrentUser();
		system.runAs(userPRM){  
		ShareSupportAsset.getDatavalues(new Account(),'test');
			}
	   }
	}
	
}
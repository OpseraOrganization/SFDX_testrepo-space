@isTest(seealldata = False)

public class CH_CustomBreadCrumbsController_Test {
  private static Account oLegalEntity;
  private static Contact oContact;
  private static Asset oAsset;
  private static List<Entitlement> oEntitlementList;
  private static List<Product2> oProduct2List;
  private static Case oCase;

  @testSetup  
  static void setupTestData() {
	List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
	insert oProspectList;
	//
	oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
	insert oLegalEntity;
	//
	oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
	oContact.LastName = 'Test LastName';
	oContact.CH_ContactType__c = 'customer';
	insert oContact;
	//
	oProduct2List = TestDataFactory.createProduct(1);
	insert oProduct2List;
	//
	oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
	insert oAsset;
	//
	oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
	insert oEntitlementList;
	//
	List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
	insert oEntitlementContactList;
	//
	oCase= TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
 // oCase.CH_AssignedDate__c=System.Today();
 oCase.Status = 'Assigned';
	oCase.CH_AssignedDate__c = DateTime.Now();
  }

	public static testMethod void TestData(){
	 setupTestData() ;
	 Test.StartTest();
	 insert oCase;
	 EmailMessage email = new EmailMessage();
		email.FromAddress = 'test@abc.org';
		email.Incoming = True;
		email.ToAddress= 'test@xyz.org';
		email.Subject = 'Test email';
		email.HtmlBody = 'Test email body';
		
		email.ParentId = oCase.Id; 
		insert email;
	   try{
	   if(oCase.Id!=Null){
		   CH_CustomBreadCrumbsController.FetchRecordIds(email.Id);
		   string executed;
		   CH_CustomBreadCrumbsHelper.FetchIds(oCase.Id);
		   if(oCase.Id!=Null){
			

/*EmailMessage[] newEmail = new EmailMessage[0];

 

newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@670ocglw7xhomi4oyr5yw2zvf.8kp7yeag.8.case.salesforce.com', Subject = 'Test email', TextBody = '23456 ', ParentId = oCase.Id)); 

 

insert newEmail; */

		 
		   } else{return;}   
		  }else{return;}   
		   }
			
			catch(Exception e){
			
			}
			Test.StopTest();
		}
   }
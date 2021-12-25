/**
 * @name	NF_BypassPreviewAndSubmitCtrlTest
 * @author   
 * @since   Jan 09, 2017
 * @desc	This class helps to code coverrage to the NF_BypassPreviewAndSubmitCtrl Class
 * @history 
 */

@isTest
public class NF_BypassPreviewAndSubmitCtrlTest {

	private static User testUser = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static User testUser1 = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static User testUser3 = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	private static User testUser2 = NF_TestDataFactory.createAdminUser('Data Loader Profile');
	 
	 
	private static Account currentAccount;
	private static Opportunity currentOpportunity;
	private static Opportunity currentOpportunity1;
	private static Opportunity currentOpportunity2;
	private static Opportunity currentOpportunity3;
	private static Opportunity currentOpportunity4;
	   
 public static void setup(){ 
		 
				   
		
	 insert testUser2 ;
	 insert testUser3;
	 insert testUser1;
	 Update testUser2;
	 Update testUser1;
				
		currentAccount =  TestDataFactory.createAccount(1)[0];
		currentAccount.L4Name__c = 'LAT CARSO CT CO';
		 currentAccount.L5Name__c = 'LAT CARSO CT CO';
		  currentAccount.L6Name__c = 'LAT CARSO CT CO';
		   currentAccount.L7Name__c = 'LAT CARSO CT CO';
			currentAccount.L2Name__c = 'LAT CARSO CT CO';
			currentAccount.L3Name__c = 'LAT CARSO CT CO';
			currentAccount.Customer_Compliance__c='US_Govern';
		insert currentAccount;

		List<Opportunity> currOpp = new List<Opportunity>();
		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		//currentOpportunity.Org_L4__c = 'LAT CARSO CT CO';
		currentOpportunity.lead_bg__c = 'NSW';
		
		currOpp.add(currentOpportunity);
		currentOpportunity1= NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		//currentOpportunity1.Org_L4__c = 'LAT CARSO CT CO';
		currentOpportunity1.lead_bg__c = 'NSW';
		currOpp.add(currentOpportunity1);
		currentOpportunity2 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		//currentOpportunity2.Org_L4__c = 'LAT CARSO CT CO';
		currentOpportunity2.lead_bg__c = 'NSW';
		currOpp.add(currentOpportunity2);
		currentOpportunity3 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		//currentOpportunity3.Org_L4__c = 'LAT CARSO CT CO';
		currentOpportunity3.lead_bg__c = 'ION';
		currentOpportunity3.Lead_BU__c = 'ION IPR';
		currOpp.add(currentOpportunity3);
		currentOpportunity4 = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		//currentOpportunity4.Org_L4__c = 'LAT CARSO CT CO';
		currentOpportunity4.lead_bg__c = 'MN';
		currOpp.add(currentOpportunity4);
		insert currOpp;
		
										   }
		   
 public static testmethod void setuptest()
 {	
 NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;	  
 system.runAs(testUser){
			Test.startTest();
				setup();		  
									
			   ApexPages.currentPage().getParameters().put('oppId',  currentOpportunity2.Id);
			   ApexPages.currentPage().getParameters().put('Gateclass','Contract');
			   NF_BypassPreviewAndSubmitCtrl pre_sub_test1= new NF_BypassPreviewAndSubmitCtrl();
			   pre_sub_test1.init();
			   pre_sub_test1.submit();
			   Test.StopTest();
					   }   
	 }
}
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
	private static Account currentAccount;
	private static Opportunity currentOpportunity;

	public static void setup(){
		currentAccount =  TestDataFactory.createAccount(1)[0];
		currentAccount.L4Name__c = 'LAT CARSO CT CO';
		currentAccount.L5Name__c = 'LAT CARSO CT CO';
		currentAccount.L6Name__c = 'LAT CARSO CT CO';
		currentAccount.L7Name__c = 'LAT CARSO CT CO';
		currentAccount.L2Name__c = 'LAT CARSO CT CO';
		currentAccount.L3Name__c = 'LAT CARSO CT CO';
		currentAccount.Customer_Compliance__c='US_Govern';
		insert currentAccount;

		currentOpportunity = NF_TestDataFactory.createOpportunity(currentAccount.Id, 'Develop Opportunity', 'Opportunity in Progress', Date.today().addDays(10), 700);
		currentOpportunity.lead_bg__c = 'CNS';
		currentOpportunity.lead_bu__c = 'CNS';
		currentOpportunity.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
		insert currentOpportunity;

	}

	public static testmethod void setuptest()
	{
		system.runAs(testUser){
			Test.startTest();
			setup();
			ApexPages.currentPage().getParameters().put('oppId',  currentOpportunity.Id);
			ApexPages.currentPage().getParameters().put('Gateclass',GlobalConstants.GATE_G2);
			NF_BypassPreviewAndSubmitCtrl ctrl= new NF_BypassPreviewAndSubmitCtrl();
			ctrl.init();
			ctrl.submit();
			ApexPages.currentPage().getParameters().put('oppId',  currentOpportunity.Id);
			ApexPages.currentPage().getParameters().put('Gateclass',GlobalConstants.GATE_G3);
			 ctrl= new NF_BypassPreviewAndSubmitCtrl();
			ctrl.init();
			ctrl.submit();
			Test.StopTest();
		}
	}
}
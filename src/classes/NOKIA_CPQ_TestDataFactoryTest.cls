@isTest
public class NOKIA_CPQ_TestDataFactoryTest
{
testMethod static void testClass()
	{
		User testUser1 = NOKIA_CPQ_TestDataFactory.createSystemAdminUser();
		List<User> users = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		users.add(testUser1);
		insert users;
		}

testMethod static void testclass1(){
List<Product2> prodList = NOKIA_CPQ_TestDataFactory.productCreation(1);
  List<product2>  prod = NOKIA_CPQ_TestDataFactory.productCreationDirect(1);
	 List<Apttus_Proposal__Proposal_Line_Item__c> pli = NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
	 List<Apttus_Config2__LineItem__c> lineitem = NOKIA_CPQ_TestDataFactory.createLineItem(1);
	 List<Apttus_Config2__ProductConfiguration__c> pg = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	 List<Accreditation__c > cc = NOKIA_CPQ_TestDataFactory.createAccreditationMaintenance(1);
   //  List<Accreditation__c > cc1 = NOKIA_CPQ_TestDataFactory.acccreateAccreditation(1);
	  List<Accreditation__c > cc2 = NOKIA_CPQ_TestDataFactory.createAccreditationforProd(1);
	  List<Apttus_Proposal__Proposal__c>  pro = NOKIA_CPQ_TestDataFactory.createProposal(1);
	 List<Apttus_Proposal__Proposal__c> prod1 =NOKIA_CPQ_TestDataFactory.createProposalWithNull(1);
	 List<Apttus_Proposal__Proposal__c> prop2 = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
}
testMethod static void testclass2(){
List<Account> acc =  NOKIA_CPQ_TestDataFactory.getAccounts(1);
}
}
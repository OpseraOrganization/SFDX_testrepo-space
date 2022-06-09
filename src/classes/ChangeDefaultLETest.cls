@isTest
public class ChangeDefaultLETest {
	private static testMethod void LEUnitTest() {
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		List<Account> parentAccounts = new List<Account>();
		List<Account> childAccounts = new List<Account>();
		User u = TestDataFactory.createUser(system.Label.Data_Loader_Profile_Name, 'Test_User');
		system.runAs(u){
			//Insert Accounts
			for(Integer i = 1; i<=13; i++)
			{
				Account parentAccount = new Account();
				parentAccount.Name = 'Test Batch DLE_Parent_'+String.valueOf(i);
				parentAccount.AccountNumber= '30999591'+String.valueOf(i);
				parentAccounts.add(parentAccount);
			}
			insert parentAccounts;
			system.debug('parentAccounts==='+ parentAccounts[0].id);
			//  Case 1.1
			
			for(Integer i = 1; i<=2; i++){
				Account childAccount1 = new Account();
				childAccount1.parentId = parentAccounts[i-1].id;
				childAccount1.Name = 'Test Batch DLE_Case1_1_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount1.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount1.Default_Legal_Entity__c = true;
				childAccount1.Active__c = false;
				childAccount1.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount1);
			}
			
			//Case 1.2
			
			for(Integer i = 3; i<=4; i++){
				Account childAccount2 = new Account();
				childAccount2.parentId = parentAccounts[i-1].id;
				childAccount2.Name = 'Test Batch DLE_Case1_2_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount2.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount2.Default_Legal_Entity__c = true;
				childAccount2.Active__c = false;
				childAccount2.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount2);
				
				Account childAccount3 = new Account();
				childAccount3.parentId = parentAccounts[i-1].id;
				childAccount3.Name = 'Test Batch DLE_Case1_2_LE.'+(i+i)+'_'+parentAccounts[i-1].AccountNumber;
				childAccount3.AccountNumber= '1000099'+ String.valueOf(Integer.valueOf(parentAccounts[i-1].AccountNumber.substringAfter('5'))+i);
				childAccount3.Default_Legal_Entity__c = false;
				childAccount3.Active__c = true;
				childAccount3.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount3);  
			}
			
			
			//Case 2
			
			for(Integer i = 6; i<=7; i++){
				Account childAccount4 = new Account();
				childAccount4.parentId = parentAccounts[i-1].id;
				childAccount4.Name = 'Test Batch DLE_Case2_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount4.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount4.Default_Legal_Entity__c = true;
				childAccount4.Active__c = true;
				childAccount4.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount4);
				
				Account childAccount5 = new Account();
				childAccount5.parentId = parentAccounts[i-1].id;
				childAccount5.Name = 'Test Batch DLE_Case2_LE.'+(i+i)+'_'+parentAccounts[i-1].AccountNumber;
				childAccount5.AccountNumber= '1000099'+ String.valueOf(Integer.valueOf(parentAccounts[i-1].AccountNumber.substringAfter('5'))+i);
				childAccount5.Default_Legal_Entity__c = true;
				childAccount5.Active__c = true;
				childAccount5.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount5);  
			}
			
			
			//Case 3
			
			
			for(Integer i = 8; i<=9; i++){
				Account childAccount6 = new Account();
				childAccount6.parentId = parentAccounts[i-1].id;
				childAccount6.Name = 'Test Batch DLE_Case2_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount6.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount6.Default_Legal_Entity__c = false;
				childAccount6.Active__c = false;
				childAccount6.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount6);
				
				Account childAccount7 = new Account();
				childAccount7.parentId = parentAccounts[i-1].id;
				childAccount7.Name = 'Test Batch DLE_Case2_LE.'+(i+i)+'_'+parentAccounts[i-1].AccountNumber;
				childAccount7.AccountNumber= '1000099'+ String.valueOf(Integer.valueOf(parentAccounts[i-1].AccountNumber.substringAfter('5'))+i);
				childAccount7.Default_Legal_Entity__c = false;
				childAccount7.Active__c = true;
				childAccount7.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount7);  
			}
			
			for(Integer i = 10; i<=11; i++){
				Account childAccount10 = new Account();
				childAccount10.parentId = parentAccounts[i-1].id;
				childAccount10.Name = 'Test Batch DLE_Case2_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount10.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount10.Default_Legal_Entity__c = false;
				childAccount10.Active__c = true;
				childAccount10.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccount10);
				
				Account childAccoun11 = new Account();
				childAccoun11.parentId = parentAccounts[i-1].id;
				childAccoun11.Name = 'Test Batch DLE_Case2_LE.'+(i+i)+'_'+parentAccounts[i-1].AccountNumber;
				childAccoun11.AccountNumber= '1000099'+ String.valueOf(Integer.valueOf(parentAccounts[i-1].AccountNumber.substringAfter('5'))+i);
				childAccoun11.Default_Legal_Entity__c = true;
				childAccoun11.Active__c = true;
				childAccoun11.recordTypeId = LERecordTypeId;
				childAccounts.add(childAccoun11);  
			}
			
			
			insert childAccounts;
		}
		
		
		
		Test.startTest();
		UpdateSingleDLE batch = new UpdateSingleDLE(childAccounts);
		batch.Query = 'SELECT ID,name,Default_Legal_Entity__c from account where Id in:updateList';
		Id batchInstanceId = Database.executeBatch(batch, 200);
		Set<String> allCustomers = new  Set<String>();
		UpdatewithoutDLEBatch batch2 = new UpdatewithoutDLEBatch(allCustomers);
		batch2.Query = 'select Id,name,Default_Legal_Entity__c,parentId,Active__c from account '+
			'where recordtype.name = \'Legal Entity\' and parent.Id!=null';
		
		Id batchInstanceId2 = Database.executeBatch(batch2, 200);
		Test.stopTest();
		
	}
	
	private static testMethod void LEUnitTest2() {
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		List<Account> parentAccounts = new List<Account>();
		List<Account> childAccountsList = new List<Account>();
		User u = TestDataFactory.createUser(system.Label.Data_Loader_Profile_Name, 'Test_User');
		system.runAs(u){ 
			for(Integer i = 1; i<=2; i++)
			{
				Account parentAccount = new Account();
				parentAccount.Name = 'Test Batch DLE_Parent_'+String.valueOf(i);
				parentAccount.AccountNumber= '30999591'+String.valueOf(i);
				parentAccounts.add(parentAccount);
			}
			insert parentAccounts;
			for(Integer i = 1; i<2; i++){
				Account childAccount12 = new Account();
				childAccount12.parentId = parentAccounts[i-1].id;
				childAccount12.Name = 'Test Batch DLE_Case2_LE.'+i+'_'+parentAccounts[i-1].AccountNumber;
				childAccount12.AccountNumber= '1000099'+parentAccounts[i-1].AccountNumber.substringAfter('5');
				childAccount12.Default_Legal_Entity__c = true;
				childAccount12.Active__c = true;
				childAccount12.recordTypeId = LERecordTypeId;
				childAccountsList.add(childAccount12);
				
				Account childAccount13 = new Account();
				childAccount13.parentId = parentAccounts[i-1].id;
				childAccount13.Name = 'Test Batch DLE_Case2_LE.'+(i+i)+'_'+parentAccounts[i-1].AccountNumber;
				childAccount13.AccountNumber= '1000099'+ String.valueOf(Integer.valueOf(parentAccounts[i-1].AccountNumber.substringAfter('5'))+i);
				childAccount13.Default_Legal_Entity__c = true;
				childAccount13.Active__c = true;
				childAccount13.recordTypeId = LERecordTypeId;
				childAccountsList.add(childAccount13);  
			}
			
			insert childAccountsList;
		}
		ChangeDefaultLE changeDLE = new ChangeDefaultLE();
		changeDLE.doChanges();
		changeDLE.computeSingleDLE();
		changeDLE.checkCustomersWithoutDLE();
		changeDLE.executeBatchUpdate();
	}
	/*  account AfterfirstLE= [SELECT id , Default_Legal_Entity__c from account where Id =: accountList[1].Id ];
System.Debug('The 1stt(after) default legal entity is --->' +AfterfirstLE.Default_Legal_Entity__c);

account AftersecondLE= [SELECT id , Default_Legal_Entity__c from account where Id =: accountList[2].Id ];
System.Debug('The 2nd(after) default legal entity is --->' +AftersecondLE.Default_Legal_Entity__c);

//Start
List<Account> parentAccount = new List<Account>();
Set<String> allCustomers = new  Set<String>();
parentAccount = TestDataFactory.createAccount(4);
Insert parentAccount;
for(Account acc: [Select id  from account where id IN:parentAccount]){
allCustomers.add(acc.id);
}
Test.startTest();
UpdatewithoutDLEBatch batch = new UpdatewithoutDLEBatch(allCustomers);
batch.Query = 'select Id,name,Default_Legal_Entity__c,parentId from account '+
'where recordtype.name = \'Legal Entity\' and parentId NOT IN:parentList '+
'and Active__c = true and parent.Id!=null';
Id batchInstanceId = Database.executeBatch(batch, 200);
Test.stopTest();
//End
*/
	private static testMethod void testSchedular() {
		String CRON_EXP = '0 0 0 15 3 ? *';
		Test.startTest();
		String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new ChangeDefaultLESchedular());
		Test.stopTest();
	}
}
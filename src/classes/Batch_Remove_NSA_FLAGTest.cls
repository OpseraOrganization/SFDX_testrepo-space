/****************************************
 * Class Name : Batch_EDPPriceListItemTest
 * Created Date: 27 June 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading price lists from sales item custom object 
*****************************************/

@isTest
private class Batch_Remove_NSA_FLAGTest {
	
	@isTest static void nsaUserTest(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].NSA_Expiration_Date__c = system.today();
		//runAsUSer[1].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[1].NSA_Compliant__c = false;
		runAsUSer[1].NSA_Expiration_Date__c = system.today();
		database.insert(runAsUSer);
		
		system.runAs(runAsUSer[0]){
			
			Test.startTest();
		
			SchedulableContext SC = null;
			Batch_Remove_NSA_FLAG tsc = new Batch_Remove_NSA_FLAG();
			tsc.execute(SC);
			Batch_Remove_NSA_FLAG batch = new Batch_Remove_NSA_FLAG();
			List<User> userListEmpty;
			Database.BatchableContext BC;
			Database.executebatch(batch,2000);
			batch.execute(BC,userListEmpty);
			
			batch.start(BC);
			batch.execute(BC, runAsUSer);
			batch.finish(BC);
					
			Test.stopTest();
	
			Map<Id,User> userslist = new Map<Id,User>([select Id,NSA_Compliant__c From User where Id = :runAsUSer[0].Id or Id = :runAsUSer[1].Id]);
					system.debug('Before update list: '+ userslist);   
				   System.assertNotEquals(runAsUSer[0].NSA_Compliant__c, userslist.get(runAsUSer[0].Id).NSA_Compliant__c);
					system.assert(runAsUSer[1].NSA_Compliant__c == userslist.get(runAsUSer[1].Id).NSA_Compliant__c);
		}
	}

}
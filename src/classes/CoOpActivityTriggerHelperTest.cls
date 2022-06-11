@isTest
public class CoOpActivityTriggerHelperTest{
	static testMethod void Activitycreation(){
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;		
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest(); 
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			Fund__c fd = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
			insert fd;
			Map<ID, Co_Op_Activity__c> activityOldMap = new Map<ID, Co_Op_Activity__c>();
			Co_Op_Activity__c activity = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fd.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
			insert activity;
			
			activityOldMap.put(activity.id, activity);
			activity.Activity_Status__c = 'Pending Approval';
			Try{
	update(activity);
			}catch(Exception e) {}
		   // CoOpActivityTriggerHelper.validateApprovalProcessCriteria(activity,activityOldMap);
			//for exception
			//List<Co_Op_Activity__c> activityList = new List<Co_Op_Activity__c>();
			//CoOpActivitHandler.beforeUpdateOperation(activityList,activityOldMap);
			Test.stopTest(); 
		}
	}
}
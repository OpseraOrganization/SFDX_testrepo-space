/***************************************
* Name : TaskCreationHelperTest
* Author : Accenture
* Description : Test class for TaskCreationHelper
*****************************************/
@isTest
private class TaskCreationHelperTest{
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static User userSales;
	private static User userSysAdmin;
	private static List<Id> opptyIds;
	private static Integer size = 3;

	private static void setup(){
		userSales = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		insert userSales;
		userSysAdmin = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userSysAdmin;
		System.runAs(userSales){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> opportunities = TestDataFactory.OpportunityCreation(size,accountCreation);
			opportunities[0].RecordTypeId = oppDirectRecordTypeId;
			opportunities[1].RecordTypeId = oppDirectRecordTypeId;
			opportunities[2].RecordTypeId = oppDirectRecordTypeId;
			opportunities[2].stageName = GlobalConstants.OBSOLETE;
			opportunities[2].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
			opportunities[2].Oppty_Completion_Date__c = System.today() + 30;
			insert opportunities;
			opptyIds=new List<Id>((new Map<Id,Opportunity>(opportunities)).keySet());
		}

	}

	static testMethod void taskCreationDeletionTest() {
		setup();
		List<Task> taskCreationList = TestDataFactory.TaskCreation(size);
		List<Id> createdTasks = new List<Id>();
		Integer index = 0;
		for(Task task : taskCreationList){
			task.whatId = opptyIds[index];
			index++;
		}
		Opportunity oppToClose = new Opportunity(Id=opptyIds[0],StageName = GlobalConstants.OBSOLETE, Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON);
		Test.startTest();
		Database.SaveResult[] results;
		System.runAs(userSysAdmin){
			results = Database.insert(taskCreationList, false);
			for(Database.SaveResult result : results){
				if(result.isSuccess()){
					createdTasks.add(result.getId());
				}
			}
			update oppToClose;
		}
		System.runAs(userSales){
			Database.delete(createdTasks);
		}
		Test.stopTest();
	}

	static testMethod void taskIWACreation(){
		setup();
		String taskPrefix = 'APTS_IWA';
		insert new Apttus_Approval__ApprovalsSystemProperties__c(Name='Approval Properties',Apttus_Approval__ApprovalTaskPrefix__c=taskPrefix);

		List<Task> taskCreationList = TestDataFactory.TaskCreation(1);
		taskCreationList[0].whatId = opptyIds[0];
		taskCreationList[0].Subject = taskPrefix + ' Approval request assigned';
		System.runAs(userSysAdmin){
			Database.insert(taskCreationList, false);
		}
	}

}
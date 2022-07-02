public without sharing class CRM_OppContactRoles_listViewController
{
	@AuraEnabled
	public static WrapperFull getOppContactRolesApex(Id oppId)
	{
		WrapperFull wrapper = new WrapperFull();
		try
		{
			wrapper.contactRoleWrapperList = new List<WrapperOppContactRole>();
			wrapper.uncontactActivities= new List<Task>();
			wrapper.accContactList = new List<CRM_CustomLookupController.RecordsData>();
			wrapper.contactIdValuesMap = new Map<Id,Contact>();
			wrapper.oppId = oppId;
			wrapper.rolePLV = getPicklistValues('OpportunityContactRole','Role');
			wrapper.opinionPLV = getPicklistValues('OpportunityContactRole','Opinion_of_Nokia__c');
			wrapper.engagementPLV = getPicklistValues('OpportunityContactRole','Engagement_Level__c');
			wrapper.taskPriorityPLV = getPicklistValues('Task','Priority');
			wrapper.taskStatusPLV = getPicklistValues('Task','Status');
			Opportunity oppRecord = [SELECT Id, AccountId,
				(SELECT Id, Contact.Name, Role, Opinion_of_Nokia__c, Engagement_Level__c, Contact.Purchasing_Role_Sales__c, Contact.Attitude__c, ContactId, OpportunityId, Opportunity.AccountId, Contact.accName__c FROM OpportunityContactRoles)
			 FROM Opportunity WHERE Id = :oppId];

			List<OpportunityContactRole> oppContactRoles = oppRecord.OpportunityContactRoles;
			Set<Id> contactIdSet = getUniqueContactId(oppContactRoles);//(new Map<Id,OpportunityContactRole>(oppContactRoles)).keySet();
			String subjectFilter =  Label.CRM_WinPlanPrefix + '%';
			List<Task> taskList = [SELECT Id, Subject, OwnerId, Owner.Name, Status, ActivityDate, Description, Priority, IsReminderSet, ReminderDateTime, whoid, whatid FROM Task WHERE whatid = :oppId AND Subject like :subjectFilter  ];

			for (Contact c : [SELECT Id, Name, Attitude__c, Purchasing_Role_Sales__c, AccountId, accName__c FROM Contact WHERE AccountId = :oppRecord.AccountId OR Id IN :contactIdSet])
			{
	wrapper.accContactList.add(new CRM_CustomLookupController.RecordsData(c.Name, '' + c.Id));
	wrapper.contactIdValuesMap.put(c.Id, c);
			}

			for(OpportunityContactRole cr : oppContactRoles)
			{
	WrapperOppContactRole wrapperCR = new WrapperOppContactRole();
	wrapperCR.Id = cr.Id;
	wrapperCR.oppId = wrapper.oppId;
	wrapperCR.contactId = cr.ContactId;
	wrapperCR.contactName = cr.Contact.Name;
	wrapperCR.role = cr.Role;
	wrapperCR.opinionOfNokia = cr.Opinion_of_Nokia__c;
	wrapperCR.engagementLevel = cr.Engagement_Level__c;
	wrapperCR.contactRole = cr.Contact.Purchasing_Role_Sales__c;
	wrapperCR.contactAttitude = cr.Contact.Attitude__c;
	wrapperCR.contactActivities = new List<Task>();
	wrapperCR.accName = cr.Contact.accName__c;

	//Setting up aux variables
	wrapperCR.showActivities = false;
	wrapperCR.readMode = true;

	for(Task t : taskList)
	{
		if(cr.ContactId.equals(t.whoid))
		{
			t.Subject = t.Subject.replace(Label.CRM_WinPlanPrefix, '');
			wrapperCR.contactActivities.add(t);
		}
	}
	wrapper.contactRoleWrapperList.add(wrapperCR);
			}
			for(Task t : taskList)
			{
	if(t.whoid == null)
	{
		t.Subject = t.Subject.replace(Label.CRM_WinPlanPrefix, '');
		wrapper.uncontactActivities.add(t);
	}
			}
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}

	@AuraEnabled
	public static Contact getContactDetailsApex(Id contactId)
	{
		try
		{
			return [SELECT Id, Name, Attitude__c, Purchasing_Role_Sales__c, AccountId, accName__c FROM Contact WHERE Id = :contactId];
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
			}
			else
			{
				throw new AuraHandledException(err.getMessage());
			}
		}
	}

	@AuraEnabled
	public static WrapperOppContactRole saveContactRoleApex(WrapperOppContactRole contactRoleWrapper)
	{
		try
		{
			Boolean isCreation = ( contactRoleWrapper.Id == null );	   
			OpportunityContactRole cr = new OpportunityContactRole();
			cr.Id = contactRoleWrapper.Id;
			cr.ContactId = contactRoleWrapper.contactId;//Id.valueOf('0030500000J7fJUAAZ');
			if(isCreation)
			{
				cr.OpportunityId = contactRoleWrapper.oppId;
			}
			cr.Role = contactRoleWrapper.role;
			cr.Opinion_of_Nokia__c = contactRoleWrapper.opinionOfNokia;
			cr.Engagement_Level__c = contactRoleWrapper.engagementLevel;
			upsert cr;

			if(isCreation)
			{
				contactRoleWrapper.Id = cr.Id;
			}

			if(contactRoleWrapper.ContactId != null)
			{
				List<Contact> contactRecList = [Select Name From Contact Where Id = :contactRoleWrapper.ContactId LIMIT 1];
				contactRoleWrapper.contactName = contactRecList[0].Name;
			}
			contactRoleWrapper.readMode = true;
		}
		catch(DMLException err)
		{
			contactRoleWrapper.errorMessage = err.getDmlMessage(0);
		}		  
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				contactRoleWrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				contactRoleWrapper.errorMessage = err.getMessage();
			}
		}
		return contactRoleWrapper;
	}

	@AuraEnabled
	public static WrapperFull deleteContactRoleApex(WrapperOppContactRole contactRoleWrapper)
	{
		WrapperFull wrapper = new WrapperFull();
		try
		{
			OpportunityContactRole cr = [SELECT Id FROM OpportunityContactRole WHERE Id = :contactRoleWrapper.Id];
			delete cr;
			wrapper.successMessage = 'Contact Role was successfully deleted.';
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}		   
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}
	@AuraEnabled
	public static WrapperFull updateCreateTaskApex(Task task)
	{
		WrapperFull wrapper = new WrapperFull();
		task.Subject = Label.CRM_WinPlanPrefix + task.Subject;
		try
		{
			upsert task;
			wrapper = getOppContactRolesApex(task.whatId);
			wrapper.successMessage = 'Task updated / created successfully.';
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				String message = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}

	@AuraEnabled
	public static WrapperFull deleteActivityApex(Task task)
	{
		WrapperFull wrapper = new WrapperFull();
		try
		{
			Id oppId = task.whatid;
			List<Task> tasksToDelete = new List<Task>();
			tasksToDelete.add(task);
			delete tasksToDelete;
			wrapper.successMessage = 'Task was successfully deleted.';
			wrapper = getOppContactRolesApex(oppId);
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}

	private static Map<String, String> getPicklistValues(String objectName, String fieldName){
		Map<String, String> options = new Map<String, String>();	   

		Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
		Schema.DescribeSObjectResult r = s.getDescribe() ;
		Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
		Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for( Schema.PicklistEntry pickListVal : ple){
			options.put(pickListVal.getValue(), pickListVal.getLabel());
		}
		return options;
	}

	private static Set<Id> getUniqueContactId(List<OpportunityContactRole> oppContactRoles)
	{
		Set<Id> uniqueContactIds = new Set<Id>();
		for( OpportunityContactRole opc  : oppContactRoles )
		{
			uniqueContactIds.add(opc.contactId);
		}
		return uniqueContactIds;
	}
	/** WRAPPER CLASSES**/
	public class WrapperFull
	{
		@AuraEnabled
		public Id oppId  {get;set;}
		@AuraEnabled
		public String comments  {get;set;}
		@AuraEnabled
		public List<WrapperOppContactRole> contactRoleWrapperList {get;set;}
		@AuraEnabled
		public List<Task> uncontactActivities  {get;set;}
		@AuraEnabled
		public Map<String, String> rolePLV  {get;set;}
		@AuraEnabled
		public Map<String, String> opinionPLV  {get;set;}
		@AuraEnabled
		public Map<String, String> engagementPLV  {get;set;}
		@AuraEnabled
		public Map<String, String> taskPriorityPLV  {get;set;}
		@AuraEnabled
		public Map<String, String> taskStatusPLV  {get;set;}
		@AuraEnabled
		public List<CRM_CustomLookupController.RecordsData> accContactList  {get;set;}
		@AuraEnabled
		public Map<Id,Contact> contactIdValuesMap  {get;set;}
		@AuraEnabled
		public String successMessage {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
	}

	public class WrapperOppContactRole
	{ 
		@AuraEnabled
		public Id Id  {get;set;}
		@AuraEnabled
		public Id contactId  {get;set;}
		@AuraEnabled
		public Id oppId  {get;set;}
		@AuraEnabled
		public String contactName  {get;set;}
		@AuraEnabled
		public String accName  {get;set;}
		@AuraEnabled
		public String role  {get;set;}
		@AuraEnabled
		public String opinionOfNokia  {get;set;}
		@AuraEnabled
		public String engagementLevel  {get;set;}
		@AuraEnabled
		public String contactRole  {get;set;}
		@AuraEnabled
		public String contactAttitude  {get;set;}
		@AuraEnabled
		public List<Task> contactActivities  {get;set;}
		/*Aux fields */
		@AuraEnabled
		public Boolean showActivities  {get;set;}
		@AuraEnabled
		public Boolean readMode  {get;set;}
		@AuraEnabled
		public String successMessage {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
	}
}
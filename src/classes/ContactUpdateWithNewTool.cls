/**
	* @description: Class on User trigger
	* @author:	Accenture IDC.
	*
	* ============================================================================
	* History:
	* -------
	* 
	* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
	* 1.0				   16/08/2017   Secondary resources requirement
	* ============================================================================ 
	*/
	public with sharing class ContactUpdateWithNewTool {
		/**
		 * method param : set of contact id
		 * Method Name : updateContacts
		 * */
		@future
		public static void updateContacts(Set<Id> contactIds) {
			try
			{
			 List<Additional_Resource_Request__c> addTool=new List<Additional_Resource_Request__c>();
			 List<Contact> contactList=new List<Contact>();  
				set<Id> contSet = new set<Id>();
			   
			  for(Contact coninstance :[select id, account.name from contact 
								where Id In: contactIds AND account.name !=: PRMGlobalConstants.IndependentContractor  
							   Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				contSet.add(coninstance.id);
			}
			//Additional_Resource_Request__c newTool=new Additional_Resource_Request__c();
			for (ID contact : contSet) {
				Additional_Resource_Request__c newTool=new Additional_Resource_Request__c();
				newTool.Additional_Resource__c=PRMGlobalConstants.toolName;
				newTool.Request_Status__c=PRMGlobalConstants.Request_Status;
				newTool.Partner_Contact__c=contact;
				//insert newTool;
				addTool.add(newTool);
			}
			database.insert(addTool);
			//update contacts;
			}
			Catch(Exception e)
			{
		  ExceptionHandler.addException(e,PRMGlobalConstants.ContactFieldUpdateOnPartnerUserCreation,PRMGlobalConstants.updateContacts);
	
			}
			
		}
	}
public without sharing class PS_CreatePartnerTicket {

  public static final Set<String> picklistFields=new Set<String>{'PS_Communication_Language__c'};
  @AuraEnabled
  public static boolean getPartnerUserType()
  {
	if(UserInfo.getUserType()=='PowerPartner') 
	 return true;
	  else
	   return false;
	
  }
	@AuraEnabled
  public static Id  getPartnerCaseRecordTypeId()
  {
	Id partnerCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('PS_Partner_Support').getRecordTypeId();
	return  partnerCaseRecordTypeId;
  }
	@AuraEnabled
  public static Map<String,String>  getPartnerUserDetails()
  {
  Map<String,String> partnerDetailsMap= new Map<String,String>();   
  List<User> userList=[Select Id,Name,contactId from User where Id=:UserInfo.getUserId()];
  if(userList!=null&&!userList.isEmpty())
  {
  String userNameAndId=userList[0].Name+';'+userList[0].Id;
  partnerDetailsMap.put('User',userNameAndId);
  List<Contact> contactList=[Select Id,Account.Name,AccountId,Name from Contact where Id=:userList[0].contactId];
  if(contactList!=null&&!contactList.isEmpty())
  {
  String accountNameAndId=contactList[0].Account.Name+';'+contactList[0].AccountId;
  partnerDetailsMap.put('Account',accountNameAndId);	
  }
  }
  return partnerDetailsMap;
  }
  
	@AuraEnabled
	public static List<ListView> getAllAvailableListViews(){
		return [SELECT Name, DeveloperName FROM ListView WHERE SobjectType='Case'];
	}
	
	 @AuraEnabled
	public static String saveExternalCase(Case objcase){
	  String caseId='';
	  if(objcase!=null)
	  {
	   insert objcase;
	   caseId=objcase.id;
	  }
	 return caseId;
	}
	
	@AuraEnabled
	public static Map<String,List<String>> getPickListValues(){
		Map<String,List<String>> pickListMap = new Map<String,List<String>>();
	  
		// Get the describe for the object
			String objType='Case';
			DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(objType).getDescribe();
			//Iterate over all the picklist field  Api declared as the class member
			for(String fieldAPI:picklistFields)
			{
				//Fetch the values for each picklist and store in options
				Schema.DescribeFieldResult fieldResult = objResult.fields.getMap().get(fieldAPI).getDescribe();
				List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
				List<String> options=new List<String>();
				for (Schema.PicklistEntry f: ple) {
					options.add(f.getLabel());
				}
				//Fill the map with picklist field api as key and  set of picklist values
				pickListMap.put(fieldAPI,options);
			}
			
			//Populating the Type Field Picklist Values based on Partner Support Record Type
			List<String> typePickVals = Label.PS_PartnerSupportTicketTypeValues.split(',');
			if(typePickVals!=null && !typePickVals.isEmpty())
				pickListMap.put('Type', typePickVals);
			
		return pickListMap;
	}   
}
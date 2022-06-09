/*******************************
Class Name: NF_User_Helper
Created By: Accenture Nov-2018
Last Modified By: 
Last Modified Date:  
Description: Helper Class for User Trigger to delete SRT and Ut2A for inactive users
*******************************/
public class NF_User_Helper implements Queueable {
	Map<Id,User>usernew=new Map<Id,User>();
	
	public NF_User_Helper(Map<ID,User> UserMap){
		this.usernew=UserMap;
	}
	public void execute(QueueableContext QC){
		System.debug('UserNEW  '+usernew);
		Set<Id> userIdset = new Set<Id>();
		List<Sales_Role__c> SrList = new List<Sales_Role__c>();
		List<UserTerritory2Association> Ut2aList = new List<UserTerritory2Association>();
		List<sObject> deleteList = new List<sObject>();
		try{
			for(User user_data : UserNew.Values())
			{
	/*SF Ticket #00347714- DEM0051154 - Commented "user_data.Admin_Notes__c.Contains(Label.NF_LoATool)"
					 and added "user_data.LoA_Tool__c" in below lines*/
	
	//if (user_data.IsActive == false && (user_data.Admin_Notes__c == NULL || user_data.Admin_Notes__c.equalsignorecase(GlobalConstants.BLANK_VALUE) ||user_data.Admin_Notes__c <> Null && !(user_data.Admin_Notes__c.Contains(Label.NF_CSP_HERA) || user_data.Admin_Notes__c.Contains(Label.NF_LoATool))))
	if (user_data.IsActive == false && (user_data.Admin_Notes__c == NULL || user_data.Admin_Notes__c.equalsignorecase(GlobalConstants.BLANK_VALUE) || (user_data.Admin_Notes__c <> Null && !user_data.Admin_Notes__c.Contains(Label.NF_CSP_HERA))) && user_data.LoA_Tool__c==false)
			userIdset.add(user_data.Id);
	
				//System.debug('AvnUserID::> '+user_data.Id);
			}
			SrList = [SELECT Active__c,Id,NSA__c,Organisation__c,Role_Code__c,Role_Name__c,User_Nokia_ID__c,User__c 
		  FROM Sales_Role__c WHERE User__c IN :userIDSet AND Role_Name__c != :Label.NF_CTHead];
	
			Ut2aList = [SELECT Id,IsActive,RoleInTerritory2,Territory2Id,UserId 
			FROM UserTerritory2Association WHERE UserId IN :userIDSet AND RoleInTerritory2 != :Label.NF_CTHead];
	
			deleteList.addAll(SrList);
			deleteList.addAll(Ut2aList);
			//System.debug('deleteList::> '+deleteList);
			if(!deleteList.IsEmpty()){
	List<Database.DeleteResult> results = Database.delete(deleteList,false);
	//System.debug('results::> '+results);}
			}
		}
		catch(Exception ex){
			//System.debug('Exception::> '+ex);
			ExceptionHandler.addException(ex, GlobalConstants.NF_USERHELPER , GlobalConstants.METHOD_DELETEUSERRELATEDENTRIES);
		}  
	}	
}
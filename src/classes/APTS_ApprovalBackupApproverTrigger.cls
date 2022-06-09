/*
** @author : Apttus
** @date : 06/02/2017
** @description : Populate the Delegate Users names 
*/


Public class APTS_ApprovalBackupApproverTrigger{
	Public static void BeforeInsert(List<Apttus_Approval__Backup_Approver__c> lstNew){
		PopulateDelegateUserName(lstNew);	
	}
	
	Public static void BeforeUpdate(List<Apttus_Approval__Backup_Approver__c> lstNew){
		PopulateDelegateUserName(lstNew);
	}
	
	public static void PopulateDelegateUserName(List<Apttus_Approval__Backup_Approver__c> lstNew){
		Set<string> setAllUserId = new Set<String>();
		for(Apttus_Approval__Backup_Approver__c objLstNew :lstNew){
			if(!String.IsBlank(objLstNew.Apttus_Approval__DelegateUserIds__c)){
				 for(string str: objLstNew.Apttus_Approval__DelegateUserIds__c.Split(',')){
					 setAllUserId.add(str.Trim()); 
				 }
			}
		}
		
		Map<Id,User> mapUser = new Map<Id,User>();
		if(setAllUserId.Size() > 0){
			mapUser = new Map<Id,User>([select id,Name from User where id IN: setAllUserId]);
		}
		for(Apttus_Approval__Backup_Approver__c objLstNew :lstNew){
			objLstNew.Delegate_All_User_Names__c= '';
			for(string str: objLstNew.Apttus_Approval__DelegateUserIds__c.Split(',')){
				 If(mapUser.Containskey(str)){
					 objLstNew.Delegate_All_User_Names__c += mapUser.get(str).Name + ',';
				 }
			 }
			 objLstNew.Delegate_All_User_Names__c = objLstNew.Delegate_All_User_Names__c.RemoveStart(',').RemoveEnd(',');
		}
	}
	


}
/**	
	About   
	-----
	Description: Class to manage entitlements for Internal User in the customer community
	
	Created for: Nokia Customer Portal 
	Created date: 05 15 2018
	
	Details / Methods   
	-----------------	
   
	
	Update History	
	--------------	
	Created: 05 15 2018 – AES 
   
	Issues / TODOs  
	--------------
**/

public with sharing class NCP_InternalEntitlements {

	public static Set<String> searchInternalEntitlements(){

		Set<String> accessList  = new Set<String>(); 
		if(NCP_Utils.isUserAuthenticated()){
			for(NCP_Internal_Users_Services__c ser : [Select NCP_Service__c,Id From NCP_Internal_Users_Services__c Where NCP_User__c =:UserInfo.getUserId() OR NCP_All_Users__c =:NCP_Constants.YES_VALUE]){
	accessList.add(ser.NCP_Service__c);
	//system.debug('### ser.NCP_Service__c '+ser.NCP_Service__c);
			}
			//system.debug('### AES serviceList '+accessList);
		}
		return accessList;
	}

	public static Set<String> searchAllInternalEntitlements(){

		Set<String> accessList  = new Set<String>(); 
		if(NCP_Utils.isUserAuthenticated()){
			for (NCP_Service_Tile__mdt tiles :[SELECT NCP_Public_Access__c, NCP_Default_Access__c, NCP_Horizontal_User__c, NCP_Title__c, NCP_Description__c,
			 NCP_Entitlement_Access_Type__c, NCP_URL__c, NCP_Image_Name__c, NCP_Image_URL__c  FROM NCP_Service_Tile__mdt where NCP_Internal_User_Service__c = true]) {
			 if(String.isNotBlank(tiles.NCP_Entitlement_Access_Type__c)){
		accessList.add(tiles.NCP_Entitlement_Access_Type__c);
	}
			}
		}
		//system.debug('### AES all serviceList '+accessList);
		return accessList;
	}
}
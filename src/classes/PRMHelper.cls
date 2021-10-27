/***
* Helper Class created for PRM components 
* Created By: Joao Rodrigues - COE Sales team - Portugal
* Created Date: 18/12/2019
***/
public class PRMHelper 
{
	public static Id getBpDetails(Id parentId) 
	{
		Id ObjId = parentId;
		Business_Plan__c bp = new Business_Plan__c();
		Schema.SObjectType sobjectType = parentId.getSObjectType();
		String sobjectName = sobjectType.getDescribe().getName();
		if(sobjectName == GlobalConstants.BUSINESS_PLAN_APINAME)
		{
			bp = [SELECT Id, Account_BP__c FROM Business_Plan__c WHERE Id = :parentId LIMIT : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			if(bp != null) 
			{
	ObjId = bp.Account_BP__c;
			}
		}
		return ObjId;
	}
	
	public static  Map<Id, String> getDistAndIR(Id parentId, boolean filterResults)
	{
		Map<Id, String> resellersId2ParnterMap = new Map<Id, String>();
		if( !filterResults || checkAccountMemberRole(parentId) ) //Only present indirect reseller data if the user is an external PRM or internal 
		{
			//Get partners that are indirect resellers Ids
			List<Partner> partnersList = [SELECT AccountToId, role FROM Partner WHERE AccountFromId = :parentId and role = :GlobalConstants.PARTNER_TYPE_IR and Partner.AccountFrom.Partner_Type__c = :GlobalConstants.PARTNER_TYPE_DISTR];
			for(Partner p:partnersList)
			{
				resellersId2ParnterMap.put(p.AccountToId, p.role);
			}
		}
		return resellersId2ParnterMap;
	}
	
	public static Set<Id> getSetFromMap(Map<Id, String> partnersId2RoleMap)
	{
		Set<Id> partnerSet = new Set<Id>();
		for(Id partnerId : partnersId2RoleMap.keySet())
		{
			partnerSet.add(partnerId);
		}
		return partnerSet;
	}
	
	public static boolean checkAccountMemberRole(Id parentId)
	{
		boolean accessGranted = false;
		String userType = UserInfo.getUserType();
		List<Account_Member__c> amRec = [SELECT Id FROM Account_Member__c WHERE Account__c = :parentId AND Name__c = :UserInfo.getUserId() AND Account_Role__c in (:GlobalConstants.ACC_MBR_TRAINING_MANAGER, :GlobalConstants.ACC_MEMBER_PRM) ];
		if( userType.equals(GlobalConstants.COLLABORATION_ROLE_STANDARD) || !amRec.isEmpty() )//Only present indirect reseller data if the user is an external PRM or internal 
		{
			accessGranted = true;
		}
		return accessGranted;
	}
	
	public static Set<String> orderSet(Set<String> setToOrder)
	{
		Set<String> orderedSet = new Set<String>();
		List<String> listToOrder = new List<String>(setToOrder);
		listToOrder.sort();
		orderedSet.addAll(listToOrder);
		return orderedSet;
	}
}
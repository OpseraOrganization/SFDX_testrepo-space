/**********************************************************************************************************************
* Class Name - NCP_GetChatterGroupsForNDA 
* author: Karan Monga
* Date: Aug -2021
* Description: Apex Class created for accessing colloboration group data which is not accessible via with sharing class NCP_GetUserEntitleMentsAndProductsForNDA
* UpdatedBy: Karan Monga
* Update:  
********************************************************************************************************************* */
public without sharing class NCP_GetChatterGroupsForNDA {
  public static List<CollaborationGroupMember> getCollaborationGroupMember(Id userId){
	List<CollaborationGroupMember> collgrpMember = [SELECT Id, CollaborationGroupId,CollaborationGroup.Name FROM CollaborationGroupMember WHERE MemberId =:userId];
	return collgrpMember;
  }
}
/*Class Name - CollaborationGroupTriggerHelper
*This class is being called from CollaborationGroupTriggerHandler
*/
public class CollaborationGroupTriggerHelper {
	
	public static void beforeInsertTriggerHandle() {
		String CustomerCommunityName = 'Customers';
		String PermissionSetName = 'DCP_Chatter_Permission';
		String communityId=Network.getNetworkId();		
		string loginUID = UserInfo.getUserId();
		User u = [select ID,profileID from User where ID=: loginUID];
		
		if(Test.isRunningTest()){   
			List<Network> networkList = [select ID,Name from Network where Name = :CustomerCommunityName];  
			if(networkList.size() > 0) {
				communityId = networkList[0].Id;
			}
		}	
		
		if(communityID!=null){
			String CommunityName=ConnectApi.Communities.getCommunity(communityId).name;
			
			if(CommunityName == CustomerCommunityName){
				if(Trigger.isInsert){										
					Set<String> cGroupOwnerIDSet = new Set<String>();
					For(CollaborationGroup cGroup:(List<CollaborationGroup>)Trigger.New){
						cGroupOwnerIDSet.add(cGroup.OwnerId);
					}
					Set<Id> permissionSetSet = new Set<Id>();
					for(PermissionSetAssignment psAssignment : [SELECT Id, PermissionSetId, 
																PermissionSet.Name, PermissionSet.ProfileId, 
																PermissionSet.Profile.Name, AssigneeId, 
																Assignee.Name FROM PermissionSetAssignment 
																WHERE PermissionSet.Name =: PermissionSetName and 
																AssigneeId In : cGroupOwnerIDSet]) 
					{
						permissionSetSet.add(psAssignment.AssigneeId);  
					}  
					
					
					For(CollaborationGroup cGroup:(List<CollaborationGroup>)Trigger.New){
						String cGroupOwnerID = cGroup.OwnerID;						 
						if(!permissionSetSet.contains(cGroupOwnerID)){
							cGroup.addError('You do not have sufficient privileges to create a group. <br> * If you are a CaPM, Please contact "collaboration.supportportal@nokia.com". * If you are not a CaPM, please contact CaPM of your customer. * If you were trying to create a group for DevOps or Enterprise customer, please contact “collaboration.supportportal@nokia.com"');  
							
						} 
						if(cGroup.CollaborationType == 'Public'){
							cGroup.addError('Creation of Public groups is not allowed on Support Portal. Please select an alternate “Access Type”');   
						}
					}   
				}		 
			}
		}
	}
	
	public static void beforeUpdateTriggerHandle() {
		String communityId=Network.getNetworkId();
		String PermissionSetName = 'DCP_Chatter_Permission'; 
		string loginUID = UserInfo.getUserId(); 
		User u = [select ID,profileID from User where ID=: loginUID];
		String CustomersProfileName = 'Customers';
		String CustomersLoginProfileName = 'Customers Login';
		String PublicGroupCollaborationType = 'Public';
		if(Test.isRunningTest()){			
			communityId = [select ID,Name from Network where Name = 'Customers'].ID ;			
		}
		
		if(communityID!=null){
			String CommunityName=ConnectApi.Communities.getCommunity(communityId).name;
			
			if(CommunityName=='Customers'){
				Set<String> cGroupOwnerIDSet = new Set<String>();
				For(CollaborationGroup cGroup: (List<CollaborationGroup>)Trigger.New){
					cGroupOwnerIDSet.add(cGroup.OwnerID);
				}				
				Map<Id, String> userIdwithProfileNameMap = new Map<Id, String>();
				
				for(User userObj: [select Id, Profile.Name from User where Id in : cGroupOwnerIDSet]) {
					userIdwithProfileNameMap.put(userObj.Id , userObj.Profile.Name);
				}				
				For(CollaborationGroup cGroup: (List<CollaborationGroup>)Trigger.New){												
					String profileName = userIdwithProfileNameMap.get(cGroup.OwnerID);
					if(profileName == CustomersProfileName || profileName == CustomersLoginProfileName){
						cGroup.addError('Group Ownership cannot be transferred to an external user in Support Portal');  
					}
					if(cGroup.CollaborationType == PublicGroupCollaborationType){
						cGroup.addError('Creation of Public groups is not allowed on Support Portal. Please select an alternate “Access Type”');   
					}		   
				}						   
			}
		}
	}
}
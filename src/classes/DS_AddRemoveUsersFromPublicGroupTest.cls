@isTest
public class DS_AddRemoveUsersFromPublicGroupTest {
   
	@isTest
	static void addremove(){
		List<GroupMember> gmlist=new List<Groupmember>();
		List<PermissionSetAssignment> pmlist=new List<PermissionSetAssignment>();
	String groupId;
		
		test.startTest();
		List<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		PermissionSet permission1 = [SELECT Name, Id, Description, Type 
									 FROM PermissionSet 
									 where name = 'DS_CLM'];
		PermissionSetAssignment pm=new PermissionSetAssignment();
		pm.AssigneeId=userCreation[0].id;
		pm.PermissionSetId=permission1.Id;
		pmlist.add(pm);
		database.insert(pmlist,false);
		
		Group groupName = [Select Id,DeveloperName 
						   from Group 
						   where DeveloperName = :CSWXGlobalConstant.Order_Management_Group Limit 1];
		if(groupName <> null)
			groupId = groupName.Id;
		
					  GroupMember gm = new GroupMember();
						gm.UserOrGroupId = userCreation[1].id;
						gm.GroupId = groupId;
					   gmlist.add(gm);
					 database.insert(gmlist,false);
				
		List<sObject> sObjectList = new List<sObject>();
		sObjectList.addAll(pmList);
		sObjectList.addAll(gmlist);
		
					 DSBatch_AddRemoveUsersFromPublicGroup batch = new DSBatch_AddRemoveUsersFromPublicGroup();
					  Database.BatchableContext BC; 
					  batch.start(BC);
					  batch.execute(BC,sObjectList);
					  batch.execute(null,null);
		test.stopTest();
				  
	}
}
@isTest(seeallData=true)
private class CollaborationGroupTriggerTest {

	/***********************
	* Method Name: Collaboration Group 
	* Description: Collaboration Group Validation
	* Parameters: NA
	************************/ 
	static testMethod void CollaborationGroupTest(){
	
		String n = network.getnetworkid() ;
		
		String communityID = NULL;
		User user = [select id,Name from User where Name = 'Informatica User' and isACTIVE = TRUE LIMIT 1];
		Id currentUserId = UserInfo.getUserId();	
		User usr = [select id,Name from User where id =: currentUserId]; 
		User pu;	
		CollaborationGroup cg1;
		CollaborationGroup cg2;
			
		system.runas(user){
			Account acc = NCP_TestFactory.createAccount();
			Contact c = NCP_TestFactory.createContact(acc);
	
			Profile p = [select id from profile where Name = 'Customers'  limit 1];  
		
			String testemail = 'puser000@amamama.com';
			pu = new User(profileId = p.id, username = testemail, email = testemail,
							   emailencodingkey = 'UTF-8', localesidkey = 'en_US',
							   languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
							   alias='cspu', lastname='lastname', contactId = c.id );
			
			insert pu ;
		}			  
			List<NetworkMember> membership = [SELECT network.name, networkID, memberID FROM NetworkMember WHERE memberID = :pu.id  ];   
			
			For(NetworkMember nm: membership){
			
				system.debug('##NM:'+nm);
				if(nm.network.name == 'Customers') {			 
					communityID = nm.networkID;
						if(communityID != NULL){
							Try{		 
								system.runAs(usr){
															
									system.debug('Test User Inside Network'+network.getnetworkid());
								  
									CollaborationGroup cg = new CollaborationGroup();
									cg.CollaborationType = 'Public' ;
									cg.NetworkId = communityId ;
									cg.Name = 'Test Name Group' ;
									cg.OwnerID = UserInfo.getUserId(); 
									insert cg;		
											   
								}
							}
							Catch(Exception E){
								Try{
									PermissionSet ps = [select ID, Name from Permissionset where Name = 'DCP_Chatter_Permission' LIMIT 1];
									
									PermissionsetAssignment psa = new  PermissionsetAssignment();
									psa.AssigneeId = usr.ID ;
									psa.PermissionSetId = ps.ID;
									insert psa; 
									

									system.runAs(usr){
									
										system.debug('Test User Inside Network2:'+network.getnetworkid());
									
										cg1 = new CollaborationGroup();
										cg1.CollaborationType = 'Public' ;
										cg1.NetworkId = communityID ;
										cg1.Name = 'Test Name Group2' ;
										cg1.OwnerID = UserInfo.getUserId(); 
										insert cg1;	
									 }
								 }Catch(Exception E1){
									 Try{
										system.runAs(usr){   
										
											cg2 = new CollaborationGroup();
											cg2.CollaborationType = 'Private' ;
											cg2.NetworkId = communityID ;
											cg2.Name = 'Test Name Group2' ;
											cg2.OwnerID = UserInfo.getUserId(); 
											insert cg2;							  
										
										} 
										system.runAs(pu){
											system.debug('Inside the PU class');
											cg2.ID = cg2.ID;
											cg2.OwnerId = pu.ID;
											cg2.Name = 'Test Name Customers' ;
											update cg2;
										}																				 
									 }								   
									 Catch(Exception E2){}
								 }
							 }									   
						}		
				}
			}	  
	}
}
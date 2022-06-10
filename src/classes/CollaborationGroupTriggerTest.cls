@isTest(seeAllData=True)
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
	  
		Contact cont = new Contact();
		cont.AccountId = acc.Id;
		cont.FirstName = 'First Name';
		cont.LastName = 'Last Name';
		cont.Email = 'test@salesforceTest.com';
		cont.City__c = 'City';
		cont.Street__c = 'Street';
		cont.State__c = 'State';
		cont.Country__c = 'Country';
		cont.Phone = '0550222333';
		cont.CH_ContactTimeZone__c = '(GMT+14:00) Line Islands Time (Pacific/Kiritimati)';
		cont.CH_PreferredMtdOfServiceCommunication__c = 'Email ';
		
		insert cont;
  
	  Profile p = [select id from profile where Name = 'Customers'  limit 1];  
	
	  String testemail = 'puser000@amamama.com';
	  pu = new User(profileId = p.id, username = testemail, email = testemail,
				 emailencodingkey = 'UTF-8', localesidkey = 'en_US',
				 languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
				 alias='cspu', lastname='lastname', contactId = cont.id );
	  
	  insert pu ;
	}	   
	  List<NetworkMember> membership = [SELECT network.name, networkID, memberID FROM NetworkMember WHERE memberID = :pu.id and network.Name = 'Customers'  LIMIT 1];   
	  
  //	For(NetworkMember nm: membership){
  //	if(membership.size() > 0){  
  //	 system.debug('##NM:'+nm);
  //	  if(membership[0].network.name == 'Customers') {   
if((membership.size() > 0) && (membership[0].network.name == 'Customers')){  
		  communityID = membership[0].networkID;
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

					  cg2.OwnerId = pu.ID;
					  cg2.Name = 'Test Name Customers' ;
					  update cg2;
					}										
				   }				   
				   Catch(Exception E2) {system.debug('cg2.NetworkId:'+cg2.NetworkId);}
				 }
			   }					 
			}   
		}
  
	  } 
  }
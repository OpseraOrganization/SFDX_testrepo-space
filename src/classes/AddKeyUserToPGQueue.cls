//Class : Queueable apex to add user in respective Market public group	
	
public class AddKeyUserToPGQueue implements Queueable 
	{		
	set<ID> UsersToAdd;
	Map<String, ID> mapMarketPublicGroup = new Map<String, ID>();
	
	public AddKeyUserToPGQueue(Set<ID> UsersToAdd){
		this.UsersToAdd = UsersToAdd;
	}
	  
	public void execute(QueueableContext context) 
	{
		 List<Group> KeyuserPG = [select id, name from Group where name like 'Key Users%'];
		 list<string> pgnameList = new List<String>();
		for(Group PG : KeyuserPG){
		pgnameList.add(PG.name);
		//String PGName = PG.name;
		//String MarketName = PGName.substring(10);
		System.debug('Public group name  :' + PG.name);
		
		}
		if(pgnameList.size()>0)
		{
			List<Matket_Key_User_Group__mdt> MarketPGList =  [Select Public_Group_ID__c, MasterLabel from Matket_Key_User_Group__mdt where Public_Group_name__c IN: pgnameList ];
			for(Matket_Key_User_Group__mdt mar : MarketPGList)
			{
					mapMarketPublicGroup.put(mar.MasterLabel , mar.Public_Group_ID__c);
					system.debug('Market Name from Metadata' +mar.MasterLabel);
			}
		}
		
		
		
		//System.debug('Market and public group mapp : '+mapMarketPublicGroup);
				   
		List<GroupMember> AddGMlist = new List<GroupMember>();
		List <User> removeUserID = new List<User>();
		
		for(User UsersToAdd : [select id, isactive, Market__c, Is_Key_User__c from user where id =: UsersToAdd ]) {
			
			If(UsersToAdd.isActive && UsersToAdd.Is_Key_User__c  == True){
			//Market_Key_Public_group__c PGId = Market_Key_Public_group__c.getValues(UsersToAdd.Market__c);
			GroupMember GM = new GroupMember();
			//GM.GroupId = PGId.Public_Group_ID__C;
			//System.debug('Public group ID is : ' + PGId.Public_Group_ID__C);
			GM.GroupId = mapMarketPublicGroup.get(UsersToAdd.Market__c);
			GM.UserOrGroupId = UsersToAdd.Id;
			AddGMlist.add(GM);		 
			}
		   else if(!UsersToAdd.Is_Key_User__c){
		   removeUserID.add(UsersToAdd);	
		   }	 
			
		}
		
		List <GroupMember> RemoveGMlist = [select id from GroupMember where UserOrGroupId IN: removeUserID AND GroupId IN:mapMarketPublicGroup.values()];
		System.Debug('RemoveGMlist : '+RemoveGMlist);
		
	if(!AddGMlist.isEmpty()) {
		Try{
		System.debug(' Add Group Member List is ' + AddGMlist);
		insert AddGMlist;
		
		}catch(exception Exp) {}
		 
	} 
		IF(!RemoveGMlist.isEmpty()){
		Try{
		System.debug('delete Group Member List is ' + AddGMlist);
		delete RemoveGMlist;
		
		}catch(exception Exp) {}
		}
		
	}
}
public class Utilities {
	//created by Reis Sónia 29/04/2019
	
	//Invocable Method to enable the use of OR logic in Users object, in a flow.
	@InvocableMethod(label='Get users OR logic' description='Returns a list of users corresponding to the specified IDs.')
	public static List<List<User>> GenericOrOFUsersForFlows(List<List<String>> ids ) {
		system.debug('cenas utilities : '+ids.size());
		
		Map<Integer, List<String>> positionListMap = new Map<Integer, List<String>>(); //to maintain the order in the end
		for(integer i=0; i<ids.size(); i++){
			positionListMap.put(i, ids[i]);
			system.debug('position'+ i + ': '+ ids[i]);
		}
		Set<String> allIdsSet = new Set<String>();
		
		if(Ids!=null && Ids.size()>0 && Ids[0].size()>0){
			for(List<String> listIDs : ids){
				if(listIDs.size()>0){
					allIdsSet.addAll(listIDs);
				}
			}
			
			List<User> allUsers = [select id, name from User where id=:allIdsSet];
			system.debug('cenas allusers : '+allUsers);
			
			Map<Id, User> idUsersMap = new Map<Id, User>();
			
			for(User u : allUsers){
				if(!idUsersMap.containsKey(u.id)){
					idUsersMap.put(u.id, u);
				}
			}
			
			List<List<User>> result = new List<List<User>>();
			
			for(Integer i : positionListMap.keyset()){
				List<String> idslist = positionListMap.get(i);
				List<User> users = new List<User>();
				for(String theID : idslist){
					users.add(idUsersMap.get(theID));
				}
				result.add(users);
			}
			
			return result;
		}
		else{
			return new List<List<User>> ();
		}
	}
	
}
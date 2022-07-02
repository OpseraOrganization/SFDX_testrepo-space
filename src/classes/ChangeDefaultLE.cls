/****************************************
* Class Name : ChangeDefaultLE
* Created Date: 22 August 2017
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 22 August 2017
* Description : Default one can remain inactive, but as soon as active one becomes available in CMD this one replaces the inactive one. Daily job
* Test Class: 
*****************************************/
public class ChangeDefaultLE{
  public ChangeDefaultLE() {
	
  }
  
  private List<Account> modifiedDLEList = new List<Account>();
  
  /*******************************
*Method name: doChanges
*Description: This method will check if there is any inactive default Legal entity for a customer 
if there is any it will calculate the single DLE for that customer and add the changes in Batch
Parameter: None
*******************************/  
  public void doChanges(){
/*	//Start
	try{
	  Set<String> customerIdSet = new Set<String>();
	  for(Account acc1 : [SELECT Id,parentId,parent.name FROM Account 
				WHERE Default_Legal_Entity__c = true 
				AND Active__c = false 
				AND recordtype.name = 'Legal Entity']){
				  customerIdSet.add(acc1.parentId); 
				}
	  Set<String> customerIds = new Set<String>();
	  if(customerIdSet!=null && !customerIdSet.isEmpty()){
		for(Account acc2 : [select Id,parentId from account where recordtype.name = 'Legal Entity' 
				  and parentId In : customerIdSet 
				  and Active__c = true and parent.Id != null]){
					customerIds.add(acc2.parentId); 
				  }
	  }
	  //End
	  /*  
//Fetch All Inactive Default Legal Entities
List<Account> inactiveDLEs= [SELECT Id,parentId,parent.name FROM Account 
WHERE Default_Legal_Entity__c = true 
AND Active__c = false 
AND recordtype.name = 'Legal Entity'];
system.debug('Wrong data......'+inactiveDLEs.size());
List<string> customerIdList = new List<string>();
//Store Customer Ids for Default Legal Entities
for(Account acc : inactiveDLEs){
customerIdList.add(acc.parentId); 
}
//Fetch all active legal entities for customers having inactive default Legal Entities
List<AggregateResult> ars = [select count(Id),parentId from account 
where recordtype.name = 'Legal Entity' 
and parentId In : customerIdList 
and Active__c = true 
group by parentId 
having  count(Id)>=1 ]; 
system.debug('Wrong customer......'+ars.size());
List<String> customerIds = new List<String>();
//Store Customer Ids having active Legal Entities but Default Legal Entity is inactive
for(AggregateResult ar : ars ){
customerIds.add(ar.get('parentId')+'' ); 
}

	  List<Account>  finalList = [select Id,accountNumber,name,parentId,Active__c,Default_Legal_Entity__c,
					parent.accountnumber,parent.Id from account 
					where recordtype.name = 'Legal Entity' 
					and parentId In : customerIds];
	  set<string> parentIdSet = new Set<string>();
	  //Change default Legal entities from INactive to active one
	  for(Account acc : finalList ){
		if(!acc.Active__c ){
		  if(UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			if(acc.Default_Legal_Entity__c){
			  acc.Default_Legal_Entity__c = false;
			  system.debug(acc.Id+'   '+ acc.accountNumber+'   '+ acc.parent.accountnumber+'   '+ acc.parent.Id+'   '+ acc.Default_Legal_Entity__c+'  '+acc.name); 
			  modifiedDLEList.add(acc);
			}
		  }
		}else if(!parentIdSet.contains(acc.parentId)){
		  acc.Default_Legal_Entity__c = true; 
		  system.debug(acc.Id+'   '+ acc.accountNumber+'   '+ acc.parent.accountnumber+'   '+ acc.parent.Id+'   '+ acc.Default_Legal_Entity__c+'  '+acc.name); 
		  parentIdSet.add(acc.parentId); 
		  modifiedDLEList.add(acc);
		}
	  }
	}
	catch(Exception ex){
	  system.debug('Exception Occurred ' + ex + ' at Line No.' + ex.getLineNumber() +' with exception' + ex.getMessage());
	}
	//update finalList;
	//modifiedDLEList = finalList;
	//computeSingleDLE();
	//
	*/
  }
  
  /*******************************
*Method name: computeSingleDLE
*Description: This method will check if there is any multiple default Legal entities for a customer 
if ther is any it will calculate the single DLE for that customer and add the changes in Batch
Parameter: None
*******************************/  
  public void computeSingleDLE(){
	List<string> accids = new List<string>();
	List<AggregateResult> arList = [select count(Id), parentId 
				  from account 
				  where recordtype.name= 'Legal Entity' 
				  and Default_Legal_Entity__c = true
				  group by parentId 
				  having count(Id)>1 LIMIT 2000];
	
	for(AggregateResult ar : arList){
	  accids.add(ar.get('parentId')+'');
	  //system.debug('more than LE for accid...'+ar.get('parentId'));
	}
	system.debug('accids...'+accids.size());
	
	Set<String> customerIds = new Set<String>();
	//List<Account> updateList = new List<Account>();
	List<account> accList = [select Id, parentId,Default_Legal_Entity__c,parent.name 
			   from account 
			   where recordtype.name = 'Legal Entity'
			   and parentId in : accids
			   and Active__c = true
			   and parentId <> NULL
			   order by lastmodifieddate desc];
	system.debug('LElist...'+accList.size());
	
	for(account acc : accList){
	  //if(updateList.size()==5)
	  //  break;
	  system.debug('acc.parentId...'+acc.parentId);
	  system.debug('acc.parentId...'+acc.parent.name);
	  if(!customerIds.contains(acc.parentId)){
		acc.Default_Legal_Entity__c = true;
		customerIds.add(acc.parentId);
		modifiedDLEList.add(acc);
	  }  
	}
	  
	 // executeBatchUpdate();
	//Start   
   /*  try{   
	 Map<String, List<Account>> parentWithLEs = new Map<String, List<Account>>();
	  for(Account acc: [select Id, parentId 
				from account 
				where recordtype.name= 'Legal Entity' and parent.Id != null
				and Default_Legal_Entity__c = true]){ 
				  if(parentWithLEs.containsKey(acc.parentId))
				  {
					parentWithLEs.get(acc.parentId).add(acc);
				  }
				  else
				  {
					List<Account> lstAcc = new List<Account>();
					lstAcc.add(acc);
					parentWithLEs.put(acc.parentId,lstAcc);
				  }
				}
	  Set<string> accids = new Set<string>();
	  for(String parentAccID: parentWithLEs.keyset()){	  
		if(!parentWithLEs.get(parentAccID).isEmpty() && parentWithLEs.get(parentAccID) != NULL && parentWithLEs.get(parentAccID).size()>1){
		  accids.add(parentAccID);
		}
	  }
	  //
	  
		List<string> accids = new List<string>();
List<AggregateResult> arList = [select count(Id), parentId 
from account 
where recordtype.name= 'Legal Entity' 
and Default_Legal_Entity__c = true
group by parentId 
having count(Id)>1];

for(AggregateResult ar : arList){
accids.add(ar.get('parentId')+'');
//system.debug('more than LE for accid...'+ar.get('parentId'));
}
system.debug('accids...'+accids.size());

	  
	  Set<String> customerIds = new Set<String>();
	  //List<Account> updateList = new List<Account>();
	  List<account> accList = [select Id, parentId,Default_Legal_Entity__c,parent.name 
				   from account 
				   where recordtype.name = 'Legal Entity'
				   and parentId in : accids
				   and Active__c = true
				   and parent.Id <> NULL
				   order by lastmodifieddate desc];
	  system.debug('LElist...'+accList.size());
	  
	  for(account acc : accList){
		//if(updateList.size()==5)
		//  break;
		system.debug('acc.parentId...'+acc.parentId);
		system.debug('acc.parentId...'+acc.parent.name);
		if(!customerIds.contains(acc.parentId)){
		  acc.Default_Legal_Entity__c = true;
		  customerIds.add(acc.parentId);
		  modifiedDLEList.add(acc);
		}  
	  }
	}
	catch(Exception ex){
	  system.debug('Exception Occurred ' + ex + ' at Line No.' + ex.getLineNumber() +' with exception' + ex.getMessage());
	}
	// executeBatchUpdate();
	 */
		
  }
  
  /*******************************
*Method name: checkCustomersWithoutDLE
*Description: This method will check if there is any customer without Default legal Entity
if ther is any it will calculate the single DLE for that customer and add the changes in Batch
Parameter: None
*******************************/  
  public void checkCustomersWithoutDLE(){
	// Moved to UpdatewithoutDLEBatch 
	/*	//Start
try{
Set<String> allCustomers = new  Set<String>();
for(Account acc1: [select id,parentId from account 
where recordtype.name = 'Legal Entity' 
and Default_Legal_Entity__c = true ]){
allCustomers.add(acc1.parentId);
}

Set<String> customerIdSet = new  Set<String>();
if(allCustomers!=null && !allCustomers.isEmpty()){
for(Account acc2: [select Id,parentId from account 
where recordtype.name = 'Legal Entity' 
and parentId Not In : allCustomers]){
customerIdSet.add(acc2.parentId);
}
}

//


Set<string> customerIdSet = new Set<string>(); 
//Fetch all active legal entities for customers
List<AggregateResult> ars = [select count(Id),parentId from account 
where recordtype.name = 'Legal Entity' 
and Default_Legal_Entity__c = true 
group by parentId ]; 
List<String> customerIds = new List<String>();
//Store Customer Ids having active Legal Entities but Default Legal Entity is inactive
for(AggregateResult ar : ars ){
customerIds.add(ar.get('parentId')+'' ); 
}

List<AggregateResult>  noDLEList = [select count(Id),parentId from account 
where recordtype.name = 'Legal Entity' 
and parentId Not In : customerIds
group by parentId 
having count(Id)>0 ];

system.debug('customers not populated value....'+noDLEList.size()); 
for(AggregateResult ar : noDLEList ){
system.debug('customers not populated value....'+ar.get('parentId'));
customerIdSet.add(ar.get('parentId')+''); 
}

List<Account> legalEntityList = [select Id,name,Default_Legal_Entity__c,parentId from account 
where parentId In:customerIdSet
and Active__c = true];
Map<string,string> customerVsLE = new Map<string,string>();

for(Account legalEntity : legalEntityList){
if(!customerVsLE.containsKey(legalEntity.parentId)){
customerVsLE.put(legalEntity.parentId,legalEntity.Id);
modifiedDLEList.add(legalEntity);
}
}
}
catch(Exception ex){
system.debug('Exception Occurred ' + ex + ' at Line No.' + ex.getLineNumber() +' with exception' + ex.getMessage());
}
*/
  }
  
  /*******************************
*Method name: executeBatchUpdate
*Description: This method will run batch for updating default Legal Entity
Parameter: None
*******************************/  
  public void executeBatchUpdate(){
	system.debug('updateList...'+modifiedDLEList.size());
	//Database.update(updateList,false);
	UpdateSingleDLE batch = new UpdateSingleDLE(modifiedDLEList);
	batch.Query = 'SELECT ID,name,Default_Legal_Entity__c from account where Id in:updateList';
	Id batchInstanceId = Database.executeBatch(batch, 1);
  }
}
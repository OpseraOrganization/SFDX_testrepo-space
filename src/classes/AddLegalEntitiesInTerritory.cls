/****************************************
 * Class Name : AddLegalEntitiesInTerritory 
 * Created Date: 19 January 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 28 January 2017
 * Description : 1. Add Legal Entities in Parent customer associated Territories				 
 * Test Class: 
 *****************************************/
public class AddLegalEntitiesInTerritory implements Queueable {
	//To store Legal Entities which needs to add in Territory 
	private List<Account> LEList = new List<Account>();
	//To store customer vs Legal Entities  
	private Map<String,List<Account>> customerVsLEList = new Map<String,List<Account>>();
	
	/********************
	*Method Name: Constructor
	*Parameter: List of Legal Entities
	*Description: Used to store Legal Entities which need to be added in Territory
	*******************/
	public AddLegalEntitiesInTerritory(List<Account> accList){
			LEList = accList;
	} 
	
	public void execute(QueueableContext context) {
		try{ 
			//Delete Previous Terrritory Assciation Records if any
			deletePreviousTerrritoryAssciation();
			//Compute parent Customer with Legal enity list map
			computeCustomerVsLEList();
			//Create new Terroitory Association Records
			createNewTerroitoryAssociation();
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.ADDLEGALENTITIESINTERRITORY ,GlobalConstants.EXECUTE );
		}
	}
	
	/********************
	*Method Name: Constructor
	*Parameter: None
	*Description: Delete Previous Terrritory Assciation Records if any
	*******************/
	private void deletePreviousTerrritoryAssciation(){
		try{
			List<objectTerritory2Association> prevTerritoryAssociation = [select Id,objectId 
																			 from objectTerritory2Association
																			 where objectId IN : LEList limit :LEList.size()];
			if(!prevTerritoryAssociation.isEmpty()){
				Database.delete(prevTerritoryAssociation);
			}
		}catch(Exception exc){
		   ExceptionHandler.addException(exc,GlobalConstants.ADDLEGALENTITIESINTERRITORY ,GlobalConstants.DELETEPREVIOUSTERRITORYASSOCIATION );
		}																				 
	}
	
	/********************
	*Method Name: computeCustomerVsLEList
	*Parameter: None
	*Description: Compute parent Customer with Legal enity list map
	*******************/
	private void computeCustomerVsLEList(){
	   try{ 
			for(Account le : LEList){
				if(customerVsLEList.containsKey(le.parentId)){
					customerVsLEList.get(le.parentId).add(le);
				}else{
					customerVsLEList.put(le.parentId,new List<Account>{le});
				}	
			}
		}catch(Exception exc){
		   ExceptionHandler.addException(exc,GlobalConstants.ADDLEGALENTITIESINTERRITORY ,GlobalConstants.COMPUTECUSTOMERTVSLELIST );
		}  
	}
	
	/********************
	*Method Name: createNewTerroitoryAssociation
	*Parameter: None
	*Description: Create new Terroitory Association Records
	*******************/
	private void createNewTerroitoryAssociation() {
		try{
			List<ObjectTerritory2Association> newLETerritoryAssociation = new List<ObjectTerritory2Association>();
			List<ObjectTerritory2Association> parentTerritoryAssociation = [select Id,objectId,Territory2Id 
																				from ObjectTerritory2Association
																				where objectId IN : customerVsLEList.keySet()
																				and Territory2.Territory2Model.state <> 'Archived'
																				limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]; 
			
			Map<string,string> customerVsTerritoryId = new Map<string,string>();
			for(objectTerritory2Association customerTerritory : parentTerritoryAssociation ){
				for(Account le : customerVsLEList.get(customerTerritory.objectId)){
					objectTerritory2Association leTerritoryAssociation = new objectTerritory2Association();
					leTerritoryAssociation.objectId = le.Id;
					leTerritoryAssociation.Territory2Id = customerTerritory.Territory2Id;
					leTerritoryAssociation.AssociationCause = GlobalConstants.TERRITORY2MANUAL;
					newLETerritoryAssociation.add(leTerritoryAssociation);
				}
			}  
		   
			if(!newLETerritoryAssociation.isEmpty()){
				Database.insert(newLETerritoryAssociation);
			}
		}catch(Exception exc){
		   ExceptionHandler.addException(exc,GlobalConstants.ADDLEGALENTITIESINTERRITORY ,GlobalConstants.CREATENEWTERRITORYASSOCIATION );
		}																				  
	}
}
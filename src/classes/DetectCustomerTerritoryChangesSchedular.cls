/****************************************
 * Class Name : DetectCustomerTerritoryChangesSchedular 
 * Created Date: 24 January 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 28 January 2017
 * Description : 1. Check if territory assignment checged for any Customer type of account
				 2. Call AddLegalEntitiesInTerritory
 * Test Class: 
 *****************************************/
Global class DetectCustomerTerritoryChangesSchedular implements Schedulable {
   /********************
	*Method Name: execute
	*Parameter: SchedulableContext
	*Description: Used to detect the change in Customers Territory so that associated Legal Entity will get added in same Territory.
	*******************/
   Global void execute(SchedulableContext sc) {
		try{
			List<string> customerIdList = new List<string>();
			Datetime latsHour =DateTime.Now().addHours(-1);
			List<ObjectTerritory2Association> customerTerritoryList = [SELECT Id, ObjectId, Territory2Id, AssociationCause, SobjectType 
								 FROM ObjectTerritory2Association 
								 where object.recordtype.name =: GlobalConstants.CUSTOMER
								 and LastModifiedDate>= :latsHour  
								 limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			if(!customerTerritoryList.isEmpty()){
				for(ObjectTerritory2Association customerTerritory : customerTerritoryList ){
					customerIdList.add(customerTerritory.ObjectId);  
				}
				List<Account> LElist = [select Id,name,parentId from account 
											where parentId In : customerIdList
											limit : customerIdList.size()];
				if(!LElist.isEmpty()){
					System.enqueueJob(new AddLegalEntitiesInTerritory(LElist));
				}
			}
		 }catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.DETECTCUSTOMERTERRITORYCHANGESSCHEDULAR ,GlobalConstants.EXECUTE );
		}
   }
}
/*************************************************************************************************
 * Class Name : CH_reUsableMultiSelectLookupCtrl
 * Created Date: 15 April 2019
 * Created By : TCS
 * Descsription: Server Side Controller for MultiSelectLookup for Product 
 * Last Modified by: 
 * Last Modified Date: 
 * Description : 
*************************************************************************************************/
public class CH_reUsableMultiSelectLookupCtrl {

	/*****************************************************
	* Method Name : fetchLookUpValues
	* Created Date: 15 April 2019
	* Created By : Ganga Prasuna
	* Description:  Getting the selected records from the Product object
	* Parameter: NA
	* Return: selected records
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/  
   
	@AuraEnabled
	public static List < Product2 > fetchLookUpValues(String searchKeyWord, String ObjectName, List<Product2> ExcludeitemsList) {
	   List < Product2 > returnList = new List < Product2 > ();
		String searchKey = '%' + searchKeyWord + '%';
		List<String> lstExcludeitems = new List<String>();
		if(ExcludeitemsList.size()>0){
		for(Product2 item : ExcludeitemsList ){
			lstExcludeitems.add(item.id);
		}
		}  
		System.debug( ' lstExcludeitems'+lstExcludeitems);
		// Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
		String sQuery =  'select id, Name from Product2 where Name LIKE: searchKey  AND Id NOT IN : lstExcludeitems order by createdDate DESC limit 5';
		//String sQuery =  'select id, Name from Product2 where Name  IN : lstExcludeitems order by createdDate DESC limit 5';
		List < Product2 > lstOfRecords = Database.query(sQuery);
		for (Product2 obj: lstOfRecords) {
			returnList.add(obj);
		}
		return returnList;
	}
	
	/*****************************************************
	* Method Name : mapCaseToArticle
	* Created Date: 17 April 2019
	* Created By : Ganga Prasuna
	* Description: Getting the records from the Product and inserting in the Topic Object
	* Parameter: NA
	* Return: Created Records
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
	*******************************************/	
	
	@AuraEnabled
	public static List<Topic> mapCaseToArticle(String FinalId,List<Product2> productvalue){
		  System.debug('Test ProductsList'+productvalue);
		  System.debug('Caseid'+FinalId);
		  List<Topic> tList =new List<Topic>();  
		  List<String> unCaughtExceptions = new List<String>();
		try{ 
		  System.debug('Test ProductsList'+productvalue);
		  System.debug('Caseid'+FinalId);
		 List<TopicAssignment>  listofta =new List<TopicAssignment> ();
		 List<Product2> lstProductitems = new List<Product2>();  
		  for(Product2 item : productvalue )
		  {
			lstProductitems.add(item);
		  }
		for (Product2 pdt: lstProductitems) 
		  {
			Topic tname =new Topic();
			 tname.Name =pdt.name;
			 tlist.add(tname);
			}
			system.debug('tlist'+tlist);	
		 if(!tlist.isEmpty()){
			  //Database.insert(tlist,false);
			  upsert tlist name;
			}
			system.debug('tlistgfnjggh'+tlist);
			//List<Topic> t1=[Select id from Topic where name In:tlist];
			system.debug('Topic List values'+tlist);
			for(Topic ta1:tlist){
			 TopicAssignment  toassi =new TopicAssignment ();
			  toassi.EntityId = FinalId; 
			  toassi.TopicId =ta1.id;  
			  listofta.add(toassi);  
			}
			System.debug('The list of topic assaignments'+listofta);
			if(!listofta.isEmpty()){
			  //Database.insert(listofta,false);  
			 upsert listofta;
			}
		
		 }catch(Exception unCaughtException){
		   System.debug('unCaughtExceptions' +  unCaughtExceptions.add(unCaughtException.getMessage()));
		}  
		return   tlist;
	}
 }
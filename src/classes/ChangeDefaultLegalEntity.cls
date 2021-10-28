/****************************************
 * Class Name : ChangeDefaultLegalEntity 
 * Created Date: 25 April 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 25 April 2017
 * Description : 1. Since Default Legal Entity is inactive need to change the default legal entity				
 * Test Class: 
 *****************************************/
public class ChangeDefaultLegalEntity implements Queueable {
	List<string> invalidCustomerNumberList = new List<string>();
	Map<string, Account> validCustomerNumberMap = new Map<string, Account>();
	Map<string,string> defaultLEVsCustomer = new Map<string,string>();
	List<Account> updateLEList = new List<Account>();
	/********************
	*Method Name: Constructor
	*Parameter: List of Legal Entities
	*Description: Used to store Legal Entities which need to be added in Territory
	*******************/
	public ChangeDefaultLegalEntity (Map<string, Account> validAccMap,List<string> invalidAccLiSt){
		   invalidCustomerNumberList = invalidAccLiSt;
		   validCustomerNumberMap = validAccMap;
	} 
	
	public void execute(QueueableContext context) {
		try{
			List<Account> activeLegalEntityList = [select Id,name,accountnumber,default_legal_entity__c,parent.accountNumber from account 
																				where recordtype.name = 'Legal Entity'
																				and parent.accountNumber IN : validCustomerNumberMap.keySet() 
																				and active__c = true
																				order by lastmodifieddate desc];
			
			for(Account legalEntity : activeLegalEntityList){
				if(!defaultLEVsCustomer.containsKey(legalEntity.parent.accountNumber)){
					legalEntity.default_legal_entity__c = true;
					defaultLEVsCustomer.put(legalEntity.parent.accountNumber,legalEntity.accountNumber);
					updateLEList.add(legalEntity);
				}
			}
			update updateLEList;
		}catch(Exception exc){
			ExceptionHandler.addException(exc,GlobalConstants.ADDLEGALENTITIESINTERRITORY ,GlobalConstants.EXECUTE );
		}
	}
}
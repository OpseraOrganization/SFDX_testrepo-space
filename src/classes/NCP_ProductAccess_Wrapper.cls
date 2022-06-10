/**	
About   
-----
Description: This wrapper class is used to build the access Type list that a customer have access in the community product detail page

Created for: Nokia Customer Portal 
Created date: 12 18 2017

Update History	
--------------	
Created: 12 18 2017 – AES 

Issues / TODOs  
--------------
**/

public with sharing class NCP_ProductAccess_Wrapper {
	
	@AuraEnabled
	public List<NCP_AccessType_Wrapper> productAccessList {get;set;}
	@AuraEnabled
	public String label {get;set;}
 
	public NCP_ProductAccess_Wrapper(String lab,List<NCP_AccessType_Wrapper> prList) {
		this.productAccessList = prList;
		this.label = lab;
	}
}
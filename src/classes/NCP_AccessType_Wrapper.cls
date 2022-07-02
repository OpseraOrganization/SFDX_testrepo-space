/**	
About   
-----
Description: This wrapper class is used to build the access Type list that a customer have access in the community product detail page

Created for: Nokia Customer Portal 
Created date: 12 19 2017

Update History	
--------------	
Created: 12 19 2017 – AES 

Issues / TODOs  
--------------
**/
public with sharing class NCP_AccessType_Wrapper {
	
	@AuraEnabled
	public NCP_Product_Access_Type__mdt productAccess {get;set;}
	@AuraEnabled
	public Boolean hasAccess {get;set;}
 
	public NCP_AccessType_Wrapper(Boolean b ,NCP_Product_Access_Type__mdt pr) {
		this.productAccess = pr;
		this.hasAccess = b;
	}
}
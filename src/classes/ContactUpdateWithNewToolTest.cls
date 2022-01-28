/**
* @description: Test Class for ContactUpdateWithNewTool
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   16/08/2017   Secondary resources requirement
* ============================================================================ 
*/
@isTest
public class ContactUpdateWithNewToolTest{
	 static testMethod void toolInsert(){
		 Set<Id> contactIds = new Set<Id>();
		 Contact con1=new Contact(LastName='Doe1',FirstName='John1');
		 Contact con2=new Contact(LastName='Doe2',FirstName='John2');
		 insert con1;
		 insert con2;
		 contactIds.add(con1.Id);
		 contactIds.add(con2.Id);
		 ContactUpdateWithNewTool.updateContacts(contactIds);
		 List<String> ContactDetails=new List<String>();
		 ContactDetails.add(con1.Id);
	 }

}
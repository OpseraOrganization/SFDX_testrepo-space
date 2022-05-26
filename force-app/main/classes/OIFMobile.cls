/****************************************
 *Class Name : OIFMobile
 *Created Date: 9th May 2017
 *Created By : Accenture
 *Last Modified by: Accenture
 *Last Modified Date:  
 *Description : Get the ID from  Visialforce page and return the Grid lock value
 *Test Class: OIFMobileTest
 *****************************************/


public with sharing  class OIFMobile {

public Static  Integer Opplock{get;set;}
public Static   Integer Gridlock{get;set;}
Public Static ID posId ;


public OIFMobile (ApexPages.StandardController controller)
//Collecting the Opportunity ID
{

 posId = controller.getRecord().Id;  
 OptyLock();
 Lock();

}

/*******************************
	 *Method name:OptyLock
	 *Description: Return the Opportunity Lock Data
	 *Parameter: 
	 *******************************/

@TestVisible Static Integer OptyLock()
{

 
 for(Opportunity Opplist:[select id,name,Grid_Buddy_Closed__c from Opportunity where id=:posId LIMIT 1])   
	   Opplock=(Integer)Opplist.Grid_Buddy_Closed__c;
	   
	
  return Opplock;
}


/*******************************
	 *Method name:Lock
	 *Description: Return the Grid Lock Data
	 *Parameter: 
	 *******************************/

@TestVisible Private Static Integer Lock()
{
  
   for(Opportunity Opplist:[select id,name,Opportunity_Lock__c from Opportunity where id=:posId LIMIT 1])   
	   Gridlock=(Integer)Opplist.Opportunity_Lock__c;
	   return Gridlock;
	   
	   
}


}
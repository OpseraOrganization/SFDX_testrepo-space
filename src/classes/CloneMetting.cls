/** * File Name: CloneMetting
* Description This class is to clone the Planned Meeting Attendees along with the Planned meeting
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
public class CloneMetting{
     
      //variable declaration
      private final Planned_Meeting__c pm;
   
      public CloneMetting(ApexPages.StandardController stdController) 
      {
           this.pm = (Planned_Meeting__c)stdController.getRecord();
       }

public pagereference clonepm (){
 Savepoint sp = Database.setSavepoint();

String pmID = ApexPages.currentPage().getParameters().get('id'); 
 if (pmID == null) { 
   // Display the Visualforce page's content if no Id is passed over
  return null;
      }
     //*************************************************************************** 
 // Get the sObject describe result for the Planned Meeting object  
 Schema.DescribeSObjectResult r = Planned_Meeting__c.sObjectType.getDescribe(); 
 Map<String, Schema.SObjectField> M = r.fields.getMap(); 
 //Generate a Map of the fields 
  //Now loop through the list of Field Names and concatenate the SOQL query string 
   String SOQL = 'Select ';  
    for (String fieldName : M.keySet()){    
     System.debug('fieldName: ' + fieldName); 
          SOQL += fieldName + ',';  
            }  
  SOQL = SOQL.substring(0,SOQL.length()-1); 
   //Remove the last , unnecessary comma 
    SOQL += ' From Planned_Meeting__c o where id=\''+pmID+'\' LIMIT 1' ; 
        //Execute SOQL & Cast the sObject type into an Planned Meeting
  sObject S = Database.query(SOQL);  
   Planned_Meeting__c pmtng = (Planned_Meeting__c)S; 

//Clone the Planned_Meeting__c - 2 parameters (PreserveId or not, IsDeepClone or not )   
  Planned_Meeting__c newPM = pmtng.clone(false,true);
   newPM.Name=pmtng.Name + ' Cloned';
   try
   { 
   insert newPM;   
   }
   catch(Exception e)
   {             
                 Database.rollback(sp);
                 return null;
     }
      
     //***************************************************************************
     // Get the sObject describe result for the Opportunity object  
 Schema.DescribeSObjectResult r1 = Planned_Meeting_Attendee__c.sObjectType.getDescribe(); 
 Map<String, Schema.SObjectField> M1 = r1.fields.getMap(); 
 //Generate a Map of the fields 
  //Now loop through the list of Field Names and concatenate the SOQL query string 
   String SOQL1 = 'Select ';  
    for (String fieldName : M1.keySet()){    
     System.debug('fieldName: ' + fieldName); 
          SOQL1 += fieldName + ',';  
            }  
  SOQL1 = SOQL1.substring(0,SOQL1.length()-1); 
   //Remove the last , unnecessary comma 
    SOQL1 += ' From Planned_Meeting_Attendee__c o where Planned_Meeting__c=\''+pmID+'\' ' ; 
        //Execute SOQL & Cast the sObject type into an Planned_Meeting_Attendee__c
  List<Planned_Meeting_Attendee__c> patt1= Database.query(SOQL1);  

//Clone the Planned_Meeting__c - 2 parameters (PreserveId or not, IsDeepClone or not )   
  List<Planned_Meeting_Attendee__c> newPM1 = new List<Planned_Meeting_Attendee__c>();
 for(integer i=0;i<patt1.size();i++)
  {
   newPM1.add(patt1[i].clone(false,true));
  }
  for(integer i=0;i<newPM1.size();i++)
  {
  newPM1[i].Planned_Meeting__c=newPM.Id ; 
  }
  try
  {
    insert newPM1;   
    
  }
  catch (Exception e){
             // roll everything back in case of errors
      Database.rollback(sp);
                 return null;
              }
     
     //***************************************************************************
 // Go to the new Planned_Meeting__c
  PageReference pageRef = new PageReference('/' + newPM.Id);
  pageRef.setRedirect(true); 
  return pageRef;
}
}
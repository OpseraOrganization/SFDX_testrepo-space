////Deactivating trigger 03/07/2012



// Jonathan Hersh - jhersh@salesforce.com
// November 13, 2008

trigger emailAttachmentReassigner on Attachment (before  insert,before update,after insert) {
/*Commenting trigger code for coverage
List<Id> idlist = new List<Id>();
List<Attachment_Object__c> aobjlist = new List<Attachment_Object__c>();
List<Attachment_Object__c> aobjlist1 = new List<Attachment_Object__c>();
List<Attachment_Object__c> aobjlist2 = new List<Attachment_Object__c>();
string newkey='11111111111111111111111111111111';
Blob cryptoKey=blob.valueof(newkey);
string    cryptoKeytext; 
 if(Trigger.Isbefore)
 {
   for( Attachment a : trigger.new ) {  
   String parent;
   //Code for Encryption
   
   
   
        // Check the parent ID - if it's 02s, this is for an email message
        if( a.parentid == null )
          { 
          system.debug('INSIDE exit');
            continue;
            }
         String s = string.valueof( a.parentid );

        if( s.substring( 0, 3 ) == '02s' )
        {

         Id i =  [select parentID from EmailMessage where id = :a.parentid].parentID;
            a.parentid = i;
                     }   
    }
  
  //insert aobjlist;
  }*/
  
  
  
  }
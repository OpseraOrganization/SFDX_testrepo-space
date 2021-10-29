trigger BodyCount on R_O_Email_Templates__c (before insert,before update) 
{
 if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
  for(R_O_Email_Templates__c ROET : trigger.new)
  {
   if(ROET.Body__c != null)
   {  
    ROET.Body_Length__c = String.valueOf(ROET.Body__c.length());
   } 
  }
 }
}
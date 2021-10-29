trigger UpdateLineItemToClosed on Discretionary_Line_Item__c (before update) {
 for(Discretionary_Line_Item__c dis : Trigger.new)
 {
 
   if(dis.Approval_Status__c=='Pending Close'  && dis.Site_Comment_Drop_Down__c=='Close')
   {
     dis.Approval_Status__c='Close';
   }
 }
}
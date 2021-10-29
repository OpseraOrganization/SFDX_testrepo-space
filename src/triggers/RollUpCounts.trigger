trigger RollUpCounts on Opportunity_Product_Line__c(after delete, after insert, after undelete) {
 set < string > plCount = new set < string > ();
 if (trigger.isInsert) {
  for (Opportunity_Product_Line__c lineItem: Trigger.new) {
   plCount.add(lineItem.Opportunity__c);
  }
 } else if (trigger.isDelete) {
  for (Opportunity_Product_Line__c lineItem: Trigger.old) {
   plCount.add(lineItem.Opportunity__c);
  }
 } else if (trigger.isUnDelete) {
  for (Opportunity_Product_Line__c lineItem: Trigger.new) {
   plCount.add(lineItem.Opportunity__c);
  }
 }
 if (plCount.size() > 0) {
  OpportunityProductLineHelper opH = new OpportunityProductLineHelper();
  opH.updateLineItemCount(plCount);
 }
}
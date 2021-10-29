public with sharing class OpportunityProductLineHelper {
 public void updateLineItemCount(set < string > deskIDs) {
  if (deskIDs == null) {
   return;
  }
  if (deskIDs.size() == 0) {
   return;
  }
  list <Opportunity_Product_Line__c> deskList = new list <Opportunity_Product_Line__c> ();
  deskList = [Select ID,Opportunity__c From Opportunity_Product_Line__c Where Opportunity__c =: deskIDs];
  integer totalCount;
  
  map < string, integer > classroomIDToDeskCountMap = new map < string, integer > ();
  
  for (Opportunity_Product_Line__c deskItem: deskList) {
   if (classroomIDToDeskCountMap.containsKey(deskItem.Opportunity__c)) {
    totalCount = classroomIDToDeskCountMap.get(deskItem.Opportunity__c);
   } else {
    totalCount = 0;
   }
   totalCount += 1;
   classroomIDToDeskCountMap.put(deskItem.Opportunity__c, totalCount);
  }
  if(deskList.size()==0){
    for(String str:deskIDs){
        classroomIDToDeskCountMap.put(str, 0);
    }   
  }
  list < Opportunity > deskUpdateList = new list < Opportunity > ();
  Opportunity deskTemp;
  for (string deskID: classroomIDToDeskCountMap.keySet()) {
   deskTemp = new Opportunity();
   deskTemp.ID = deskID;
   deskTemp.Avionics_Count__c = classroomIDToDeskCountMap.get(deskID);
   deskUpdateList.add(deskTemp);
  }
  if (deskUpdateList.size() > 0) {
   update deskUpdateList;
  }
 }
}
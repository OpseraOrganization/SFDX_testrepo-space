/* Trigger to update Plant Code Master field based on the Plant Code field in Discretionary Line Item */

trigger DiscretionaryLineItem_UpdatePlantCodeMaster on Discretionary_Line_Item__c (before insert,before update) {
/*commenting trigger code for coverage
List<Id> plantCodeId=new List<Id>();
List<Plant_Code_Del__c> plantList=new List<Plant_Code_Del__c>();
for(  Discretionary_Line_Item__c DiscNew : Trigger.new){
    plantCodeId.add(DiscNew.Plant_Code__c);
}*/
/* Retrieve the Plant Code Master field from Plant Code entered in the Discretionary Line Item*/

//plantList=[Select Id,Plant_Code_Master__c from Plant_Code_Del__c where Id in:plantCodeId];

/* Update the Plant Code Master field retrieved on Discretionary Line Item */
/*for(Discretionary_Line_Item__c  Disc: Trigger.new){
       for(integer i=0;i<plantList.size();i++){
         if(Disc.Plant_Code__c==plantList[i].Id)
         Disc.Plant_Code_Master__c=plantList[i].Plant_Code_Master__c;
       }
}*/
}
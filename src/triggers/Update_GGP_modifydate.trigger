trigger Update_GGP_modifydate on Deliverable_Item__c (After update, After Insert) {
List<Go_Green_Plan__c> GGPList = new List<Go_Green_Plan__c>();
List<String> greenlist = new List<String>();
if(trigger.isUpdate || trigger.isInsert){
  for (Deliverable_Item__c deli : trigger.new)
   {
    if (deli.Go_Green_Plan__c!=null)
    greenlist.add(deli.Go_Green_Plan__c);
   }
   if (greenlist.size()>0)
    { 
     GGPList  = [select id from Go_Green_Plan__c where id=:greenlist];
    }
     Update GGPList;
 }
}
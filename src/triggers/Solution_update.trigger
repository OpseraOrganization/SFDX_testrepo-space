/** * File Name: ServiceRecovery_BeforeTrigger
* Description :
* autopopulates account,contact from Cases
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* * @author : Wipro
* Modification Log ===============================================================
  Modified By ITSS : Enhancement 2425 : Supported Product Lookup Implementation 
  Ver Date Author Modification --- ---- ------ -------------
* */ 

trigger Solution_update on Skills2__c (After Insert, After Update) {
List<String> support = new List<String>();
List<Solution> Sol = new List<Solution>();
set<id> test = new set<id>();
for (skills2__C gg : trigger.new)
test.add(gg.id);

//if the Primary_Secondary or the Contact or the Supported Product is changed in the Skills, the corresponding Supported Product is added in a list
try{
if(trigger.isupdate){
      for(Skills2__c s : Trigger.new){
    if(System.Trigger.OldMap.get(s.id).Primary_Secondary__c !=System.Trigger.NewMap.get(s.Id).Primary_Secondary__c||  
          System.Trigger.OldMap.get(s.id).Contact__c != System.Trigger.NewMap.get(s.id).Contact__c || 
           System.Trigger.OldMap.get(s.id).Supported_Products__c != System.Trigger.NewMap.get(s.id).Supported_Products__c  
           ){
           if(s.Supported_Products__c != '' && s.Supported_Products__c != null){
           support.add(s.Supported_Products__c);
           }
        }
      }  
    }

//when a new skill is created, the Supporetd Product is added in a list
else{
for(Skills2__c s : Trigger.new){
system.debug('SUP********'+s.Primary_Secondary__c+'SUP********'+s.Supported_Products__c);
    if(s.Primary_Secondary__c != ''&& s.Supported_Products__c != '' && s.Supported_Products__c != null){
       support.add(s.Supported_Products__c);
    }
  }
}
 
system.debug('SUP********'+support);
if (support.size()>0 && support!= null){
//The solution is queried if the Supported Product is one of that present in the List 
Sol = [select id from solution where Supported_Products__c in: support]; 
system.debug('SOLU********'+Sol); 
 
 //updating the Sol
 update Sol;
 }
 }catch(exception e){
  system.debug(e);
 } 
}
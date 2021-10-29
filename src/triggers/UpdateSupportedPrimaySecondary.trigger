trigger UpdateSupportedPrimaySecondary on Skills2__c (after insert, after update) {
List<String> support = new List<String>();
List<String> primarysecondary = new List<String>();
List<String> contactId = new List<String>();
List<Supported_Products__c> suppProduct = new List<Supported_Products__c>();

try{
if(trigger.isupdate){
      for(Skills2__c s : Trigger.new){
    if(System.Trigger.OldMap.get(s.id).Primary_Secondary__c !=System.Trigger.NewMap.get(s.Id).Primary_Secondary__c||  
          System.Trigger.OldMap.get(s.id).Contact__c != System.Trigger.NewMap.get(s.id).Contact__c || 
           System.Trigger.OldMap.get(s.id).Supported_Products__c != System.Trigger.NewMap.get(s.id).Supported_Products__c  
           ){
           support.add(s.Supported_Products__c);
           primarysecondary.add(s.Primary_Secondary__c);
           contactId.add(s.Contact__c);
        }
      }  
    }

else{
for(Skills2__c s : Trigger.new){
    //if(s.Primary_Secondary__c != ''&& s.Supported_Products__c != ''){
       support.add(s.Supported_Products__c);
       primarysecondary.add(s.Primary_Secondary__c);
       contactId.add(s.Contact__c);
    //}
  }
}
 
system.debug('suppProduct ********'+support);
 
suppProduct = [select Id,Primary__c,Secondary__c from Supported_Products__c where Id in: support]; 
system.debug('suppProduct********'+suppProduct); 

for(Integer i=0;i<suppProduct.size();i++){
    for(Skills2__c s : Trigger.new){
        if(suppProduct[i].Id == s.Supported_Products__c && s.Primary_Secondary__c == 'Primary'){
            suppProduct[i].Primary__c = s.Contact__c;
            //suppProduct[i].Secondary__c = NULL;
        }else if(suppProduct[i].Id == s.Supported_Products__c && s.Primary_Secondary__c == 'Secondary'){
            suppProduct[i].Secondary__c = s.Contact__c;
            //suppProduct[i].Primary__c = NULL;
        }else {
            //suppProduct[i].Secondary__c = NULL;
            //suppProduct[i].Primary__c = NULL;
        }
    }
}

    update suppProduct;
    }catch(exception e){
        system.debug(e);
    } 
}
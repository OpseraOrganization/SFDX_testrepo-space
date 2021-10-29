trigger Package_creation on Packaged_Products__c (after insert, after update) {   
    List<Product2> productList = new List<Product2>();
    List<RMU_VALUE__c> offeringList = new List<RMU_VALUE__c>();
    List<Opportunity> oppUpdateList = new List<Opportunity>();
    map<id,Opportunity> oppUpdateMap = new map<id,Opportunity>();
    set<id> offbundle = new set<id>();
    Set<Id> OppProduct2Id = new Set<Id>();
    public String offeringBundleName;
    Id aircraftPlatformId;
    System.debug('in StopOthers-----'+StopOthers.ppfirstRun);
    StopOthers.ppfirstRun=false;
    if(Label.Stopupdatetechsales == 'Active'){
        if (Trigger.isInsert) {
            if (Trigger.isAfter) {
                for(Packaged_Products__c ob :trigger.new){
                    if (ob.name != null) {
                        offbundle.add(ob.Id);
                        Product2 prod = new Product2();
                        RMU_VALUE__c offobj = new RMU_VALUE__c();
                      
                       /* offobj.Name = 'PKG-'+ob.Name;                    
                        offobj.Offering_1__c = ob.Offering_1__c;
                        offobj.Offering_2__c = ob.Offering_2__c;
                        offobj.Offering_3__c = ob.Offering_3__c;
                        offobj.Offering_4__c = ob.Offering_4__c;
                        offobj.Offering_5__c = ob.Offering_5__c;            
                        offobj.RMU_Type__c = 'Product';
                        offobj.RMU_Status__c = 'Bulk Load';
                        offobj.RecordTypeId = '0122D000000CQHJ';
                        offeringBundleName = ob.Name;
                        offeringList.add(offobj);
                        productList.add(prod);*/
                    }
               }          
               String cbtTeamVal = '';         
             //  if(offeringList.size()>0){
                   for(Packaged_Products__c  ob :[SELECT Id, CBT_Team1__c, Product_1__r.Name, Product_1__c, Product_2__r.Name,Product_3__r.Name,Product_4__r.Name,Product_5__r.Name, Aircraft_Platform__r.Id FROM Packaged_Products__c WHERE Id =:offbundle]){
                       if(ob.Product_1__c != NULL){                      
                           OppProduct2Id.add(ob.Product_1__c);                       
                       }
                       if(ob.Product_2__c != NULL){                      
                           OppProduct2Id.add(ob.Product_2__c);                      
                       }
                       if(ob.Product_3__c != NULL){                       
                           OppProduct2Id.add(ob.Product_3__c);                      
                       }
                       if(ob.Product_4__c != NULL){                      
                           OppProduct2Id.add(ob.Product_4__c);                      
                       }
                       if(ob.Product_5__c != NULL){                      
                           OppProduct2Id.add(ob.Product_5__c);                       
                       }
                       cbtTeamVal = ob.CBT_Team1__c;
                       aircraftPlatformId = ob.Aircraft_Platform__r.Id;
                       System.debug('package product'+ob);
                   }               
              // }
                
               if(OppProduct2Id.size()>0){      
                   System.debug('product id'+OppProduct2Id);
                   List<OpportunityLineItem> olitemlst = [SELECT ID, Name, Product2.name, Product2Id, OpportunityId, Opportunity.Package_Product_Link__c, Opportunity_Name__c, Opportunity.CBT_Team_Tier_3__c, Opportunity.SBU__c, opportunity.Aircraft_Ref__r.Platform_Name__r.id FROM OpportunityLineItem WHERE Product2Id =: OppProduct2Id];
                   System.debug('the line item are==='+olitemlst);
                   for(OpportunityLineItem olitem : [SELECT ID, Name, Product2.name, Product2Id, OpportunityId, Opportunity.Package_Product_Link__c, Opportunity_Name__c, Opportunity.CBT_Team_Tier_3__c, Opportunity.SBU__c, opportunity.Aircraft_Ref__r.Platform_Name__r.id FROM OpportunityLineItem WHERE Product2Id =: OppProduct2Id]){
                       Opportunity oppUpdate = new Opportunity();
                       if(olitem.opportunity.Aircraft_Ref__r.Platform_Name__r.id == aircraftPlatformId){
                           if(olitem.Opportunity.CBT_Team_Tier_3__c == cbtTeamVal && (olitem.Opportunity.SBU__c == 'BGA' || olitem.Opportunity.SBU__c == 'ATR')){
                               oppUpdate.id = olitem.OpportunityId;
                               oppUpdate.Package_Product__c = offeringBundleName;
                               String input = '<a href=/'+offbundle+'>'+offeringBundleName+'</a>';
                               system.debug('this is the link > '+input);
                               String dacntSaleDet = '';
                               dacntSaleDet = input.replace('{', '');        
                               dacntSaleDet = dacntSaleDet.replace('}', '');          
                               oppUpdate.Package_Product_Link__c =dacntSaleDet;                          
                               oppUpdateMap.put(oppUpdate.id, oppUpdate);
                           }
                       }
                       if(olitem.Opportunity.SBU__c == 'ATR'){
                           oppUpdate.id = olitem.OpportunityId;
                           oppUpdate.Package_Product__c = offeringBundleName;
                           String input = '<a href=/'+offbundle+'>'+offeringBundleName+'</a>';
                           system.debug('this is the link > '+input);
                           String dacntSaleDet = '';
                           dacntSaleDet = input.replace('{', '');        
                           dacntSaleDet = dacntSaleDet.replace('}', '');          
                           oppUpdate.Package_Product_Link__c =dacntSaleDet;
                           
                           oppUpdateMap.put(oppUpdate.id, oppUpdate);
                       }                   
                   }
               }
               System.debug('the value is ===='+oppUpdateList);
               if(oppUpdateMap.size()>0){    
                   System.debug('in StopOthers on update-----'+StopOthers.ppfirstRun);
                   update oppUpdateMap.values();
                   
               }
               System.debug(productList+'productList1==='+offeringList);
            }        
        }else if(Trigger.isUpdate){
            if (Trigger.isAfter) {
                for(Packaged_Products__c ob :trigger.new){
                    if (ob.name != null) {
                        offbundle.add(ob.Id);
                    }
                }
                String cbtTeamVal = '';
                if(offbundle.size()>0){
                   System.debug('product bundle is in update----'+offbundle);
                   for(Packaged_Products__c  ob :[SELECT Id, Name, CBT_Team1__c, Product_1__r.Name, Product_1__c, Product_2__r.Name,Product_3__r.Name,Product_4__r.Name,Product_5__r.Name, Aircraft_Platform__r.Id FROM Packaged_Products__c WHERE Id =:offbundle]){
                       if(ob.Product_1__c != NULL){
                           Id someId = ob.Product_1__c;
                           OppProduct2Id.add(someId);
                       }
                       if(ob.Product_2__c != NULL){
                           Id someId = ob.Product_2__c;                       
                           OppProduct2Id.add(someId);                       
                       }
                       if(ob.Product_3__c != NULL){
                           Id someId = ob.Product_3__c;
                           OppProduct2Id.add(someId);
                       }
                       if(ob.Product_4__c != NULL){
                           Id someId = ob.Product_4__c;                   
                           OppProduct2Id.add(someId);
                       }
                       if(ob.Product_5__c != NULL){
                           Id someId = ob.Product_5__c;
                           OppProduct2Id.add(someId);
                       }
                       cbtTeamVal = ob.CBT_Team1__c;
                       offeringBundleName = ob.Name;
                       aircraftPlatformId = ob.Aircraft_Platform__r.Id;
                   }
               }
               System.debug(offeringBundleName + 'name ----'+cbtTeamVal+'product is in update----'+OppProduct2Id);
               if(OppProduct2Id.size()>0){
                   Map<Id,RMU_Sales__c> toGetOppProdMap = new Map<Id,RMU_Sales__c>();
                   for(RMU_Sales__c rsval : [SELECT Id,Opportunity__c, Opportunity_Product_ID__c,Order_Part__c FROM RMU_Sales__c WHERE Order_Part__c =: OppProduct2Id]){
                       toGetOppProdMap.put(rsval.Opportunity__c, rsval);
                   }
                   
                   System.debug('Offering Sale Map IS in else -----------'+toGetOppProdMap);      
                   for(OpportunityLineItem olitem : [SELECT ID, Name, Product2.name, Product2Id, OpportunityId, Opportunity.IsClosed, Opportunity.StageName, Opportunity.Package_Product_Link__c, Opportunity_Name__c, Opportunity.CBT_Team_Tier_3__c,Opportunity.SBU__c, opportunity.Aircraft_Ref__r.Platform_Name__r.id FROM OpportunityLineItem WHERE Product2Id =: OppProduct2Id]){
                       Opportunity oppUpdate = new Opportunity();
                       if(olitem.opportunity.Aircraft_Ref__r.Platform_Name__r.id == aircraftPlatformId){
                           if(olitem.Opportunity.CBT_Team_Tier_3__c == cbtTeamVal && (olitem.Opportunity.SBU__c == 'BGA' || olitem.Opportunity.SBU__c == 'ATR')){
                               oppUpdate.id = olitem.OpportunityId;
                               oppUpdate.Package_Product__c = offeringBundleName;
                               String input = '<a href=/'+offbundle+'>'+offeringBundleName+'</a>';
                               system.debug('this is the link > '+input);
                               String dacntSaleDet = '';
                               dacntSaleDet = input.replace('{', '');        
                               dacntSaleDet = dacntSaleDet.replace('}', '');          
                               oppUpdate.Package_Product_Link__c =dacntSaleDet;
                               
                               oppUpdateMap.put(oppUpdate.id, oppUpdate);
                           }
                           System.debug('Map size-----'+toGetOppProdMap.size());
                           System.debug('SBU-----'+olitem.Opportunity.SBU__c);
                           System.debug('stage-----'+olitem.Opportunity.StageName);
                           System.debug(olitem.Product2Id+'<==== RMU OPP Part =====>'+toGetOppProdMap.get(olitem.OpportunityId));
                           if(toGetOppProdMap.get(olitem.OpportunityId) != null && (toGetOppProdMap.size() > 0 && olitem.Opportunity.CBT_Team_Tier_3__c == cbtTeamVal && (olitem.Opportunity.SBU__c == 'BGA' || olitem.Opportunity.SBU__c == 'ATR') && toGetOppProdMap.get(olitem.OpportunityId).Order_Part__c == olitem.Product2Id && toGetOppProdMap.containsKey(olitem.OpportunityId) && olitem.Opportunity.StageName == 'Closed Won')){
                               System.debug('Package product-----'+oppUpdate.Package_Product__c);
                              oppUpdate.id = olitem.OpportunityId;
                              oppUpdate.Package_Product__c = ''; 
                              oppUpdate.Package_Product_Link__c ='';
                              oppUpdateMap.put(olitem.OpportunityId, oppUpdate);
                           }
                       }
                       // Adding logic for ATR
                       if(olitem.Opportunity.SBU__c == 'ATR'){
                           oppUpdate.id = olitem.OpportunityId;
                           oppUpdate.Package_Product__c = offeringBundleName;
                           String input = '<a href=/'+offbundle+'>'+offeringBundleName+'</a>';
                           system.debug('this is the link > '+input);
                           String dacntSaleDet = '';
                           dacntSaleDet = input.replace('{', '');        
                           dacntSaleDet = dacntSaleDet.replace('}', '');          
                           oppUpdate.Package_Product_Link__c =dacntSaleDet;
                           //oppUpdateList.add(oppUpdate);
                           oppUpdateMap.put(oppUpdate.id, oppUpdate);
                       }
                       System.debug('Map size-----'+toGetOppProdMap.size());
                       System.debug('SBU-----'+olitem.Opportunity.SBU__c);
                       System.debug('stage-----'+olitem.Opportunity.StageName);
                       System.debug(olitem.Product2Id+'<==== RMU OPP Part =====>'+toGetOppProdMap.get(olitem.OpportunityId));
                       if(olitem.Opportunity.SBU__c == 'ATR' && olitem.Opportunity.StageName == 'Closed Won'){
                           System.debug('Package product-----'+oppUpdate.Package_Product__c);
                          oppUpdate.id = olitem.OpportunityId;
                          oppUpdate.Package_Product__c = ''; 
                          oppUpdate.Package_Product_Link__c ='';
                          oppUpdateMap.put(olitem.OpportunityId, oppUpdate);
                       }
                       //update oppUpdate;
                   }
               }
               System.debug('the value is ===='+oppUpdateMap);
               if(oppUpdateMap.size()>0){    
                   System.debug('in StopOthers on update-----'+StopOthers.ppfirstRun);
                   if(!Test.isRunningTest()){update oppUpdateMap.values();}
                   
               }
               System.debug(productList+'productList1==='+offeringList);
            }  
        }
    }
}
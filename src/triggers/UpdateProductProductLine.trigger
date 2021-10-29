/*************************************************************************************************************
Name                 : UpdateProductProductLine
Created by           : Haritha Lekkala
Company Name         : HoneyWell
Project              : Aero Sales
Created Date         :  2/9/2017
Usage                :   This Trigger is to auto populate M&PM Product Line when M&PM Product field is populated and vice versa.
Modification History 
Date                    Version No                Modified By                    Brief Description of Modification
*****************************************************************************************************************/       


//Trigger to auto populate M&PM Product Line when M&PM Prodcut field is populated.
trigger UpdateProductProductLine on OpportunityLineItem (before insert,before update) {  
    if(AvoidRecursion.isFirstRun_UpdateProductProductLine()){ 
     
    //system.debug('This is from the UpdateProductProductLine trigger:'+AvoidRecursion.checkCount());
    // Note: API name of apportunity Prouct is OpportunityLineItem
    // Take all the opportunity products which are for insert or update and assign them to a list
    list<OpportunityLineItem> lineItemList = trigger.new;
    set<id> productIdsFromOpportunityProduct = new set<id>();
    set<id> productIds = new set<id>();
    set<id> aircraftRefIds = new set<id>();
    set<id> opportunityIds = new set<id>();
    map<id,string> opportunityIdMap = new map<id,string>();
    map<id,string> rmuPlatformMap = new map<id,string>();
    set<id> rumSet = new set<id>();
    map<id,string> plafromNamesMapfromFleet = new map<id,string>(); 
    //Take all the M&PM Product Ids from all the Opportunity Product records into 'productIdsFromOpportunityProduct' set which is defined in above line, this we need to select the corresponding Product Cross Referece details at Line #12
    for(OpportunityLineItem opportunityProductRec: lineItemList){
        productIdsFromOpportunityProduct.add(opportunityProductRec.M_PM_Product__c);
        productIds.add(opportunityProductRec.Product2Id);
        opportunityIds.add(opportunityProductRec.OpportunityId);
     }
    for(Opportunity opp:[select id,Aircraft_Ref__c  from Opportunity where id in :opportunityIds]){
        aircraftRefIds.add(opp.Aircraft_Ref__c);
        opportunityIdMap.put(opp.id,opp.Aircraft_Ref__c);
    }
    set<string> platformIdSet = new set<string>();
    if(aircraftRefIds.size()>0){
        
        for(Fleet_Asset_Detail__c fsd:[select id,Platform_Name__r.Name from Fleet_Asset_Detail__c where id in :aircraftRefIds]){
            platformIdSet.add(fsd.Platform_Name__c);
            plafromNamesMapfromFleet.put(fsd.id,fsd.Platform_Name__c);
        }
        
    }
    
    system.debug('productIds values:'+productIds);
    map<String,RMU_Product__c> rmuProductMap = new map<String,RMU_Product__c>();
    if(productIds.size()>0){
        list<RMU_Product__c> rmuProductList = new list<RMU_Product__c>([select RMU__c,RMU_Product__c from RMU_Product__c where RMU_Product__c in :productIds]);
        for(RMU_Product__c rmuProdRec:rmuProductList){
            rmuProductMap.put(rmuProdRec.RMU_Product__c,rmuProdRec);
            rumSet.add(rmuProdRec.RMU__c);
        }   
    }
    list<OFFERING_MAPPER__c> offerMapperList = new list<OFFERING_MAPPER__c>([select id,RMU_VALUE__c,Name,Aircraft_Platform__c from OFFERING_MAPPER__c where Aircraft_Platform__c in:platformIdSet ]);
    map<string,list<OFFERING_MAPPER__c>> offerMapperMap = new map<string,list<OFFERING_MAPPER__c>>();
    for(OFFERING_MAPPER__c offMapper:offerMapperList){
        list<OFFERING_MAPPER__c> mapperList = new list<OFFERING_MAPPER__c>();
        mapperList.add(offMapper);
        if(offerMapperMap.get(offMapper.RMU_VALUE__c) == null){         
            offerMapperMap.put(offMapper.RMU_VALUE__c,mapperList);
        }else{
            offerMapperMap.get(offMapper.RMU_VALUE__c).addAll(mapperList);
        }
    }
    if(productIds.size()>0){
        list<RMU_Product__c> rmuProductList = new list<RMU_Product__c>([select RMU__c,RMU_Product__c from RMU_Product__c where RMU_Product__c in :productIds and RMU_Product_Primary__c=true]);
        for(RMU_Product__c rmuProdRec:rmuProductList){
            rmuProductMap.put(rmuProdRec.RMU_Product__c,rmuProdRec);
        }   
    }
    system.debug('rmuProductMap value:'+rmuProductMap);
    //now select all the Line Item corss refernce records and put into a map, this map we will need to get the Product Line Item reference at line#:16
    map<id,Product_Line_Cross_Ref__c> productMap = new map<id,Product_Line_Cross_Ref__c>(
                                            [select id,Product_Line__c from Product_Line_Cross_Ref__c where id in :productIdsFromOpportunityProduct]);
    
    list<Product_Line_Cross_Ref__c> productlineItemXReference = [select id,Name from Product_Line_Cross_Ref__c];
    map<string,id> productLineItemCrossRefNameMap = new map<string,id>();
    for(Product_Line_Cross_Ref__c xrefRec:productlineItemXReference){
        productLineItemCrossRefNameMap.put(xrefRec.Name,xrefRec.id);
    }
    map<id,Product_Line__c > productLineRecordsMap = new map<id,Product_Line__c >(
                    [SELECT Id,Name FROM Product_Line__c]);
    for(OpportunityLineItem opportunityProductRec: lineItemList){
        //Need to check if records values are updated.
        if(rmuProductMap.get(opportunityProductRec.product2id) != null){
            opportunityProductRec.RMU__c = rmuProductMap.get(opportunityProductRec.product2id).RMU__c;
        }
        if(offerMapperMap.get(opportunityProductRec.RMU__c) != null){
            if(plafromNamesMapfromFleet.get(opportunityIdMap.get(opportunityProductRec.opportunityid)) != null){
                list<OFFERING_MAPPER__c> offerMapperList1 = offerMapperMap.get(opportunityProductRec.RMU__c);
                for(OFFERING_MAPPER__c offRec:offerMapperList1){
                    system.debug('offRec.Name:'+offRec.Name+' plafromNamesMapfromFleet.get(opportunityIdMap.get(opportunityProductRec.opportunityid)) :'+plafromNamesMapfromFleet.get(opportunityIdMap.get(opportunityProductRec.opportunityid)));
                    if(offRec.Aircraft_Platform__c == plafromNamesMapfromFleet.get(opportunityIdMap.get(opportunityProductRec.opportunityid))){
                        opportunityProductRec.RMU_Platform__c = offRec.id;
                        break;
                    }
                }
            }
        }
                
        if(Trigger.isUpdate){
            Boolean isMPMProductChanged = false;
            Boolean isMPMProductLineChanged = false;
            //Get the old copy for the record for the current record in the list.
            OpportunityLineItem oldopportunityProductRec = Trigger.oldMap.get(opportunityProductRec.id);
            //Check if M&PM Product field is modified
            if(oldopportunityProductRec.M_PM_Product__c != opportunityProductRec.M_PM_Product__c){
                isMPMProductChanged = true;
            }
            //Check if M&PM Product Line field is modified
            if(oldopportunityProductRec.M_PM_Product_Line__c != opportunityProductRec.M_PM_Product_Line__c){
                isMPMProductLineChanged = true;
            }
            //If both M&PM Product and Product Line is modified set Product LIne to null as we need to give priority to Product.
            if(isMPMProductChanged && isMPMProductLineChanged){
                opportunityProductRec.M_PM_Product_Line__c = null;
            }
            //If M&PM Product is changed set the product Line to null
            if(isMPMProductChanged && !isMPMProductLineChanged){
                opportunityProductRec.M_PM_Product_Line__c = null;
            }
            //If M&PM Product Line is changed set Product to null
            if(!isMPMProductChanged && isMPMProductLineChanged){
                opportunityProductRec.M_PM_Product__c = null;
            }
        }
        
        //Scenario 3
        if(opportunityProductRec.M_PM_Product__c != null && opportunityProductRec.M_PM_Product_Line__c!= null){
            opportunityProductRec.M_PM_Product_Line__c = null;
        }
        //Scenario 1
        if(opportunityProductRec.M_PM_Product__c != null && opportunityProductRec.M_PM_Product_Line__c== null){
            Product_Line_Cross_Ref__c productRec = productMap.get(opportunityProductRec.M_PM_Product__c);
            opportunityProductRec.M_PM_Product_Line__c= productRec.Product_Line__c;
        }
        
        //Scenario 2
        if(opportunityProductRec.M_PM_Product__c == null && opportunityProductRec.M_PM_Product_Line__c!= null){
            Product_Line__c productLineItemRec = productLineRecordsMap.get(opportunityProductRec.M_PM_Product_Line__c);
            opportunityProductRec.M_PM_Product__c = productLineItemCrossRefNameMap.get(productLineItemRec.Name);
        }
    }
   } 
}
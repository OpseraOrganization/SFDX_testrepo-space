global class CreateTaskForMSPAPUEngineOfferings implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    Map<id,MSPAPUEngineOfferings> fleetMSPMap = new Map<id,MSPAPUEngineOfferings>();  
    
    Set<id> aircraftIdsWithEngine = new Set<id>();
    Set<id> aircraftIdsWithAPU = new Set<id>();
    Set<id> aircraftsWithOpenOppAPU = new Set<id>();
    Set<id> aircraftsWithOpenOppEngine = new Set<id>();
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String storage = 'Storage';
        String inService = 'In Service';
        String OnOrder = 'On Order';
        String TypeSwap = 'Type Swap';
        String mspAPU = '%MSP APU%';
        String HONEYWELL = '%Honeywell%';
        String mspEngine = '%MSP Engines%';
        //String tempId = 'a9A1B000000cjx2';
        String query ='SELECT id,Aircraft_Installed_Count__c,Aircraft__c,Account__r.type,RMU__c,RMU__r.Name,Aircraft__r.Platform_Engine_Maker__c'+
                        ',Aircraft__r.Platform_APU_Maker__c'+
                        ' FROM Account_Eligible_RMU_Fleet_Asset__c where (Aircraft__r.Platform_APU_Maker__c like :HONEYWELL or Aircraft__r.Platform_Engine_Maker__c like :HONEYWELL)and(Aircraft__r.Status__c=:inService or Aircraft__r.Status__c=:storage or Aircraft__r.Status__c=:OnOrder or Aircraft__r.Status__c=:TypeSwap)and (RMU__r.Name like:mspAPU or RMU__r.Name like:mspEngine)and Aircraft__r.Platform_Name__r.MSP_APU_ENG__c = True';
          
          //String query ='SELECT id,Aircraft_Installed_Count__c,Aircraft__c,Account__r.type,RMU__c,RMU__r.Name'+
          //              ' FROM Account_Eligible_RMU_Fleet_Asset__c where
        System.debug('query is---------->'+query);
        return Database.getQueryLocator(query);
   }
    
    global void execute(Database.BatchableContext bc, List<Account_Eligible_RMU_Fleet_Asset__c> fleetRecords){
    Set<id> aircraftIds = new Set<id>();
    
    for(Account_Eligible_RMU_Fleet_Asset__c aer:fleetRecords){
        aircraftIds.add(aer.Aircraft__c);
        if(aer.Aircraft__r.Platform_Engine_Maker__c.containsIgnoreCase('Honeywell')){
            aircraftIdsWithEngine.add(aer.Aircraft__c);
        }
        if(aer.Aircraft__r.Platform_APU_Maker__c.containsIgnoreCase('Honeywell')){
            aircraftIdsWithAPU.add(aer.Aircraft__c);
        }
    }
    
    for(opportunityLineItem oli:[select id,Opportunity.Aircraft_Ref__c,Product2.Name from opportunityLineItem where Opportunity.Aircraft_Ref__c in:aircraftIds and Opportunity.recordtype.Name like 'BGA%' and (NOT Opportunity.stageName like 'Close%') and (Product2.Name like '%MSP APU%' or Product2.Name like '%MSP% Eng%')]){
        if(oli.Product2.Name.containsIgnoreCase('MSP APU')){
            aircraftsWithOpenOppAPU.add(oli.Opportunity.Aircraft_Ref__c);
        }else{
            aircraftsWithOpenOppEngine.add(oli.Opportunity.Aircraft_Ref__c);
        }
    }
    system.debug('Inside execute method');
        try{
        
        for(Account_Eligible_RMU_Fleet_Asset__c fleetRecord: fleetRecords){
            
            MSPAPUEngineOfferings mspOffering = new MSPAPUEngineOfferings();
            if(fleetMSPMap.get(fleetRecord.Aircraft__c) != null){
                mspOffering = fleetMSPMap.get(fleetRecord.Aircraft__c);
            }
            //Add aircraft id.
            mspOffering.aircraft = fleetRecord.Aircraft__c;
            
            //MSP APU
            if(fleetRecord.RMU__r.Name.equalsIgnoreCase('MSP APU')){
                if(aircraftsWithOpenOppAPU.contains(fleetRecord.Aircraft__c)){
                    continue;
                }
                if(fleetRecord.Aircraft_Installed_Count__c >0){
                        mspOffering.mspAPUCount = 1;
                }else{
                    mspOffering.mspAPUCount = 0;
                }                
            }   
            //MSP APU Gold
            if(fleetRecord.RMU__r.Name.equalsIgnoreCase('MSP APU (Gold)')){
                if(fleetRecord.Aircraft_Installed_Count__c >0){
                    mspOffering.mspAPUGoldCount = 1;
                }else{
                    mspOffering.mspAPUGoldCount = 0;
                }
            }
            //MSP Engines
            if(fleetRecord.RMU__r.Name.equalsIgnoreCase('MSP Engines')){
                if(aircraftsWithOpenOppEngine.contains(fleetRecord.Aircraft__c)){
                    continue;
                }
                if(fleetRecord.Aircraft_Installed_Count__c >0){
                    mspOffering.mspEnginesCount = 1;
                }else{
                    mspOffering.mspEnginesCount = 0;
                }                
            }
            //MSP Engines Gold
            if(fleetRecord.RMU__r.Name.equalsIgnoreCase('MSP Engines (Gold)')){
                if(fleetRecord.Aircraft_Installed_Count__c >0){
                    mspOffering.mspEnginesGoldCount = 1;
                }else{
                    mspOffering.mspEnginesGoldCount = 0;
                }                
            }
            fleetMSPMap.put(fleetRecord.Aircraft__c,mspOffering);
            system.debug('Map value at 63'+fleetMSPMap);
        }
        
        
        }catch(Exception e){
            System.debug('Error1 : '+e.getMessage()); 
            System.debug('Error line1 : '+e.getLineNumber());
        } 
     }
      
    global void finish(Database.BatchableContext BC){
        String mspAPUTaskOwner = Label.task_owner_name;//'0051300000CDwuV';//'005a0000009Fgg6';
        String mspEngineTaskOwner = Label.task_owner_name;//'0051300000CDwuV';//'005a0000009Fgg6';
    
        Set<String> contractIds = new Set<String>();
        Map<id,RMU_Sales__c> rmuSalesMap = new Map<id,RMU_Sales__c>([select RMU__r.Name,Order_Number__c,Aircraft__c from RMU_Sales__c where Aircraft__c in :fleetMSPMap.keySet() and (RMU__r.Name ='MSP APU (Gold)' or RMU__r.Name ='MSP Engines (Gold)' or RMU__r.Name ='MSP APU' or RMU__r.Name ='MSP Engines') order by Order_Date__c desc]);
        
        for(RMU_Sales__c rmuSales:rmuSalesMap.values()){
            MSPAPUEngineOfferings offeringPojo = fleetMSPMap.get(rmuSales.Aircraft__c);
            if(rmuSales.Order_Number__c != null && rmuSales.Order_Number__c.startswith('Cnt-')){
                String orderNumber = rmuSales.Order_Number__c.replace('Cnt-','');
                if(rmuSales.RMU__r.Name == 'MSP APU' && offeringPojo.mspAPUContract == null){
                    offeringPojo.mspAPUContract = orderNumber;
                    contractIds.add(orderNumber);
                }
                if(rmuSales.RMU__r.Name == 'MSP APU (Gold)' && offeringPojo.mspAPUGoldContract == null){
                    offeringPojo.mspAPUGoldContract = orderNumber;
                    contractIds.add(orderNumber);
                }
                if(rmuSales.RMU__r.Name == 'MSP Engines' && offeringPojo.mspEnginesContract == null){
                    offeringPojo.mspEnginesContract = orderNumber;
                    contractIds.add(orderNumber);
                }
                if(rmuSales.RMU__r.Name == 'MSP Engines (Gold)' && offeringPojo.mspEnginesGoldContract == null){
                    offeringPojo.mspEnginesGoldContract = orderNumber;
                    contractIds.add(orderNumber);
                }
                fleetMSPMap.put(rmuSales.Aircraft__c,offeringPojo);
            }   
            
        }
        
      // Nothing here.
      List<Task> taskList = new List<Task>();
        Date futureDate = system.today().addDays(30);//system.today().addYears(3);
        Map<String,Contract> contractMap = new Map<String,Contract>();
        //for(Contract contractRec:[select id,Name,AccountId from Contract where Name in :contractIds and (endDate >=:system.today() and endDate <=:futureDate)]){
          for(Contract contractRec:[select id,Name,AccountId from Contract where Name in :contractIds and (endDate >=:system.today() and endDate =:futureDate)]){   
            contractMap.put(contractRec.Name,contractRec);
        }
        system.debug('Contract Names:'+contractIds);
        Map<Id,Fleet_Asset_Detail__c> aircraftMap = new Map<Id,Fleet_Asset_Detail__c>([select id,Account__c from Fleet_Asset_Detail__c where id in :fleetMSPMap.keySet()]);
        System.debug('fleetMSPMap value:'+fleetMSPMap);
        for(Id aircraftId:fleetMSPMap.keySet()){
            MSPAPUEngineOfferings offeringPojo = fleetMSPMap.get(aircraftId);
            switch on offeringPojo.MSPAPUCase {
              when 1 {
                   System.debug('when MSP APU block 1');
                   if(offeringPojo.mspAPUContract == offeringPojo.mspAPUGoldContract){
                        Contract contractRec = contractMap.get(offeringPojo.mspAPUContract);
                        if(contractRec != null){
                            taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP APU and MSP APU Gold offering'));
                        }
                   }else{
                        Contract contractRec = contractMap.get(offeringPojo.mspAPUContract);
                       if(contractRec != null){
                            taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP APU offering'));
                       }
                        contractRec = contractMap.get(offeringPojo.mspAPUGoldContract);
                        if(contractRec != null){
                            taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP APU Gold offering'));
                        }
                   }
               }
               when 2 {
                   System.debug('when MSP APU block -2');
                   Contract contractRec = contractMap.get(offeringPojo.mspAPUGoldContract);
                   if(contractRec != null){
                    taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP APU Gold offering'));
                   }
               }
               when 3 {
                   System.debug('when MSP APU block -3');
                   Contract contractRec = contractMap.get(offeringPojo.mspAPUContract);
                   if(contractRec != null){
                        taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew APU Or Upgrade to Gold'));
                    }
               }
               when 4 {
                   System.debug('when MSP APU block -4');
                   Fleet_Asset_Detail__c aricraft = aircraftMap.get(offeringPojo.aircraft);
                   if(aricraft != null){
                    if(aircraftIdsWithAPU.contains(offeringPojo.aircraft) && !aircraftsWithOpenOppAPU.contains(offeringPojo.aircraft)){
                        taskList.add(createTask(mspAPUTaskOwner,aricraft.Account__c,offeringPojo.aircraft,'Install MSP APU or Gold'));
                    }
                   }
               }
               when 5 {
                   System.debug('when MSP APU block -5');
                   Contract contractRec = contractMap.get(offeringPojo.mspAPUGoldContract);
                   if(contractRec != null){
                    taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'No MSP APU but MSP APU Gold is installed'));
                   }
               }
               when 6 {
                   System.debug('when MSP APU block -6');
                   Contract contractRec = contractMap.get(offeringPojo.mspAPUGoldContract);
                   System.debug('contractRec value:'+contractRec);
                   System.debug('contractMap keys value:'+contractMap.keySet());
                   if(contractRec != null){
                    taskList.add(createTask(mspAPUTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP APU offering'));
                   }
               }
               when else {
                   System.debug('default');
               }
            }
            
            switch on offeringPojo.MSPEnginesCase {
              when 1 {
                   System.debug('when MSP Engines block 1');
                   if(offeringPojo.mspEnginesContract == offeringPojo.mspEnginesGoldContract){
                        Contract contractRec = contractMap.get(offeringPojo.mspEnginesGoldContract);
                        if(contractRec!=null){
                            taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP Engines and MSP Engines Gold offering'));
                        }
                   }else{
                        Contract contractRec = contractMap.get(offeringPojo.mspEnginesContract);
                        if(contractRec!=null){
                            taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP Engines offering'));
                            contractRec = contractMap.get(offeringPojo.mspEnginesGoldContract);
                            taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP Engines Gold offering'));
                        }
                   }
               }
               when 2 {
                   System.debug('when MSP Engines block -2');
                   Contract contractRec = contractMap.get(offeringPojo.mspEnginesGoldContract);
                   if(contractRec != null){
                    taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP Engines Gold offering'));
                   }
               }
               when 3 {
                   System.debug('when MSP Engines block -3');
                   Contract contractRec = contractMap.get(offeringPojo.mspEnginesContract);
                   if(contractRec != null){
                        taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew Engines Or Upgrade to Gold'));
                    }
               }
               when 4 {
                   System.debug('when MSP Engines block -4');
                   Fleet_Asset_Detail__c aricraft = aircraftMap.get(offeringPojo.aircraft);
                    if(aricraft != null){
                    if(aircraftIdsWithEngine.contains(offeringPojo.aircraft) && !aircraftsWithOpenOppEngine.contains(offeringPojo.aircraft)){
                        taskList.add(createTask(mspEngineTaskOwner,aricraft.Account__c,offeringPojo.aircraft,'Install MSP Engines or Gold'));
                    }
                   }
               }
               when 5 {
                   System.debug('when MSP Engines block -5');
                   Contract contractRec = contractMap.get(offeringPojo.mspEnginesGoldContract);
                   if(contractRec != null){
                    taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'No MSP Engines but MSP Engines Gold installed'));
                   } 
               }
               when 6 {
                   System.debug('when MSP Engines block -6');
                   Contract contractRec = contractMap.get(offeringPojo.mspEnginesGoldContract);
                   if(contractRec != null){
                    taskList.add(createTask(mspEngineTaskOwner,contractRec.AccountId,contractRec.id,'Renew MSP Engines offering'));
                   }                   
               }
               when else {
                   System.debug('default');
               }
            }
        
        }
        Database.executeBatch(new BatchInsert(taskList));
    }   
    
    public Task createTask(String owner,String account,String whatId,String taskSubject){
        Task t = new Task();
        t.OwnerId = owner;
        t.Priority = 'Normal';
        t.ActivityDate = Date.today();
        t.Accounts_Name__c = account;
        t.Status = 'Not Started';
        t.whatId = whatId;
        t.RecordTypeId = Label.MSP_Engine_APU;
        t.Description = taskSubject;
        t.Subject = 'MSP APU & ENG';
        t.Task_Subject__c = taskSubject;
        
        return t;
    }
     global void execute(SchedulableContext SC) {
      CreateTaskForMSPAPUEngineOfferings ct = new CreateTaskForMSPAPUEngineOfferings();
      database.executebatch(ct,200);
    }
}
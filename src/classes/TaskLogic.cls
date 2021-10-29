/***
** This class is responsible for creating tasks based on the contract end date.
***/

Public Class TaskLogic{
    public void createTask(){
        List<Task> task = new List<Task>();
      set<id> aircraftIds = new set<id>();
      map<id,Contract> contractMap = new map<id,Contract>([select id,Aircraft__c,AccountId,Region__c,EndDate,Type__c,Aircraft__r.Inside_Sales__c,SBU__c from Contract where Type__c includes('HAPP-MPP','HAPP','MPP') and EndDate =:Date.today() and SBU__C = 'BGA']);
      List<Contract> contractList = contractMap.values();
      set<id> idsWithFAA = new set<id>();
      list<Contract> airCraftContractList = new list<Contract>([select id,Aircraft__c,AccountId,Region__c,EndDate,Type__c,Aircraft__r.Inside_Sales__c from Contract where Type__c includes('HAPP-MPP','HAPP','MPP') and Aircraft__r.OEM_Warranty_Period__c =:Date.today() and Site_Name__c='SAP_CNT']);
      //contractList.addAll(airCraftContractList);
      for(Contract con: airCraftContractList) {
          if(con.Type__c !='HAPP-MSP'){
            aircraftIds.add(con.Aircraft__c);
            if(contractMap.get(con.id) == null){
                contractList.add(con);
            }
            idsWithFAA.add(con.id);
          }
      }
      
      Map<Id,Fleet_Asset_Detail__c> faaMap = new Map<Id,Fleet_Asset_Detail__c>([select id,Inside_Sales__c,Account__c,Region__c from Fleet_Asset_Detail__c where OEM_Warranty_Period__c =:Date.today()]);  
      system.debug('Date ->'+Date.today());
      map<id,id> aircaftAndUserMap = new map<id,id>();
          for(Contract con: contractList) {
          if(con.Type__c.contains('HAPP-MPP') || con.Type__c.contains('HAPP') || con.Type__c.contains('MPP')){
                 faaMap.remove(con.Aircraft__c);
                 // Only valid contract.
                 /*if(contractMap.get(con.id) != null){
                    Boolean skipInsert = false;
                    Task t = new Task();
                    t.whatId = con.id;
                    t.Subject = 'Contract Expired';
                    t.Description = 'Contract Expired';
                    if(con.Aircraft__r.Inside_Sales__c != null){
                     t.OwnerId = con.Aircraft__r.Inside_Sales__c;
                     if(t.OwnerId == null){
                      //   continue;
                      skipInsert = true;
                     }
                     }else{
                        // continue;
                        skipInsert = true;
                     }
                     
                     t.Priority = 'Normal';
                     t.Status = 'Not Started';
                     t.RecordTypeId = Label.Happ_MPP_Task;
                     
                    
                     t.Accounts_Name__c = con.AccountId;
                     t.Region__c = con.Region__c;
                     t.ActivityDate = Date.today();
                     if(!skipInsert){
                        task.add(t); 
                    }                       
                 }*/
            } 
                 if(idsWithFAA.contains(con.id)){
                    Boolean skipInsert = false;
                    Task t = new Task();
                    t.whatId = con.Aircraft__c;
                    t.RecordTypeId = Label.MSPAv_Mech_Task;
                    t.Subject = 'OEM Warranty Expired';
                    t.Description = 'OEM Warranty Expired';
                    if(con.Aircraft__r.Inside_Sales__c != null){
                     t.OwnerId = '0051300000CUHXF';
                     if(t.OwnerId == null){
                         skipInsert = true;
                     }
                     }else{
                         skipInsert = true;
                     }
                     
                     t.Priority = 'Normal';
                     t.Status = 'Not Started';
                     
                    
                     t.Accounts_Name__c = con.AccountId;
                     t.Region__c = con.Region__c;
                     t.ActivityDate = Date.today();
                     if(!skipInsert){
                        task.add(t); 
                    }      
                 }
                 
                  
                 
                 
               
            }   
            
      
      for(Fleet_Asset_Detail__c faaRec:faaMap.values()){
                 system.debug('Second loop:'+faaRec.Id+'->'+faaRec.Inside_Sales__c);
                 Task t = new Task(); 
                 t.OwnerId = '0051300000CUHXF';
                 if(t.OwnerId == null){
                     continue;
                 }
                 t.RecordTypeId = Label.MSPAv_Mech_Task;
                 t.Subject = 'OEM Warranty Expired';
                 t.Priority = 'Normal';
                 t.Status = 'Not Started';
                 t.Description = 'OEM Warranty Expired';
                 t.whatId = faaRec.id;
                 t.Accounts_Name__c = faaRec.Account__c;
                 t.Region__c = faaRec.Region__c;
                 t.ActivityDate = Date.today();
                 task.add(t);   
            }
            
             if(!task.IsEmpty())
                insert task;
      
    }
}
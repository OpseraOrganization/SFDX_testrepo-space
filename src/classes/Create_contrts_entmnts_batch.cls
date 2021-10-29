global class Create_contrts_entmnts_batch implements Database.batchable<sObject>, Schedulable{
    global string query;
    string s =label.ContractsEntitlementBatchDate;
    list<String> sl = s.split(':');
    integer inte = Integer.valueOf(sl[0]);
    integer inte1 = Integer.valueOf(sl[1]);
    
    global date date1 = system.today().adddays(inte);
    global date date2 = system.today().adddays(inte1);
    
    global Create_contrts_entmnts_batch(){
     query = label.ContractsEntitlementBatchQuery;
      System.debug('query ' + query);
      }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
      }
    
    global void execute(Database.BatchableContext BC, List<Fleet_Asset_Detail__c> scope){
     System.debug(scope);
     Map<ID, Fleet_Asset_Detail__c> faaMap = new Map<ID, Fleet_Asset_Detail__c>();
      for(Fleet_Asset_Detail__c FAA:scope){
        faaMap.put(FAA.id, FAA);
      }
      
     //Preparing map for existing contracts
     Map<ID, Contract> cntrMap = new Map<ID, Contract>();
      for(contract objCS : [Select Aircraft__r.id, Id From contract where Aircraft__r.id in: faaMap.KeySet() and recordtype.name ='Training Contracts']){
        cntrMap.put(objCS.Aircraft__r.id, objCS);
        }  
        
        
    //Preparing map for entitlement matrix
    Map<string, list<entitlement_matrix__c>> emMap = new Map<string, list<entitlement_matrix__c>>(); 
    for(entitlement_matrix__c objEM : [Select Make__c,Model__c, Id, Class_name__c,Class_id__c,number_of_seats__c,Time_period__c From entitlement_matrix__c])
        {
            if(!emMap.containsKey(objEM.Make__c+objEM.Model__c))
            {
                emMap.put(objEM.Make__c+objEM.Model__c, new List<entitlement_matrix__c>{objEM});
            }else
            {
                emMap.get(objEM.Make__c+objEM.Model__c).add(objEM);
            }
        }
        System.debug(emMap);
        
      
    try{
    //Preapring new contracts and entitlements
    list<Contract> contr = new list<Contract>();
    list<Entitlement__c> ent = new list<Entitlement__c>();
    For(Fleet_Asset_Detail__c listObj:scope)
    {
    System.debug(listObj.Make__c+listObj.Model__c+' '+
    listObj.account__r.name+' '+listObj.Model__c+' '+listObj.Make__c+' '+emMap.containsKey(listObj.Make__c+listObj.Model__c));
   
        if(!cntrMap.containsKey(listObj.id)
        && listObj.account__r.name !=null && listObj.Model__c !=null && listObj.Make__c!=null && emMap.containsKey(listObj.Make__c+listObj.Model__c))
        {
        contract cntr = new contract();
        cntr.recordtypeid = label.HNTraining_contract_RTid;
        cntr.type__c ='Training Contract';
        System.debug(cntr);
        cntr.accountid = listObj.account__r.id;
        System.debug(cntr);
        cntr.Aircraft__c = listObj.id;
        System.debug(cntr);
        cntr.startdate =listObj.aircraft_delivery_date__c; 
        list<entitlement_matrix__c> em = emMap.get(listObj.Make__c+listObj.Model__c);
        cntr.enddate =listObj.aircraft_delivery_date__c.addYears(em[0].Time_period__c.intValue());
        cntr.status ='New';
        System.debug(cntr);
        if(listObj.account__r.name !=null){
        cntr.name =listObj.account__r.name;
        }
        if(cntr.name !=null && cntr.name.length()<80 && listObj.Model__c != null){
        cntr.name =cntr.name +' '+ listObj.Model__c;
        cntr.description =listObj.Model__c;
        }
        if(cntr.name !=null && cntr.name.length()<80 && listObj.serial_number__c != null){
        cntr.name =cntr.name +' S/N '+ listObj.serial_number__c;
        }
        if(listObj.Model__c != null){
        cntr.description =listObj.Model__c;
        }
        System.debug(cntr);
        if(cntr.description !=null && listObj.serial_number__c != null){
        cntr.description =cntr.description +' S/N '+ listObj.serial_number__c;
        }
        System.debug(cntr);
        contr.add(cntr);
        
    }
      }
    insert contr;
    
    for (contract cnt:[select id,Aircraft_Make__c,Aircraft_Model__c,Aircraft__c,name,startdate,enddate from contract where id in: contr ]){
    list<entitlement_matrix__c> em = emMap.get(cnt.Aircraft_Make__c+cnt.Aircraft_Model__c);
    System.debug(cnt.Aircraft_Make__c+cnt.Aircraft_Model__c);
    //Prepare entitlements
        for (entitlement_matrix__c enmtx:em)
        {
        entitlement__c en = new entitlement__c();
        en.Fleet_Asset_Aircraft__c = cnt.Aircraft__c;
        en.Entitlement_Type__c = 'Training - A/C Delivery';
        en.Contract_Number__c = cnt.id;
        en.Entitlement_Name__c = cnt.name;
        en.Entitlement_Start_Date__c = cnt.startdate;
        en.end_date__c = cnt.enddate;
        en.Course__c = enmtx.Class_id__c;
        en.Number_Of_Seats__c = enmtx.Number_Of_Seats__c;
        en.Percentage__c = 100;
        en.Usage_Cap__c = enmtx.Number_Of_Seats__c;
        en.Usage_Count__c = 0;
        en.status__c = 'Active';
        ent.add(en);
        }
    }
    insert ent;
  
               }
            catch(Exception ex){
                RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
                tlog.Status__c = 'failed';
                tlog.Description__c = 'Create_contrts_entmnts_batch class:'+ex;
                tlog.Sales_Order_Num__c = 'User Name:'+userinfo.getUserName();
                insert tlog;
            }
    }
    
    global void finish(Database.BatchableContext BC){        
    
    } 
    
    global void execute(SchedulableContext sc){
        Create_contrts_entmnts_batch ContractBatch = new Create_contrts_entmnts_batch();
        database.executeBatch(ContractBatch,50);
    }
    
}
global class CreateTaskForCase implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){   
        Date ClosedDate = System.now().dateGMT();
        String Closed = 'Closed';
        String repairOverHaul = 'Repair & Overhaul';
        String aog  = 'AOG';
        String orders = 'Orders';
        String Exchange= 'Exchange';//added for AOG/Spex Case Record Type Split
        String bga = 'BGA';
        String closedAsDuplicate = 'Closed as Duplicate';
        String blank = '';
        String query = 'SELECT Due_Date__c,AccountId,Aircraft_Tail_Number__c,Aircraft_Serial_Number__c,ClosedDate,Product_Code__c,Product_Part_Number__c, Product_Part__c,product__c,id,RecordType.Name,Sub_Class__c,Type,Classification__c,Sales_Order_Number__c,Detail_Class__c,Account.Strategic_Business_Unit__c FROM Case where (RecordType.Name=:repairOverHaul or RecordType.Name=:Exchange or RecordType.Name=:aog or RecordType.Name=:orders) and ClosedDate >=:ClosedDate'+ 
        ' and Account.Strategic_Business_Unit__c=:bga and Status <>:closedAsDuplicate '+
        ' and Sales_Order_Number__c <>:blank and Status = :Closed and Serv_Contract__c =:blank and Contract_Number__c =:blank and Contract_Type__c =:blank and Aircraft_Tail_Number__c<>:blank and Aircraft_Serial_Number__c<>:blank';//added for AOG/Spex Case Record Type Split
        SYstem.debug('ClosedDate value:'+ClosedDate);
        System.debug('query is---------->'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> caseRecords){
        try{
            String blank = '';
            map<String,Case> caseMap = new map<String,Case>();
            set<String> tailNumber = new set<String>();
            for(Case caseRec:caseRecords){
                tailNumber.add(caseRec.Aircraft_Tail_Number__c);
                caseMap.put(caseRec.Aircraft_Tail_Number__c+caseRec.Aircraft_Serial_Number__c,caseRec);
            }
            List<Fleet_Asset_Detail__c> fadList = new list<Fleet_Asset_Detail__c>();
            List<Task> taskList = new List<Task>();
            for(Fleet_Asset_Detail__c fadRec:[select id,Inside_Sales__c,Tail_Number__c,Serial_Number__c from Fleet_Asset_Detail__c where Tail_Number__c in :tailNumber and Serial_Number__c<>:blank]){
                string key = fadRec.Tail_Number__c+fadRec.Serial_Number__c;
                 System.debug('task1 is---------->'+tasklist);
                if(caseMap.get(key) != null){
                 System.debug('task2 is---------->'+taskList );
                    Case caseRec = caseMap.get(key);
                    Task t = new Task(); 
                    t.OwnerId = '0051300000CUHXF';
                    t.Subject = 'SPEX Billable Order';
                    t.Priority = 'Normal';
                    t.Status = 'Not Started';
                    t.Description = 'SPEX Billable Order';
                    t.whatId = caseRec.Id;
                    t.ActivityDate = caseRec.Due_Date__c;
                    t.RecordTypeId = Label.MSPAv_Mech_Task;
                    taskList.add(t);  
                }
            }
            insert taskList;
             System.debug('task3 is---------->'+taskList );
        }catch(Exception e){
            System.debug('Error1 : '+e.getMessage()); 
            System.debug('Error line1 : '+e.getLineNumber());
        }        
    }
      
    global void finish(Database.BatchableContext BC){
      // Nothing here.
    }   
}
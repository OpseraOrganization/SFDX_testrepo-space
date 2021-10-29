global class UpdateMSPCustomerProfileCheck_Batch implements Database.batchable<sObject>, Schedulable{
    global string query;
    global date dt = System.today().addDays(130);
    
    global UpdateMSPCustomerProfileCheck_Batch(){
        query = 'SELECT Renewal_Start_date__c,id,Aircraft__c,SAP_Contract_Number__c,Name,MSP_Customer_Profile_Automation__c'+
        ' FROM contract WHERE Renewal_Start_date__c <=: dt and MSP_Customer_Profile_Automation__c = \'Data Loaded\' and'+
        ' Renewal_Order_Receipt_Name__c != null and recordtype.name = \'MSP Contracts\'  ORDER BY CreatedDate';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<contract> scope){
        for(Contract con:scope){
          con.MSP_Customer_Profile_Automation__c = 'Create Profile';
        }   
        if(!scope.isEmpty()){       
            update scope;
        }  
    }
    
    global void finish(Database.BatchableContext BC){        
    
    } 
    
    global void execute(SchedulableContext sc){
        UpdateMSPCustomerProfileCheck_Batch MSPBatch = new UpdateMSPCustomerProfileCheck_Batch();
        database.executeBatch(MSPBatch,20);
    }
}
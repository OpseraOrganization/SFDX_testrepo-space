global class ContractEndNotification implements Database.batchable<sObject>, Schedulable
{  
 List<contract>  contr = new List<contract>();
    global Database.QueryLocator start(Database.BatchableContext BC){  
        Date today1 = date.valueof(system.today()+ 90); 
        return Database.getQueryLocator([SELECT EndDate,Ownerid,type__c,accountid,account.name,account.owner.email,account.owner.name,owner.email,owner.name,Account_Team_Lead__c,ContractNumber FROM Contract WHERE enddate = : today1 and RecordTypeid =: label.Contracts_Record_Type and accountid !=: label.HON_AERO_AES_CUSTOMER_SERVICES and Account_Team_Lead__c != 'API User SFDC Cust Master' and type__c  EXCLUDES ('EMCPP','FMP','FMS','GDC','GDC - Custom','GDC - ISO','GDC - Standard','GMA','HAPP','MSP','NavDB','NavDb - Demo','NavDb - Free','NavDb - ISO','NavDb - Manual Invoice','NavDb - No Charge','NavDb - One Time','NavDb - Paid','ZING','MPP','Training Contract','TechPubs')]);
        //return Database.getQueryLocator([SELECT EndDate,Ownerid,accountid,account.name,account.owner.email,account.owner.name,owner.email,owner.name,Account_Team_Lead__c,ContractNumber FROM Contract WHERE enddate = : today1 and id= : '800c0000000H8CD']);
    }  
    global void execute(Database.BatchableContext BC, List<contract> scope)
    {
       
        List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>();    
        for(contract rsv:scope)
        { 
            string htmlbody2 = '<font  style="font-family:Times New Roman;font-style:italic;font-weight:bold;color:black;"><a href="'+ label.ServerName +'/'+rsv.account.id +'">'+rsv.account.name+'</a></font>';
            string htmlbody3 = '<font  style="font-family:Times New Roman;font-style:italic;font-weight:bold;color:black;"><a href="'+ label.ServerName +'/'+rsv.id +'">'+rsv.ContractNumber+'</a></font>';
            String  htmlBody='<font style="font-family:Times New Roman"> This is an automated alert from SFDC. Please be aware that ' + htmlbody2 + '  contract   '+ htmlbody3 + '<font style="font-family:Times New Roman"> is coming to an end in 90 days.  Please take appropriate action if required.'+'<br/><br/>'+' Thank you'; 
            string htmlbody1 = 'Hello '+ rsv.Account_Team_Lead__c +' and '+ rsv.owner.name;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {rsv.owner.email,rsv.account.owner.email};                                            
            mail.setToAddresses(toAddresses);
            mail.setSubject(htmlbody1);
            mail.setHtmlBody(htmlBody);
            mails.add(mail);          
        }
         Messaging.sendEmail(mails); 
    }   
    global void finish(Database.BatchableContext BC){   
            
    }     
    global void execute(SchedulableContext sc)
    {
        ContractEndNotification contractnotification = new ContractEndNotification();
        database.executeBatch(contractnotification,200);
    }
}
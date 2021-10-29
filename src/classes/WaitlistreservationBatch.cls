global class WaitlistreservationBatch implements Database.batchable<sObject>, Schedulable{
   global string query;
  
    datetime myDate;
    Id temp =label.Notification_of_Vacancy;
    integer count=0;
    list<id> classids = new list<id>();
    
    
    global WaitlistreservationBatch(){
        
         query = 'SELECT CreatedDate,Flag__c,Id,Mail_send_date__c,Name,Reservation_Status__c,Reservation__c.Class_Name__c FROM Reservation__c WHERE Reservation_Status__c = \'Wait List\' AND Flag__c = true ORDER BY CreatedDate';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
     
         return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Reservation__c> scope){
        List<Reservation__c> lstrsv  = new List<Reservation__c>();
        List<Reservation__c> listrsv  = new List<Reservation__c>();
        List<Messaging.SingleEMailMessage>  mails = new List<Messaging.SingleEMailMessage>();
        
        //Go through the Reservations to update the status from 'Wait list' to 'Ignored'
        for(Reservation__c rsv:scope){
          myDate =rsv.Mail_send_date__c.addDays(3);
          // myDate =rsv.Mail_send_date__c; 
           if(myDate < system.now()){
           classids.add(rsv.Class_Name__c);
           
            rsv.Reservation_Status__c = 'Ignored';
            lstrsv.add(rsv);
            }
            
        }
        
        if(lstrsv.size()>0){
            try{
                update lstrsv;
            }
            catch(Exception ex){}
             
                
      list<Reservation__c> rsvlst = [select id,CreatedDate,Email__c,Class_Name__c,Flag__c,Reservation_Status__c,Student__c from Reservation__c where Reservation_Status__c = 'Wait List' and Flag__c = false and Class_Name__c =:classids Order By CreatedDate ];
                
      list<Class__c > clslst =[select id,Seats_Remaining__c from class__c where id in:classids];
                
                
               
      if(clslst.size()>0){
      for(class__c cls:clslst){
          for( Reservation__c rs : rsvlst){
              if(cls.id==rs.Class_Name__c && count<cls.Seats_Remaining__c ){
                       
                       Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                       mail.setTemplateId(temp); 
                       mail.setTargetObjectId( rs.student__c);
                       mail.setsaveasactivity(false); 
                       mail.setWhatId(rs.id);
                      // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                       mails.add(mail);
                       rs.Flag__c = True;
                       rs.Mail_send_date__c=system.now();
                       listrsv.add(rs); 
                       count++;
                    }
                }
                count=0;
               
            }
            Messaging.sendEmail(mails);
            update listrsv;
          }
        }
    }
    
    global void finish(Database.BatchableContext BC){        
    
    } 
    
    global void execute(SchedulableContext sc){
       WaitlistreservationBatch WaitlstBatch = new WaitlistreservationBatch();
        database.executeBatch(WaitlstBatch,200);
    }
}
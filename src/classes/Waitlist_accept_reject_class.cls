public class Waitlist_accept_reject_class {
    public string rsvaccept{get;set;}
    public  string rsvdecline{get;set;}
     string rsvRec=null;
     datetime myDate;
     Reservation__c rs;
     Id clsid;
     Id temp =label.Notification_of_Vacancy;

    public Waitlist_accept_reject_class() {
      rsvaccept=ApexPages.currentPage().getParameters().get('rsvAccepted');
      rsvdecline=ApexPages.currentPage().getParameters().get('rsvRejected');
      rsvRec=ApexPages.currentPage().getParameters().get('rsv');
      if(rsvRec!=null){
      rs=[select id,Reservation_Status__c,Class_Name__c,Mail_send_date__c,Student__c from Reservation__c where id=:rsvRec ];
        clsid = rs.Class_Name__c;
      }
    }
           
    public void ok(){
           myDate= rs.Mail_send_date__c;
          if(rs.Reservation_Status__c =='Wait list'&& system.now() < myDate.addDays(3)){
          
           if(rsvaccept=='True'){
           rs.Reservation_Status__c = 'Registered';
           update rs;
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'you have successfully registered this course');
           ApexPages.addMessage(msg);
            Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
             mail.setTemplateId('00X30000001iU7n'); 
             mail.setTargetObjectId( rs.student__c);
             mail.setOrgWideEmailAddressId('0D2a00000008QQ8');
             mail.setsaveasactivity(false); 
             mail.setWhatId(rs.id);
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           }
           else if(rsvdecline=='True'){
           
            rs.Reservation_Status__c = 'Declined';
            update rs;
            ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Info,'you have successfully declined this course');
            ApexPages.addMessage(msg1);
            
            list<Reservation__c> rsv =  [SELECT Class_Name__c,CreatedDate,Flag__c,Id,Reservation_Status__c,Student__c FROM Reservation__c WHERE Reservation_Status__c = 'Wait list' AND Class_Name__c =: clsid  AND Flag__c = false ORDER BY CreatedDate LIMIT 1]; 
            
             if(rsv.size()>0){
            
             Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
             mail.setTemplateId(temp); 
             mail.setTargetObjectId( rsv[0].student__c);
             mail.setsaveasactivity(false); 
             mail.setOrgWideEmailAddressId('0D2a00000008QQ8');
             mail.setWhatId(rsv[0].id);
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
             rsv[0].Flag__c = True;
             rsv[0].Mail_send_date__c=system.now();
             update rsv[0];
             }
            
            }
            }
            else if(rs.Reservation_Status__c=='Wait list'&& system.now() > myDate.addDays(3)){
            ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.Info,'you have ignored this course');
            ApexPages.addMessage(msg2);
            }
            
           
            else if(rs.Reservation_Status__c =='Registered'){
             ApexPages.Message msg3 = new ApexPages.Message(ApexPages.Severity.Info,'you have already registered this course');
             ApexPages.addMessage(msg3);
            }
            else if(rs.Reservation_Status__c =='Declined'){
              ApexPages.Message msg4 = new ApexPages.Message(ApexPages.Severity.Info,'you have already cancel this course');
              ApexPages.addMessage(msg4);
            }
            else if(rs.Reservation_Status__c =='ignored'){
              ApexPages.Message msg5 = new ApexPages.Message(ApexPages.Severity.Info,'you have ignored this course');
              ApexPages.addMessage(msg5);
            }
            
    }
   }
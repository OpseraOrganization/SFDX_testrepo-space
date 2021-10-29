trigger changestatusaswaitlist on Reservation__c(before insert,before update){
    List<Reservation__c > reservlist = new List<Reservation__c>();
    List<Class__c> classlist = new List<Class__c>();
    list <Contact> conlist=new list <Contact>();
    list <user> userlist=new list <user>();
    List<id> clslist = new List<ID>();
    List<id> userid = new List<ID>();
    String strCourseName = null;
    list<String> emailtoaddress=new list<string>();
    //Profile proid =[select id from Profile where name='System Administrator' limit 1];
    if(trigger.isinsert)
    {
    for(Reservation__c rs :trigger.new){
        userid.add(rs.Createdbyid);
        clslist.add(rs.Class_Name__c);
    }
        userlist=[select id,Profileid from user where id in :userid];
        classlist = [select Maximum_Capacity__c,Number_of_reservations__c,Course_Name__c,Waitlist_students__c,Seats_Remaining__c from class__c where Id in :clslist];
       for(integer i=0; i<classlist.size();i++){
         for(integer j=0; j<trigger.new.size();j++){
           if(classlist[i].id== trigger.new[j].Class_Name__c && ((classlist[i].Seats_Remaining__c- classlist[i].Waitlist_students__c)<=0)){
             
                 if(trigger.new[j].Reservation_Status__c=='Registered'){
                  
                       
                trigger.new[j].Reservation_Status__c='Wait list';
          /* Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
             mail.setTemplateId('00X30000001iU8g'); 
             mail.setTargetObjectId( trigger.new[j].student__c);
             mail.setOrgWideEmailAddressId('0D2a00000008QQ8');
             mail.setsaveasactivity(false); 
             mail.setWhatId(trigger.new[j].id);
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                    
              }
                
            }
         }
        }
    }
   if(trigger.isupdate)
    {
    for(Reservation__c rs :trigger.new){
        userid.add(rs.Createdbyid);
        system.debug('userid' +userid);
        clslist.add(rs.Class_Name__c);
    }
       // userlist=[select id,Profileid from user where id in :userid];
       // Profile proid =[select id from Profile where name='System Administrator' limit 1];
        classlist = [select Maximum_Capacity__c,Number_of_reservations__c,Course_Name__c,Waitlist_students__c,Seats_Remaining__c from class__c where Id in :clslist];
       for(integer i=0; i<classlist.size();i++){
         for(integer j=0; j<trigger.new.size();j++){
           if(classlist[i].id== trigger.new[j].Class_Name__c && ((classlist[i].Seats_Remaining__c- classlist[i].Waitlist_students__c)<=0)){
               if(trigger.new[j].Reservation_Status__c=='Registered'&& (trigger.old[j].Reservation_Status__c=='Wait List' || trigger.old[j].Reservation_Status__c=='Waitlist') && classlist[i].Seats_Remaining__c!=0 ){
               
                      trigger.new[j].Reservation_Status__c='Registered';
                        
                    }
                    else if(trigger.new[j].Reservation_Status__c=='Registered') {
                           trigger.new[j].Reservation_Status__c='Wait List';
                          }      
                
            }
         }
        }
    } 
    
}
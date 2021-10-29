trigger Cancel_Rsv_Updateclass on Class__c (after update) {
list<Class__c > clslst = trigger.new;
integer count=0;
Id temp =label.Notification_of_Vacancy;
list<Id> clsid = new list<Id>();
list<Class__c > lstcls = new list<class__c>();
list<Class__c > lstclass = new list<class__c>();
list<Reservation__c> lstrsv = new list<Reservation__c>();
for(integer i=0;i<clslst.size();i++){
if(clslst[i].Number_of_reservations__c!= Trigger.old[i].Number_of_reservations__c && clslst[i].Number_of_reservations__c<Trigger.old[i].Number_of_reservations__c ){
clsid.add(clslst[i].id);
lstcls.add(clslst[i]);
}

}
list<Reservation__c> rsvlst = [select id,CreatedDate,Email__c,Class_Name__c,Flag__c,Reservation_Status__c,Student__c from Reservation__c where Class_Name__c in:clsid and Reservation_Status__c = 'Wait List' and Flag__c=false  Order By CreatedDate ];

for(integer i=0; i<lstcls.size(); i++){
 for(integer j=0; j<rsvlst.size(); j++){
 if(lstcls[i].id==rsvlst[j].Class_Name__c && count<lstcls[i].Seats_Remaining__c ){
            
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  
    mail.setTemplateId(temp); 
    mail.setTargetObjectId( rsvlst[j].student__c);
    mail.setsaveasactivity(false); 
    mail.setOrgWideEmailAddressId('0D2a00000008QQ8');
    mail.setWhatId(rsvlst[j].id);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      rsvlst[j].Flag__c = True;
      rsvlst[j].Mail_send_date__c=system.now();
    lstrsv.add(rsvlst[j]); 
    count++;
 }

}
count=0;
}
  update lstrsv ;
 
}
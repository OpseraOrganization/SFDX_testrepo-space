trigger SendMail_Contact on Task (after insert) {
List<Id> TaskIds= new List<Id> ();
List<Id> contactId= new List<Id>();
List<Contact> contacts =new List<Contact>();


List<User> Ownerlist = new List<User>();

list<contact> Contactemail = new list<contact>();
List<Task> Sublist = new List<Task>();
String Subjected;
set<id> OwnerID= new set<id>();
set<id> WhatID= new set<id>();
list<id> Who = new list<id>();
Map<String,String> taskmap = new Map<String,String>();
string owner;
Map<String,String> taskmap1 = new Map<String,String>();
Map<String,String> accmap = new Map<String,String>();
Map<String,String> cntmap = new Map<String,String>();

  for(Task ntask : Trigger.new){   
   // getting parent id
   if(ntask.recordtypeid!= label.General_Task ){
    String parent=ntask.whatId;  
      if(parent!=null)
      parent=parent.substring(0,3);
        if(parent=='a0Y'  && ntask.whoId!=null){     
         TaskIds.add(ntask.Id);
         
           System.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&ntask.whoId'+ntask.whoId);
         contactId.add(ntask.whoId);
        } 
    }           
  } 
    if(contactId.size()>0){
    contacts=[Select Id, name, email from Contact where Id in:contactId];
    }
    
  
  for(Task ntask : Trigger.new){ 
  
  
  String htmlstring= '';
     htmlstring+='<a href=http://honeywellaero.force.com/PlannedMeetingTask?id='+ntask.id;
            htmlstring+='> Click Here</a>';
             
  String contemail,contName;  
   // getting parent id
    String parent=ntask.whatId; 
    String parentname=''; 
   if(parent!=null)
      parent=parent.substring(0,3);
        if(parent=='a0Y'  && ntask.whoId!=null){   
        parentname=[Select name from Planned_Meeting__c where id=:ntask.whatId].name;
            for(integer i=0;i<contacts.size();i++){
              if(contacts[i].Id==ntask.whoId){
                contemail=contacts[i].email;
                contName=contacts[i].name;
              }
            }
       
       System.debug('&&&&&&&&&&&contemail'+contemail);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {contemail}; 
                mail.setToAddresses(toAddresses);
                 mail.setSenderDisplayName('No-Reply@Honeywell.com');
                 mail.setSubject(parentname+' - Planned Meeting Task');
                 mail.setBccSender(false);
                 mail.setUseSignature(false);
                mail.setHtmlBody('Dear '+contName+',<br><br>A task has recently been created from the '+parentname+' Meeting.<br><br>&nbsp;&nbsp;  To view the task click on the following  link ('+ htmlstring +'). Update the necessary fields on this activity such as, status and Action Results and close the activity.'); 
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
       }
   }    
    
}// end of trigger
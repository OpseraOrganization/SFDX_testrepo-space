/*******************************************************************************
Name                  : AircraftNotifications
Usages                : Send alerts to contacts who subscribed for the Aircraft Notification. 
Service Request       : SR#425363
Created date          : 1/3/2014
Modification History  :
Date             Version No.     Service Request     Brief Description of Modification
18/3/2014        1.1             SR#431202           Creating New contract when new Fleet Aircraft Record Created. 
2/18/2017        1.2             Training Ent Proj   Moving new contract creation to schedule class
*******************************************************************************/
trigger AircraftNotifications on Fleet_Asset_Detail__c (after insert,after update) 
{   

    List<Messaging.SingleEMailMessage> mails = new List<Messaging.SingleEMailMessage>();// for contacts 
    set<id> faaid = new set<id>();
    //set<id> contracids = new set<id>();
     List<Attachment> attList = new List<Attachment>();
     //boolean bole = false;
     try{
     system.debug('Trigger Stopper:'+AircraftNotificationsTriggerStopper.hasalreadyExecuted());
    if((trigger.isupdate) && (!AircraftNotificationsTriggerStopper.hasalreadyExecuted()))
    {   
        DateTime LastDate = datetime.newInstanceGmt(2014, 09, 05);
        system.debug('LastDate' +LastDate);
        string emailTemplateId = Label.Fleet_Asset_Aircraft_Notification_Id;        
        //Notifications for Contacts
        //List<Contact> listContact = [select id, Aircraft_Alert_for_Platforms__c from Contact where Aircraft_Notifications__c = true and Contact_Is_Employee__c = true and Lastmodifieddate >: LastDate]; //and recordtypeid in: conRTs.keyset()];    
         // system.debug('listContactsize-->' +listContact.size()  + 'listContacts->' +listContact);
        for(Fleet_Asset_Detail__c fleetAsset : Trigger.New)
        {
            faaid.add(fleetAsset.id);
        }
        if(faaid!=null)
        {
            attList = [SELECT id, Name, body, ContentType FROM Attachment WHERE ParentId=:faaid];
            system.debug('attlist' +attList.size());
        }
        List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
        if(attList.size()>0 && attList!=null)
        {
            for(Attachment att : attList)
            {
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                efa.setFileName(att.Name);
                efa.setBody(att.body);
                efa.setContentType(att.ContentType);
                efa.setInline(false);
                efaList.add(efa);
            }   
            system.debug('efaList1' +efaList.size());
        }
    
    
        list<Fleet_Asset_Detail__c> lstfsd = Trigger.New;
 
        for(integer i=0; i < lstfsd.size();i++)
        {
            if(lstfsd[i].New_Alert_Identification__c == true && lstfsd[i].Fleet_Asset_Notification__c == true && Trigger.old[i].Fleet_Asset_Notification__c == false)
            {         

                    
                
              for(Contact con:[select id, Aircraft_Alert_for_Platforms__c from Contact where Aircraft_Notifications__c = true and Contact_Is_Employee__c = true and Email != ''])
              {
                    system.debug('con.id---->1' + con.id);
                    
                    
                    if(con.Aircraft_Alert_for_Platforms__c == 'All' && con.Aircraft_Alert_for_Platforms__c != 'None'){
                        Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                        mail.setTemplateID(emailTemplateId);
                        system.debug('emailTemplateId--->1' + emailTemplateId);
                        mail.setWhatId(lstfsd[i].id);
                        mail.setTargetObjectId(con.id);
                        mail.setSaveAsActivity(false);
                        if(efaList.size()>0)
                        mail.setFileAttachments(efaList);
                        mails.add(mail);                     
                    }else if(con.Aircraft_Alert_for_Platforms__c != 'None' && con.Aircraft_Alert_for_Platforms__c!= null){
                        system.debug('con.id---->2' + con.id);
                        if(con.Aircraft_Alert_for_Platforms__c.contains(lstfsd[i].Platform_Name__c)){
                            Messaging.SingleEMailMessage mail = new Messaging.SingleEMailMessage();
                            mail.setTemplateID(emailTemplateId);
                            system.debug('emailTemplateId---->2' + emailTemplateId);
                            mail.setWhatId(lstfsd[i].id);
                            mail.setTargetObjectId(con.id);
                            system.debug('con.id---->' + con.id);
                            mail.setSaveAsActivity(false);
                            if(efaList.size()>0)
                            mail.setFileAttachments(efaList);
                            mails.add(mail);  
                        }
                    }
                }        
            }           
        } 
        
    }
    
        if(!AircraftNotificationsTriggerStopper.hasalreadyExecuted())
        {
        system.debug('trigger stop ' + AircraftNotificationsTriggerStopper.hasalreadyExecuted());
        Messaging.sendEmail(mails);
        AircraftNotificationsTriggerStopper.setalreadyExecuted(); 
        system.debug('triggerstop1');
        }       
        //SR#431202  changes
                
    }catch(Exception ex){
        //system.debug('---->Error ' + ex.getmessage());
          RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
                tlog.Status__c = 'failed';
                tlog.Description__c = 'Aircraft Delivery Notification Trigger:'+ex;
                tlog.Case_Num__c = 'Fleet Asset Aircraft ID'+faaid;
                tlog.Sales_Order_Num__c = 'User Name:'+userinfo.getUserName();
                insert tlog;
    }
}
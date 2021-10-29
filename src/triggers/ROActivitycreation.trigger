trigger ROActivitycreation on EmailMessage (after insert){
   /*commenting trigger code for coverage
    Id recrdtypid1 = label.Repair_Overhaul_RT_ID;      
    set<Id> caseid = new set<Id>(); 
    List<Task> NewTaskInsert = new List<Task>();
    //List<Agent_Contact_Mapping__c> lstAgent = new List<Agent_Contact_Mapping__c>();   
    List<string> lstProd = new List<String>();
    List<string> lstProd1 = new List<String>();
    List<Task> tasklist =  new List<Task>();
    List<Task> ts = new List<Task>();
    List<Emailmessage> em = new List<Emailmessage>();
    set<Id> parentid1 = new set<Id>();
    set<Id> parentid = new set<Id>(); 
    set<Id> emailid = new set<Id>();
    string emailSubject;
    public String  uid ;
    string email;  
    string email2;  
    DateTime Msgdate ,lastCreatedDate;
    for(EmailMessage e1 : Trigger.new) 
    {
        uid = Userinfo.getuserid(); 
        if(e1.Incoming == true && e1.ParentId != null)
        {    
            parentid1.add(e1.ParentId);
            emailSubject = e1.Subject; 
            email = e1.FromAddress;
            email2 = e1.ToAddress;
        } 
        if(e1.Incoming == false && e1.ParentId != null)
        {    
           parentid.add(e1.ParentId);
           emailid.add(e1.id);
           lastCreatedDate = e1.MessageDate;
        }      
    }
    if(email != null && email2 != null)
    {
        if(email.contains('honeywell.com'))
        {         
        }
        else
        {          
            if((email2 == 'aeror&oavionics@honeywell.com') || (email2 == 'AeroROAvionicsQA@honeywell.com') 
               || (email2 == 'aeror&oapu@honeywell.com') || (email2 == 'aeror&oengines@honeywell.com') 
               || (email2== 'aeror&ofastshop@honeywell.com' ) || (email2=='aeror&omechcomponents@honeywell.com')
               || (email2=='aeroromechcomponentsqa@honeywell.com')
              )
            {
                case c2 = [select ID,ContactID,Subject,OwnerName__c,R_O_Case_Origin__c,Agent_Contact_Flag__c ,RecordTypeId,OwnerId,CaseNumber from case where id =:parentid1];
                system.debug('venkat12345'+c2.R_O_Case_Origin__c);
                string CaseId1 = c2.OwnerId;    
                string que1 = CaseId1.substring(0,3);
                if(c2.ContactID != null && c2.R_O_Case_Origin__c != null && c2.RecordTypeId == recrdtypid1)
                {
                    List<Agent_Contact_Mapping__c> lstAgent = [select id,CSR__c,CSR__r.Signature1__c,Contact__c,Process__c from Agent_Contact_Mapping__c where Contact__c =:c2.ContactID and Process__c =:c2.R_O_Case_Origin__c];
                    if(lstAgent.size() > 0)
                    {
                        for(Agent_Contact_Mapping__c agc:lstAgent)
                        {
                            if(agc.CSR__c != null)
                            {
                                Task t = new Task();
                                t.whatId = c2.Id;
                                t.Task_Subject__c = c2.subject;
                                t.RecordTypeId = label.R_O_Activity_Label;
                                t.type = 'R&O Activity';
                                t.OwnerId = agc.CSR__c;
                                if(c2.subject != null)
                                {
                                    t.subject = 'Activty on '+ c2.CaseNumber + '-' + emailSubject;
                                }
                                if(c2.subject == null)
                                {
                                    t.subject = 'Activty on '+ c2.CaseNumber;
                                }
                                t.Status = 'Open';        
                                NewTaskInsert.add(t);
                            }
                        }
                    }                   
                }                                               
                else if(c2 != null && c2.RecordTypeId == recrdtypid1 && c2.OwnerName__c != null)
                {
                    Task t = new Task();
                    t.whatId = c2.Id;
                    t.Task_Subject__c = c2.subject;
                    t.RecordTypeId = label.R_O_Activity_Label;
                    t.type = 'R&O Activity';
                    t.OwnerId = c2.OwnerId;
                    if(c2.subject != null)
                    {
                        t.subject = 'Activty on '+ c2.CaseNumber + '-' + emailSubject;
                    }
                    if(c2.subject == null)
                    {
                        t.subject = 'Activty on '+ c2.CaseNumber;
                    }
                    t.Status = 'Open';        
                    NewTaskInsert.add(t);
                }
                else if(c2 != null && c2.RecordTypeId == recrdtypid1 && que1=='00G')
                {
                    Task t = new Task();
                    t.whatId = c2.Id;
                    t.Task_Subject__c = c2.subject;
                    t.OwnerId = label.AERODEFAULTUSER;
                    t.RecordTypeId = label.R_O_Activity_Label;
                    t.type = 'R&O Activity';
                    if(c2.subject != null)
                    {
                        t.subject = 'Activty on ' + c2.CaseNumber + '-' + emailSubject;
                    }
                    if(c2.subject == null)
                    {
                        t.subject = 'Activty on ' + c2.CaseNumber;
                    }
                    t.Status = 'Open';        
                    NewTaskInsert.add(t); 
                }
            }
            if(NewTaskInsert.size() > 0)
            {
                system.debug('new task');
                insert NewTaskInsert;
            }
        }
    }
    if(parentid.size() > 0)
    {
     em=[select Id,Status,MessageDate from Emailmessage where ParentId =:parentid and Status = '3' and id !=: emailid];     
     if(em.size()>0)
        {
        }
     else
        {
           case c1=[select id,CreatedById from case where id=:parentid limit 1];
           ts=[select ID,status,First_Message_Date_Time__c from Task where Whatid=:ParentId  and case_Origin__c='Email' and status != 'Completed'  and CreatedById=:c1.CreatedByID limit 1];
           for (Task tsk : ts)
            {
                tsk.First_Message_Date_Time__c = lastCreatedDate;
                tasklist.add(tsk);
            }
            Update tasklist;
        } 
     } */
}
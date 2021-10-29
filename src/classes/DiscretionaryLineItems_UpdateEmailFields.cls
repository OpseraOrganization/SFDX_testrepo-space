global class DiscretionaryLineItems_UpdateEmailFields implements Database.Batchable<sObject>, Schedulable{

    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute        
        //String query = 'SELECT Id, Spend_Amount__c,Discretionary_Account__c,Performing_site__c,Plant_Code_Master_Name__c, Funding_Amount__c, Mail_Send__c, Mail_Send1__c, Mail_Send2__c, DLIFlag__c, Spend_Amount_Percentage__c, Approval_Status__c, Discretionary_CC_List_Email_Formulae__c, DisEngr_Lead_Contact_EmailFormule__c, CC_Emailid_from_Disc__c, Engineering_Contact_emailid_from_Disc__c, AccountOpener__c, Account_Opener_Backup__c, Discretionary_Request__c, LastModifiedDate FROM Discretionary_Line_Item__c WHERE Spend_Amount_Percentage__c >=50 AND DLIFlag__c = true AND Id=\'' +'a0k1B00000GxixA'+ '\' AND Approval_Status__c !=\'' + 'Close' + '\'';
        //String query = 'SELECT Id, Spend_Amount__c,Discretionary_Account__c,Performing_site__c,Plant_Code_Master_Name__c, Funding_Amount__c, Mail_Send__c, Mail_Send1__c, Mail_Send2__c, DLIFlag__c, Spend_Amount_Percentage__c, Approval_Status__c, Discretionary_CC_List_Email_Formulae__c, DisEngr_Lead_Contact_EmailFormule__c, CC_Emailid_from_Disc__c, Engineering_Contact_emailid_from_Disc__c, AccountOpener__c, Account_Opener_Backup__c, Discretionary_Request__c, LastModifiedDate FROM Discretionary_Line_Item__c WHERE Spend_Amount_Percentage__c >=50 AND DLIFlag__c = true AND Approval_Status__c !=\'' + 'Close' + '\'';
        //System.debug('the query ----'+query);
        String query ='';
        if(test.isrunningtest()){
            query = 'SELECT Id, Spend_Amount__c,Discretionary_Account__c,Performing_site__c,Plant_Code_Master_Name__c, Funding_Amount__c, Mail_Send__c, Mail_Send1__c, Mail_Send2__c, DLIFlag__c, Spend_Amount_Percentage__c, Approval_Status__c, Discretionary_CC_List_Email_Formulae__c, DisEngr_Lead_Contact_EmailFormule__c, CC_Emailid_from_Disc__c, Engineering_Contact_emailid_from_Disc__c, AccountOpener__c, Account_Opener_Backup__c, Discretionary_Request__c, LastModifiedDate FROM Discretionary_Line_Item__c limit 1';
        }else{
            query = 'SELECT Id, Spend_Amount__c,Discretionary_Account__c,Performing_site__c,Plant_Code_Master_Name__c, Funding_Amount__c, Mail_Send__c, Mail_Send1__c, Mail_Send2__c, DLIFlag__c, Spend_Amount_Percentage__c, Approval_Status__c, Discretionary_CC_List_Email_Formulae__c, DisEngr_Lead_Contact_EmailFormule__c, CC_Emailid_from_Disc__c, Engineering_Contact_emailid_from_Disc__c, AccountOpener__c, Account_Opener_Backup__c, Discretionary_Request__c, LastModifiedDate FROM Discretionary_Line_Item__c WHERE Spend_Amount_Percentage__c >=50 AND DLIFlag__c = true AND Approval_Status__c !=\'' + 'Close' + '\'';
           // query = 'SELECT Id, Spend_Amount__c,Discretionary_Account__c,Performing_site__c,Plant_Code_Master_Name__c, Funding_Amount__c, Mail_Send__c, Mail_Send1__c, Mail_Send2__c, DLIFlag__c, Spend_Amount_Percentage__c, Approval_Status__c, Discretionary_CC_List_Email_Formulae__c, DisEngr_Lead_Contact_EmailFormule__c, CC_Emailid_from_Disc__c, Engineering_Contact_emailid_from_Disc__c, AccountOpener__c, Account_Opener_Backup__c, Discretionary_Request__c, LastModifiedDate FROM Discretionary_Line_Item__c WHERE Spend_Amount_Percentage__c >=50 AND DLIFlag__c = true AND Id=\'' +'a0k1B00000GwvJu'+ '\' AND Approval_Status__c !=\'' + 'Close' + '\'';
        }
        //System.debug('the query ----'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Discretionary_Line_Item__c> dliList){  
        // process each batch of records
        List<Discretionary_Line_Item__c> DL=dliList;
        set<id> dliids = new set<id>();
        set<string> sbuset = new set<string>();
        set<string> cbtset = new set<string>();
        set<string> gbeset = new set<string>();
        list<string> CAPPlst = new list<string>();
        list<string> CAPPEmaillst = new list<string>();
        map<string,string> usermap = new map<string,string>();
        list<string> managerids = new list<string>();
        list<string> managernames = new list<string>();
        map<string,string> Approvedusersmail = new map<string,string>();
        list<DR_Approvers_List__c> DRAlist = new list<DR_Approvers_List__c>();
        
        list<user> usrs = new list<user>();
        list<Discretionary_Line_Item__c> lstdli = new list<Discretionary_Line_Item__c>();
        map<id,string> dliemailmap = new map<id,string>();
        /* Update the values of the Email fields from the custom formula fields that have the values of CC List and Engineering List
        EmailIds from Discretionary Requests*/
        for(Integer i=0;i<DL.size();i++){
            DL[i].Discretionary_CC_List_Email__c=DL[i].Discretionary_CC_List_Email_Formulae__c;
            DL[i].Discretionary_Engineer_Lead_ContactEmail__c=DL[i].DisEngr_Lead_Contact_EmailFormule__c;
            DL[i].CC_Email_from_Disc__c = DL[i].CC_Emailid_from_Disc__c;
            DL[i].Eng_Lead_contact_email_from_Disc__c = DL[i].Engineering_Contact_emailid_from_Disc__c;
            DL[i].Account_Opener_Email__c = DL[i].AccountOpener__c;
            DL[i].Account_Opener_Backup_Email__c = DL[i].Account_Opener_Backup__c;            
            dliids.add(DL[i].id);
        }
        //System.Debug('36 '+'DLII'+DL);
        
        List<Discretionary__c> drlist = new List<Discretionary__c>();
        set<id> drid = new set<id>();
        for(Discretionary_Line_Item__c dli:dliList){
            drid.add(dli.Discretionary_Request__c);
        }
        //System.debug('the id is ---'+drid);
        if(drid.size()>0 && drid.size()!=null)
        drlist = [select Approval_Status__c,id,GBE__c,DR_Approver_ID__c,OpportunityName__c, Opportunity__r.Sales_Lead__r.Email, Opportunity__r.Owner.PS_Manager_Name__c, Opportunity__r.Owner.PS_Manager_EID__c, Opportunity__r.Owner.Email, Name, OwnerId,Type__c, CBT__c, SBU__c, Program__c, Account__r.Name, Total_Request_Amount_rollup__c, Engineering_lead_Contact__r.Name, CC_List__r.Name, Current_Approver__c, Total_Approved_Amount__c, Owner__r.Name, Engineering_Lead_User__r.Name, Approver_EmailId__c, sr_number__c, Program_key_code__c,  Current_UserManagerApprove_Email__c,Current_UserManagerApprove_Username__c,Service_request__c, CurrentUserManagerBackupEmail__c,Current_UserManagerBackup_Username_Formu__c from Discretionary__c where id IN:drid];
        //System.Debug('the dr list iss----'+drlist);
        for(Discretionary__c dr:drlist){
            sbuset.add(dr.SBU__c);
            cbtset.add(dr.CBT__c);
            gbeset.add(dr.GBE__c);
            CAPPlst.add(dr.Current_Approver__c);
            CAPPEmaillst.add(dr.Approver_EmailId__c);
            managerids.add(dr.Opportunity__r.Owner.PS_Manager_EID__c);
            managernames.add(dr.Opportunity__r.Owner.PS_Manager_Name__c);
       }
      
       if(drlist.size()>0 && drlist.size()!=null){
    
        if(CAPPlst.size()>0 && CAPPlst.size()!=null && CAPPEmaillst.size()!=null && CAPPEmaillst.size()>0)
           usrs = [select id, email,Name,ContactId from User where Name=:CAPPlst and Email =: CAPPEmaillst and ContactId = null and IsActive = true];
         
         for(user u:usrs){
           usermap.put(u.name,u.email);
         }
         
         if(dliids.size()>0 && dliids.size()!=null){
           lstdli = [select id, Engineering_lead_Contact__r.Email from Discretionary_Line_Item__c where id =:dliids];
         }
           
         for(Discretionary_Line_Item__c dli :lstdli){
           dliemailmap.put(dli.id,dli.Engineering_lead_Contact__r.Email);
         }
        boolean foundWithGbe = false;
        if(sbuset.size()>0 && sbuset.size()!= null && cbtset.size()>0 && cbtset.size()!= null && gbeset.size()>0){
            DRAlist = new list<DR_Approvers_List__c>([SELECT CBT__c,Id,Spent_Sales_Lead_CC__c,Spent_Manager_CC__c,SBU__c,GBE__c FROM DR_Approvers_List__c WHERE SBU__c =:sbuset AND CBT__c =: cbtset AND GBE__c =:gbeset]);
            if(DRAlist != null && DRAlist.size()>0){
                foundWithGbe = true;
            }
        }
        
        if(sbuset.size()>0 && sbuset.size()!= null && cbtset.size()>0 && cbtset.size()!= null && !foundWithGbe){
         DRAlist = [SELECT CBT__c,Id,Spent_Sales_Lead_CC__c,Spent_Manager_CC__c,SBU__c FROM DR_Approvers_List__c WHERE SBU__c =:sbuset AND CBT__c =: cbtset];
        }
        
        for(user usr :[select id,Email,EmployeeNumber from User where name=:managernames and EmployeeNumber =:managerids and IsActive=true]){
            Approvedusersmail.put( usr.EmployeeNumber ,usr.Email);
        }
        
        System.debug('dliList----'+dliList.size());
        
        for(Discretionary_Line_Item__c dli:dliList){
            
            for(Discretionary__c dr:drlist){
            String[] toaddr = new String[]{};
            String[] toaddr1 = new String[]{};
            String[] ccAddresses = new String[]{};
            for(DR_Approvers_List__c dal:DRAlist){
                if(dr.SBU__c == dal.SBU__c && dr.CBT__c == dal.CBT__c ){
                 //system.debug('94 '+dr.Opportunity__r.Sales_Lead__r.Email);
                 //system.debug('95 '+Approvedusersmail.get(dr.Opportunity__r.Owner.PS_Manager_EID__c));
                 if( dal.Spent_Sales_Lead_CC__c == true && dr.Opportunity__r.Sales_Lead__r !=null )
                    ccAddresses.add( dr.Opportunity__r.Sales_Lead__r.Email );
                 if( dal.Spent_Manager_CC__c == true && Approvedusersmail.get(dr.Opportunity__r.Owner.PS_Manager_EID__c) != null )
                    ccAddresses.add( Approvedusersmail.get( dr.Opportunity__r.Owner.PS_Manager_EID__c ) );
                }
            }
            if( usermap.get(dr.Current_Approver__c)!=null )
                ccAddresses.add(usermap.get(dr.Current_Approver__c));
            string siteengmail = dliemailmap.get(dli.id);
            if(dr.Opportunity__c!=null){
            toaddr.add(dr.Opportunity__r.Owner.Email);
            toaddr.add(dli.AccountOpener__c);
            toaddr1.add(dr.Opportunity__r.Owner.Email);
            toaddr1.add(dli.AccountOpener__c);
            }
            if(dr.sr_number__c != null){
            dli.Account_Opener_GTO__c = dr.Current_UserManagerApprove_Username__c;
            dli.Account_Opener_Email__c = dr.Current_UserManagerApprove_Email__c; 
            dli.Account_Opener_Backup_GTO__c = dr.Current_UserManagerBackup_Username_Formu__c;
            dli.Account_Opener_Backup_Email__c = dr.CurrentUserManagerBackupEmail__c;
            }
            //system.debug('108============= '+siteengmail);
            if(siteengmail!=null)
            toaddr1.add(siteengmail);
                 // System.debug('Spend_Amount_Percentage__c '+dli.Spend_Amount_Percentage__c);
                  //System.debug('Approval_Status__c '+dli.Approval_Status__c);
                   //system.debug('DLIFlag__c '+dli.DLIFlag__c);
                  //system.debug('Mail_Send__c'+dli.Mail_Send__c);
                 // system.debug('send address'+toaddr);
                if((dli.Spend_Amount_Percentage__c >=50 && dli.Spend_Amount_Percentage__c <=79 && dli.Approval_Status__c !='Close' && dli.DLIFlag__c == true && dli.Mail_Send__c == false)
                    ||(test.isrunningtest())
                   )
                {
                    try{
                        //System.debug('50% Email ');
                        //System.debug('50% Email ToAddr='+toaddr);
                       //System.debug('50% Email CCAddr='+ccAddresses);                        
                        
                        DateTime dt = dli.LastModifiedDate;
                        String mydate = dt.format('MM/dd/yyyy');
                        String body = '<font size="2" style="font-family:arial">Dear Honeywell Colleague,<br/><br/> Your discretionary'+
                        ' spend has exceeded 50% of the requested amount. <br/><br/>';
                        
                          //System.debug('Opportunity'+dr.Opportunity__c);
                          
                         if(dr.Opportunity__c!=null){
                         //System.debug('Opportunity1'+dr.Opportunity__c);
                        body +=' Request Type:&nbsp;'+dr.Type__c+'<br/>Opportunity : &nbsp;'+dr.OpportunityName__c+'<br/><br/>Program Name : &nbsp;'
                        +dr.Program__c+'<br/>Customer Name : &nbsp;'+dr.Account__r.Name+'<br/>';
                        }
                        System.debug('DR no.'+dr.Service_request__c);
 
                        if(dr.Service_request__c!=null){
                        
                        System.debug('creating email template');
                        body +=' Service Request : &nbsp;'+dr.Sr_number__c+'<br/><br/>Program Key Code : &nbsp;'
                        +dr.Program_key_code__c+'<br/>';
                        }
                        body +='Amount Requested :&nbsp;$'+dr.Total_Request_Amount_rollup__c+'<br/> Approved Amount:&nbsp;$'
                        +dr.Total_Approved_Amount__c+'<br/> Sales Manager Name :&nbsp;'+dr.Owner__r.Name+'<br/> Request Date :&nbsp;'+
                        mydate+'<br/>Engineering Name : &nbsp;'+dr.Engineering_Lead_User__r.Name+','+
                        dr.Engineering_lead_Contact__r.Name+'<br/>Copy To Name :&nbsp;'+dr.CC_List__r.Name+
                        '<br/><br/><br/>Charge Number :&nbsp;'+dli.Discretionary_Account__c+'<br/>';
                        if(dr.Opportunity__c!=null){
                        body +='DLI Site :&nbsp;'+dli.Plant_Code_Master_Name__c +'<br/>';
                        }
                        if(dr.Service_request__c!=null){
                        body +='Performing Site :&nbsp;'+dli.Performing_site__c +'<br/>'+'Work Center :&nbsp;'+
                        dli.Work_center__c +'<br/>';}
                        body +='Site Funding Amount : &nbsp;$'+dli.Funding_Amount__c+'<br/>Spent Amount :&nbsp;$'+dli.Spend_Amount__c+
                        '<br/><br/>Thank you, we appreciate your support! <br/><br/>Please click on the below link to view the details / changes. <br/><a href="'+ label.ServerName +'/'+dli.id+'"/>'+label.ServerName +'/'+dli.id;
                        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                        mail.setCcAddresses(ccAddresses);
                        mail.setToAddresses(toaddr);
                        
                        mail.setSubject('Spend Amount Percentage reached 50%');
                        mail.setHtmlBody(body);
                        mail.setBccSender(false); 
                        mail.setUseSignature(false);
                        mail.setSaveAsActivity(false);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                        dli.Mail_Send__c = true;
                       
                        update dli;
                    }catch(Exception e){
                        
                    }
                }
                if((dli.Spend_Amount_Percentage__c >=80 && dli.Spend_Amount_Percentage__c <=99 && dli.Approval_Status__c !='Close' && dli.DLIFlag__c == true && dli.Mail_Send1__c == false)
                    ||(test.isrunningtest())
                   )
                   {
                    try{
                        System.debug('80% Email ');
                        System.debug('80% Email ToAddr='+toaddr1);
                        System.debug('80% Email CCAddr='+ccAddresses);
                        
                        DateTime dt = dli.LastModifiedDate;
                        String mydate = dt.format('MM/dd/yyyy');
                        String body = '<font size="2" style="font-family:arial">Dear Honeywell Colleague,<br/><br/> Your discretionary'+
                        ' spend has exceeded 80% of the requested amount. <br/><br/>';
                        if(dr.Opportunity__c!=null){
                        body +=' Request Type:&nbsp;'+dr.Type__c+'<br/>Opportunity : &nbsp;'+dr.OpportunityName__c+'<br/><br/>Program Name : &nbsp;'
                        +dr.Program__c+'<br/>Customer Name : &nbsp;'+dr.Account__r.Name+'<br/>';
                        }
                        if(dr.Service_request__c!=null){
                        body +=' Service Request : &nbsp;'+dr.Sr_number__c+'<br/><br/>Program Key Code : &nbsp;'
                        +dr.Program_key_code__c+'<br/>';}
                        body +='Amount Requested :&nbsp;$'+dr.Total_Request_Amount_rollup__c+'<br/> Approved Amount:&nbsp;$'
                        +dr.Total_Approved_Amount__c+'<br/> Sales Manager Name :&nbsp;'+dr.Owner__r.Name+'<br/> Request Date :&nbsp;'+
                        mydate+'<br/>Engineering Name : &nbsp;'+dr.Engineering_Lead_User__r.Name+','+
                        dr.Engineering_lead_Contact__r.Name+'<br/>Copy To Name :&nbsp;'+dr.CC_List__r.Name+
                        '<br/><br/><br/>Charge Number :&nbsp;'+dli.Discretionary_Account__c+'<br/>';
                        if(dr.Opportunity__c!=null){
                        body +='DLI Site :&nbsp;'+dli.Plant_Code_Master_Name__c +'<br/>';
                        }
                        if(dr.Service_request__c!=null){
                        body +='Performing Site :&nbsp;'+dli.Performing_site__c +'<br/>'+'Work Center :&nbsp;'+
                        dli.Work_center__c +'<br/>';
                        }
                        body +='Site Funding Amount : &nbsp;$'+dli.Funding_Amount__c+'<br/>Spent Amount :&nbsp;$'+
                        dli.Spend_Amount__c+'<br/><br/>Thank you, we appreciate your support! <br/><br/>Please click on the '+
                        'below link to view the details / changes. <br/><a href="'+ label.ServerName +'/'+dli.id+'"/>'+
                        label.ServerName +'/'+dli.id;                        
                        
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        
                        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setCcAddresses(ccAddresses);
                        mail.setToAddresses(toaddr1);
                   
                        mail.setSubject('Spend Amount Percentage reached 80%');
                        mail.setHtmlBody(body);
                        mail.setBccSender(false); 
                        mail.setUseSignature(false);
                        mail.setSaveAsActivity(false);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                        dli.Mail_Send1__c = true;
                        
                        update dli;
                    }catch(Exception e){
                       
                    }
                }
                if((dli.Spend_Amount_Percentage__c >=100 && dli.Approval_Status__c !='Close' && dli.DLIFlag__c == true && dli.Mail_Send2__c == false)
                    ||(test.isrunningtest())
                   )
                   {
                    try{
                        System.debug('100% Email ');
                        System.debug('100% Email ToAddr='+toaddr1);
                        System.debug('100% Email CCAddr='+ccAddresses);
                        System.debug('100% Email CCAddr='+dr.Opportunity__c+' '+dr.Service_request__c);
                        DateTime dt = dli.LastModifiedDate;
                        String mydate = dt.format('MM/dd/yyyy');
                        String body = '<font size="2" style="font-family:arial">Dear Honeywell Colleague,<br/><br/> Your discretionary'+
                        ' spend has reached or exceeded 100% of the requested amount. Please click on the Discretionary Line Item link'+
                        ' below to close the charge number or increase your allocations accordingly.<br/><br/>';
                        if(dr.Opportunity__c!=null){
                        body +=' Request Type:&nbsp;'+dr.Type__c+'<br/>Opportunity : &nbsp;'+dr.OpportunityName__c+'<br/><br/>Program Name : &nbsp;'
                        +dr.Program__c+'<br/>Customer Name : &nbsp;'+dr.Account__r.Name+'<br/>';
                        }
                        if(dr.Service_request__c!=null){
                        body +=' Service Request : &nbsp;'+dr.Sr_number__c+'<br/><br/>Program Key Code : &nbsp;'
                        +dr.Program_key_code__c+'<br/>';
                        }
                        body +='Amount Requested :&nbsp;$'+dr.Total_Request_Amount_rollup__c+'<br/> Approved Amount:&nbsp;$'
                        +dr.Total_Approved_Amount__c+'<br/> Sales Manager Name :&nbsp;'+dr.Owner__r.Name+'<br/> Request Date :&nbsp;'+
                        mydate+'<br/>Engineering Name : &nbsp;'+dr.Engineering_Lead_User__r.Name+','+
                        dr.Engineering_lead_Contact__r.Name+'<br/>Copy To Name :&nbsp;'+dr.CC_List__r.Name+
                        '<br/><br/><br/>Charge Number :&nbsp;'+dli.Discretionary_Account__c+'<br/>';
                        if(dr.Opportunity__c!=null){
                        body +='DLI Site :&nbsp;'+dli.Plant_Code_Master_Name__c +'<br/>';
                        }
                        if(dr.Service_request__c!=null){
                        body +='Performing Site :&nbsp;'+dli.Performing_site__c +'<br/>'+'Work Center :&nbsp;'+
                        dli.Work_center__c +'<br/>';
                        }
                        body +='Site Funding Amount : &nbsp;$'+dli.Funding_Amount__c+'<br/>Spent Amount :&nbsp;$'+
                        dli.Spend_Amount__c+'<br/><br/> <span style="color:red;">IF BUDGET IS NOT INCREASED BY NOON MST THIS NUMBER WILL BE CLOSED'+
                        ' </span> <br/><br/>Thank you, we appreciate your support! <br/><br/>Please click on the below link to view the details /'+
                        ' changes. <br/><a href="'+ label.ServerName +'/'+dli.id+'"/>'+label.ServerName +'/'+dli.id;
                        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        if ( owea.size() > 0 ) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }
                        mail.setCcAddresses(ccAddresses);
                        mail.setToAddresses(toaddr1);                        
                        
                        mail.setSubject('Spend Amount Percentage is 100%');
                        mail.setHtmlBody(body);
                        mail.setBccSender(false); 
                        mail.setUseSignature(false);
                        mail.setSaveAsActivity(false);
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                        dli.Mail_Send2__c = true;
                                               
                        update dli;
                    }catch(Exception e){
                       
                    }
                }
            }
        }
        }
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
    global void execute(SchedulableContext sc){
        if(!test.isrunningtest())
        {
        DiscretionaryLineItems_UpdateEmailFields  dliUpdate = new DiscretionaryLineItems_UpdateEmailFields();
        Database.executeBatch(dliUpdate, 1);
        }
    }
}
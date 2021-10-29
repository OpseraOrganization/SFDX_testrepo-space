/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : Notify MCORE Admin
* Description           : Notify the MCORE Admin if Mcore case is Approved/Denied 
                          but the web tool access status doesnt change 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 05-Mar-2013      1.00           Anusuya NTTData       Initial Version
***********************************************************************************************************/

global class MCOREAdminNotification implements Database.Batchable<sObject>, Schedulable
{
    global Integer noofdays=4;
    global String cond = '>';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        DateTime dt = System.now();
        dt=dt.addDays(-noofdays);
        system.debug('dt'+dt);
        String query = 'SELECT case_number__c, ContactId,Status FROM Case WHERE Tool_Name__c like \'%MCORE%\' AND (Status = \'Approved\' OR Status = \'Denied\')'; //and LastModifiedDate '+ cond + ' :dt'; 
        system.debug('query ::'+query );
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
    
        List<Case> cslist = (List<Case>) scope;
        system.debug('Total : '+cslist.size());   
        List<string> str = new List<String>();
        String strCNTID =null;
        
        Map<String,Case> mpskill = new Map<String,Case>();
        for(Integer i=0;i<cslist.size();i++){
            system.debug('inside'+cslist[i].Contactid);
            strCNTID = cslist[i].Contactid;
            if(strCNTID!=null){
                strCNTID= strCNTID.toUpperCase();
                str.add(cslist[i].Contactid);
                }
            system.debug(strCNTID);                            
            mpskill.put(strCNTID,cslist[i]);
          }
        system.debug(str.size());
        Portal_Tools_Master__c mcoretoolid = [SELECT Id FROM Portal_Tools_Master__c where name like '%MCORE%' limit 1];

        List<Contact_Tool_Access__c> ctalist = [SELECT CRM_Contact_ID__c,Portal_Tool_Master__c FROM Contact_Tool_Access__c WHERE Portal_Tool_Master__c =:mcoretoolid.id and CRM_Contact_ID__c in :str and request_Status__c not in('Approved','Denied')];
        system.debug('USER SIze'+ctalist.size());       
        
        Case objs = new Case();
        
        //OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where address like 'aerodonotreply@honeywell.com'] ; // Like 'myaerospace@honeywell.com''                                        
        //system.debug(owa.displayname);
        
        if(ctalist.size()>0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                            
            String[] toAddresses = new String[] {'MCOREAdmin@honeywell.com'};  // Add the MCORE Admin EMail ID "MCOREAdmin@honeywell.com"
            system.debug('toAddresses ::'+toAddresses);                            
            mail.setToAddresses(toAddresses); 
            //mail.setsenderdisplayName('yourresponse@honeywell.com');
            mail.setOrgWideEmailAddressId('0D2300000008P9e');
            //mail.setReplyTo('yourresponse@honeywell.com');
            //mail.setSenderDisplayName('yourresponse@honeywell.com');
             
            String htmlHeader  = '<html><head>'                                        
            +'<body><table>'                                         
            +'<h1 align="right"><font size="18" color="red" align ="right" family="Copper Black"><b>Honeywell</b></font> </h1>'                                         
            +'<tr><hr width="800" color="red" height="25"/></tr>'                                        
            +'</table></head></body></html>';                                                                                
            String htmlbody='Dear MCORE ADMIN,<br/><br/>' ;                                                               
            String field1= 'SFDC application was unable to properly process below access request to MCORE (Maintenance Cost Reduction):<br/>';
            String field3= 'Hence required update to the corresponding Web Portal Contact Tool Access record failed, please follow below link and manually update the record based on the MyAerospace Registration Request case status:<br/>';    
            String field5= 'Thank you! <br/><br/>Honeywell MyAerospace Portal Team';
            mail.setSubject('Approval Failed for MCORE (Maintenance Cost Reduction)');
            String field2 = '<ul>';
            String field4 = '<ul>';
            for(Integer i=0;i<ctalist.size();i++)
            {
                system.debug('EMP num '+ctalist[i].CRM_Contact_ID__c);
                strCNTID= ctalist[i].CRM_Contact_ID__c;
                if(strCNTID!=null)
                    strCNTID= strCNTID.toUpperCase();
                objs = mpskill.get(strCNTID);
                       
                String fullRecordURLTool = URL.getSalesforceBaseUrl().toExternalForm() + '/' + ctalist[i].id ; 
                String fullRecordURLCase = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objs .id ;  
                System.Debug('fullRecordURLTool:::'+fullRecordURLTool );
                field2 = field2 + '<li><a href=\"'+fullRecordURLCase +'\">    MyAerospace Registration Request – '+objs.case_number__c+'</a></li>';           
                
                field4 = field4 + '<li><a href=\"'+fullRecordURLTool +'\">    MCORE Contact Tool Access – Request Status = Pending</a></li>';           
                
            }
            field2 = field2 + '</ul><br/>';
            field4 = field4 + '</ul><br/>';
            mail.setHtmlBody( +htmlHeader+ '<br/>' +htmlbody+ field1+ field2 + field3 + field4 + field5);                             
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    global void finish(Database.BatchableContext BC){
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'Anusuya.Murugiah@nttdata.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Job of Sending Email Completed.');
        mail.setPlainTextBody
        ('The Apex Job has been finished processing');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    global void execute(SchedulableContext sc){
    
      // Below Lines Should be there to call the batchablecontext execute method
      MCOREAdminNotification objSkill = new MCOREAdminNotification();
      Database.executeBatch(objSkill );
      
    }
    public static testmethod void skillupdateexecute() {
    
        Profile prf = [Select id from profile where name = 'System Administrator'];
        UserRole rl = [select id from userrole where name='GTO AM DS FSE 6A'];
        
        User usr =new User(EmployeeNumber='E123456',firstname='Test',lastname='test',
        Username='dfdsf@fff.com', Email='dfsdf@dfdf.com', Alias='sdfsdf', CommunityNickname='sdfsd',
        TimeZoneSidKey='America/Phoenix',LocaleSidKey='en_US',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',           
        ProfileId=prf.id,userroleid=rl.id);         
        insert usr;
         User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {       
        Test.StartTest();
        Account acc= new Account(name = 'Test Account',Market_name__C = 'Military');
        insert acc;
        
        Contact cont = new Contact(
                    firstname = 'Test',
                    LastName = 'Contact',
                    AccountId = acc.Id,
                    Phone_3__c = '9986502495',
                    //Contact_role__c ='FSE',                                        
                    EMAIL = 'anusuya.murugiah@nttdata.com'
                );
               Contact cont1 = new Contact(
                    firstname = 'Test1',
                    LastName = 'Contact1',
                    AccountId = acc.Id,
                    Phone_3__c = '9912122695',
                    //Contact_role__c ='FSE',                                        
                    EMAIL = 'anusuya.murugiah@nttdata.com',
                    Employee_Number__c = 'E123456'
                );
        insert cont; 
        insert cont1; 
            
        Recordtype rt = [select id, name from recordtype  where name like 'Web Portal%' limit 1];
        //insert rt;        
      
        Case case1 = new Case(Tool_Name__c='MCORE-Test',contactid=cont.id,Status='Approved',recordtypeid=rt.id);          
        insert case1;
        //Case case2 = new Case(Tool_Name__c='Other',contactid=cont1.id,Status='Open');          
        //insert case2;
        Portal_Tools_Master__c mcoretoolid = new Portal_Tools_Master__c(name='MCORE',tool_description__c ='MCORE ADMIN');
        insert mcoretoolid;
        
        Contact_tool_access__c cta1 = new Contact_tool_access__c(Request_status__c='Pending',CRM_Contact_ID__c=cont.id,Portal_Tool_Master__c=mcoretoolid.id ,Portal_Honeywell_ID__c = 'E812402');
        insert cta1;
        Contact_tool_access__c cta2 = new Contact_tool_access__c(CRM_Contact_ID__c=cont1.id,Portal_Honeywell_ID__c = 'E812402');
        insert cta2;
                
        MCOREAdminNotification objskup = new MCOREAdminNotification ();
        objskup.noofdays=1;
        DateTime dt = System.now();
        dt=dt.addDays(objskup.noofdays);
        objskup.cond = '=';
       // Integer intcount = [SELECT count() FROM CASE WHERE LastModifiedDate >:dt];      
        ID batchid = Database.executeBatch(objskup ,200 );
        MCOREAdminNotification objskillup = new MCOREAdminNotification ();
        String sch = '0 30 4 12 3 ?';
        System.Schedule('MCOREAdminNotificationScheduler-Testing', sch, objskillup );
        
        Test.StopTest();
        }
    }
}
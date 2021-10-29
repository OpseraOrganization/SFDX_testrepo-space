/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : SkillUpdateBatch
* Description           : Batch class to send the email notification for the contact who has not update 
*                         the Skills for the past Six month 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 19-Nov-2012      1.00           Anusuya NTTData       Initial Version
***********************************************************************************************************/

global class SkillUpdateBatch implements Database.Batchable<sObject>, Schedulable
{
    global Integer noofdays=180;
    global String cond = '<';
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        DateTime dt = System.now();
        dt=dt.addDays(-noofdays);
        system.debug('dt'+dt);
        //String query = 'SELECT Contact_Email__c,Contact__c,Contact_Name__c,Id,LastModifiedDate FROM Skills2__c WHERE LastModifiedDate '+ cond + ' :dt' + ' and (Contact__r.Contact_Role__c in (\'FSE\',\'Product Support Engineer\') or Contact__r.Employee_Contact_Role__c in (\'Field Service Engineer (FSE)\',\'Field Service Manager\',\'Product Support Engineer\',\'Product Support Eng Manager\',\'Product Support Program Mgr (PSPM)\'))'; 
        String query = 'SELECT Contact_Email__c,Contact__c,Contact_Name__c,Id,LastModifiedDate,Contact__r.Employee_number__c FROM Skills2__c WHERE LastModifiedDate '+ cond + ' :dt'; 
        system.debug('query ::'+query );
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
    
        /////////List<skills2__c> objskill = (List<skills2__c>) scope;
        List<skills2__c> stlist = (List<skills2__c>) scope;
        system.debug('Total : '+stlist.size());
        ///////////////
        List<string> str = new List<String>();
        String strEMP =null;
        Map<String,skills2__c> mpskill = new Map<String,skills2__c>();
        for(Integer i=0;i<stlist.size();i++){
            system.debug('inside'+stlist[i].Contact__r.Employee_number__c);
            strEMP = stlist[i].Contact__r.Employee_number__c;
            if(strEMP !=null){
                strEMP = strEMP.toUpperCase();
                str.add(stlist[i].Contact__r.Employee_number__c);
                }
            //system.debug('inside'+stlist.size());
            system.debug(strEMP);
            //system.debug(stlist[i].Contact__r.Employee_number__c+' '+stlist[i].id);
                
            mpskill.put(strEMP,stlist[i]);
          }
          system.debug(str.size());
        List<User> userlist = [SELECT Employeenumber,email,userrole.name FROM User WHERE employeenumber in :str and isactive=true and (userrole.name like '%PSE%' or userrole.name like'%TSE%' or userrole.name like '%FSE%')];
        system.debug('USER SIze'+userlist.size());
        Skills2__c objs = new skills2__c();
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress where displayname like 'your%'] ;                                         
        system.debug(owa.displayname);
        for(Integer i=0;i<userlist.size();i++)
        {
            system.debug('EMP num '+userlist[i].Employeenumber);
            strEMP = userlist[i].Employeenumber;
            if(strEMP !=null)
                strEMP = strEMP.toUpperCase();
            objs = mpskill.get(strEMP);
            
                    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();                            
            //////////////String[] toAddresses = new String[] {objskill[i].Contact_Email__c};            
            String[] toAddresses = new String[] {objs.Contact_Email__c};            
            system.debug('toAddresses ::'+toAddresses);                            
            mail.setToAddresses(toAddresses);                         
            //mail.setsenderdisplayName('yourresponse@honeywell.com');
            mail.setOrgWideEmailAddressId(owa.id);
            
            
            /////////String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objskill[i].id ;   
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objs.id ;   
            System.Debug('fullRecordURL:::'+fullRecordURL );
            String htmlHeader  = '<html><head>'                                        
            +'<body><table>'                                         
            +'<h1 align="right"><font size="18" color="red" align ="right" family="Copper Black"><b>Honeywell</b></font> </h1>'                                         +'<tr><hr width="800" color="red" height="25"/></tr>'                                        +'</table></head></body></html>';                                                             
            
            String htmlbody='Dear SalesForce User,<br>' 
            +'In order to keep our records updated, we are asking all SalesForce users to make sure that all of the information in the Virtual Network is kept updated.   Please review to make sure your information is correct.  We will be requiring all users to go in every 6 months to verify and/or update information.'
            +'<br><br>'
            +'If your information is correct once you have gone into the system, then there is NO action required.  '
            +'<br><br>'
            +'Please click the link below to view step-by-step instructions on how to update your information based on your current role.'
            +'<br><br>';                            
            
            String field1= '<a href="http://in.honeywell.com/sites/aero/CPS/Documents/How to Update my SFDC Information 2012.pptx"> How to Update My Information in Salesforce</a>';
            String field2= '<br><br>';
            String field3= 'Update your information in Salesforce NOW   ';
            String field4= '('+fullRecordURL +')<br><br>';
            
            String field5= 'Thank you, we appreciate your support!'
            +'<br><br><br><br>'
            +'If you have any question please contact your Salesforce Administrator.';
            
            mail.setSubject('Update your skills and accounts in Salesforce');
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
      Skillupdatebatch objSkill = new Skillupdatebatch();
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
                    Phone_3__c = '9986502695',
                    //Contact_role__c ='FSE',                                        
                    EMAIL = 'anusuya.murugiah@nttdata.com',
                    Employee_Number__c = 'E123456'
                );
        insert cont; 
        insert cont1; 
        
        Skills2__c objsk = new Skills2__c(Skill_Type__c='Aircraft Type Q-Z',Skill_Value__c='Sikorsky UH-60 Black Hawk',
        Contact__c=cont.id);
        Skills2__c objsk1 = new Skills2__c(Skill_Type__c='Aircraft Type Q-Z',Skill_Value__c='Sikorsky UH-60 Black Hawk',
        Contact__c=cont1.id);
        insert objsk; 
        insert objsk1;  
        
        SkillUpdateBatch objskup = new SkillUpdateBatch ();
        objskup.noofdays=4;
        DateTime dt = System.now();
        dt=dt.addDays(-objskup.noofdays);
        objskup.cond = '>';
        Integer intcount = [SELECT count() FROM Skills2__c WHERE LastModifiedDate >:dt];      
        ID batchid = Database.executeBatch(objskup ,intcount );
        SkillUpdateBatch  objskillup = new SkillUpdateBatch();
        String sch = '0 0 12 29 11 ?';
        System.Schedule('SkillUpdateScheduler-Testing', sch, objskillup );
        
        Test.StopTest();
        }
    }
}
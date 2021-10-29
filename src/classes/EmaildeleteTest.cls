@isTest(seeAlldata=true)
//@isTest
private class EmaildeleteTest {
@istest(seealldata=true)
     static void deleteemail()
         {
      
           Case c= new case();
          c.origin='Email';
          c.RecordtypeId=Schema.sobjecttype.case.getrecordtypeinfosbyname().get('Technical Issue').getrecordtypeid();
          c.Emailbox_Origin__c= 'Email-AeroTechSupport';
          c.ownerId= '005300000042rPL';
          c.status='closed';
         // Id csoroId= label.CSO_R_O_Team;  
          insert c;
            //case reccase  =[select id,status, origin from case where origin='Email' and status!='open' limit 1]; 
        
        c=[select id,Case_Ref_ID__c from case where id=:c.id limit 1];
        EmailMessage em =new EmailMessage();
        em.status = '5';
        em.FromAddress ='aexmailer@aeroxchange.com';      
        em.Subject = 'test';
        em.textbody='test' + c.Case_Ref_ID__c ;
        em.ToAddress= 'Aerotechsupport@honeywell.com';        
        em.ParentId = c.Id; 
        insert em;
        
        Test.starttest();
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='CRM Admin'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
         UserName=uniqueUserName);
        System.runAs(u) { 
        EmailMessage e;
        e=[select id from EmailMessage where id=:em.id limit 1];
        delete e;
        }
        Test.stoptest();
        
}
}
@isTest
public class EmailMessagesPaginationControllerTest {

    public static testMethod void  ControllerTest(){
        case c = new case();
        c.origin='Email';
        c.RecordtypeId=Schema.sobjecttype.case.getrecordtypeinfosbyname().get('Technical Issue').getrecordtypeid();
        c.Emailbox_Origin__c= 'Email-AeroTechSupport';
        c.status = 'Open';
        insert c;
        
        //Case qC =[select id,Case_Ref_ID__c from case where id=:c.id limit 1];
        List<EmailMessage> emList = new List<EmailMessage>();
         EmailMessage em =new EmailMessage();
        em.Incoming = true;
        em.FromAddress ='test@sample.com';      
        em.Subject = 'Sample Email';
        em.ToAddress= 'sample@invalid.com';        
        em.ParentId = c.Id; 
        emList.add(em);
       // insert em; 
        EmailMessage em1 =new EmailMessage();
        em1.Incoming = true;
        em1.FromAddress ='test@sample.com';      
        em1.Subject = 'Sample Email';
        em1.ToAddress= 'sample@invalid.com';        
        em1.ParentId = c.Id; 
        emList.add(em1);
        insert emList; 
        Test.startTest();
        EmailMessagesPaginationController.previousMsg(emList[0].id);
        EmailMessagesPaginationController.NextMessage(emList[0].id);
        Test.stopTest();
        
    }
}
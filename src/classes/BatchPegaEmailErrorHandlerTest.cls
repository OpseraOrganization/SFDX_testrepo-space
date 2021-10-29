@isTest
public class BatchPegaEmailErrorHandlerTest {
   
public static Country__c country=new Country__c();
public static Account a= new Account();
public static contact con= new contact();
//public static  case pega1=new case();
//public static  case caseeg=new case();
//public static User g;
    
    @isTest
    public static void testPositive(){
      
        List<PegaEmailServiceQueue__c>  queuelist= new  List<PegaEmailServiceQueue__c>();
        
       PegaService__c ps=new PegaService__c(name='Endpoints',Email_To_Pega__c='https://infbpo-dt1.pegacloud.io/prweb/PRRestService/SFDC/ProcessRequest/EmailService',Create_Case__c='https://infbpo-dt1.pegacloud.io:443/prweb/PRRestService/SFDC/ProcessRequest/CreateCase');
    insert ps;
        
   PegaCredentials__c pc=new PegaCredentials__c(name='ServiceCredentials',Username__c='abx',Password__c='ru');
   insert pc;
   
    country.name= 'testcountry';
    country.SFDC_Country_Name__c='testcountry1';
    insert country;
    system.debug('##########coun'+country.id);
  
    a.name='testacc';
    a.Customer_Status__c='Active';
    a.Country__c=country.id;
    a.Service_Level__c='Standard';
    a.Strategic_Business_Unit__c='ATR';
    a.type='Dealer';
    a.REPORT_ACCOUNT_NAME__c='xyz';
    insert a;
    system.debug('##########acc'+a.id);

    list<RecordType> rt = [SELECT Id FROM RecordType Where name ='Honeywell Employee' and SobjectType='contact'];
    con.RecordTypeID=rt[0].id;
    con.lastname='Testcon';
    system.debug('nsdba'+a.id);
    con.AccountId=a.Id;
    con.Contact_Function__c='AOG';
    con.Email='ramya.s31@infosys.com';
    insert con;
    system.debug('##########contact'+con.id);
        
        case pega1=new case();
        list<RecordType> rt1 = [SELECT Id FROM RecordType Where name ='orders' and SobjectType='case' ];
        pega1.recordtypeId=rt1[0].id;
        system.debug('##########RECORDIDDD'+pega1.recordtypeId);
        
       
        
        pega1.origin='Email';
        pega1.Export_Compliance_Content_ITAR_EAR__c='No';
        pega1.Government_Compliance_SM_M_Content__c='No';
        pega1.Pega_Reason_for_Hold__c= 'Shipment Status';
        pega1.status='open';
        pega1.Type= 'Place Order';
        pega1.Sales_Order_Number__c='1234567890';
        pega1.ContactId=con.id;
        User u=[Select Id from User where name='Pega'];
        pega1.OwnerId=u.id;
        pega1.Pega_Case_ID__c='O-1234';
        insert pega1;
        
        EmailMessage em= new EmailMessage();
    em.FromAddress ='ramya.s31@infosys.com';
    em.ParentId =pega1.id;
    em.Subject ='test email';
       // em.HasAttachment=true;
    em.ToAddress ='orderstatus@honeywell.com';
    em.TextBody ='insert test email';
        em.Incoming=true;
    insert em;
        system.debug('##########EMAIL'+em);
        
         EmailMessage e= new EmailMessage();
    e.FromAddress ='mayur.sokanki@infosys.com';
    e.ParentId =pega1.id;
    e.Subject ='test email without attachment';
       // em.HasAttachment=true;
    e.ToAddress ='orderstatus@honeywell.com';
    e.TextBody ='insert test email';
        e.Incoming=true;
    insert e;
        system.debug('##########EMAIL'+e);

    Attachment att= new Attachment();
    att.ParentId=em.id;
    att.name='test attachemnt';
    att.Body=blob.valueOf('check attachment');
    insert att;
        system.debug('##########  ATTAChement'+att);
                
        
        Set<Id> emailIds=new Set<Id>();
        emailIds.add(em.id);
        emailIds.add(e.id);
        PegaEmailServiceQueue__c queueobj= new PegaEmailServiceQueue__c();
        queueobj.CC_Address__c='testemail@honeywell.com';
        queueobj.From_Address__c='testemail@honeywell.com';
        queueobj.Bcc_Address__c='testemail@honeywell.com';
        queueobj.Email_Message_Id__c=em.id;
        queueobj.Html_Body__c='sample body';
        queueobj.Pega_Case_Id__c='o-4341';
        queueobj.Sent__c=date.today();
        queueobj.Subject__c='test sub';
        queueobj.To_Address__c='ramya.s31@gmail.com';
                    
        
        insert queueobj;
 
        
        Test.startTest();
        //queuelist=[SELECT id,CC_Address__c,Email_Message_Id__c,From_Address__c,Html_Body__c,Pega_Case_Id__c,Sent__c,Subject__c,To_Address__c,Bcc_Address__c FROM PegaEmailServiceQueue__c];
        Test.setMock(HttpCalloutMock.class, new PegaEmailServiceMock());
        BatchPegaEmailErrorHandler obj= new BatchPegaEmailErrorHandler();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test', sch, obj);
        DataBase.executeBatch(obj);   
        test.stopTest();
        List<PegaEmailServiceQueue__c> que=[Select id from PegaEmailServiceQueue__c limit 5];
        system.debug('##########queuelist'+que);
        system.assertEquals(true, que.isEmpty());
      
    }

}
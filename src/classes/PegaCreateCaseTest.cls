@isTest
public class PegaCreateCaseTest {
    
    public static Country__c country=new Country__c();
    public static Account a= new Account();
    public static contact con= new contact();
    public static List<Case> caselist= new List<Case>();
    
    @isTest
    public static void testPegaCreateCase(){
        PegaService__c ps=new PegaService__c(name='Endpoints',Email_To_Pega__c='https://infbpo-dt1.pegacloud.io/prweb/PRRestService/SFDC/ProcessRequest/EmailService',Create_Case__c='https://infbpo-dt1.pegacloud.io:443/prweb/PRRestService/SFDC/ProcessRequest/CreateCase',Token_Endpoint__c='https://infbpo-dt1.pegacloud.io:443/prweb/PRRestService/oauth2/v1/token');
        insert ps;
        
        PegaCredentials__c pc=new PegaCredentials__c(name='ServiceCredentials',Username__c='abx',Password__c='ru',Client_Credentials__c='test');
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
        a.CBT__c = 'Airbus';
        a.CBT_Team__c = 'Airbus Companies';
        a.Sales_Channel__c = 'Mechanical Systems & Components OE';
        a.SC1__c = 'Airbus';
        a.Market_Name__c = 'Air Transport';
        a.Business_Owner__c = 'Chevrier, Philippe';
        a.type='Dealer';
        a.REPORT_ACCOUNT_NAME__c='testacc';
        insert a;
        system.debug('##########acc'+a.id);

        list<RecordType> rt = [SELECT Id FROM RecordType Where name ='Honeywell Employee' and SobjectType='contact'];
        con.RecordTypeID=rt[0].id;
        con.lastname='Testcon';
        system.debug('nsdba'+a.id);
        con.AccountID=a.id;
        con.Contact_Function__c='AOG';
        con.Email='ramya.s31@infosys.com';
        con.Primary_Email_Address__c='abc@xyz.com';
        insert con;
        system.debug('##########contact'+con.id);

   
        case pega1=new case();
        //list<RecordType> rt1 = [SELECT Id FROM RecordType Where name ='orders' and SobjectType='case' ];
        pega1.recordtypeId=Label.Orders_Rec_ID;
        system.debug('##########RECORDIDDD'+pega1.recordtypeId);
        pega1.origin='Email';
        pega1.Export_Compliance_Content_ITAR_EAR__c='No';
        //Pega1.Contact.Primary_Email_Address__c,='ramya.s31@infosys.com';
        pega1.Government_Compliance_SM_M_Content__c='No';
        pega1.Pega_Reason_for_Hold__c= 'Shipment Status';
        pega1.status='open';
        pega1.Type= 'Place Order';
        pega1.Sales_Order_Number__c='1234567890';
        pega1.ContactId=con.Id;
       // pega1.contact.email='abc@xyz.com';
        //User u=[Select Id from User where name='Pega'];
        pega1.OwnerId=Label.Pega_Owner_Id;
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
        //update pega1;
       

        Attachment att= new Attachment();
        att.ParentId=em.id;
        att.name='test attachemnt';
        att.Body=blob.valueOf('check attachment');
        insert att;
        system.debug('##########  ATTAChement'+att);
        
        Attachment att1= new Attachment();
        att1.ParentId=em.ParentId;
        att1.name='test attachemnt1';
        att1.Body=blob.valueOf('check attachment1');
        insert att1;
        
        Case caseeg=[Select id,recordtypeId,OwnerId,Additional_Web_Form_Info__c,origin,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Pega_Reason_for_Hold__c,status,Type,Sales_Order_Number__c,ContactId,contact.email,(SELECT FromAddress,Id,ParentId,Incoming,Status,Subject,TextBody,CCAddress,ToAddress,HtmlBody,hasAttachment,createdDate FROM EmailMessages) from case where id=:pega1.id];
        //EmailMessage email=[SELECT FromAddress,Id,ParentId,Incoming,Status,Subject,TextBody,CCAddress,ToAddress,HtmlBody,hasAttachment,createdDate FROM EmailMessage where parentId=:pega1.id];
        user g=[Select Id from User where Name='Pega'];
        Contact c=[Select id,Email from contact where id=:caseeg.ContactId];
        c.Email='abc@xyz.com';
        //update c;
        system.debug('##########GROUP'+g.id);
        caseeg.OwnerId=g.id;
        caseeg.ContactId=c.id;
        //caseeg.Contact.email='abc@xyz.com';
        system.debug('##########GROUP'+caseeg.OwnerId);
       // update caseeg;
        system.debug('##########  Case after update'+caseeg);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new PegaCreateCaseMock());
        String msg=PegaCreateCaseController.CreatePegaCase(caseeg.id);
        
        PegaRequestWrapper pr = new PegaRequestWrapper();
        Test.stopTest();
        
        
        
    }

}
@istest
public class PegaCaseServiceControllerTest {
 
    public static Country__c country=new Country__c();
    public static Account a= new Account();
    public static contact con= new contact();
    public static  case pega1=new case();
    public static  case caseeg=new case();
    public static User g;
    
    public static case testdata(){
      
        //PegaService__c ps=new PegaService__c(name='Endpoints',Email_To_Pega__c='https://infbpo-dt1.pegacloud.io/prweb/PRRestService/SFDC/ProcessRequest/EmailService',Create_Case__c='https://infbpo-dt1.pegacloud.io:443/prweb/PRRestService/SFDC/ProcessRequest/CreateCase');
        //insert ps;
            
        //PegaCredentials__c pc=new PegaCredentials__c(name='ServiceCredentials',Username__c='abx',Password__c='ru');
        //insert pc;
        //country.name= 'testcountry';
        //country.SFDC_Country_Name__c='testcountry1';
        //insert country;
        //system.debug('##########coun'+country.id);

        /*a.name='testacc';
        a.Customer_Status__c='Active';
        a.Country__c=country.id;
        a.Service_Level__c='Standard';
        a.Strategic_Business_Unit__c='ATR';
        a.type='Dealer';
        a.REPORT_ACCOUNT_NAME__c='xyz';
        insert a;
        system.debug('##########acc'+a.id);
        //list<RecordType> rt = [SELECT Id FROM RecordType Where name ='Honeywell Employee' and SobjectType='contact'];
        con.RecordTypeID=Label.Honeywell_Employee_Recordtype;
        con.lastname='Testcon';
        system.debug('nsdba'+a.id);
        con.AccountId=a.Id;
        con.Contact_Function__c='AOG';
        con.Email='ramya.s31@infosys.com';
        con.Primary_Email_Address__c='abc@xyz.com';
        insert con;
        system.debug('##########contact'+con.id);*/

       
        //list<RecordType> rt1 = [SELECT Id FROM RecordType Where name ='orders' and SobjectType='case' ];
        pega1.origin='Email';
        pega1.Export_Compliance_Content_ITAR_EAR__c='No';
        //Pega1.Contact.Primary_Email_Address__c,='ramya.s31@infosys.com';
        pega1.Government_Compliance_SM_M_Content__c='No';
        pega1.Pega_Reason_for_Hold__c= 'Missed Shipment';
        pega1.status='Done';
        pega1.Type= 'Place Order';
        pega1.Sales_Order_Number__c='1234567890';
        //pega1.ContactId=con.Id;
        pega1.RecordTypeId='01230000000Zen1';
        //pega1.RecordType='General';
        //User u=[Select Id from User where name='Aero Default'];
        //pega1.OwnerId=Label.AERODEFAULTUSER;
        pega1.OwnerId=Label.Pega_Owner_Id;
        pega1.Reason_for_Hold__c='A/C Details';
        insert pega1;
        system.debug('##########casepega1'+pega1.id);
        
        caseeg=[Select id,casenumber,recordtypeId,OwnerId,origin,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Pega_Reason_for_Hold__c,status,Type,Sales_Order_Number__c, (SELECT FromAddress,Id,ParentId,Incoming,Status,Subject,TextBody,CCAddress,ToAddress,HtmlBody,hasAttachment,createdDate FROM EmailMessages) from case where id= :pega1.id];
        //g=[Select Id from User where Name='Pega'];
        //system.debug('##########GROUP'+g.id);
        system.debug('##########caseeg'+caseeg);
        //Contact c=[Select id,Email from contact where id=:caseeg.ContactId];
        //c.Email='abc@xyz.com';
        //update c;
        //caseeg.OwnerId=Label.Pega_Owner_Id;
        //caseeg.ContactId=c.id;
        //caseeg.Contact.email='abc@xyz.com';
        //update caseeg;
        Task  tsk = new Task();
        tsk.Status = 'In Progress';
        tsk.WhatId = caseeg.id;
        try{
        insert tsk;
        system.debug('##########task'+tsk.id);
        }
        catch(DMLEXception e){}
        
        return caseeg;
       
    }
   
    @isTest
    public static void positiveCase(){
        Test.startTest();
        Case caseeg= PegaCaseServiceControllerTest.testdata();
        system.debug('#####Inside positive case###'+caseeg);
        
        //User g=[Select Id from User where Name='Pega'];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Cases/'+caseeg.Id;
        PegaCaseServiceController.fromJSON reqparam= new PegaCaseServiceController.fromJSON();
        reqparam.EscalatedTo='abc@xyz.com';
        reqparam.Status='Done';
        reqparam.SalesOrderNumber='1234567890';
        reqparam.OwnerId=Label.Pega_Owner_Id;
        reqparam.SubStatus='Business Hold';
        reqparam.ReasonForHold='A/C Details';
        String JsonMsg=JSON.serialize(reqparam);
        req.httpMethod = 'PUT';
        req.requestbody=Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        PegaCaseServiceController.updateCaseFields();
        
        PegaCaseServiceController.CaseResponse caseres = (PegaCaseServiceController.CaseResponse)JSON.deserialize(res.responseBody.toString(),PegaCaseServiceController.CaseResponse.class);        
        system.debug('##########caseresponse'+caseres);
        system.debug('##########GR34343number'+caseeg.caseNumber);
        //system.assertEquals(200, res.statusCode);
        
        system.assertEquals('Success', caseres.Status );
        system.assertEquals(caseeg.caseNumber, caseres.caseNumber );
       Test.stopTest();
    }
    
    @isTest
    public static void negativeDmlCase(){
       Test.startTest();
   
        case caseeg= PegaCaseServiceControllerTest.testdata();
        caseeg.Sales_Order_Number__c='';
        update caseeg;
        system.debug('#####Inside negativeDMLCase case###'+caseeg);
        //User g=[Select Id from User where Name='Pega'];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Cases/'+caseeg.Id;
        PegaCaseServiceController.fromJSON reqparam= new PegaCaseServiceController.fromJSON();
        reqparam.EscalatedTo='abc@xyz.com';
        reqparam.Status='On Hold';
        reqparam.SalesOrderNumber='';
        reqparam.OwnerId=Label.Pega_Owner_Id;
       
        String JsonMsg=JSON.serialize(reqparam);
        req.httpMethod = 'PUT';
        req.requestbody=Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        PegaCaseServiceController.updateCaseFields();
        PegaCaseServiceController.CaseResponse caseres = (PegaCaseServiceController.CaseResponse)JSON.deserialize(res.responseBody.toString(),PegaCaseServiceController.CaseResponse.class);        
      
        system.assertNotEquals(200, res.statusCode);
        system.assertEquals('Failure', caseres.Status );
        system.assertEquals(null, caseres.caseNumber );
        Test.stopTest();
       
    }
    @isTest
    public static void negativeQueryCase(){
        case caseeg= PegaCaseServiceControllerTest.testdata();
     
        //User g=[Select Id from User where Name='Pega'];
       Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/Cases/';
        PegaCaseServiceController.fromJSON reqparam= new PegaCaseServiceController.fromJSON();
        reqparam.EscalatedTo='';
        reqparam.Status='Done';
        reqparam.SalesOrderNumber='';
        reqparam.OwnerId=Label.AERODEFAULTUSER;
       
        String JsonMsg=JSON.serialize(reqparam);
        req.httpMethod = 'PUT';
        req.requestbody=Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        PegaCaseServiceController.updateCaseFields();
        PegaCaseServiceController.CaseResponse caseres = (PegaCaseServiceController.CaseResponse)JSON.deserialize(res.responseBody.toString(),PegaCaseServiceController.CaseResponse.class);        
      
        system.assertNotEquals(200, res.statusCode);
        system.assertEquals('Failure', caseres.Status );
        system.assertEquals(null, caseres.caseNumber );
        Test.stopTest();
        
    }

}
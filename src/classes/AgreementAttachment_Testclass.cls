/***********************************************************************************************************
    * Company Name          : Honeywell Aero
    * Name                  : AgreementAttachment_Testclass
    * Description           : Test Class for AgreementAttachmentToContract-To move the attachment from Agreement 
    *                         to Contract object when agreement is Signed                         
    * 
    * Modification History  :
    * Date             Version No.    Modified by           Brief Description of Modification
    * 18-Jan-2013      1.00           Anusuya NTTData       Initial Version
    * 22-Sept-2016     2.00           Sofiya  NTTData       Changes made for PPO
    ***********************************************************************************************************/ 
    @isTest(SeeAllData=true)
    private class AgreementAttachment_Testclass{

       static testMethod void AgreementAttachment_TestMthd1(){
        
          Test.startTest();
          
          RecordType rt = [select id from recordtype where name='HAPP/MPP Contracts' and SObjectType='Contract']; 
          
          Profile ProfRec = [select name from Profile where name = 'System Administrator'];
       
          Account acc1= new Account(name = 'Test Account',Market_name__C = 'Military',Report_Address_Line_1__c='Line1');
          insert acc1; 
        
          Contact objcnt = new Contact(firstname='Test',lastname='Testing',AccountId=acc1.id, Primary_Email_Address__c='sindhuja.velmurugan@test.com',Phone_3__c='11111',Phone_1__c='222222');
          insert objcnt; 
          
          Contact objcnt1 = new Contact(firstname='Test1',lastname='Testing1',AccountId=acc1.id, Primary_Email_Address__c='venu.gundlapalli@test.com',Phone_3__c='11111',Phone_1__c='222222');
          insert objcnt1;
            
            Contract cnt = new Contract();
            cnt.RecordTypeID = rt.id;
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acc1.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acc1.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acc1.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Order_Receipt_Name__c = objcnt.id;
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.EndDate = date.newinstance(2012, 8, 17);
            insert cnt;
            
            
            
            ContractContactRole ccr = new ContractContactRole();
            ccr.ContractId = cnt.id;
            ccr.role = 'Other';
            ccr.ContactId = objcnt1.id;
            insert ccr;
            
            //sendAgmtNotification.sendNotification(cnt.id);
           
            Test.stopTest();
        }
        static testMethod void AgreementAttachment_TestMthd2(){
        
          Test.startTest();
          
          RecordType rt = [select id from recordtype where name='HAPP/MPP Contracts' and SObjectType='Contract']; 
          
          Profile ProfRec = [select name from Profile where name = 'System Administrator'];
       
          Account acc1= new Account(name = 'Test Account',Market_name__C = 'Military',Report_Address_Line_1__c='Line1');
          insert acc1; 
        
          Contact objcnt = new Contact(firstname='Test',AccountId=acc1.id, lastname='Testing',Primary_Email_Address__c='sindhuja.velmurugan@test.com',Phone_3__c='11111',Phone_1__c='222222');
          insert objcnt; 
          
          Contact objcnt1 = new Contact(firstname='Test1',lastname='Testing1',AccountId=acc1.id, Primary_Email_Address__c='venu.gundlapalli@test.com',Phone_3__c='11111',Phone_1__c='222222');
          insert objcnt1;
            
            Contract cnt = new Contract();
            cnt.RecordTypeID = rt.id;
            // SR# 364434 - Agreement to Contract attachment - Start        
            //cnt.AccountId = '0013000000bFwrw';
            cnt.AccountId = acc1.id;
            cnt.Renewal_Package_Sent__c = date.newinstance(2009, 1, 7);
            cnt.Renewal_Start_date__c = System.today();
            cnt.Renewal_Account_Name_Dealer__c = acc1.id;
            cnt.Renewal_End_Date__c = date.newinstance(2022, 8, 17);        
            cnt.Renewal_Customer__c = acc1.id;
            cnt.Renewal_Notes__c = 'Test Note';        
            cnt.Renewal_Order_Receipt_Name__c = objcnt.id;
            cnt.Renewal_Fleet_Discount__c = '10%';
            // SR# 364434 - Agreement to Contract attachment - End       
            cnt.Status = 'Pending Activation';
            cnt.Type__c = 'HAPP/MPP';
            cnt.StartDate = date.newinstance(2009, 1, 7);
            cnt.EndDate = date.newinstance(2012, 8, 17);
            insert cnt;
            

            
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment signed.pdf';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.ParentId = cnt.id;
            insert attach;
            
            case c = new case();
            c.recordtypeid = '01230000000bTFi';
            c.subject ='MSP Customer Profile';
            c.contactid = objcnt.id;
            c.serv_Contract__c = cnt.id;
            c.Sub_Status__c = 'Customer Profile Sent';
            insert c;
            
            c.Sub_Status__c = 'First Follow Up';
            update c;
            Test.stopTest();
            }
       static testMethod void AgreementAttachment_TestMthdPPO(){
            Case cas = new Case();
            cas.Origin = 'web';
            cas.Status = 'Open';  
            cas.OwnerId = Label.CSO_R_O_Team;
            //cas.ContactId = objContact.Id;
            cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
            cas.Classification__c = 'CSO Repair Order';
            //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
            cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
            cas.Government_Compliance_SM_M_Content__c = 'No';
            cas.Sales_Order_Number__c = '12345678';
            //cas.Order_Entered_By__c = 'Harikishore';
            cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
            cas.Description = 'Test cases';
            cas.subject='test case';
            insert cas;
            
            Platform__c p = new Platform__c();
            p.Platform__c ='Test platform please ignore';
            insert p;
            
            Fleet_Asset_Detail__c fad = new Fleet_Asset_Detail__c();
            fad.Case_Associated__c = cas.Id;
            fad.New_Alert_Identification__c = true;
            fad.Platform_Name__c =p.id;
            fad.Serial_Number__c = 'test 123';
            insert fad;
            
            Test.startTest();
                Attachment attach=new Attachment();     
                attach.Name='Unit Test Attachment signed.pdf';
                Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
                attach.body=bodyBlob;
                attach.parentId=cas.id;
                insert attach;
                
                Attachment attach1=new Attachment();     
                attach1.Name='Unit Test Attachment signed.pdf';
                Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
                attach1.body=bodyBlob1;
                attach1.parentId=fad.id;
                insert attach1;
            
             }
              
    }
@isTest(SeeAllData=true)
private class TestClass_AeroGSEVendorSupport 
{
    static testMethod void TestMthd_AeroGSEVendorSupport ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            Case cs = new Case();
            cs.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs.Origin = 'Email';
            cs.Sub_Class__c = 'Purchasing';
            cs.subject  ='Purchasing';
            cs.Classification__c= 'GSE Vendor Support';
            cs.Status = 'Open';
            cs.ContactId = c1.Id;
            cs.Type='';
            cs.RecordtypeId=label.GSS_Quotes_Orders;            
            cs.Classification__c = 'GTO Field Service';          
            lstCases.add(cs);
    
            
            insert lstCases;
   
            EmailMessage newEmail = new EmailMessage();
            newEmail.Status='0';
            newEmail.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail.Incoming = True;
            newEmail.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail.Subject = 'Purchasing';
            newEmail.TextBody = 'test pur ';
            newEmail.ParentId = cs.Id;
            newEmail1.add(newEmail);
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }    
    
    static testMethod void TestMthd_AeroGSEVendorSupport2 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest(); 
          
            Case cs1 = new Case();
            cs1.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs1.Origin = 'Email';
            cs1.Sub_Class__c = 'Engineering';
            cs1.subject  ='Engineering';
            cs1.Classification__c= 'GSE Vendor Support';
            cs1.Status = 'Open';
            cs1.ContactId = c1.Id;
            cs1.Type='';
            cs1.RecordtypeId=label.GSS_Quotes_Orders;           
            cs1.Classification__c = 'GTO Field Service';            
            lstCases.add(cs1);
   
            insert lstCases;
   
    
            EmailMessage newEmail2 = new EmailMessage();
            newEmail2.Status='0';
            newEmail2.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail2.Incoming = True;
            newEmail2.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail2.Subject = 'Engineering';
            newEmail2.TextBody = 'test eng ';
            newEmail2.ParentId = cs1.Id;
            newEmail1.add(newEmail2);
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }   
    
    static testMethod void TestMthd_AeroGSEVendorSupport3 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            
    
            Case cs2 = new Case();
            cs2.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs2.Origin = 'Email';
            cs2.Sub_Class__c = 'Quality';
            cs2.subject  ='Quality';
            cs2.Classification__c= 'GSE Vendor Support';
            cs2.Status = 'Open';
            cs2.ContactId = c1.Id;
            cs2.Type='';
            cs2.RecordtypeId=label.GSS_Quotes_Orders;           
            cs2.Classification__c = 'GTO Field Service';            
            lstCases.add(cs2);
            
            
            insert lstCases;
   
            

            EmailMessage newEmail3 = new EmailMessage();
            newEmail3.Status='0';
            newEmail3.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail3.Incoming = True;
            newEmail3.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail3.Subject = 'Quality';
            newEmail3.TextBody = 'test eng ';
            newEmail3.ParentId = cs2.Id;
            newEmail1.add(newEmail3);
     
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }    
    
    static testMethod void TestMthd_AeroGSEVendorSupport4 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            
            
            Case cs3 = new Case();
            cs3.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs3.Origin = 'Email';
            cs3.Sub_Class__c = 'Receiving';
            cs3.subject  ='Receiving';
            cs3.Classification__c= 'GSE Vendor Support';
            cs3.Status = 'Open';
            cs3.ContactId = c1.Id;
            cs3.Type='';
            cs3.RecordtypeId=label.GSS_Quotes_Orders;
            cs3.Classification__c = 'GTO Field Service';            
            lstCases.add(cs3);
            
           
            insert lstCases;
   
     
            EmailMessage newEmail4 = new EmailMessage();
            newEmail4.Status='0';
            newEmail4.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail4.Incoming = True;
            newEmail4.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail4.Subject = 'Receiving';
            newEmail4.TextBody = 'test eng ';
            newEmail4.ParentId = cs3.Id;
            newEmail1.add(newEmail4);
            
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }    
    
    static testMethod void TestMthd_AeroGSEVendorSupport5 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();  
            
            Case cs4 = new Case();
            cs4.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs4.Origin = 'Email';
            cs4.Sub_Class__c = 'drawings';
            cs4.subject  ='drawings';
            cs4.Classification__c= 'GSE Vendor Support';
            cs4.Status = 'Open';
            cs4.ContactId = c1.Id;
            cs4.Type='';
            cs4.RecordtypeId=label.GSS_Quotes_Orders;
            cs4.Classification__c = 'GTO Field Service';            
            lstCases.add(cs4);
            
            
            insert lstCases;
   
            EmailMessage newEmail5 = new EmailMessage();
            newEmail5.Status='0';
            newEmail5.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail5.Incoming = True;
            newEmail5.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail5.Subject = 'drawings';
            newEmail5.TextBody = 'test eng ';
            newEmail5.ParentId = cs4.Id;
            newEmail1.add(newEmail5);
            
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }    
    
    static testMethod void TestMthd_AeroGSEVendorSupport6 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            
            
            Case cs5 = new Case();
            cs5.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs5.Origin = 'Email';
            cs5.Sub_Class__c = 'follow-up';
            cs5.subject  ='follow-up';
            cs5.Classification__c= 'GSE Vendor Support';
            cs5.Status = 'Open';
            cs5.ContactId = c1.Id;
            cs5.Type='';
            cs5.RecordtypeId=label.GSS_Quotes_Orders;
            cs5.Classification__c = 'GTO Field Service';            
            lstCases.add(cs5);
            
            insert lstCases;
   
            
            EmailMessage newEmail6 = new EmailMessage();
            newEmail6.Status='0';
            newEmail6.FromAddress = 'venkatesh.athanti@nttdata.com';
            newEmail6.Incoming = True;
            newEmail6.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail6.Subject = 'follow-up';
            newEmail6.TextBody = 'test eng ';
            newEmail6.ParentId = cs5.Id;
            newEmail1.add(newEmail6);
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }    
    
     static testMethod void TestMthd_AeroGSEVendorSupport7 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            
            
            Case cs5 = new Case();
            cs5.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs5.Origin = 'E2CP Test';
            cs5.Sub_Class__c = 'follow-up';
            cs5.subject  ='follow-up';
            cs5.description ='THE BOEING COMMUNICATION SYSTEM';
            cs5.Classification__c= 'GSE Vendor Support';
            cs5.Status = 'Open';
            cs5.ContactId = c1.Id;
            cs5.Type='';
            cs5.RecordtypeId=label.General_RT_ID;
            cs5.Classification__c = 'GTO Field Service'; 
            cs5.ownerid = label.aero_default_user_id;           
            lstCases.add(cs5);
            
            insert lstCases;
   
            
            EmailMessage newEmail6 = new EmailMessage();
            newEmail6.Status='0';
            newEmail6.FromAddress = 'venkatesh.athanti@BOEING.COM';
            newEmail6.Incoming = True;
            newEmail6.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
            newEmail6.Subject = 'follow-up';
            newEmail6.TextBody = 'test eng ';
            newEmail6.ParentId = cs5.Id;
            newEmail1.add(newEmail6);
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    } 
    
     static testMethod void TestMthd_AeroGSEVendorSupport8 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
        try
        {
            Account a1 = New Account(Name= 'Teatingaccount1', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
            insert a1;
             Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
             Test.startTest();      
            
            
            Case cs5 = new Case();
            cs5.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
            cs5.Origin = 'Email';
            cs5.Sub_Class__c = 'follow-up';
            cs5.subject  ='follow-up';
            cs5.description ='THE BOEING COMMUNICATION SYSTEM';
            cs5.Classification__c= 'GSE Vendor Support';
            cs5.Status = 'Open';
            cs5.ContactId = c1.Id;
            cs5.Type='';
            cs5.RecordtypeId=label.General_RT_ID;
            cs5.Classification__c = 'GTO Field Service'; 
            cs5.ownerid = label.aero_default_user_id;           
            lstCases.add(cs5);
            
            insert lstCases;
   
            
            EmailMessage newEmail6 = new EmailMessage();
            newEmail6.Status='0';
            newEmail6.FromAddress = 'venkatesh.athanti@embraer.COM';
            newEmail6.Incoming = True;
            newEmail6.ToAddress= 'aerocsobgaspares@honeywell.com';
            newEmail6.Subject = 'follow-up';
            newEmail6.TextBody = 'test eng ';
            newEmail6.ParentId = cs5.Id;
            newEmail1.add(newEmail6);
  
            insert newEmail1;
            Test.stopTest();
        }    
        catch(Exception e)
        {
            System.debug('Exception occured '+e);
        }
      
    }       
}
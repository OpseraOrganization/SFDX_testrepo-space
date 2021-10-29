@isTest(SeeAllData=true)
    private class TestClass_AeroGSEVendorSupport2 
  {
    static testMethod void TestMthd_AeroGSEVendorSupport2 ()
    { 
      List<Case> lstCases = new List<Case>(); 
         
        list<EmailMessage> newEmail1 = new list<EmailMessage>();    
      try
      {
        Account a1 = New Account(Name= 'Teatingaccount12', Strategic_Business_Unit__c = 'D&S',   CBT__c = 'HTSI');
        insert a1;
         Contact c1 = new Contact(lastname='Test1',firstname='firstname1',accountId=a1.Id,Contact_Is_Employee__c=false,Primary_Email_Address__c='harikishore.vutukuri@nttdata.com',Phone_1__c='(999) 999-9999');
            insert c1;
      
     Test.startTest();         
      Case cs = new Case();
      cs.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
      cs.Origin = 'Email';
      cs.Sub_Class__c = 'Receiving';
      cs.subject  ='Receiving';
      cs.Classification__c= 'GSE Vendor Support';
      cs.Status = 'Open';
      cs.ContactId = c1.Id;
      cs.Type='';
      cs.RecordtypeId=label.GSS_Quotes_Orders;
      //cs.No_FCR_Reason__c='Not Trained'; For Ticket INC000009687923
      cs.HON_Commit_Date__c=system.now();
      cs.Classification__c = 'GTO Field Service';
      cs.HON_Commit_Date__c = System.now();  
      lstCases.add(cs);
          
      Case cs1 = new Case();
      cs1.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
      cs1.Origin = 'Email';
      cs1.Sub_Class__c = 'Drawings';
      cs1.subject  ='Drawings';
      cs1.Classification__c= 'GSE Vendor Support';
      cs1.Status = 'Open';
      cs1.ContactId = c1.Id;
      cs1.Type='';
      cs1.RecordtypeId=label.GSS_Quotes_Orders;
      //cs1.No_FCR_Reason__c='Not Trained';For Ticket INC000009687923
      cs1.HON_Commit_Date__c=system.now();
      cs1.Classification__c = 'GTO Field Service';
      cs1.HON_Commit_Date__c = System.now();  
      lstCases.add(cs1);
      
      /*Case cs2 = new Case();
      cs2.Emailbox_Origin__c ='Email-Aero GSE Vendor Support';
      cs2.Origin = 'Email';
      cs2.Sub_Class__c = 'Follow-up';
      cs2.subject  ='Follow-up';
      cs2.Classification__c= 'GSE Vendor Support';
      cs2.Status = 'Open';
      cs2.ContactId = c1.Id;
      cs2.Type='';
      cs2.RecordtypeId=label.GSS_Quotes_Orders;
      cs2.No_FCR_Reason__c='Not Trained';
      cs2.HON_Commit_Date__c=system.now();
      cs2.Classification__c = 'GTO Field Service';
      cs2.HON_Commit_Date__c = System.now();  
      lstCases.add(cs2);*/
                                  
      insert lstCases;
   
    EmailMessage newEmail = new EmailMessage();
    newEmail.Status='0';
    newEmail.FromAddress = 'venkatesh.athanti@nttdata.com';
    newEmail.Incoming = True;
    newEmail.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
    newEmail.Subject = 'Receiving';
    newEmail.TextBody = 'test pur ';
    newEmail.ParentId = cs.Id;
    newEmail1.add(newEmail);
    
    EmailMessage newEmail2 = new EmailMessage();
    newEmail2.Status='0';
    newEmail2.FromAddress = 'venkatesh.athanti@nttdata.com';
    newEmail2.Incoming = True;
    newEmail2.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
    newEmail2.Subject = 'Drawings';
    newEmail2.TextBody = 'test eng ';
    newEmail2.ParentId = cs1.Id;
    newEmail1.add(newEmail2);
    
    /*EmailMessage newEmail3 = new EmailMessage();
    newEmail3.Status='0';
    newEmail3.FromAddress = 'venkatesh.athanti@nttdata.com';
    newEmail3.Incoming = True;
    newEmail3.ToAddress= 'AeroGSEVendorSupport@Honeywell.com';
    newEmail3.Subject = 'Follow-up';
    newEmail3.TextBody = 'test eng ';
    newEmail3.ParentId = cs2.Id;
    newEmail1.add(newEmail3);*/
       
    insert newEmail1;
         Test.stopTest();
              
    }    
      catch(Exception e)
      {
      System.debug('Exception occured '+e);
      }
      
    }    
    }
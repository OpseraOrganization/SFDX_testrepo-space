@isTest(SeeAllData=true)
private class GetCPNTest {
    private static testMethod void TestGetCPNID() {
        Test.startTest();
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
       /* string result = GetCPN.GetCPNID(honeywellAccount.id);
        system.debug('result===>'+result); */
        Test.stopTest();
    }
    private static testMethod void TestGetCPNID1() {
      
        Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account1',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='Intercompany',CBT__c='Intercompany',CBT_Team__c='Intercompany',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        Account_Address__c accadd = new Account_Address__c();
        accadd.Account_Name__c = honeywellAccount.id;
        accadd.Distributor_Sub_Category__c = 'Microelectronics';
        accadd.Rep_Locator_Products__c = 'APU 131-9';
        accadd.Rep_Locator_Visibility__c = true;
        insert accadd;
        List<Channel_Partner_Nomination__c> cpnlist = new List<Channel_Partner_Nomination__c>();
        Channel_Partner_Nomination__c cpn = new Channel_Partner_Nomination__c();
        cpn.Account__c = honeywellAccount.id;
        cpn.Product_s_Service_s_in_Scope__c = 'HUMS / CBMS; Microelectronics; High Temp Electronics; APU HGT1700';
        cpn.ATR_Channel_Partner__c = true;
        cpn.Is_Due_Diligence_Required_under_Policy_2__c = 'Yes';
        cpn.Legal_team_Consulted__c = 'Yes';
        cpn.STC_Applicable_to_the_Partner__c = 'Yes';
        cpn.Type_of_Agreement__c = 'Avionics Dealers';
        cpn.Reduction_of_Work_at_Site__c = 'Yes';
        cpn.SAP_Account__c = 'test';
        cpn.Type_Of_Approval__c = 'New Channel Partner';
        cpnlist.add(cpn);
          Test.startTest();
        insert cpnlist;
        
         Blob b = Blob.valueOf('Test Data');
         list<Attachment> lstAttachments = new list<Attachment>();
         Attachment attachment = new Attachment();
         attachment.ParentId = cpn.id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;
         lstAttachments.add(attachment);
         insert(attachment);
         updateCPN.updateCheckAttachmentOnCPN(lstAttachments);
         CPNFromAccountAddress.getDistributorLineItems(cpnlist);
         CPNFromAccountAddress.legalApproverField(cpnlist);
        Test.stopTest();
    }
    
    private static testMethod void TestGetCPNID2() {
         ProcessInstanceWorkitem proWI =  [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
       Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account1',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',CBT_Team__c='ATR Airlines Asia Pacific',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        Account_Address__c accadd = new Account_Address__c();
        accadd.Account_Name__c = honeywellAccount.id;
        accadd.Distributor_Sub_Category__c = 'Microelectronics';
        accadd.Rep_Locator_Products__c = 'APU 131-9';
        accadd.Rep_Locator_Visibility__c = true;
        insert accadd;
        List<Channel_Partner_Nomination__c> cpnlist = new List<Channel_Partner_Nomination__c>();
        Channel_Partner_Nomination__c cpn = new Channel_Partner_Nomination__c();
        cpn.Account__c = honeywellAccount.id;
        cpn.Product_s_Service_s_in_Scope__c = 'Microelectronics; Magnetic Sensors; Engine ALF502/LF507; Lighting; Mechanical Components';
        cpn.ATR_Channel_Partner__c = true;
        cpn.Is_Due_Diligence_Required_under_Policy_2__c = 'Yes';
        cpn.Legal_team_Consulted__c = 'Yes';
        cpn.STC_Applicable_to_the_Partner__c = 'Yes';
        cpn.Type_of_Agreement__c = 'Avionics Dealers';
        cpn.Reduction_of_Work_at_Site__c = 'Yes';
        cpn.SAP_Account__c = 'test';
        cpn.Type_Of_Approval__c = 'New Channel Partner';
        cpn.Check_Attachment__c = false;
        cpnlist.add(cpn);
         
        insert cpnlist;
         Blob b = Blob.valueOf('Test Data');
         list<Attachment> lstAttachments = new list<Attachment>();
         Attachment attachment = new Attachment();
         attachment.ParentId = cpn.id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;
         lstAttachments.add(attachment);
         Test.startTest();
         insert(attachment);
         
        
         
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(cpn.id);
        app.setComments('test comment');
       
        Approval.ProcessResult result = Approval.process(app);
         //String result_wrk = result.getNewWorkitemIds()[0];
        
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Approve');
         req.setWorkitemId(proWI.Id);
        req.setComments('Test Approve');
        
        system.debug('Contract_Approver__c===>'+cpn.Contract_Approver__c);
        system.debug('Vertical_Strategy_Approvre__c===>'+cpn.Vertical_Strategy_Approvre__c);
        system.debug('Licensing_Approval__c===>'+cpn.Licensing_Approval__c);
        system.debug('AMB_Approver__c===>'+cpn.AMB_Approver__c);
        system.debug('AMB_Approver_E_PS__c===>'+cpn.AMB_Approver_E_PS__c);
        system.debug('AMB_Approver_M_SC__c===>'+cpn.AMB_Approver_M_SC__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(cpn);
        ProcessInstanceController pic = new ProcessInstanceController(sc);
        pic.stopMessaging();
        Test.stopTest();
         // Verify the result
        System.assert(result.isSuccess());
     
      /*  System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus()); */
    
        // Approve the submitted request
        // First, get the ID of the newly created item
      //  List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
     try{   
        pic.Approve();
        //pic.Reject();
        pic.Cancel();
        }
        catch(exception e){
        }
        //pic.stopMessaging();
  }
  
  private static testMethod void TestGetCPNID4() {
         ProcessInstanceWorkitem proWI =  [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
       Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account1',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',CBT_Team__c='ATR Airlines Asia Pacific',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        Account_Address__c accadd = new Account_Address__c();
        accadd.Account_Name__c = honeywellAccount.id;
        accadd.Distributor_Sub_Category__c = 'Microelectronics';
        accadd.Rep_Locator_Products__c = 'APU 131-9';
        accadd.Rep_Locator_Visibility__c = true;
        insert accadd;
        List<Channel_Partner_Nomination__c> cpnlist = new List<Channel_Partner_Nomination__c>();
        Channel_Partner_Nomination__c cpn = new Channel_Partner_Nomination__c();
        cpn.Account__c = honeywellAccount.id;
        cpn.Product_s_Service_s_in_Scope__c = 'Microelectronics; Magnetic Sensors; Engine ALF502/LF507; Lighting; Mechanical Components';
        cpn.ATR_Channel_Partner__c = true;
        cpn.Is_Due_Diligence_Required_under_Policy_2__c = 'Yes';
        cpn.Legal_team_Consulted__c = Null;
        cpn.STC_Applicable_to_the_Partner__c = 'Yes';
        cpn.Type_of_Agreement__c = 'Avionics Dealers';
        cpn.Reduction_of_Work_at_Site__c = 'Yes';
        cpn.SAP_Account__c = 'test';
        cpn.Type_Of_Approval__c = 'New Channel Partner';
        cpn.Check_Attachment__c = false;
        cpnlist.add(cpn);
         
        insert cpnlist;
         Blob b = Blob.valueOf('Test Data');
         list<Attachment> lstAttachments = new list<Attachment>();
         Attachment attachment = new Attachment();
         attachment.ParentId = cpn.id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;
         lstAttachments.add(attachment);
         Test.startTest();
         insert(attachment);
         
        
         
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(cpn.id);
        app.setComments('test comment');
       
        Approval.ProcessResult result = Approval.process(app);
         //String result_wrk = result.getNewWorkitemIds()[0];
        
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Approve');
         req.setWorkitemId(proWI.Id);
        req.setComments('Test Approve');
        
        system.debug('Contract_Approver__c===>'+cpn.Contract_Approver__c);
        system.debug('Vertical_Strategy_Approvre__c===>'+cpn.Vertical_Strategy_Approvre__c);
        system.debug('Licensing_Approval__c===>'+cpn.Licensing_Approval__c);
        system.debug('AMB_Approver__c===>'+cpn.AMB_Approver__c);
        system.debug('AMB_Approver_E_PS__c===>'+cpn.AMB_Approver_E_PS__c);
        system.debug('AMB_Approver_M_SC__c===>'+cpn.AMB_Approver_M_SC__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(cpn);
        ProcessInstanceController pic = new ProcessInstanceController(sc);
        pic.stopMessaging();
        Test.stopTest();
         // Verify the result
        System.assert(result.isSuccess());
     
      /*  System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus()); */
    
        // Approve the submitted request
        // First, get the ID of the newly created item
      //  List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
     try{   
        pic.Approve();
        //pic.Reject();
        pic.Cancel();
        }
        catch(exception e){
        }
        //pic.stopMessaging();
  }
    private static testMethod void TestGetCPNID3() {
       ProcessInstanceWorkitem proWI =  [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
       Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account1',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',CBT_Team__c='ATR Airlines Asia Pacific',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        Account_Address__c accadd = new Account_Address__c();
        accadd.Account_Name__c = honeywellAccount.id;
        accadd.Distributor_Sub_Category__c = 'Microelectronics';
        accadd.Rep_Locator_Products__c = 'APU 131-9';
        accadd.Rep_Locator_Visibility__c = true;
        insert accadd;
        List<Channel_Partner_Nomination__c> cpnlist = new List<Channel_Partner_Nomination__c>();
        Channel_Partner_Nomination__c cpn = new Channel_Partner_Nomination__c();
        cpn.Account__c = honeywellAccount.id;
        cpn.Product_s_Service_s_in_Scope__c = 'Microelectronics; Magnetic Sensors; Engine ALF502/LF507; Lighting; Mechanical Components';
        cpn.ATR_Channel_Partner__c = true;
        cpn.Is_Due_Diligence_Required_under_Policy_2__c = 'Yes';
        cpn.Legal_team_Consulted__c = 'Yes';
        cpn.STC_Applicable_to_the_Partner__c = 'Yes';
        cpn.Type_of_Agreement__c = 'Avionics Dealers';
        cpn.Reduction_of_Work_at_Site__c = 'Yes';
        cpn.SAP_Account__c = 'test';
        cpn.Type_Of_Approval__c = 'New Channel Partner';
        cpn.Check_Attachment__c = false;
        cpn.Approved_By_Legal__c = true;
        cpnlist.add(cpn);
         
        insert cpnlist;
         Blob b = Blob.valueOf('Test Data');
         list<Attachment> lstAttachments = new list<Attachment>();
         Attachment attachment = new Attachment();
         attachment.ParentId = cpn.id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;
         lstAttachments.add(attachment);
         Test.startTest();
         insert(attachment);
         
        
         
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(cpn.id);
       app.setComments('Test Reject');
       
        Approval.ProcessResult result = Approval.process(app);
        //String result_wrk = result.getNewWorkitemIds()[0];
        
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Reject');
        req.setWorkitemId(proWI.Id);
       req.setComments('Test Reject');
        
        
        system.debug('Contract_Approver__c===>'+cpn.Contract_Approver__c);
        system.debug('Vertical_Strategy_Approvre__c===>'+cpn.Vertical_Strategy_Approvre__c);
        system.debug('Licensing_Approval__c===>'+cpn.Licensing_Approval__c);
        system.debug('AMB_Approver__c===>'+cpn.AMB_Approver__c);
        system.debug('AMB_Approver_E_PS__c===>'+cpn.AMB_Approver_E_PS__c);
        system.debug('AMB_Approver_M_SC__c===>'+cpn.AMB_Approver_M_SC__c);
       
         // Verify the result
        System.assert(result.isSuccess());
       
      Test.stopTest();
       /* System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus()); */
    
        // Approve the submitted request
        // First, get the ID of the newly created item
      //  List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cpn);
        ProcessInstanceController pic = new ProcessInstanceController(sc);
        pic.rejectionReason = 'Test Reject';
        pic.legalConsulted = 'yes';
        
        //pic.Approve();
        try{
        pic.Reject();
        pic.Cancel();
        }
        catch(exception e){
        }
       // pic.stopMessaging();
       
       
    }
     private static testMethod void TestGetCPNID5() {
       ProcessInstanceWorkitem proWI =  [SELECT ActorId, CreatedById, Id FROM ProcessInstanceWorkitem limit 1];
       Country__c countryval = new Country__c(name='INDIA',SFDC_Country_Name__c='INDIA');
        insert countryval;
        account honeywellAccount = new account(name='test_case_account1',ATR_Channel_Partner__c=true,BGA_Account__c=true,D_S_Channel_Partner__c=true,Customer_Status__c='Active',Country__c=countryval.id,Service_Level__c='Standard',Strategic_Business_Unit__c='ATR',CBT__c='Airlines',CBT_Team__c='ATR Airlines Asia Pacific',Market_Name__c='Intercompany',type='Honeywell',REPORT_ACCOUNT_NAME__c='test honeywell account');
        insert honeywellAccount;
        Account_Address__c accadd = new Account_Address__c();
        accadd.Account_Name__c = honeywellAccount.id;
        accadd.Distributor_Sub_Category__c = 'Microelectronics';
        accadd.Rep_Locator_Products__c = 'APU 131-9';
        accadd.Rep_Locator_Visibility__c = true;
        insert accadd;
        List<Channel_Partner_Nomination__c> cpnlist = new List<Channel_Partner_Nomination__c>();
        Channel_Partner_Nomination__c cpn = new Channel_Partner_Nomination__c();
        cpn.Account__c = honeywellAccount.id;
        cpn.Product_s_Service_s_in_Scope__c = 'Microelectronics; Magnetic Sensors; Engine ALF502/LF507; Lighting; Mechanical Components';
        cpn.ATR_Channel_Partner__c = true;
        cpn.Is_Due_Diligence_Required_under_Policy_2__c = 'Yes';
        cpn.Legal_team_Consulted__c = Null;
        cpn.STC_Applicable_to_the_Partner__c = 'Yes';
        cpn.Type_of_Agreement__c = 'Avionics Dealers';
        cpn.Reduction_of_Work_at_Site__c = 'Yes';
        cpn.SAP_Account__c = 'test';
        cpn.Type_Of_Approval__c = 'New Channel Partner';
        cpn.Check_Attachment__c = false;
        cpn.Approved_By_Legal__c = true;
        cpnlist.add(cpn);
         
        insert cpnlist;
         Blob b = Blob.valueOf('Test Data');
         list<Attachment> lstAttachments = new list<Attachment>();
         Attachment attachment = new Attachment();
         attachment.ParentId = cpn.id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;
         lstAttachments.add(attachment);
         Test.startTest();
         insert(attachment);
         
        
         
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(cpn.id);
       app.setComments('Test Reject');
       
        Approval.ProcessResult result = Approval.process(app);
        //String result_wrk = result.getNewWorkitemIds()[0];
        
         Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
         req.setAction('Reject');
        req.setWorkitemId(proWI.Id);
       req.setComments('Test Reject');
        
        
        system.debug('Contract_Approver__c===>'+cpn.Contract_Approver__c);
        system.debug('Vertical_Strategy_Approvre__c===>'+cpn.Vertical_Strategy_Approvre__c);
        system.debug('Licensing_Approval__c===>'+cpn.Licensing_Approval__c);
        system.debug('AMB_Approver__c===>'+cpn.AMB_Approver__c);
        system.debug('AMB_Approver_E_PS__c===>'+cpn.AMB_Approver_E_PS__c);
        system.debug('AMB_Approver_M_SC__c===>'+cpn.AMB_Approver_M_SC__c);
       
         // Verify the result
        System.assert(result.isSuccess());
       
      Test.stopTest();
       /* System.assertEquals(
            'Pending', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus()); */
    
        // Approve the submitted request
        // First, get the ID of the newly created item
      //  List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cpn);
        ProcessInstanceController pic = new ProcessInstanceController(sc);
        pic.rejectionReason = 'Test Reject';
        pic.legalConsulted = 'yes';
        
        //pic.Approve();
        try{
        pic.Reject();
        pic.Cancel();
        }
        catch(exception e){
        }
       // pic.stopMessaging();
       
       
    }
}
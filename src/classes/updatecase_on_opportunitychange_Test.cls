@isTest(SeeAllData=true)
private class updatecase_on_opportunitychange_Test{

    static testmethod void updatecase_on_opportunitychange_Test(){
     list<opportunity> lstopp = new list<opportunity>();
     
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 
      
        Opportunity oppty = new Opportunity();
        oppty.AccountID = acc.ID;
        oppty.Name = 'Test Opportunity';
        oppty.StageName = 'Opening';
        oppty.CloseDate = system.today().addDays(50);
        oppty.Proposal_Submitted_Date__c = System.today();
        oppty.RFP_Expected_Date__c = System.today();
        oppty.Proposal_Complexity_Description__c = 'test';
        oppty.Ship_Set_Parts__c = 'test';
        oppty.Ship_Set_Quantity__c = 11;
        oppty.Certification_Requirements__c = 'Direct Commercial';
        oppty.Ship_Set_Delivery_Period__c = 'test';
        oppty.Proposal_Due_Date__c = System.today();
        oppty.Proposal_Kickoff_Date__c = System.today();
        oppty.ATR_Aircraft_Quantity__c=1;
        oppty.Tech_Sales_Product_Area__c='APU';
        lstopp.add(oppty);
        
        Opportunity oppty1 = new Opportunity();
        oppty1.AccountID = acc.ID;
        oppty1.Name = 'Test Opportunity1';
        oppty1.StageName = 'Opening';
        oppty1.CloseDate = system.today().addDays(50);
        oppty1.Proposal_Submitted_Date__c = System.today();
        oppty1.RFP_Expected_Date__c = System.today();
        oppty1.Proposal_Complexity_Description__c = 'test';
        oppty1.Ship_Set_Parts__c = 'test';
        oppty1.Ship_Set_Quantity__c = 11;
        oppty1.Certification_Requirements__c = 'Direct Commercial';
        oppty1.Ship_Set_Delivery_Period__c = 'test';
        oppty1.Proposal_Due_Date__c = System.today();
        oppty1.Proposal_Kickoff_Date__c = System.today();
        oppty1.ATR_Aircraft_Quantity__c=1;
        oppty1.Tech_Sales_Product_Area__c='APU';
        lstopp.add(oppty1);
       
        insert lstopp;
         
        Case cases = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            //ContactId = cont.Id,
            Origin = 'Phone',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order',
            Opportunity__c = oppty.ID,
            Opportunity_Type__c= 'D&S PrePriced',
            Program__c='Albin Test',
            Contractor_Status__c='Prime',
            Status='New',
  //        RecordTypeID = label.D_S_Clear_House_RecordTypeId_Case,
            NSN__c = '1,2',
            Part_Number__c = '2,3',
            Certification_Requirements__c = 'Direct Commercial'
        );
        insert cases; 
        test.starttest();
        case c1 = [select id,Opportunity__c,CBT__c,SBU__c,Program_Description__c,Received_Date_at_Honeywell__c,Proposal_Response_due_date__c,New_Proposal_Manager1__c,Plant__c,Request_Type_Opp__c from case where id=:cases.id];
        
        Opportunity_Proposal__c opprop = new Opportunity_Proposal__c();
            opprop.Opportunity__c = c1.Opportunity__c;
            opprop.Description__c = c1.Program_Description__c;
            opprop.RFP_Receipt_Date__c = c1.Received_Date_at_Honeywell__c;
            opprop.Proposal_Due_Date__c = c1.Proposal_Response_due_date__c;
            opprop.Proposal_Coordinator__c = c1.New_Proposal_Manager1__c;
            opprop.Site__c = c1.Plant__c;
            opprop.Request_Type__c = c1.Request_Type_Opp__c;
                 
            insert opprop;
            c1.Opportunity_Proposal__c = opprop.id;
            update c1;
                
            opprop.Opportunity__c = oppty1.id;
            update opprop;
       test.stoptest();
                
    }
}
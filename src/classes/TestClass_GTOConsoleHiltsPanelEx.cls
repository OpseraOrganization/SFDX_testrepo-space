@isTest(SeeAllData=true)
private class TestClass_GTOConsoleHiltsPanelEx{
    static testMethod void TestMthd(){  
        
        List<case> lstcase=new List<case>();   
        List<case> lstcase1=new List<case>();   
        List<R_O_Case_Reassignment_Queue__c> objCaseAssignQueue = R_O_Case_Reassignment_Queue__c.getall().values(); //get the values from R&O Case Reassignment Queue in custom settings
        Test.startTest();
        Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test2';
        objAccnt.Customer_Status__c = 'Active';
        objAccnt.Strategic_Business_Unit__c = 'D&S';
        objAccnt.CBT__c = 'DAA';
        objAccnt.Region_Name__c = 'Americas';
        objAccnt.Sub_Region_Name__c = 'Canada';
        objAccnt.Service_Level__c = 'Standard';
        objAccnt.Type = 'OEM';
        objAccnt.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert objAccnt;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Hari';
        objContact.FirstName = 'vnv';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@nttdata.com';
        objContact.Email='harikishore.vutukuri@nttdata.com';        
        insert objContact;
        
        platform__c at =[select id from platform__c where   Active__c = true limit 1];  
        Supported_Products__c sp =[select id from Supported_Products__c where status__c = 'active' limit 1];  
        Case objInsrtCase1 = new case();
        objInsrtCase1.Origin = 'Email';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.SBU_w2c__c = 'ATR';
        objInsrtCase1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        objInsrtCase1.Government_Compliance_SM_M_Content__c = 'No';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.aircraft_type__c = at.id;
        objInsrtCase1.Supported_Products__c = sp.id;
        //objInsrtCase1.HON_Commit_Date__c = System.now();
       // objInsrtCase1.Sub_Class__c = '';
        //objInsrtCase1.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase1.recordtypeid=label.TechnicalIssueId;
        //objInsrtCase1.Type = 'Shipping/Invoicing';
        //objInsrtCase1.Repair_Location__c = 'EMEAI Avionics';
        lstcase.add(objInsrtCase1);
        
        Case objInsrtCase2 = new Case();
        objInsrtCase1.Origin = 'Email';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.SBU_w2c__c = 'ATR';
        objInsrtCase1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        objInsrtCase1.Government_Compliance_SM_M_Content__c = 'No';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.aircraft_type__c = at.id;
        //objInsrtCase1.HON_Commit_Date__c = System.now();
       // objInsrtCase1.Sub_Class__c = '';
        //objInsrtCase1.Classification__c = 'CSO Repair/Overhaul';
        objInsrtCase1.recordtypeid=label.TechnicalIssueId;
        //objInsrtCase1.Type = 'Shipping/Invoicing';
        //objInsrtCase1.Repair_Location__c = 'EMEAI Avionics';
        lstcase.add(objInsrtCase2);
        insert lstcase; 
        objInsrtCase1.status = 'Propose to Close';
        update objInsrtCase1;
        system.debug('##Inserted Case'+objInsrtCase1);
        PageReference pageRef  = Page.GTO_Console_Highlights_Panel;
        pageRef.getParameters().put('id',lstcase[0].id);
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController sc = new ApexPages.StandardController(objInsrtCase1);
        GTOConsoleHighlightsPanelExtension cust = new GTOConsoleHighlightsPanelExtension(sc);
        
        cust.cid = lstcase[0].id;
        integer a =cust.acc; 
        string a1 = cust.acc1;
        integer a3 = cust.acc3;
        string a4 = cust.acc4;
        PageReference pageRef1  = Page.SkillRelatedList;
        pageRef1.getParameters().put('id',lstcase[0].id);
        Test.setCurrentPage(pageRef1);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objInsrtCase1);
        SkillRelatedListExtension cust1 = new SkillRelatedListExtension(sc1);
        PageReference p = cust.DoNothing();
        Decimal d = cust.acc2;
        Boolean aa = cust.rendergreen;
        Boolean b = cust.renderyellow;
        Boolean cxx = cust.renderred;
        Boolean cc = cust.rendergray;
        List<skills2__c> sk =cust1.getSk();
        Test.stopTest();
        }
        }
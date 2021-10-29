@istest
public class CaseEscalationForHolds_Test {
    	@testsetup static void getdetails(){
        list<case> caslst = new list<case>();
        list<SharePoint_Site_Data__c> sptlst = new list<SharePoint_Site_Data__c>();
        list<User> usrlst = new list<User>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Id recordTypeIdcsord = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();
        Profile p = [select id from profile where name='System Administrator'];
        User usr = new User();
        usr.alias = 'testt';
        usr.email = 'testing@testing222.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnvb';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.EmployeeNumber = 'H411234';
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standardhfuser@testinfghg.com';
        usrlst.add(usr);
        User usr1 = new User();
        usr1.alias = 'testt';
        usr1.email = 'testing@testing123.com';
        usr1.emailencodingkey='UTF-8';
        usr1.lastname='vnvb';
        usr1.ManagerId = usr.id;
        usr1.EmployeeNumber = 'H411235';
        usr1.languagelocalekey='en_US';
        usr1.localesidkey='en_US';
        usr1.profileid = p.Id;
        usr1.timezonesidkey='America/Los_Angeles';
        usr1.username='standardhfuser12@testinfghg.com';
        usrlst.add(usr1);
        insert usrlst;
        
        Account acc = new Account();
        acc.name = 'test';
        insert acc;
        list<Contact> conlst = new list<Contact>();
        Contact con = new Contact();
        con.AccountId=acc.Id;
        con.LastName='testing123';
        con.Primary_Email_Address__c='testing@testing123.com';
        con.email = 'testing@testing123.com';
        con.Phone_1__c= '1234567678';
        con.User__c = usr1.id;
        con.Employee_Number__c = 'H411235';
        conlst.add(con);
        Contact con1 = new Contact();
        con1.AccountId=acc.Id;
        con1.LastName='testing222';
        con1.Primary_Email_Address__c='testing@testing222.com';
        con1.Phone_1__c= '1234567678';
        con1.User__c = usr.id;
        con1.Employee_Number__c = 'H411234';
        conlst.add(con1);
        insert conlst;
        list<Escalations_and_Holds__c> eshlst = new list<Escalations_and_Holds__c>();
        Escalations_and_Holds__c esh = new Escalations_and_Holds__c();
        esh.Sub_Status__c = 'Finance Hold';
        esh.Reason_for_Hold__c = 'PAYMENT ISSUES';
        esh.Case_Type__c = 'Repair & Overhaul';
        esh.Automate__c = 'Yes';
        esh.Lev2_Followup_Calendar_Days__c = 2;
        esh.Lev3_Followup_Calendar_Days__c = 3;
        esh.Lev4_Followup_Calendar_Days__c = 4;
        esh.Level_1_Source__c = 'SFDC Case Escalated To (Contact)';
        esh.Level_1_POC__c = con.Primary_Email_Address__c;
        esh.Level_2_Source__c = 'SFDC Escalation Table';
        esh.Level_2_POC__c = con.Primary_Email_Address__c;
        esh.Level_3_Source__c = 'SFDC Escalation Table';
        esh.Level_3_POC__c = con.Primary_Email_Address__c;
        esh.Level_4_Source__c = 'SFDC Escalation Table';
        esh.Level_4_POC__c = con1.Primary_Email_Address__c;
        eshlst.add(esh);
        Escalations_and_Holds__c esh22 = new Escalations_and_Holds__c();
        esh22.Sub_Status__c = 'BUSINESS HOLD';
        esh22.Reason_for_Hold__c = 'PRICING VALIDATION';
        esh22.Case_Type__c = 'Repair & Overhaul';
        esh22.Automate__c = 'Yes';
        esh22.Lev2_Followup_Calendar_Days__c = 2;
        esh22.Lev3_Followup_Calendar_Days__c = 3;
        esh22.Lev4_Followup_Calendar_Days__c = 4;
        esh22.Level_1_Source__c = 'SFDC Account Business Focal';
        esh22.Level_1_POC__c = 'BUSINESS FOCAL';
        esh22.Level_2_Source__c = 'SFDC Account Business Escalation';
        esh22.Level_2_POC__c = 'BUSINESS FOCAL ESCALATION';
        esh22.Level_3_Source__c = 'SFDC Account Business Escalation Contact User Primary Manager Name';
        esh22.Level_3_POC__c = 'BUSINESS FOCAL ESCALATION MANAGER';
        esh22.Level_4_Source__c = 'SFDC Account Business Escalation Contact User Primary Manager Name Contact Primary Manager Name';
        esh22.Level_4_POC__c = 'T3 VP';
        eshlst.add(esh22);
        Escalations_and_Holds__c esh23 = new Escalations_and_Holds__c();
        esh23.Sub_Status__c = 'CSO HOLD';
        esh23.Reason_for_Hold__c = 'INTERNAL QUALITY REVIEW';
        esh23.Case_Type__c = 'Repair & Overhaul';
        esh23.Automate__c = 'Yes';
        esh23.Lev2_Followup_Calendar_Days__c = 2;
        esh23.Lev3_Followup_Calendar_Days__c = 3;
        esh23.Lev4_Followup_Calendar_Days__c = 4;
        esh23.Level_1_Source__c = 'SFDC Case Owner';
        esh23.Level_1_POC__c = 'ASSIGNED CSR';
        esh23.Level_2_Source__c = 'Salesforce Case Owner Manager';
        esh23.Level_2_POC__c = 'T1 LEADER';
        esh23.Level_3_Source__c = 'Salesforce Case Owner Manager Manager';
        esh23.Level_3_POC__c = 'T2 LEADER';
        esh23.Level_4_Source__c = 'Salesforce Case Owner Manager Manager Manager';
        esh23.Level_4_POC__c = 'T3 LEADER';
        eshlst.add(esh23);
        Escalations_and_Holds__c esh1 = new Escalations_and_Holds__c();
        esh1.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        esh1.Reason_for_Hold__c = 'CAFÉ REPORT';
        esh1.Case_Type__c = 'Orders';
        esh1.Automate__c = 'Yes';
        esh1.Lev2_Followup_Calendar_Days__c = 2;
        esh1.Lev3_Followup_Calendar_Days__c = 3;
        esh1.Lev4_Followup_Calendar_Days__c = 4;
        esh1.Level_1_Source__c = 'ISC Sharepoint';
        esh1.Level_1_POC__c = 'ISC Mailbox per site';
        esh1.Level_2_Source__c = 'ISC Sharepoint';
        esh1.Level_2_POC__c = 'Mailbox Manager';
        esh1.Level_3_Source__c = 'ISC Sharepoint';
        esh1.Level_3_POC__c = 'Site Leader';
        esh1.Level_4_Source__c = 'ISC Sharepoint';
        esh1.Level_4_POC__c = 'Op VP and C&PS VP';
        eshlst.add(esh1);
        Escalations_and_Holds__c esh2 = new Escalations_and_Holds__c();
        esh2.Sub_Status__c = 'QUALITY HOLD';
        esh2.Reason_for_Hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        esh2.Case_Type__c = 'Orders';
        esh2.Automate__c = 'Yes';
        esh2.Lev2_Followup_Calendar_Days__c = 2;
        esh2.Lev3_Followup_Calendar_Days__c = 3;
        esh2.Lev4_Followup_Calendar_Days__c = 4;
        esh2.Level_1_Source__c = 'ISC Sharepoint';
        esh2.Level_1_POC__c = 'Quality Contact';
        esh2.Level_2_Source__c = 'ISC Sharepoint';
        esh2.Level_2_POC__c = 'Site Quality Leader';
        esh2.Level_3_Source__c = 'ISC Sharepoint';
        esh2.Level_3_POC__c = 'Quality Director';
        esh2.Level_4_Source__c = 'ISC Sharepoint';
        esh2.Level_4_POC__c = 'VP Quality team';
        eshlst.add(esh2);
        Escalations_and_Holds__c esh3 = new Escalations_and_Holds__c();
        esh3.Sub_Status__c = 'QUALITY HOLD';
        esh3.Reason_for_Hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        esh3.Case_Type__c = 'Repair & Overhaul';
        esh3.Automate__c = 'Yes';
        esh3.Lev2_Followup_Calendar_Days__c = 2;
        esh3.Lev3_Followup_Calendar_Days__c = 3;
        esh3.Lev4_Followup_Calendar_Days__c = 4;
        esh3.Level_1_Source__c = 'ISC Sharepoint';
        esh3.Level_1_POC__c = 'Quality Contact';
        esh3.Level_2_Source__c = 'ISC Sharepoint';
        esh3.Level_2_POC__c = 'Site Quality Leader';
        esh3.Level_3_Source__c = 'ISC Sharepoint';
        esh3.Level_3_POC__c = 'Quality Director';
        esh3.Level_4_Source__c = 'ISC Sharepoint';
        esh3.Level_4_POC__c = 'VP Quality team';
        eshlst.add(esh3);
        insert eshlst;
        list<SharePoint_Site_Data__c> ssdlst = new list<SharePoint_Site_Data__c>();
        SharePoint_Site_Data__c ssdc = new SharePoint_Site_Data__c();
        ssdc.Site_Code__c = '1234';
        ssdc.Record_Type__c = 'Repair & Overhaul';
        ssdc.Level_1_ISC_Help_Mailbox__c = con.Primary_Email_Address__c;
        ssdc.Level_2_Mailbox_Manager__c = con.Primary_Email_Address__c;
        ssdc.Level_3_Site_Leader__c = con.Primary_Email_Address__c;
        ssdc.Level_4_Op_VP_and_C_PS_VP__c = con1.Primary_Email_Address__c;
        ssdc.Quality_Contact__c = con.Primary_Email_Address__c;
        ssdc.Site_Quality_Leader__c = con.Primary_Email_Address__c;
        ssdc.Quality_Director__c = 'testing@testing123.com;testing@testing222.com';
        ssdc.VP_Quality_Team__c = con1.Primary_Email_Address__c;
        sptlst.add(ssdc);
        SharePoint_Site_Data__c ssdc1 = new SharePoint_Site_Data__c();
        ssdc1.Site_Code__c = '2345';
        ssdc1.Record_Type__c = 'Orders';
        ssdc1.Level_1_ISC_Help_Mailbox__c = 'testing@testing123.com;testing@testing222.com';
        ssdc1.Level_2_Mailbox_Manager__c = con1.Primary_Email_Address__c;
        ssdc1.Level_3_Site_Leader__c = con1.Primary_Email_Address__c;
        ssdc1.Level_4_Op_VP_and_C_PS_VP__c = con1.Primary_Email_Address__c;
        ssdc1.Quality_Contact__c = con1.Primary_Email_Address__c;
        ssdc1.Site_Quality_Leader__c = con1.Primary_Email_Address__c;
        ssdc1.Quality_Director__c = con1.Primary_Email_Address__c;
        ssdc1.VP_Quality_Team__c = con1.Primary_Email_Address__c;
        sptlst.add(ssdc1);
        insert sptlst;
        
        Case cs = new Case();
        cs.RecordTypeId = recordTypeIdcs;
        cs.Origin = 'Phone';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Status = 'Open';
        cs.contactid = con.id;
        cs.Classification__c = 'GCE BPM Operations';
        cs.Type = 'FGI Orders';
        cs.OwnerId = Usr1.id;
        cs.Sub_Status__c = '';
        cs.Case_Comments__c = 'hello';
        cs.AccountId = acc.id;
        caslst.add(cs);
        System.debug('cs.OwnerId::'+cs.OwnerId);
        Case cs1 = new Case();
        cs1.RecordTypeId = recordTypeIdcsord;
        cs1.Origin = 'Phone';
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Status = 'Open';
        cs1.contactid = con.id;
        //cs1.Escalation_Level__c = 'Escalation 2';
        cs1.Classification__c = 'GCE BPM Operations';
        cs1.Type = 'FGI Orders';
        cs1.OwnerId = UserInfo.getUserId();
        cs1.Sub_Status__c = '';
        cs1.Case_Comments__c = 'hello123';
        cs1.AccountId = acc.id;
        caslst.add(cs1);
        Case css = new Case();
        css.RecordTypeId = recordTypeIdcsord;
        css.Origin = 'Phone';
        css.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css.Government_Compliance_SM_M_Content__c = 'No';
        css.contactid = con.id;
        css.Classification__c = 'GCE BPM Operations';
        css.Type = 'FGI Orders';
        css.OwnerId = UserInfo.getUserId();
        css.AccountId = acc.id;
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Quality Hold';
        css.Reason_for_hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = true;
        css.Escalation_Level__c = 'Escalation 3';
        css.Max_Escalation_Level_Reach__c = '';
        css.Due_Date__c = system.today();
        css.Pega_Reason_for_Hold__c = 'Yes';
        css.Sales_Order_Number__c = '23478';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '2345';
        css.Repair_Notification_Number__c = '2346';
        caslst.add(css);
        Case css22 = new Case();
        css22.RecordTypeId = recordTypeIdcsord;
        css22.Origin = 'Phone';
        css22.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css22.Government_Compliance_SM_M_Content__c = 'No';
        css22.contactid = con.id;
        css22.Classification__c = 'GCE BPM Operations';
        css22.Type = 'FGI Orders';
        css22.OwnerId = UserInfo.getUserId();
        css22.AccountId = acc.id;
        css22.Status = 'On Hold';
        css22.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css22.Reason_for_hold__c = 'CAFÉ REPORT';
        css22.Case_Comments__c = 'Test';
        css22.VN_Name__c = con.id;
        css22.Escalated__c = true;
        css22.Escalation_Level__c = 'Escalation 3';
        css22.Max_Escalation_Level_Reach__c = 'Escalation 2';
        css22.Due_Date__c = system.today();
        css22.Pega_Reason_for_Hold__c = 'Yes';
        css22.Sales_Order_Number__c = '23478';
        css22.Hon_Plant_Code_del__c = '2345';
        css22.Part_Number__c = '2345';
        css22.Repair_Notification_Number__c = '2346';
        caslst.add(css22);
        Case css12 = new Case();
        css12.RecordTypeId = recordTypeIdcs;
        css12.Origin = 'Phone';
        css12.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css12.Government_Compliance_SM_M_Content__c = 'No';
        css12.contactid = con.id;
        css12.Classification__c = 'GCE BPM Operations';
        css12.Type = 'FGI Orders';
        css12.OwnerId = Usr1.Id;
        css12.AccountId = acc.id;
        css12.Status = 'On Hold';
        css12.Sub_Status__c = 'BUSINESS HOLD';
        css12.Reason_for_hold__c = 'PRICING VALIDATION';
        css12.Case_Comments__c = 'Test';
        css12.VN_Name__c = con.id;
        css12.Escalated__c = true;
        css12.Escalation_Level__c = 'Escalation 3';
        css12.Due_Date__c = system.today();
        css12.Pega_Reason_for_Hold__c = 'Yes';
        css12.Sales_Order_Number__c = '23478';
        css12.Hon_Plant_Code_del__c = '2345';
        css12.Part_Number__c = '2345';
        css12.Repair_Notification_Number__c = '2346';
        caslst.add(css12);
        Case css11 = new Case();
        css11.RecordTypeId = recordTypeIdcs;
        css11.Origin = 'Phone';
        css11.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css11.Government_Compliance_SM_M_Content__c = 'No';
        css11.contactid = con.id;
        css11.Classification__c = 'GCE BPM Operations';
        css11.Type = 'FGI Orders';
        css11.OwnerId = Usr1.Id;
        css11.AccountId = acc.id;
        css11.Status = 'On Hold';
        css11.Sub_Status__c = 'CSO HOLD';
        css11.Reason_for_hold__c = 'INTERNAL QUALITY REVIEW';
        css11.Case_Comments__c = 'Test';
        css11.VN_Name__c = con.id;
        css11.Escalated__c = false;
        css11.Escalation_Level__c = 'Escalation 3';
        css11.Due_Date__c = system.today();
        css11.Pega_Reason_for_Hold__c = 'Yes';
        css11.Sales_Order_Number__c = '23478';
        css11.Hon_Plant_Code_del__c = '2345';
        css11.Part_Number__c = '2345';
        css11.Repair_Notification_Number__c = '2346';
        caslst.add(css11);
        Case css3 = new Case();
        css3.RecordTypeId = recordTypeIdcs;
        css3.Origin = 'Phone';
        css3.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css3.Government_Compliance_SM_M_Content__c = 'No';
        css3.contactid = con.id;
        css3.Classification__c = 'GCE BPM Operations';
        css3.Type = 'FGI Orders';
        css3.OwnerId = UserInfo.getUserId();
        css3.AccountId = acc.id;
        css3.Status = 'On Hold';
        css3.Sub_Status__c = 'Finance Hold';
        css3.Reason_for_hold__c = 'PAYMENT ISSUES';
        css3.Case_Comments__c = 'Test';
        css3.VN_Name__c = con.id;
        css3.Escalated__c = true;
        css3.Escalation_Level__c = 'Escalation 1';
        css3.Due_Date__c = system.today();
        css3.Pega_Reason_for_Hold__c = 'Yes';
        caslst.add(css3);
        Case css4 = new Case();
        css4.RecordTypeId = recordTypeIdcsord;
        css4.Origin = 'Phone';
        css4.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css4.Government_Compliance_SM_M_Content__c = 'No';
        css4.contactid = con.id;
        css4.Classification__c = 'GCE BPM Operations';
        css4.Type = 'FGI Orders';
        css4.OwnerId = UserInfo.getUserId();
        css4.AccountId = acc.id;
        css4.Status = 'On Hold';
        css4.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css4.Reason_for_hold__c = 'CAFÉ REPORT';
        css4.Case_Comments__c = 'Test';
        css4.VN_Name__c = con.id;
        css4.Escalated__c = true;
        css4.Escalation_Level__c = 'Escalation 1';
        css4.Due_Date__c = system.today();
        css4.Pega_Reason_for_Hold__c = 'Yes';
        css4.Hon_Plant_Code_del__c = '2345';
        css4.Part_Number__c = '2345';
        css4.Repair_Notification_Number__c = '2346';
        caslst.add(css4);
        Case css5 = new Case();
        css5.RecordTypeId = recordTypeIdcsord;
        css5.Origin = 'Phone';
        css5.Export_Compliance_Content_ITAR_EAR__c = 'No';
        css5.Government_Compliance_SM_M_Content__c = 'No';
        css5.contactid = con.id;
        css5.Classification__c = 'GCE BPM Operations';
        css5.Type = 'FGI Orders';
        css5.OwnerId = UserInfo.getUserId();
        css5.AccountId = acc.id;
        css5.Status = 'On Hold';
        css5.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css5.Reason_for_hold__c = 'CAFÉ REPORT';
        css5.Case_Comments__c = 'Test';
        css5.VN_Name__c = con.id;
        css5.Escalated__c = true;
        css5.Escalation_Level__c = 'Escalation 2';
        css5.Due_Date__c = system.today();
        css5.Pega_Reason_for_Hold__c = 'Yes';
        css5.Hon_Plant_Code_del__c = '2345';
        css5.Part_Number__c = '2345';
        css5.Repair_Notification_Number__c = '2346';
        caslst.add(css5);
        insert caslst;
        test.startTest();
        User thisUser = [select Id,email,EmployeeNumber from User where Id = :UserInfo.getUserId()];
        System.debug('thisUser::'+thisUser);
        System.runAs (thisUser) {
        Group grp = [Select name from Group where name = 'Alt Leadership'];
        GroupMember grpMem1 = new GroupMember();
        grpMem1.UserOrGroupId = usr.id;
        grpMem1.GroupId = grp.Id;
        Insert grpMem1;
        }
        Test.stopTest();
    }
    
    @istest static void testmethod1(){
        test.startTest();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, contactid, Accountid, Status, Origin, Case_Comments__c, OwnerId, RecordTypeId from Case limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Finance Hold';
        css.Reason_for_hold__c = 'PAYMENT ISSUES';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        update css;
        System.debug('css after update::'+css);
		test.stopTest();
    }
    @istest static void testmethod111(){
        test.startTest();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, VN_Name__c, Escalated__c, contactid, Accountid, Status, Reason_for_hold__c, Origin, Case_Comments__c, OwnerId, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'Finance HOLD' AND RecordTypeId =: recordTypeIdcs limit 1];
    	  ContentVersion contentVersion = new ContentVersion(
          Title = css.Reason_for_hold__c+'-'+'TestDocs',
          PathOnClient = 'TestDocs.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.debug('documents::'+documents);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = css.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'I';
        insert cdl;
        CaseEscalationForHolds.sendescalatedemailFirstEscalation(css.id);
        test.stopTest();
    }
    @istest static void testmethod112(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'CSO HOLD' limit 1];
    	 System.debug('css::'+css); 
         ContentVersion contentVersion = new ContentVersion(
          Title = css.Reason_for_hold__c+'-'+'TestDocs',
          PathOnClient = 'TestDocs.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.debug('documents::'+documents);
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = css.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'I';
        insert cdl;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod2(){
        test.startTest();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, contactid, Accountid, Status, Origin, Case_Comments__c, OwnerId, RecordTypeId from Case where Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css.Reason_for_hold__c = 'CAFÉ REPORT';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 2';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        update css;
        System.debug('css after update::'+css);
        test.stopTest();
    }
    @istest static void testmethod31(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css.Reason_for_hold__c = 'CAFÉ REPORT';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        css.Max_Escalation_Level_Reach__c = 'Escalation 1';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod35(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css.Reason_for_hold__c = 'CAFÉ REPORT';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        //css.Max_Escalation_Level_Reach__c = 'Escalation 1';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
        @istest static void testmethod32(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'QUALITY HOLD' limit 1];
        System.debug('css::'+css);
        css.RecordTypeId = recordTypeIdcs;
        css.Status = 'On Hold';
        css.Sub_Status__c = 'QUALITY HOLD';
        css.Reason_for_hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        //css.Max_Escalation_Level_Reach__c = 'Escalation 1';
        css.Hon_Plant_Code_del__c = '1234';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod33(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'BUSINESS HOLD' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'BUSINESS HOLD';
        css.Reason_for_hold__c = 'PRICING VALIDATION';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 4';
        css.Due_Date__c = system.today();
        css.Max_Escalation_Level_Reach__c = 'Escalation 1';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 4';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod34(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'BUSINESS HOLD' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'BUSINESS HOLD';
        css.Reason_for_hold__c = 'PRICING VALIDATION';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        css.Max_Escalation_Level_Reach__c = 'Escalation 1';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
        @istest static void testmethod22(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'Quality Hold' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Quality HOLD';
        css.Reason_for_hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        css.Escalation_Level__c = 'Escalation 2';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        css.Sales_Order_Number__c = '23478';
        css.Pega_Reason_for_Hold__c = 'yes';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod23(){
         test.startTest();
         list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        User usr = [Select id, EmployeeNumber, email from User where email = 'testing@testing222.com' limit 1];
        User usr1 = [Select id, EmployeeNumber, email, ManagerId from User where email = 'testing@testing123.com' limit 1]; 
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where RecordTypeId=: recordTypeIdcs AND Status='Open' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'CSO HOLD';
        css.Reason_for_hold__c = 'INTERNAL QUALITY REVIEW';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        css.Escalation_Level__c = 'Escalation 4';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        css.Sales_Order_Number__c = '23478';
        css.Pega_Reason_for_Hold__c = 'yes';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        //CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod24(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcsord = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'Open' AND RecordTypeId =: recordTypeIdcsord limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD';
        css.Reason_for_hold__c = 'CAFÉ REPORT';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        //css.Escalation_Level__c = 'Escalation 2';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Sales_Order_Number__c = '123456';
        //css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod25(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcsord = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Orders').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'Open' AND RecordTypeId =: recordTypeIdcsord limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Quality HOLD';
        css.Reason_for_hold__c = 'PROVIDE ANSWER TO CUSTOMER QUERY';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        css.Escalation_Level__c = 'Escalation 2';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        css.Sales_Order_Number__c = '23478';
        css.Pega_Reason_for_Hold__c = 'yes';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
       // CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod26(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'Finance Hold' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Finance Hold';
        css.Reason_for_hold__c = 'PAYMENT ISSUES';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        css.Escalation_Level__c = 'Escalation 2';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        css.Sales_Order_Number__c = '23478';
        css.Pega_Reason_for_Hold__c = 'yes';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod266(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Sub_Status__c = 'CSO Hold' AND Status = 'On Hold' limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'CSO Hold';
        css.Reason_for_hold__c = 'INTERNAL QUALITY REVIEW';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Due_Date__c = system.today();
        css.Escalation_Level__c = 'Escalation 2';
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        css.Sales_Order_Number__c = '23478';
        css.Pega_Reason_for_Hold__c = 'yes';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
    @istest static void testmethod27(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'Finance Hold' AND RecordTypeId =: recordTypeIdcs limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Finance Hold';
        css.Reason_for_hold__c = 'PAYMENT ISSUES';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Sales_Order_Number__c = '123456';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod28(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'CSO HOLD' AND RecordTypeId =: recordTypeIdcs limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'CSO HOLD';
        css.Reason_for_hold__c = 'INTERNAL QUALITY REVIEW';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 3';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Sales_Order_Number__c = '123456';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 3';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod29(){
        test.startTest();
         list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'CSO HOLD' AND RecordTypeId =: recordTypeIdcs limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'CSO HOLD';
        css.Reason_for_hold__c = 'INTERNAL QUALITY REVIEW';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Escalation_Level__c = 'Escalation 4';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Sales_Order_Number__c = '123456';
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 4';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod30(){
        test.startTest();
        list<Case> cslst = new list<Case>();
        Map<Id, Case> cslstmap = new Map<Id, Case>();
        Id recordTypeIdcs = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Repair & Overhaul').getRecordTypeId();
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Case css = [select id, Sub_Status__c, Due_Date__c, VN_Name__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, Case_Record_Type__c,
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Product_Number__r.Name, 
              		Part_Number__c, Status, Origin, Reason_for_hold__c, Pega_Reason_for_Hold__c,Hon_Plant_Code_del__c, Max_Escalation_Level_Reach__c,
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Status = 'On Hold' AND Sub_Status__c = 'Finance Hold' AND RecordTypeId =: recordTypeIdcs limit 1];
        System.debug('css::'+css);
        css.Status = 'On Hold';
        css.Sub_Status__c = 'Finance Hold';
        css.Reason_for_hold__c = 'PAYMENT ISSUES';
        css.Case_Comments__c = 'Test';
        css.VN_Name__c = con.id;
        css.Escalated__c = false;
        css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 4';
        css.Escalation_Level__c = 'Escalation 4';
        css.Due_Date__c = system.today();
        css.Hon_Plant_Code_del__c = '2345';
        css.Part_Number__c = '12345';
        css.Sales_Order_Number__c = '123456';
        //css.Email_Subject_Value__c = 'ACTION REQUIRED - ESCALATION 2';
        css.Repair_Notification_Number__c = '2346';
        update css;
        cslst.add(css);
        System.debug('css after update::'+css);
        for(Case cs: cslst){
            cslstmap.put(cs.id, cs);
        }
        CaseEscalationForHolds.sendescalatedemail(cslst, cslstmap);
        test.stopTest();
    }
     @istest static void testmethod3(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       list<Case> css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,10);
        test.stopTest();
     }
   /* @istest static void testmethod4(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       Case css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Escalation_Level__c = 'Escalation 3' AND Sub_Status__c = 'Finance Hold' limit 1];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
        test.stopTest();
     }
    @istest static void testmethod5(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       Case css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Escalation_Level__c = 'Escalation 3' AND Sub_Status__c = 'Quality Hold' limit 1];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
        test.stopTest();
     }
    @istest static void testmethod6(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       Case css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Escalation_Level__c = 'Escalation 3' AND Sub_Status__c = 'CSO Hold' limit 1];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
        test.stopTest();
     }
    @istest static void testmethod7(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       Case css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Escalation_Level__c = 'Escalation 2' AND Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD' limit 1];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
        test.stopTest();
     }
     @istest static void testmethod8(){
        Contact con = [Select id, name, email from Contact where LastName = 'testing123' limit 1];
        Account Acc = [Select id from Account where name = 'test' limit 1];
       Case css = [select id, Sub_Status__c, Due_Date__c, Escalated__c, Escalation_Level__c, contactid, Accountid, 
                    Case_Ref_ID__c, CaseNumber, Customer_Sold_To__c, Sales_Order_Number__c, Quote_Number__c, 
                    Repair_Notification_Number__c, Customer_PO_RO_WONumber__c, Contract_Number__c,Status, Origin, 
                    Case_Comments__c, OwnerId, To_addresses__c, RecordTypeId from Case where Escalation_Level__c = 'Escalation 3' AND Sub_Status__c = 'INTEGRATED SUPPLY CHAIN HOLD' limit 1];
        System.debug('css::'+css);
        System.debug('css after update::'+css);
        test.startTest();
        CaseEscalationForHolds_Batch cef = new CaseEscalationForHolds_Batch();
        database.executeBatch(cef,5);
        test.stopTest();
     }*/
}
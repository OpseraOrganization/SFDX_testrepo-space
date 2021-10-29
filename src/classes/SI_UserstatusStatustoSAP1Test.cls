@isTest(seealldata=true)
Private class SI_UserstatusStatustoSAP1Test{ 
    Public static testmethod void testDoPost() 
    {        
        List<Case> c = new List<Case>();
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        cas.Classification__c = 'CSO Repair Order';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        cas.Quote_Number__c= '213424';
        cas.CaseOwnerChanged__c = 'nandini.nanjappan@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        cas.Repair_Notification_Number__c = '3243';
        insert cas;
        //insert c;
        Z_Task__c zt = new Z_Task__c();
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cas.id;
        zt.Status__c = null;
        zt.type__c='Z107 Order Information Required';
        zt.lastmodifiedbyid = label.DeniedPartyScreening_APIUser_ID;
        zt.Requested_By__c = label.Task_Activities_Requested_By;
        zt.New_Long_Text__c= 'testcase';
        zt.Followuptask__c = false;
        zt.Language_Key__c = 'test11';
        zt.SI_SAP_Task__c = false;
        zt.Event_Type__c = 'test';
        zt.Name = 'TestZtask';
        zt.Sub_Type__c = 'test';
        //insert zt;
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'HRTS';
        u1.Status__c = 'Open';
        u1.Case__c = cas.id;
        u1.Task_Activities__c = zt.id;
        u1.SAPUserStatusObjectNumber__c = 'Test';
        u1.Email_Status__c = 'Sent';
        ulist.add(u1);
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'HRTS';
        u2.Status__c = 'Closed';
        u2.Case__c = cas.id;
        u2.Task_Activities__c = zt.id;
        u2.SAPUserStatusObjectNumber__c = 'Test';
        u2.Email_Status__c = 'Sent';
        ulist.add(u2);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());      
        Test.startTest();
        insert zt;
        insert ulist;
        list<id> userid=new list<id>();
        string userid1;
        for(Activitiy_Line_Item__c user:ulist)
        {
            userid.add(user.id);
            userid1=user.id;
        }           
        SI_UserstatusStatustoSAP1.SendTaskStatus(userid);
        SI_UserstatusStatustoSAP.SendTaskStatus(userid1);
        Test.stopTest();
    }
    Public static testmethod void testDoPost1() 
    {        
        List<Case> c = new List<Case>();
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        cas.Classification__c = 'CSO Repair Order';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        cas.Quote_Number__c= '213424';
        cas.CaseOwnerChanged__c = 'nandini.nanjappan@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        cas.Repair_Notification_Number__c = '3243';
        insert cas;
        Z_Task__c zt = new Z_Task__c();
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cas.id;
        zt.Status__c = null;
        zt.type__c='Z107 Order Information Required';
        zt.lastmodifiedbyid = label.DeniedPartyScreening_APIUser_ID;
        zt.Requested_By__c = label.Task_Activities_Requested_By;
        zt.New_Long_Text__c= 'testcase';
        zt.Followuptask__c = false;
        zt.Language_Key__c = 'test11';
        zt.SI_SAP_Task__c = false;
        zt.Event_Type__c = 'test';
        zt.Name = 'TestZtask';
        zt.Sub_Type__c = 'test';
        //insert zt;
        List<Activitiy_Line_Item__c> ulist = new List<Activitiy_Line_Item__c>();
        Activitiy_Line_Item__c u1 = new Activitiy_Line_Item__c();
        u1.Name__c = 'HRTS';
        u1.Status__c = 'Closed';
        u1.Case__c = cas.id;
        u1.Task_Activities__c = zt.id;
        u1.SAPUserStatusObjectNumber__c = 'Test';
        u1.Email_Status__c = 'Sent';
        ulist.add(u1);
        Activitiy_Line_Item__c u2 = new Activitiy_Line_Item__c();
        u2.Name__c = 'HRTS';
        u2.Status__c = 'deleted';
        u2.Case__c = cas.id;
        u2.Task_Activities__c = zt.id;
        u2.SAPUserStatusObjectNumber__c = 'Test';
        u2.Email_Status__c = 'Sent';
        ulist.add(u2);
        Activitiy_Line_Item__c u3 = new Activitiy_Line_Item__c();
        u3.Name__c = 'HRTS';
        u3.Status__c = 'open';
        u3.Case__c = cas.id;
        u3.Task_Activities__c = zt.id;
        u3.SAPUserStatusObjectNumber__c = 'Test';
        u3.Email_Status__c = 'Sent';
        ulist.add(u3);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());      
        Test.startTest();
        insert zt;
        insert ulist;
        list<id> userid=new list<id>();
        string userid1;
        for(Activitiy_Line_Item__c user:ulist)
        {
            userid.add(user.id);
            userid1=user.id;
        }           
        SI_UserstatusStatustoSAP1.SendTaskStatus(userid);
        SI_UserstatusStatustoSAP.SendTaskStatus(userid1);
        Test.stopTest();
    }
}
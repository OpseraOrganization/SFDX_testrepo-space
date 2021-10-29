/*******************************************************************************
Name         : SI_ZtaskStatustoSAP
Created By   : NTTDATA
Company Name : NTT Data
Project      : <SI_SAPtoSFDCServiceclass>
Created Date : 20-Sep-2016
Usages       : Test Class for CaseCreationPortaltoSFDC
*******************************************************************************/
@isTest(seealldata=true)
global class SI_ZtaskStatustoSAPTest{ 
    testMethod static void SI_ZtaskStatustoSAPTest()
    {
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
                
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test & and <> and "';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122 & and <> and "';
        zt11.New_Long_Text__c='Test122 & and <> and "';
        zt11.Sub_Type__c = 'Test & and <> and "';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Open';
        zt11.Followuptask__c=false;
        zt11.Language_Key__c='test';
        zt11.ownerid=label.CSO_R_O_Team;
        insert zt11;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        set<id> ztaskid=new set<id>();
        ztaskid.add(zt11.id);
        //SI_ZtaskStatustoSAP.SendTaskStatus(ztaskid);
        List<id> ztaskid1=new List<id>();
        ztaskid1.add(zt11.id);
        //SI_ZtaskStatustoSAP1.SendTaskStatus(ztaskid1);
    }
    testMethod static void SI_ZtaskStatustoSAPTest1()
    {
         Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Z_Task__c zt12 = new Z_Task__c();
        zt12.SAP_ZTask_Number__c = 'Test123';
        zt12.Name = 'Tasktest1';
        zt12.RelatedTo__c = cas.id;
        zt12.Short_Text__c = '';
        //zt12.Short_Text2__c='';
        zt12.Comments__c = 'Test Ztask';
        zt12.Long_Text__c = 'Test122 & and <> and "';
        zt12.New_Long_Text__c='Test122 & and <> and "';
        zt12.Sub_Type__c = null;
        zt12.Other_Short_Text__c = 'Test';
        zt12.Status__c = 'Open';
        zt12.Followuptask__c=false;
        zt12.Language_Key__c='test';
        zt12.ownerid=label.CSO_R_O_Team;
        insert zt12;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        set<id> ztaskid2=new set<id>();
        ztaskid2.add(zt12.id);
        //SI_ZtaskStatustoSAP.SendTaskStatus(ztaskid2);
        List<id> ztaskid3=new List<id>();
        ztaskid3.add(zt12.id);
        
        //SI_ZtaskStatustoSAP1.SendTaskStatus(ztaskid3);
    }
     testMethod static void SI_ZtaskStatustoSAPTest2()
    {
         Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Z_Task__c zt12 = new Z_Task__c();
        zt12.SAP_ZTask_Number__c = 'Test123';
        zt12.Name = 'Tasktest1';
        zt12.RelatedTo__c = cas.id;
        zt12.Short_Text__c = '';
        //zt12.Short_Text2__c='';
        zt12.Comments__c = 'Test Ztask';
        zt12.Long_Text__c = 'Test122 & and <> and "';
        zt12.New_Long_Text__c='Test122 & and <> and "';
        zt12.Sub_Type__c = 'Test';
        zt12.Other_Short_Text__c = 'Test';
        zt12.Status__c = 'Open';
        zt12.Followuptask__c=false;
        zt12.Language_Key__c='test';
        zt12.ownerid=label.CSO_R_O_Team;
        insert zt12;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        set<id> ztaskid2=new set<id>();
        ztaskid2.add(zt12.id);
        //SI_ZtaskStatustoSAP.SendTaskStatus(ztaskid2);
        List<id> ztaskid3=new List<id>();
        ztaskid3.add(zt12.id);
        
        //SI_ZtaskStatustoSAP1.SendTaskStatus(ztaskid3);
    }
}
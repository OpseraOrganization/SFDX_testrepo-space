@isTest(seealldata=true)
global class ROI_ZtaskUserStatustoSAPTest{ 
    testMethod static void SendTaskStatusTest()
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
        set<Id> Zid = new set<id>();        
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
        zt11.type__c ='Z107 Order Information Required';
        insert zt11;
        Zid.add(zt11.id);
        ROI_ZtaskUserStatustoSAP.SendTaskStatus(Zid);
        
    }
    testMethod static void SendTaskStatusTest1()
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
        set<Id> Zid = new set<id>();        
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
        zt11.type__c ='Z155 Airworthyness Board Approval from Cust.';
        insert zt11;
        Zid.add(zt11.id);
        List<Activitiy_Line_Item__c> actItem = new List<Activitiy_Line_Item__c>();
        Activitiy_Line_Item__c acItem = new Activitiy_Line_Item__c();
		acItem.status__c = 'open';
        acItem.Task_Activities__c = zt11.id;
        acItem.Case__c = cas.id;
		actItem.add(acItem);
        insert actItem;
        ROI_ZtaskUserStatustoSAP.SendTaskStatus(Zid);
        
    }

}
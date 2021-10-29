@isTest(seeAllData = false)
public class DSPC_Case_List_controller_test {
    static testMethod void myUnitTest() {
    test.starttest();        
        Country__c cc = new Country__c();
        cc.name = 'test';
        cc.SFDC_Country_Name__c = 'test';
        Account ac = new Account();
        ac.Name = 'Test Account two';
        ac.Customer_Status__c = 'Active';
        ac.Region_Name__c = 'Americas';
        ac.Sub_Region_Name__c = 'United States';
        ac.Service_Level__c = 'Standard';
        ac.Strategic_Business_Unit__c = 'D&S';
        ac.CBT__c = 'DSPC';
        ac.CBT_Team__c = 'Orion';
        ac.Country__c = cc.id;
        ac.Market_Name__c = 'Space';
        ac.Type = 'OEM';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Account';
        ac.DSPC_Account__c = true;
        insert ac;
        
        Contact con = new Contact();
        con.Lastname = 'Test Portal two';
        con.Accountid = ac.id;
        con.SBU_Contact__c = 'D&S';
        con.CBT__c = 'DSPC';
        con.CBT_Team__c = 'ORION';
        con.Email = 'test@test.com';
        insert con;
        //Profile p = [ select Id from Profile where Name=:'D&S_Partner_Portal_User']; 
      /*  User u = new User(ContactId = con.Id,
            Username = 'test@test.com.dspctwo',
            Email = 'test@testtwo.com',
            LastName = 'lastNametwo',
            Alias = 'alias',
            ProfileID = label.D_S_Partner_ProfileId,
            PortalRole = 'Manager',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey='UTF-8'
        );
        insert u; */
        user u=[select id,name from user where id=:label.test_user];      
        Case c = new case();
        c.Account_Name_web__c = 'Test Account';
        c.Address_Line_1__c = 'Test Address';
        c.City_Name__c = 'Test City';
        c.Country_Name__c = 'Test Country';
        c.Status = 'Active';
        c.First_Call_Resolution__c = true;
        c.RecordTypeId = label.DSPC_CMDT_RecordTypeId;
        c.Export_Compliance_Content_ITAR_EAR__c = 'No';
        c.Government_Compliance_SM_M_Content__c = 'No';
        //c.OwnerId = Label.DSPC_MDT_Queue_ID;
        c.contactid = con.id;
        insert c;
        PageReference pageRef = Page.DSPC_Campaign_List;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',c.id);
        DSPC_Case_List_controller Cntlr = new DSPC_Case_List_controller();        
        Cntlr.previous();
        Cntlr.next();  
        Boolean a = Cntlr.hasNext; 
        Boolean b = Cntlr.hasPrevious; 
        Integer c1 = Cntlr.pageNumber;
        Cntlr.AllSearchcase = new List<Case>();
    test.stoptest(); 
    }
}
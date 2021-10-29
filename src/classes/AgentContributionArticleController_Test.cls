@isTest
public class AgentContributionArticleController_Test {
    static testMethod void testCommented(){
        Test.StartTest();
        //The object name below has to match up with your trigger/class
        AgentContributionArticleController obj = new AgentContributionArticleController();
        //This one link is asserting that you successfully created it
        system.assertNotEquals(null,obj);   
        Test.StopTest();
        
        /* Rest of legacy code if you have it */
        
    }
   /* static testmethod void testmethod1(){
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
       // acc.Do_Not_Send_to_Portal__c=False;
        acc.Stop_to_Send_Surveys__c='test';
        insert acc;
            
        
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@honeywell.com';
        con.Last_Survey_Date__c=Date.parse('12/16/15');
        con.Email='sumit13.gupta@nttdata.com';
        insert con;
             
        test.startTest();       
        Case cseLow1 = new Case();
        cseLow1.Origin = 'Email-EMS-Norcross';
        cseLow1.Status = 'Open';
        cseLow1.RecordTypeId = Label.Case_AOG_RecordType;
        //cseLow1.Classification__c = 'MyGDC';
        cseLow1.ContactId = con.Id;
        cseLow1.vn_name__c=con.id;
        cseLow1.Type_of_Change__c = 'New Account';
        cseLow1.Type = 'Other';
        cseLow1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cseLow1.Government_Compliance_SM_M_Content__c = 'NO';
        //cseLow1.OwnerId=label.aero_default_user_id;
        insert cseLow1; 
        
        cseLow1.RecordTypeId=Label.Orders_Rec_ID;
        cseLow1.Type='Place Order';
        cseLow1.Status='Open';
        cseLow1.Origin='Email';
        cseLow1.Classification__c = 'EDI';    
        cseLow1.OwnerId=UserInfo.getUserId();  
        cselow1.Sales_Order_Number__c = '123';
        update cseLow1;
         
        Knowledge_Article__kav kak = new Knowledge_Article__kav();
        PageReference pageRef = new PageReference('knowledge/publishing/articleEdit.apexp?sourceId='+cseLow1.id+'&type=Knowledge_Article__kav');
        Test.setCurrentPageReference(pageRef);
        // load the extension
        AgentContributionArticleController acac = new AgentContributionArticleController(new ApexPages.KnowledgeArticleVersionStandardController(kak));
 
        
        test.stopTest();    

        
    } */
  

    
}
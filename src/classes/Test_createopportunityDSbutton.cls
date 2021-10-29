@isTest(SeeAllData = true)
public class Test_createopportunityDSbutton{
//005Q0000000u76O', 
    static testMethod void createopportunityDSbutton() {
  
       Profile pf = [select name from Profile where name = 'System Administrator'];
            User testUser = new User(FirstName = 'Trigger', LastName = 'Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
                'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
                'ISO-8859-1',ProfileId = pf.ID, LanguageLocaleKey = 
                'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam');
            insert testUser;
    D_S_Profile__c DS = New D_S_Profile__c(Profile__c='005Q0000000u76O');
    DS.Name = 'test DS';
    insert ds;
    Portal_Access_Template__c wpt= New Portal_Access_Template__c(Template_Description__c='Test descp');
    Account acc= new Account(name = 'Test Account D&S',Market_name__C = 'Military',ATR_Portal_Access_Template__c=wpt.id);
        insert acc;
        
        //creating contact
        Contact cont = new Contact(
            firstname = 'Test',
            LastName = 'Contact D&S',
            AccountId = acc.Id,
            Phone_3__c = '9986502495',
            Contact_Is_Employee__c = true,
            Contact_Status__c = 'Active',
            Employee_Contact_Role__c = 'Analyst',
            //Employee_Number__c = 'T123567',
            Honeywell_ID__c = '01499xxx40331',
            EMAIL = 'aldcv.sfwv@vfv.com'
        );
        insert cont; 
        
        
        Case cases = new Case(
            AccountId = acc.Id,
            subject = 'ARINC Update',
            ContactId = cont.Id,
            Origin = 'Phone',
            //No_FCR_Reason__c = 'Not Trained', For Ticket INC000009687923
            Type = 'Order',
            Opportunity_Type__c ='D&S PrePriced',
            Program__c='Albin Test',
            Contractor_Status__c='Prime',
            Status='New',
          //RecordTypeID = label.D_S_Clear_House_RecordTypeId_Case,
            NSN__c = '1,2',
            Part_Number__c = '2,3',Certification_Requirements__c = 'Direct Commercial',
            Estimated_Proposal_Value__c='24',
            Proposal_Content__c = 'ENG'
            
        );
        insert cases;
       
        Product2 pro= New Product2(IsActive=true,Name='Test pro D&S',ProductCode='3',Site__c='Phoenix, AZ');
        pro.IsActive = true;
        insert pro;
        Case_Line_Item__c clt=New Case_Line_Item__c(Case_Number__c=cases.id,Quantity__c=2,Product_Number__c=pro.id, Comments__c = 'Test');
        insert clt;
        test.starttest();

        ApexPages.StandardController con = new ApexPages.StandardController(cases);
        apexpages.currentpage().getparameters().put('id' , cases.id);
        createopportunityDSbutton test1 = new createopportunityDSbutton(con);
        TriggerInactive.TestOppRequiredFields = false;    
        test1.doinsert();
        system.debug('22222'+cases.Opportunity_Proposal__c);

        test.stoptest();
    }
  }
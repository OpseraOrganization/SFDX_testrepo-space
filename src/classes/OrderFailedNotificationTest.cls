@isTest
public class OrderFailedNotificationTest{

    
     @isTest
    static void OrderFailedNoteTest(){
      
      Test.StartTest(); 
        
        Profile prof = [select id from profile where name ='NGBSS API'];
        User user = new User();
        user.firstName = 'test1';
        user.lastName = 'test2';
        user.profileId = prof.id;
        user.username = 'test@testalias.com';
        user.email = 'test@test.com';
        user.CompanyName = 'TEST';
        user.Title = 'title';
        user.Alias = 'alias';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        insert user;
      
      
     Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',External_Account_ID__c='300669',XREF_Type__c = 'SAP_SOLD_TO',Account_Name__c=acc.id,Site_Code__c='765');
        insert acref; 
        //  system.runAs(user){  
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
           
            Id  rtSoftware_Tools_SW_Tools = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Software Tools (SWT)').getRecordTypeId();
        Case ca = New Case();
        Ca.Subject = 'Test Case';
        Ca.RecordTypeId = rtSoftware_Tools_SW_Tools;
        ca.Origin = 'Web';
        ca.Status = 'Open';
        Ca.Type = 'SW Tools';
        Ca.Contactid = C.id;
        Ca.Classification__c = 'Misc';
        Ca.HON_Commit_Date__c = System.Now();
        Insert ca;
          Apttus_Config2__ClassificationName__c classif = new Apttus_Config2__ClassificationName__c();
        classif.name = 'TestClassification1';
        classif.Apttus_Config2__HierarchyLabel__c = 'TestClassification1';
        classif.Required_For_Portal__c = true;
        classif.Apttus_Config2__Type__c = 'Offering';
        insert classif;
        Apttus_Config2__ClassificationHierarchy__c clashir = new Apttus_Config2__ClassificationHierarchy__c();
        clashir.Apttus_Config2__HierarchyId__c=classif.id;
        clashir.Name='Navigational Data';
        clashir.Apttus_Config2__Label__c='Navigational Data';
        insert clashir;
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
    prod1.family = 'Nav Database';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
    insert prod1;
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id; 
        insert pog;
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod1.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        
        Apttus_Config2__PriceList__c Pricelist =  New Apttus_Config2__PriceList__c();
        Pricelist.Name = 'Aspire PriceList';
        Insert Pricelist;
        
        case c1 = [Select id,CaseNumber from Case where id =: ca.id limit 1];
        
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        //objOrder.Case_Number__c = c1.caseNumber;
        insert objOrder;
        
                
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = objOrder.id
        );
        insert config;
        
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1
        );
        insert lineItem; 
        
        Apttus_Config2__OrderLineItem__c Orderli = New Apttus_Config2__OrderLineItem__c();
        Orderli.Apttus_Config2__ProductId__c = prod1.id;
        Orderli.Apttus_Config2__OptionId__c = prod1.id;
        Orderli.Apttus_Config2__OrderId__c = objOrder.id;
        
        Insert Orderli;
        
        CPQ_Platform__c Cpq = New CPQ_Platform__c();
        Cpq.Line_Item__c = lineItem.id;
        cpq.Name = '243643';
        cpq.Order_Line_Item__c = Orderli.id;
        Insert cpq; 
        
        CPQ_Email__c  Cemaill = New CPQ_Email__c();
        Cemaill.Name = 'karanatakam.ganguraju@honeywell.com';
        Cemaill.Order__C = objOrder.id;
        
        Insert Cemaill;
        
        objOrder.Case_Number__c = c1.casenumber;
        objorder.NGBSS_Processing_Status__c = 'Order Error';
        Update objOrder;
        
        //crete Invoice
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(Apttus_Billing__Status__c = 'Draft',Case_Number__c = c1.caseNumber);
        insert invoice;
       
              
        //}
        Test.StopTest();
}

}
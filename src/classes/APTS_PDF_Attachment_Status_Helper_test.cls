@istest public class APTS_PDF_Attachment_Status_Helper_test {
    
    @isTest static void APTS_PDF_Attachment_Status_Helper_test1() {
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft',
            Price_List__c='Aspire priceList',
            Apttus_Billing__DeliveryStatus__c = 'Pending'
        );
        insert invoice;
        
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
        
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
       
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
        prod1.License_Type__c='APU';
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
        
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
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
        Orderli.License_Required_and_Linked__c= 'No';
        Orderli.Apttus_Config2__LineType__c='Option';
        
        Insert Orderli;
        
        CPQ_Platform__c Cpq = New CPQ_Platform__c();
        Cpq.Line_Item__c = lineItem.id;
        cpq.Name = '243643';
        cpq.Order_Line_Item__c = Orderli.id;
        cpq.License_Status__c= 'Activation Key-Created';
        cpq.Type__c='test';
        Insert cpq; 
        
        CPQ_Email__c  Cemaill = New CPQ_Email__c();
        Cemaill.Name = 'karanatakam.ganguraju@honeywell.com';
        Cemaill.Order__C = objOrder.id;
        
        Insert Cemaill;
        
        CPQ.License_Status__c= 'Activation Key-Linked';
        update CPQ;
        
        Orderli.License_Required_and_Linked__c= 'yes';
        Update Orderli;
        
        objOrder.Count_of_License_Status_Yes__c = 1;
        objOrder.Count_of_License_Status_No__c  = 0;
        objOrder.Licence_Key_Linked__c = True; 
        Update objOrder;
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA',
            Apttus_Config2__OptionId__c=prod1.id
        );
        insert assetLineItem;
        
       
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        insert billingSchedule;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id,
            Apttus_Billing__AssetLineItemId__c=assetLineItem.id
        );
        insert invoiceLineItem;
        
        APTS_PDF_Attachment_Status__c PDFAtt1 = New APTS_PDF_Attachment_Status__c();
        PDFAtt1.APTS_Invoice__c = invoice.id;
        PDFAtt1.APTS_Delete_Draft_Attachments__c = False;
        Insert PDFAtt1;
        
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment();
        attachment.ParentId = invoice.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        //insert(attachment);
        invoice.Is_License_Required__c=true;
        invoice.Apttus_Billing__Status__c='Approved';
        update invoice;
        APTS_PDF_Attachment_Status__c apts_pdf_attachment_status = new APTS_PDF_Attachment_Status__c(
            //APTS_Attachment_Id__c = attachment.id,
            APTS_Attachment_Title__c = 'INV-123456_FE Invoice_JAI_2019-01-11.pdf',
            APTS_Delete_Draft_Attachments__c = false,
            APTS_INV_Billing_Document_Number__c = '734736373633636',
            APTS_Integration_Requested__c = DateTime.newInstance(2019,12,11,8,492,29572),
            APTS_Invoice_Status__c = 'Approved',
            APTS_Invoice__c = invoice.id,
            APTS_Status__c = 'Completed');
        insert apts_pdf_attachment_status;
    }
}
/**************************************************************************
Class Name: QTO_CdLineItemAssociationHelperTest
Created by: Shaik Johny Basha
Created Date: 24 Jan 2023
Last modified by: Shaik Johny Basha
Description: Test class for QTO_CdLineItemAssociationHelper  
UserStory : DSI-2151
***************************************************************************/
@isTest 
public with sharing class QTO_CdLineItemAssociationHelperTest {
    
    /* This method is to setup testdata */
    @testsetup
    static void associateCdLineItemsTest() {
        
        List<Account> accList = QTO_TestDataFactory.createAccount(2);
        insert accList; 
        
        List<Account> accList1 = QTO_TestDataFactory.createAccount(1);
        accList1[0].Name='Dummy Acc';
        insert accList1; 
        
        
        List<Product2> productList = new List<Product2>();
        Product2 product1 = new Product2();
        product1.CurrencyIsoCode = 'USD';
        product1.ProductCode = 'Bundle 1S 4 ABIA';
        product1.Name = 'My SFR Cutlery';
        product1.Description = 'Test Detailed Product Description';
        product1.IsActive=True;
        product1.Apttus_Config2__ConfigurationType__c = 'Bundle';
        product1.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
        productList.add(product1);
        
        Product2 product2 = new Product2();
        product2.CurrencyIsoCode = 'USD';
        product2.ProductCode = 'Bundle 1S 4 ABIA1';
        product2.Name = 'My SFR Cutlery1';
        product2.Description = 'Test Detailed Product Description1';
        product2.IsActive=True;
        product2.Apttus_Config2__ConfigurationType__c = 'Bundle';
        product2.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
        productList.add(product2);
        insert productList;
        
        
        
        Apttus_Config2__PriceList__c priceList = QTO_TestDataFactory.priceList(); 
        priceList.Name = 'SFR Price List for Cutlery';
        priceList.Apttus_Config2__Description__c = 'SFR Price List for Cutlery';
        priceList.Apttus_Config2__Active__c = true;
        priceList.Apttus_Config2__AccountId__c = accList[0].Id;
        priceList.PriceList_Type__c = 'DS';
        priceList.Business_Group__c = 'GS';
        //priceList.Apttus_Config2__ContractNumber__c = 'Bundle 1S 4 ABIA';
        insert priceList;
        
        List<Apttus_Config2__PriceListItem__c> priceListItem = new List<Apttus_Config2__PriceListItem__c>();
        Apttus_Config2__PriceListItem__c priListItem1 = QTO_TestDataFactory.createPriceListItem(priceList); 
        priListItem1.Apttus_Config2__PriceListId__c = priceList.Id;
        priListItem1.Apttus_Config2__ProductId__c = productList[0].Id;
        priListItem1.Apttus_Config2__ChargeType__c = 'Product Price';
        priListItem1.Apttus_Config2__PriceType__c = 'One Time';
        priListItem1.Apttus_Config2__PriceUom__c = 'Each';
        priListItem1.Apttus_Config2__ContractPrice__c = 2500;
        priListItem1.Apttus_Config2__ListPrice__c = 2555;
        priListItem1.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA';
        priceListItem.add(priListItem1);
        
        Apttus_Config2__PriceListItem__c priListItem2 = QTO_TestDataFactory.createPriceListItem(priceList); 
        priListItem2.Apttus_Config2__PriceListId__c = priceList.Id;
        priListItem2.Apttus_Config2__ProductId__c = productList[1].Id;
        priListItem2.Apttus_Config2__ChargeType__c = 'Product Price';
        priListItem2.Apttus_Config2__PriceType__c = 'One Time';
        priListItem2.Apttus_Config2__PriceUom__c = 'Each';
        priListItem2.Apttus_Config2__ContractPrice__c = 2500;
        priListItem2.Apttus_Config2__ListPrice__c = 2555;
        priListItem2.Apttus_Config2__ContractItemNumber__c = 'Bundle 1S 4 ABIA1';
        priceListItem.add(priListItem2);
        insert priceListItem;
        
        Opportunity opp = QTO_TestDataFactory.OpportunityCreation(accList[0]);
        insert opp;
        
        Apttus__APTS_Agreement__c agr = QTO_TestDataFactory.createAgreement(accList[0], opp, accList[1]);
        agr.Apttus__Status_Category__c = 'In Effect';
        agr.Apttus__Status__c = 'Activated';
        agr.CurrencyIsoCode = 'EUR';
        agr.Apttus__Contract_End_Date__c = System.today()+10;
        insert agr; 
        
        List<Apttus__AgreementLineItem__c> agList = new List<Apttus__AgreementLineItem__c>();
        
        Apttus__AgreementLineItem__c agLine0 = new Apttus__AgreementLineItem__c();
        agLine0.Apttus__AgreementId__c = agr.Id;
        agLine0.Apttus__Description__c = 'My SFR Cutlery desc';
        agLine0.Contract_Item_Number__c = 'My SFR Cutlery';
        agLine0.CLM_CFE_Reference__c = 'My SFR Cutlery';
        agLine0.Apttus__ProductId__c = productList[0].Id;
        agLine0.Apttus__Quantity__c = 0;
        agLine0.Apttus_CMConfig__Uom__c = 'PCE';
        agLine0.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
        agLine0.Apttus__NetPrice__c = 2222.00;
        
            
        Apttus__AgreementLineItem__c agLine1 = new Apttus__AgreementLineItem__c();
        agLine1.Apttus__AgreementId__c = agr.Id;
        agLine1.Apttus__Description__c = 'My SFR Cutlery desc';
        agLine1.Contract_Item_Number__c = 'My SFR Cutlery';
        agLine1.CLM_CFE_Reference__c = 'My SFR Cutlery';
        agLine1.Apttus__ProductId__c = productList[1].Id;
        agLine1.Apttus__Quantity__c = 10;
        agLine1.Apttus_CMConfig__Uom__c = 'PCE';
        agLine1.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
        agLine1.Apttus__NetPrice__c = 2222.00;
        
        Apttus__AgreementLineItem__c agLine2 = new Apttus__AgreementLineItem__c();
        agLine2.Apttus__AgreementId__c = agr.Id;
        agLine2.Apttus__Description__c = 'My SFR Cutlery desc';
        agLine2.Contract_Item_Number__c = 'My SFR Cutlery1';
        agLine2.CLM_CFE_Reference__c = 'My SFR Cutlery1';
        agLine2.Apttus__ProductId__c = product2.Id;
        agLine2.Apttus__Quantity__c = 20;
        agLine2.Apttus_CMConfig__Uom__c = 'PCE';
        agLine2.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
        agLine2.Apttus__NetPrice__c = 2222.00;
        
        Apttus__AgreementLineItem__c agLine3 = new Apttus__AgreementLineItem__c();
        agLine3.Apttus__AgreementId__c = agr.Id;
        agLine3.Apttus__Description__c = 'My SFR Cutlery desc';
        agLine3.Contract_Item_Number__c = 'My SFR Cutlery1';
        agLine3.CLM_CFE_Reference__c = 'My SFR Cutlery1';
        agLine3.Apttus__ProductId__c = product1.Id;
        agLine3.Apttus__Quantity__c = 40;
        agLine3.Apttus_CMConfig__Uom__c = 'PCE';
        agLine3.Apttus_CMConfig__NetUnitPrice__c = 2222.00;
        agLine3.Apttus__NetPrice__c = 2222.00;
        
        agList.add(agLine0);
        agList.add(agLine1);
        agList.add(agLine2);
        agList.add(agLine3);
        insert agList;
        
        
        Map<Id,List<Apttus__AgreementLineItem__c>> agreementAndLinesMap = new Map<Id,List<Apttus__AgreementLineItem__c>>();
        agreementAndLinesMap.put(agr.Id, agList);
        
        List<Apttus_Proposal__Proposal__c> quotes = QTO_TestDataFactory.createProposal(1,opp.id); 
        quotes[0].Sold_To_Party__c=accList[0].Id;
        quotes[0].Apttus_Proposal__Account__c=accList[0].Id;
        quotes[0].Price_List__c=priceList.Id;
        quotes[0].Agreement_Lookup__c=agr.Id;
        quotes[0].Apttus_Proposal__Opportunity__c=opp.Id;
        quotes[0].CurrencyIsoCode = 'EUR';
        insert quotes;
        
        List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
        Apttus_Proposal__Proposal_Line_Item__c quoteLines1 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[0]); 
        quoteLines1.Apttus_Proposal__Product__c = productList[0].Id;
        quoteLines1.Apttus_QPConfig__PriceListItemId__c = priceListItem[0].Id;
        quoteLines1.Apttus_QPConfig__Quantity2__c = 100;
        quoteLines1.Apttus_QPConfig__Uom__c = 'PCE';
        quoteLines1.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
        quoteLinesList.add(quoteLines1);
        
        Apttus_Proposal__Proposal_Line_Item__c quoteLines2 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
        quoteLines2.Apttus_Proposal__Product__c = productList[1].Id;
        quoteLines2.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
        quoteLines2.Apttus_QPConfig__Quantity2__c = 100;
        quoteLines2.Apttus_QPConfig__Uom__c = 'PCE';
        quoteLines2.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
        quoteLinesList.add(quoteLines2);
        
        Apttus_Proposal__Proposal_Line_Item__c quoteLines3 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
        quoteLines3.Apttus_Proposal__Product__c = productList[1].Id;
        quoteLines3.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
        quoteLines3.Apttus_QPConfig__Quantity2__c = 10;
        quoteLines3.Apttus_QPConfig__Uom__c = 'PCE';
        quoteLines3.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
        quoteLinesList.add(quoteLines3);
        
        Apttus_Proposal__Proposal_Line_Item__c quoteLines4 = QTO_TestDataFactory.proposalLineItemCreation(quotes[0].id,priceListItem[1]); 
        quoteLines4.Apttus_Proposal__Product__c = productList[1].Id;
        quoteLines4.Apttus_QPConfig__PriceListItemId__c = priceListItem[1].Id;
        quoteLines4.Apttus_QPConfig__Quantity2__c = 30;
        quoteLines4.Apttus_QPConfig__Uom__c = 'PCE';
        quoteLines4.Apttus_QPConfig__NetUnitPrice__c = 2222.00;
        quoteLinesList.add(quoteLines4);
        insert quoteLinesList;  
    
        Customer_Document__c cd = QTO_TestDataFactory.createCustomerDocument();
        cd.Status__c = 'Draft';
        cd.Customer_Document_ID__c = '12435678';
        cd.Classification__c = 'Purchase Order';
        cd.Sub_Classification__c = 'Standard';
        cd.Nokia_Legal_Entity_Account__c = accList[0].Id;
        cd.Customer__c = accList[0].Id;
        insert cd;
        
        cd.Customer__c = accList[0].Id;
        cd.QTO_Classification__c = 'Purchase Order';
        cd.QTO_Sub_Classification__c = 'Standard';
        cd.Classification__c = 'Purchase Order';
        cd.Sub_Classification__c = 'Standard';
        cd.Status__c =  QTO_Constants.STATUS_ENRICHED;
        update cd;
        
        
        //Customer Document Line Item
        List<Customer_Document_Line_Items__c> customerDocLines = new List<Customer_Document_Line_Items__c>();
        Customer_Document_Line_Items__c cdli0 = new Customer_Document_Line_Items__c();
        cdli0.High_level_Product__c = 'My SFR Cutlery';
        cdli0.High_level_Product_Description__c = 'My SFR Bundle Description';
        cdli0.Detailed_Product__c = 'Bundle 1S 4 ABIA';
        cdli0.Detailed_Product_Description__c = 'Test Detailed Product Description';
        cdli0.Contract_Item_Number__c = 'My SFR Cutlery';
        cdli0.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
        cdli0.QTO_Product_Name__c = productList[0].Id;
        cdli0.Price_List_Item__c = priceListItem[0].Id;
        cdli0.QTO_PDF_Quantity__c = '10';
        cdli0.Quantity__c = '10';
        cdli0.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli0.QTO_Unit_Of_Measure__c = 'PCE';
        cdli0.QTO_PDF_Unit_Price__c = '2222,00';
        cdli0.Total_Value__c = 50;
        cdli0.QTO_PDF_Currency_Code__c = 'EUR';
        cdli0.CurrencyIsoCode = 'EUR';
        cdli0.QTO_Unit_Price__c = 2222.00;
        cdli0.Customer_Document__c = cd.Id;
        cdli0.QTO_Unit_of_Measure__c = 'PCE';
        cdli0.QTO_PDF_Total_Value__c = '624.70';                    
        cdli0.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';             
        cdli0.Status__c='Enriched(Lines)';              
        customerDocLines.add(cdli0);
        
        
        Customer_Document_Line_Items__c cdli1 = new Customer_Document_Line_Items__c();
        cdli1.High_level_Product__c = 'My SFR Cutlery1';
        cdli1.High_level_Product_Description__c = 'My SFR Bundle Description1';
        cdli1.Detailed_Product__c = 'Bundle 1S 4 ABIA1';
        cdli1.Detailed_Product_Description__c = 'Test Detailed Product Description1';
        cdli1.Contract_Item_Number__c = 'My SFR Cutlery1';
        cdli1.QTO_Product_Code__c = 'Bundle 1S 4 ABIA1';
        cdli1.QTO_Product_Name__c = productList[1].Id;
        cdli1.Price_List_Item__c = priceListItem[1].Id;
        cdli1.QTO_PDF_Quantity__c = '0';
        cdli1.Quantity__c = '0';
        cdli1.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli1.QTO_Unit_Of_Measure__c = 'PCE';
        cdli1.QTO_PDF_Unit_Price__c = '2222,00';
        cdli1.Total_Value__c = 50;
        cdli1.QTO_PDF_Currency_Code__c = 'EUR';
        cdli1.CurrencyIsoCode = 'EUR';
        cdli1.QTO_Unit_Price__c = 2222.00;
        cdli1.Customer_Document__c = cd.Id;
        cdli1.QTO_Unit_of_Measure__c = 'PCE';
        cdli1.QTO_PDF_Total_Value__c = '624.70';                    
        cdli1.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';             
        cdli1.Status__c='Enriched(Lines)';  
        cdli1.Association_Comment__c='Association Successful'; 
        customerDocLines.add(cdli1);
        
        Customer_Document_Line_Items__c cdli2 = new Customer_Document_Line_Items__c();
        cdli2.High_level_Product__c = 'My SFR Cutlery1';
        cdli2.High_level_Product_Description__c = 'My SFR Bundle Description1';
        cdli2.Detailed_Product__c = 'Bundle 1S 4 ABIA1';
        cdli2.Detailed_Product_Description__c = 'Test Detailed Product Description1';
        cdli2.Contract_Item_Number__c = 'My SFR Cutlery1';
        cdli2.QTO_Product_Code__c = 'Bundle 1S 4 ABIA1';
        cdli2.QTO_Product_Name__c = productList[1].Id;
        cdli2.Price_List_Item__c = priceListItem[1].Id;
        cdli2.QTO_PDF_Quantity__c = '30';
        cdli2.Quantity__c = '30';
        cdli2.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli2.QTO_Unit_Of_Measure__c = 'Each';
        cdli2.QTO_PDF_Unit_Price__c = '2222,00';
        cdli2.Total_Value__c = 50;
        cdli2.QTO_PDF_Currency_Code__c = 'EUR';
        cdli2.CurrencyIsoCode = 'EUR';
        cdli2.QTO_Unit_Price__c = 2222.00;
        cdli2.Customer_Document__c = cd.Id;
        cdli2.QTO_Product_Name__c = product2.Id;
        cdli2.QTO_Unit_of_Measure__c = 'PCE';
        cdli2.QTO_PDF_Total_Value__c = '624.70';                    
        cdli2.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021';    
        cdli2.Status__c='Enriched(Lines)';
        customerDocLines.add(cdli2);
        
        Customer_Document_Line_Items__c cdli3 = new Customer_Document_Line_Items__c();
        cdli3.High_level_Product__c = 'My SFR Cutlery';
        cdli3.High_level_Product_Description__c = 'My SFR Bundle Description';
        cdli3.Detailed_Product__c = 'Bundle 1S 4 ABIA';
        cdli3.Detailed_Product_Description__c = 'Test Detailed Product Description';
        cdli3.Contract_Item_Number__c = 'My SFR Cutlery';
        cdli3.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
        cdli3.QTO_Product_Name__c = productList[0].Id;
        cdli3.Price_List_Item__c = priceListItem[0].Id;
        cdli3.QTO_PDF_Quantity__c = '40';
        cdli3.Quantity__c = '40';
        cdli3.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli3.QTO_Unit_Of_Measure__c = 'Each';
        cdli3.QTO_PDF_Unit_Price__c = '2222,00';
        cdli3.Total_Value__c = 50;
        cdli3.QTO_PDF_Currency_Code__c = 'EUR';
        cdli3.CurrencyIsoCode = 'EUR';
        cdli3.QTO_Unit_Price__c = 2222.00;
        cdli3.Customer_Document__c = cd.Id;
        cdli3.QTO_Product_Name__c = product2.Id;
        cdli3.QTO_Unit_of_Measure__c = 'PCE';
        cdli3.QTO_PDF_Total_Value__c = '624.70';                    
        cdli3.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
        cdli3.Status__c='Enriched(Lines)';
        customerDocLines.add(cdli3);
        
        Customer_Document_Line_Items__c cdli4 = new Customer_Document_Line_Items__c();
        cdli4.High_level_Product__c = 'My SFR Cutlery';
        cdli4.High_level_Product_Description__c = 'My SFR Bundle Description';
        cdli4.Detailed_Product__c = 'Bundle 1S 4 ABIA';
        cdli4.Detailed_Product_Description__c = 'Test Detailed Product Description';
        cdli4.Contract_Item_Number__c = 'My SFR Cutlery';
        cdli4.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
        cdli4.QTO_Product_Name__c = productList[0].Id;
        cdli4.Price_List_Item__c = priceListItem[0].Id;
        cdli4.QTO_PDF_Quantity__c = '5';
        cdli4.Quantity__c = '5';
        cdli4.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli4.QTO_Unit_Of_Measure__c = 'Each';
        cdli4.QTO_PDF_Unit_Price__c = '2222,00';
        cdli4.Total_Value__c = 50;
        cdli4.QTO_PDF_Currency_Code__c = 'EUR';
        cdli4.CurrencyIsoCode = 'EUR';
        cdli4.QTO_Unit_Price__c = 2222.00;
        cdli4.Customer_Document__c = cd.Id;
        cdli4.QTO_Product_Name__c = product2.Id;
        cdli4.QTO_Unit_of_Measure__c = 'PCE';
        cdli4.QTO_PDF_Total_Value__c = '624.70';                    
        cdli4.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
        cdli4.Status__c='Enriched(Lines)';
        customerDocLines.add(cdli4);
        
        Customer_Document_Line_Items__c cdli5 = new Customer_Document_Line_Items__c();
        cdli5.High_level_Product__c = 'My SFR Cutlery1';
        cdli5.High_level_Product_Description__c = 'My SFR Bundle Description';
        cdli5.Detailed_Product__c = 'Bundle 1S 4 ABIA';
        cdli5.Detailed_Product_Description__c = 'Test Detailed Product Description';
        cdli5.Contract_Item_Number__c = 'My SFR Cutlery';
        cdli5.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
        cdli5.QTO_Product_Name__c = productList[0].Id;
        cdli5.Price_List_Item__c = priceListItem[0].Id;
        cdli5.QTO_PDF_Quantity__c = '5';
        cdli5.Quantity__c = '5';
        cdli5.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli5.QTO_Unit_Of_Measure__c = 'Each';
        cdli5.QTO_PDF_Unit_Price__c = '2222,00';
        cdli5.Total_Value__c = 50;
        cdli5.QTO_PDF_Currency_Code__c = 'EUR';
        cdli5.CurrencyIsoCode = 'EUR';
        cdli5.QTO_Unit_Price__c = 2222.00;
        cdli5.Customer_Document__c = cd.Id;
        cdli5.QTO_Product_Name__c = product2.Id;
        cdli5.QTO_Unit_of_Measure__c = 'PCE';
        cdli5.QTO_PDF_Total_Value__c = '624.70';                    
        cdli5.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
        cdli5.Status__c='Exception-Enrichment(Lines)';
        customerDocLines.add(cdli5);
        
        
        Customer_Document_Line_Items__c cdli6 = new Customer_Document_Line_Items__c();
        cdli6.High_level_Product__c = 'My SFR Cutlery1';
        cdli6.High_level_Product_Description__c = 'My SFR Bundle Description';
        cdli6.Detailed_Product__c = 'Bundle 1S 4 ABIA';
        cdli6.Detailed_Product_Description__c = 'Test Detailed Product Description';
        cdli6.Contract_Item_Number__c = 'My SFR Cutlery';
        cdli6.QTO_Product_Code__c = 'Bundle 1S 4 ABIA';
        cdli6.QTO_Product_Name__c = productList[0].Id;
        cdli6.Price_List_Item__c = priceListItem[0].Id;
        cdli6.QTO_PDF_Quantity__c = '5';
        cdli6.Quantity__c = '5';
        cdli6.QTO_PDF_Unit_Of_Measure__c = 'PCE';
        cdli6.QTO_Unit_Of_Measure__c = 'Each';
        cdli6.QTO_PDF_Unit_Price__c = '2222,00';
        cdli6.Total_Value__c = 50;
        cdli6.QTO_PDF_Currency_Code__c = 'EUR';
        cdli6.CurrencyIsoCode = 'EUR';
        cdli6.QTO_Unit_Price__c = 2222.00;
        cdli6.Customer_Document__c = cd.Id;
        cdli6.QTO_Product_Name__c = product2.Id;
        cdli6.QTO_Unit_of_Measure__c = 'PCE';
        cdli6.QTO_PDF_Total_Value__c = '624.70';                    
        cdli6.QTO_PDF_Requested_Delivery_Date__c = '08.08.2021'; 
        cdli6.Status__c='Exception-Matching(Lines)';
        customerDocLines.add(cdli6);
        
        
        insert customerDocLines;
        
        //CUstomer Facing Attributes
        List<Customer_facing_Attribute__c> cfaList = new List<Customer_facing_Attribute__c>();
        Customer_facing_Attribute__c cfa1 = new Customer_facing_Attribute__c();
        cfa1.Attribute_Label__c = 'PDF QUOTE REF';
        cfa1.Attribute_Value__c = quotes[0].Name;
        cfa1.QTO_Customer_Document__c = cd.Id;
        cfa1.QTO_Customer_Document_Line_Items__c = null;
        cfaList.add(cfa1);
        
        Customer_facing_Attribute__c cfa2 = new Customer_facing_Attribute__c();
        cfa2.Attribute_Label__c = 'PDF CONTRACT REF';
        cfa2.Attribute_Value__c = agr.Name;
        cfa2.QTO_Customer_Document__c = cd.Id;
        cfa2.QTO_Customer_Document_Line_Items__c = null;
        cfaList.add(cfa2);
        
        Customer_facing_Attribute__c cfa3 = new Customer_facing_Attribute__c();
        cfa3.Attribute_Label__c = 'PDF SITE CODE';
        cfa3.Attribute_Value__c = 'S-00123360';
        cfa3.QTO_Customer_Document__c = cd.Id;
        cfa3.QTO_Customer_Document_Line_Items__c = null;
        cfaList.add(cfa3);
        
        Customer_facing_Attribute__c cfa4 = new Customer_facing_Attribute__c();
        cfa4.Attribute_Label__c = 'SITE CODE';
        cfa4.Attribute_Name__c = 'SITE CODE';
        cfa4.Attribute_Value__c = 'S-00123360';
        cfa4.Quote__c = quotes[0].id;
        cfa4.Quote_Line_Item__c = quoteLinesList[0].id;
        cfaList.add(cfa4);
        
        
        Customer_facing_Attribute__c cfa5 = new Customer_facing_Attribute__c();
        cfa5.Attribute_Label__c = 'ANTICIPATION REF';
        cfa5.Attribute_Value__c = 'ANT-00123360';
        cfa5.QTO_Customer_Document__c = cd.Id;
        cfa5.QTO_Customer_Document_Line_Items__c = null;
        cfaList.add(cfa5);
        
        Customer_facing_Attribute__c cfa6 = new Customer_facing_Attribute__c();
        cfa6.Attribute_Label__c = 'ANTICIPATION REF';
        cfa6.Attribute_Name__c = 'ANTICIPATION REF';
        cfa6.Attribute_Value__c = 'ANT-00123360';
        cfa6.Quote__c = quotes[0].id;
        cfa6.Quote_Line_Item__c = quoteLinesList[0].id;
        cfaList.add(cfa6);
        
        
        Customer_facing_Attribute__c cfa7 = new Customer_facing_Attribute__c();
        cfa7.Attribute_Label__c = 'PDF SITE CODE';
        cfa7.Attribute_Name__c = 'PDF SITE CODE';
        cfa7.Attribute_Value__c = 'S-00123360';
        cfa7.Quote__c = quotes[0].id;
        cfa7.Quote_Line_Item__c = quoteLinesList[1].id;
        cfa7.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
        cfaList.add(cfa7);
        
        Customer_facing_Attribute__c cfa8 = new Customer_facing_Attribute__c();
        cfa8.Attribute_Label__c = 'ANTICIPATION REF';
        cfa8.Attribute_Name__c = 'ANTICIPATION REF';
        cfa8.Attribute_Value__c = 'S-00123360';
        cfa8.Quote__c = quotes[0].id;
        cfa8.Quote_Line_Item__c = quoteLinesList[1].id;
        cfa8.QTO_Customer_Document_Line_Items__c = customerDocLines[1].Id;
        cfaList.add(cfa8);
        
        insert cfaList;
        
        List<QTO_Customer_Document_Agreement_Line__c>  cdliAgreeAssocs = new List<QTO_Customer_Document_Agreement_Line__c> ();
        List<QTO_Customer_Document_Quote_Line__c> createAssociations = new List<QTO_Customer_Document_Quote_Line__c>();
        
        Map<Id, String> refMap = new Map<Id, String>();
        //Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems = new  Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
        Map<Id,Id> pdfQuoteRefQuoteIdAndAgreeIdMap = new Map<Id,Id>();
        Map<Id,Apttus__AgreementLineItem__c>  updateAgreementLineItems = new Map<Id,Apttus__AgreementLineItem__c>();
        
        QTO_CdLineItemAssociationHelper.isQuoteAgreementAssociationByContRef(customerDocLines[0], pdfQuoteRefQuoteIdAndAgreeIdMap, agreementAndLinesMap, cdliAgreeAssocs, updateAgreementLineItems) ;
        QTO_CdLineItemAssociationHelper.isAgreementAssociationByContractRef(customerDocLines[0], agreementAndLinesMap,  cdliAgreeAssocs,updateAgreementLineItems) ;
        
        
        
        
    }
    
    @isTest
    static void cdLineAssociationTest1(){
        test.startTest();
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocumentLines);
        QTO_CDLineItemMatchingHelper.matchCdLineItems(customerDocumentLines); 
        //QTO_CDLineItemMatchingHelper.updateCDocStatus(customerDocumentLines);  
        QTO_CDLineItemMatchingHelper.updateQuoteAndAgreementAcceptance(customerDocumentLines); 
        test.stopTest();    
    }
    
    @isTest
    static void cdLineAssociationTest2(){
        test.startTest();
        Customer_facing_Attribute__c cfa = [Select Id from Customer_facing_Attribute__c where Attribute_Label__c='PDF QUOTE REF'];
        delete cfa;
        
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c,Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocumentLines);
        test.stopTest();    
    }
    @isTest
    static void cdLineAssociationTest3(){
        test.startTest();
        List<Customer_facing_Attribute__c> cfa = [Select Id from Customer_facing_Attribute__c where Attribute_Label__c='PDF SITE CODE'];
        delete cfa;
        
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c,Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocumentLines);
        test.stopTest();    
    }
    
    @isTest
    static void cdLineAssociationTest4(){
        test.startTest();
        List<Customer_facing_Attribute__c> cfa = [Select Id from Customer_facing_Attribute__c where Attribute_Label__c IN ('PDF SITE CODE', 'PDF QUOTE REF','ANTICIPATION REF')];
        delete cfa;
        
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c,Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocumentLines);
        test.stopTest();    
    }
    
    
    @isTest
    static void cdLineAssociationTest5(){
        test.startTest();
        List<Customer_Document_Line_Items__c>  customerDocLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, Customer_Document__r.Sub_Classification__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c,Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        List<Apttus_Proposal__Proposal_Line_Item__c> quoteLinesList = [Select Id,Name,NokiaCPQ_Product_Name__c,Apttus_QPConfig__PriceListItemId__c,
                    Apttus_Proposal__Proposal__c,Apttus_Proposal__Proposal__r.Name, Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c,
                    Apttus_Proposal__Proposal__r.Id, Apttus_Proposal__Product__c,DS_Grouping_Name__c,Product_Code__c,
                    Apttus_Proposal__Product__r.ProductCode,External_Reference__c, Apttus_Proposal__Quantity__c,
                    Apttus_QPConfig__Uom__c, Apttus_QPConfig__NetUnitPrice__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode,
                    Apttus_QPConfig__Quantity2__c, QTO_QLI_Matched_Risk_Quantity__c  
                    from Apttus_Proposal__Proposal_Line_Item__c];
        
        System.debug('customerDocumentLines 5 >>>>>'+customerDocLines.size());
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocLines);
        
        List<QTO_Customer_Document_Quote_Line__c> quoteAssociationList = new List<QTO_Customer_Document_Quote_Line__c>();
        QTO_Customer_Document_Quote_Line__c quoteAssociation1 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation1.QTO_Customer_Document_Line_Items__c =  customerDocLines[0].Id;
        quoteAssociation1.QTO_Proposal_Line_Item__c = quoteLinesList[0].id;
        quoteAssociationList.add(quoteAssociation1);
        
        QTO_Customer_Document_Quote_Line__c quoteAssociation2 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation2.QTO_Customer_Document_Line_Items__c =  customerDocLines[1].Id;
        quoteAssociation2.QTO_Proposal_Line_Item__c = quoteLinesList[1].id;
        quoteAssociationList.add(quoteAssociation2);
        
        QTO_Customer_Document_Quote_Line__c quoteAssociation3 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation3.QTO_Customer_Document_Line_Items__c =  customerDocLines[2].Id;
        quoteAssociation3.QTO_Proposal_Line_Item__c = quoteLinesList[2].id;
        quoteAssociationList.add(quoteAssociation3);
        
        QTO_Customer_Document_Quote_Line__c quoteAssociation4 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation4.QTO_Customer_Document_Line_Items__c =  customerDocLines[3].Id;
        quoteAssociation4.QTO_Proposal_Line_Item__c = quoteLinesList[3].id;
        quoteAssociationList.add(quoteAssociation4);    
        
        QTO_Customer_Document_Quote_Line__c quoteAssociation5 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation5.QTO_Proposal_Line_Item__c = quoteLinesList[0].id;
        quoteAssociation5.QTO_Customer_Document_Line_Items__c =  customerDocLines[4].Id;
        quoteAssociationList.add(quoteAssociation5);
        
        QTO_Customer_Document_Quote_Line__c quoteAssociation6 = new QTO_Customer_Document_Quote_Line__c();
        quoteAssociation6.QTO_Customer_Document_Line_Items__c =  customerDocLines[0].Id;
        quoteAssociation6.QTO_Proposal_Line_Item__c = quoteLinesList[2].id;
        quoteAssociationList.add(quoteAssociation6);
        
        
        insert quoteAssociationList;
        Map<Id,Apttus_Proposal__Proposal_Line_Item__c>  updateQuoteLineItems = new  Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
        List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation1, customerDocLines[0], quoteLinesList[0] ,updateQuoteLineItems, issueLogList);
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation2, customerDocLines[1], quoteLinesList[1] ,updateQuoteLineItems, issueLogList);
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation3, customerDocLines[2], quoteLinesList[2] ,updateQuoteLineItems, issueLogList) ; 
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation4, customerDocLines[3], quoteLinesList[3] ,updateQuoteLineItems, issueLogList) ;
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation5, customerDocLines[4], quoteLinesList[0] ,updateQuoteLineItems, issueLogList) ;
        QTO_CdLineItemAssociationHelper.updateMatchedQuoteQuantity(quoteAssociation6, customerDocLines[0], quoteLinesList[2] ,updateQuoteLineItems, issueLogList) ;
        
        
        test.stopTest();    
    }
    
    @isTest
    static void cdLineAssociationTest6(){
        test.startTest();
        
        List<Customer_facing_Attribute__c> cfa = [Select Id from Customer_facing_Attribute__c where Attribute_Label__c IN ('PDF SITE CODE', 'PDF QUOTE REF','ANTICIPATION REF')];
        delete cfa;
        
        List<Customer_Document_Line_Items__c>  customerDocLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c,QTO_CDLI_Matched_Quoted_Quantity__c,  QTO_CDLI_Matched_Contracted_Quantity__c,Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        List<Apttus__AgreementLineItem__c> agList = [Select Id,Apttus__AgreementId__c,Name,Apttus__Description__c,Contract_Item_Number__c,
                 Apttus__ProductId__c,Apttus__ProductId__r.ProductCode,Product_Code__c, Apttus__Quantity__c, 
                 QTO_ALI_Matched_Contracted_Quantity__c ,Apttus_CMConfig__Uom__c,Apttus__NetPrice__c,  Apttus_CMConfig__NetUnitPrice__c, Apttus__AgreementId__r.CurrencyIsoCode 
                 From Apttus__AgreementLineItem__c];
        System.debug('customerDocumentLines 6 >>>>>'+customerDocLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocLines);
        
        Map<Id,Apttus__AgreementLineItem__c>  updateAgreementLineItems = new Map<Id,Apttus__AgreementLineItem__c>();
        
        List<QTO_Customer_Document_Agreement_Line__c> aggAssociationList = new List<QTO_Customer_Document_Agreement_Line__c>();
        QTO_Customer_Document_Agreement_Line__c qtoagline1 = new QTO_Customer_Document_Agreement_Line__c();
        qtoagline1.QTO_Agreement_Line_Item__c = agList[0].Id;
        qtoagline1.QTO_Customer_Document_Line_Items__c =  customerDocLines[0].Id;
        aggAssociationList.add(qtoagline1);
        
        QTO_Customer_Document_Agreement_Line__c qtoagline2 = new QTO_Customer_Document_Agreement_Line__c();
        qtoagline2.QTO_Agreement_Line_Item__c = agList[1].Id;
        qtoagline2.QTO_Customer_Document_Line_Items__c =  customerDocLines[1].Id;
        aggAssociationList.add(qtoagline2);
        
        QTO_Customer_Document_Agreement_Line__c qtoagline3 = new QTO_Customer_Document_Agreement_Line__c();
        qtoagline3.QTO_Agreement_Line_Item__c = agList[2].Id;
        qtoagline3.QTO_Customer_Document_Line_Items__c =  customerDocLines[2].Id;
        aggAssociationList.add(qtoagline3);     
        
        QTO_Customer_Document_Agreement_Line__c qtoagline4 = new QTO_Customer_Document_Agreement_Line__c();
        qtoagline4.QTO_Agreement_Line_Item__c = agList[3].Id;
        qtoagline4.QTO_Customer_Document_Line_Items__c =  customerDocLines[3].Id;
        aggAssociationList.add(qtoagline4);
        
        QTO_Customer_Document_Agreement_Line__c qtoagline5 = new QTO_Customer_Document_Agreement_Line__c();
        qtoagline5.QTO_Customer_Document_Line_Items__c =  customerDocLines[4].Id;
        qtoagline5.QTO_Agreement_Line_Item__c = agList[0].Id;
        aggAssociationList.add(qtoagline5);     
        
        insert aggAssociationList; 
        
        List<QTO_Customer_Document_Issue_Log__c> issueLogList = new List<QTO_Customer_Document_Issue_Log__c>();
        QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(qtoagline1, customerDocLines[0], agList[0] ,updateAgreementLineItems, issueLogList);
        QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(qtoagline2, customerDocLines[1], agList[1] ,updateAgreementLineItems, issueLogList);
        QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(qtoagline3, customerDocLines[2], agList[0] ,updateAgreementLineItems, issueLogList); 
        QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(qtoagline4, customerDocLines[3], agList[1] ,updateAgreementLineItems, issueLogList);
        QTO_CdLineItemAssociationHelper.updateMatchedAgreementQuantity(qtoagline5, customerDocLines[4], agList[0] ,updateAgreementLineItems, issueLogList);
        
    
        
        
        test.stopTest();    
    }
    
    
    @isTest
    static void cdLineAssociationTest7(){
        test.startTest();
        List<Customer_facing_Attribute__c> cfa = [Select Id from Customer_facing_Attribute__c where Attribute_Label__c IN ('PDF SITE CODE', 'PDF QUOTE REF','ANTICIPATION REF')];
        delete cfa;
        Apttus_Proposal__Proposal__c prop = [Select Id from Apttus_Proposal__Proposal__c limit 1];
        delete prop; 
        
        
        
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CdLineItemAssociationHelper.associateCdLineItems(customerDocumentLines);
        test.stopTest();    
    }
    
    @isTest
    static void cdLineAssociationTest8(){
        test.startTest();
        List<Customer_Document_Line_Items__c>  customerDocumentLines = 
            [
    Select Id,High_level_Product__c,High_level_Product_Description__c,QTO_PDF_Unit_Of_Measure__c,QTO_PDF_Quantity__c,QTO_PDF_Unit_Price__c,
    QTO_PDF_Currency_Code__c,Detailed_Product__c,Detailed_Product_Description__c, Quantity__c, QTO_Unit_of_Measure__c, QTO_Unit_Price__c, CurrencyIsoCode,
    QTO_Customer_Grouping__c,QTO_Product_Code__c,QTO_Product_Name__c,Contract_Item_Number__c,QTO_PDF_Total_Value__c,QTO_PDF_Requested_Delivery_Date__c,
    Price_List_Item__c,Customer_Document__c,Customer_Document__r.Customer__c, QTO_CDLI_Matched_Quoted_Quantity__c, QTO_CDLI_Matched_Contracted_Quantity__c, Customer_Document__r.QTO_Currency__c
    from Customer_Document_Line_Items__c
            ]; 
        
        System.debug('customerDocumentLines>>>>>'+customerDocumentLines.size());
        
        QTO_CDLineItemMatchingHelper.updateCDocStatus(customerDocumentLines);  

        test.stopTest();    
    }
    
    
}
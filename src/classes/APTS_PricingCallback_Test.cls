@IsTest ( seealldata = false )
Public class APTS_PricingCallback_Test
{
        //ds
    @testSetup
     private static void setupTestData () {
        
            Apttus_Config2__ConfigCustomClasses__c customSettingClasses=new Apttus_Config2__ConfigCustomClasses__c(Name='Config Custom Classes',Apttus_Config2__PricingCallbackClass__c='APTS_PricingCallBack');
            insert customSettingClasses;
            
            Apttus_Config2__ConfigLineItemCustomFields__c cfield = new Apttus_Config2__ConfigLineItemCustomFields__c(Name='System Properties',Apttus_Config2__CustomFieldNames__c='APTS_CallbackApply__c');
            insert cfield ;
             
            Account account = APTS_Testing_Utility.instantiateAccount ();

            insert account;
         
            Apttus_Config2__PriceList__c pricelist = APTS_Testing_Utility.instantiatePriceList ();

            insert pricelist;

           Apttus_Proposal__Proposal__c proposal = APTS_Testing_Utility.instantiateProposal ( account.Id
                                                                          , pricelist.Id
                                                                );

            insert proposal;

            
            //Create Products
            List<Product2> prodList = new List<Product2>();
            Product2 prod1 = APTS_Testing_Utility.createProduct('Dialer Minutes','015', null, 'Option', TRUE, TRUE,'NTT');
            prodList.add(prod1);
            Product2 prod2 = APTS_Testing_Utility.createProduct('Dialer Minutes', '014', null, 'Option', TRUE, FALSE,'ATA');
            prodList.add(prod2);
            insert prodList;
            
            //Create Price List Items
            List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
            Apttus_Config2__PriceListItem__c pli1 = APTS_Testing_Utility.createPriceListItem(pricelist.Id, prodList[0].Id, 'Standard Price', 'One Time', 'Per Unit', 0.02, '', 'Each', 'One Time', 'Bill In Advance', 'Manual');
            pli1.Apttus_Config2__AutoRenew__c        = true;
            pli1.Apttus_Config2__AutoRenewalType__c  = 'Fixed';
            pli1.Apttus_Config2__AutoRenewalTerm__c  = 12;
            pliList.add(pli1);
            Apttus_Config2__PriceListItem__c pli2 = APTS_Testing_Utility.createPriceListItem(pricelist.Id, prodList[1].Id, 'Standard Price', 'One Time', 'Per Unit', 0.02, '', 'Each', 'One Time', 'Bill In Advance', 'Manual');
            pli2.Apttus_Config2__AutoRenew__c        = true;
            pli2.Apttus_Config2__AutoRenewalType__c  = 'Fixed';
            pli2.Apttus_Config2__AutoRenewalTerm__c  = 12;          
            pliList.add(pli2);
            insert pliList;
            
            Apttus_Config2__ProductGroup__c pg = new Apttus_Config2__ProductGroup__c();
            pg.Apttus_Config2__Description__c ='Testing';
            pg.Name='testing';
            insert pg;
            
           
            
            Apttus_Config2__ProductGroupMember__c pgm = new Apttus_Config2__ProductGroupMember__c();
            pgm.Apttus_Config2__ProductId__c=prod2.Id;
            pgm.Apttus_Config2__ProductGroupId__c=pg.Id;
            pgm.Apttus_Config2__Sequence__c=1;
            insert pgm;
            
            
            
            //create product configuration
            Apttus_Config2__ProductConfiguration__c objProdConfig = APTS_Testing_Utility.createTestProductConfig(proposal, account, pricelist);
            objProdConfig.Name = 'Tester Config TestPricig';
            insert objProdConfig;
            
            //create LineItem
            List<Apttus_Config2__LineItem__c> listLineItem = new List<Apttus_Config2__LineItem__c>();
            Apttus_Config2__LineItem__c oLineItem1 = APTS_Testing_Utility.createLineItem(objProdConfig, pliList[0].Id, null, prod1.Id, null, null, 1, 1, 1, 'Product/Service', null, 'Monthly', 'Bill In Advance', 'One Time', 'Per Unit', 'Each', 500.0);
            oLineItem1.Apttus_Config2__StartDate__c = System.today().addDays(-30);
            oLineItem1.Apttus_Config2__ConfigurationId__c = objProdConfig.Id;
            oLineItem1.Apttus_Config2__HasOptions__c=True;
            oLineItem1.Apttus_Config2__ChargeType__c='Prepayment';
            oLineItem1.Apttus_Config2__BasePrice__c=0.02;
            oLineItem1.Apttus_Config2__AdjustmentType__c='Base Price Override';
            oLineItem1.Apttus_Config2__AdjustmentAmount__c=0.002;
            oLineItem1.Apttus_Config2__AutoRenew__c=true;
            oLineItem1.Apttus_Config2__AutoRenewalType__c='Fixed';
            oLineItem1.Apttus_Config2__AutoRenewalTerm__c=12;
            oLineItem1.Apttus_Config2__LineStatus__c = 'Existing';
            oLineItem1.Apttus_Config2__LineNumber__c = 1;
            oLineItem1.Apttus_Config2__ChargeType__c = 'Standard Price';
            oLineItem1.Apttus_Config2__Quantity__c=2;
            listLineItem.add(oLineItem1);
            
            
            
            Apttus_Config2__LineItem__c oLineItem2 = APTS_Testing_Utility.createLineItem(objProdConfig, pliList[1].Id, null, prod2.Id,null, null, 2, 1, 2, 'Option', null, 'Monthly', 'Bill In Advance', 'One Time', 'Per Unit', 'Each', 200.0);
            oLineItem2.Apttus_Config2__EndDate__c = System.today().addDays(90);
            oLineItem2.Apttus_Config2__ConfigurationId__c = objProdConfig.Id;
            oLineItem2.Apttus_Config2__BasePrice__c=0.02;
            oLineItem2.Apttus_Config2__AdjustmentType__c='Base Price Override';
            oLineItem2.Apttus_Config2__AdjustmentAmount__c=0.002;
            oLineItem2.Apttus_Config2__AutoRenewalType__c='Fixed';
            oLineItem2.Apttus_Config2__AutoRenewalTerm__c=12;
            oLineItem2.Apttus_Config2__LineStatus__c = 'Existing';
            oLineItem2.Apttus_Config2__LineNumber__c = 1;
            oLineItem2.Apttus_Config2__ChargeType__c = 'Standard Price';
            oLineItem2.Apttus_Config2__Quantity__c=2;

            listLineItem.add(oLineItem2);
            
            insert listLineItem;
            System.debug('listLineItem='+listLineItem);
            List<Apttus_Config2__ProductAttributeValue__c> LstPAV = New List<Apttus_Config2__ProductAttributeValue__c>(); 
            
            Apttus_Config2__ProductAttributeValue__c PAV = New Apttus_Config2__ProductAttributeValue__c();
            PAV.Apttus_Config2__LineItemId__c=listLineItem[0].id;
            PAV.ATR_Price_Type__c='Paid';
            PAV.APTS_Additional_Aircraft_Types__c= 2;
            LstPAV.Add(PAV);
            
            Apttus_Config2__ProductAttributeValue__c PAV1 = New Apttus_Config2__ProductAttributeValue__c();
            PAV1.Apttus_Config2__LineItemId__c=listLineItem[1].id;
            PAV1.ATR_Price_Type__c='Paid';
            PAV1.APTS_Additional_Aircraft_Types__c= 2;
             LstPAV.Add(PAV1);
             Insert LstPAV;
             
             
        
           listLineItem[1].Apttus_Config2__NetPrice__c  = listLineItem[1].Apttus_Config2__NetPrice__c + (listLineItem[1].Apttus_Config2__SellingTerm__c * 50000) + (listLineItem[1].Apttus_Config2__SellingTerm__c * 50000 * PAV.APTS_Additional_Aircraft_Types__c);
           Update listLineItem[1];
    }   //  setupTestData ()
    
    Static testmethod void Test()
    {
       
       //APTS_PricingCallback PCB =  New APTS_PricingCallback();
       
       // create the update price request
            Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
            // add request parameters
            
            Apttus_Config2__ProductConfiguration__c  C = [Select id from Apttus_Config2__ProductConfiguration__c ];
            objUpdatePriceRequestDO.CartId = c.id;
            // update price for the cart
            Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
       
       
    }
}
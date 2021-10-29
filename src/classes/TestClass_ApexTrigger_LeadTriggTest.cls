/** * File Name:  TestClass_ApexTrigger_LeadTriggTest
* Description Test Method
* Class Tested: updateOtherObjectsAfterConversion , leadAircraftUpdate ,sendEmailToLead
* Copyright : Wipro Technologies Limited Copyright (c) 2011
* * @author : Wipro
* Modification Log =============================================================== 
Ver Date Author Modification --- ---- ------ -------------
* */
@isTest
private class TestClass_ApexTrigger_LeadTriggTest {

    static testMethod void leadTriggTestTest() {
            
            
            
                //Account tstAcc = New Account(Name= 'Task trigger Test Account');
                //insert tstAcc;
                
               /* Contact tstContact = new Contact(
                Account=tstAcc,
                Primary_Email_Address__c='Test@test.com',
                Primary_Contact__c=true,
                Phone='885626773',
                Phone_1__c= '885626773',
                firstname='Test',
                LastName='Contact Inactive'    
                
               ); 
              insert tstContact;
              */ 
                                 
                Aircraft_Base__c tstAircrftBase= new Aircraft_Base__c(
                    Name='Aircraft Base', 
                    Country__c='US',
                    State__c='IL',
                    Region__c='South'
             
                ); 
                insert tstAircrftBase;
                
                /* Fleet_Asset_Detail__c tstFleetAssetDetail = new Fleet_Asset_Detail__c(
             
                    Tail_Number__c='asghgfs',
                    Serial_Number__c='123456789d',
                    Account__c=tstAcc.Id,
                    Aircraft_Base__c=tstAircrftBase.id,  
                    Cntry__c='US',   
                    State__c='IL', 
                    Region__c='South' 
            
                    );
                insert tstFleetAssetDetail;
                */ 
                RecordType tstRecTyp = [select id , name from RecordType where name='BGA Honeywell'];
                
                Opportunity tstOpp3 = new Opportunity(
                      Name='Test Opp3',
                   amount =100.00,
                    Type = 'OCM Programs' ,
                    closedate = System.today(),
                    ForecastCategoryName = 'Pipeline',
                    Probability=10.0,
                    stagename='Prospecting'
                    
        
                    );   
                insert tstOpp3;
                
                 Platform__c tstPlatform = new Platform__c(
                   Name = 'TestPlatform',               
                   Platform_Type__c = 'Airplane',
                   Model__c = 'G650',
                   Make__c = 'Gulf',
                   Managing_SBU__c = 'BGA'
                   
                );
                insert tstPlatform;
            
                Test.startTest();   
                Lead tstLead= new Lead(    
                    //Account__c=tstAcc.Id, 
                    Description='Test Lead',
                    Opportunity_Type__c='BGA Aftermarket',
                    Regional_Sales_Manager__c='Andy Gill', 
             //       Contact__c=tstContact.Id,
                  recordtypeid = tstRecTyp.id,
                    Company='Honeywell',  
                    Status='Open',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                   // Aircraft__c=tstFleetAssetDetail.Id,
                    CreatedDate=system.today()-1,
                    Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Follow_Up_action_requested__c='Send a brochure',
                    Aircraft_Type__c= tstPlatform.Id,
                    Aircraft_Tail_Number__c= 'N747NA'               
                   
                );
                insert tstLead;
                
                Product2 tstProduct3 = new Product2(name='Test Product3', RMU__c=true,
                        CanUseRevenueSchedule=true
                    );
                insert tstProduct3;
                
                Lead_Products__c tstLeadProd = new Lead_Products__c(
                     Product__c=tstProduct3.Id,
                     Lead__c=tstLead.Id
                
                );
                insert tstLeadProd; 
                
                Pricebook2 tstPriceBook3 =[select id from Pricebook2 where IsStandard = true limit 1];       
                PricebookEntry tstPriceBkEntry3 = new PricebookEntry(product2id = tstProduct3.Id, UnitPrice=10.00 , Pricebook2Id=tstPriceBook3.Id ,  IsActive=true, UseStandardPrice=false); 
                insert tstPriceBkEntry3;
                
                /*Pricebook2 tstPriceBook4 =[Select Id from Pricebook2 Where IsActive = true and name like 'BGA AM 2011' LIMIT 1];
                PricebookEntry tstPriceBkEntry4 = new PricebookEntry(product2id = tstProduct3.Id, UnitPrice=10.00 , Pricebook2Id=tstPriceBook4.Id ,  IsActive=true, UseStandardPrice=false); 
                insert tstPriceBkEntry4;*/
                Database.LeadConvert tstLeadConvert = new Database.LeadConvert();
                tstLeadConvert.setLeadId(tstLead.id);
                LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];             
                tstLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
                 
                //tstLead.IsConverted=true;
                //tstLead.ConvertedDate=system.Today();
                //tstLead.ConvertedAccountId = tstAcc.Id;
                
                //tstLead.ConvertedContactId=tstContact.Id;
                //tstLead.ConvertedOpportunityId=tstOpp3.id;
            
            
            //     tstContact.Primary_Email_Address__c='Test@test.com';
              //   update tstContact;
               // Database.LeadConvertResult lcr = Database.convertLead(tstLeadConvert);
                
                
              /*         Lead tstLead2= new Lead(    
                    Account__c=tstAcc.Id, 
                    Description='Test Lead',
                    Opportunity_Type__c='BGA Aftermarket',
                    Regional_Sales_Manager__c='Andy Gill', 
               //     Contact__c=tstContact.Id,
                    recordtypeid = tstRecTyp.id,
                    Company='Honeywell',  
                    Status='Open',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    Aircraft__c=tstFleetAssetDetail.Id,
                    CreatedDate=system.today()-1,
                    //Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    Follow_Up_action_requested__c='Send a brochure ',
                    Displays__c='MFRD',
                    
                    Thank_you_for_stopping_by_letter__c='Send Letter - Use General Signature',
                    thanksforstopbyemailSent__c=false,
                    BGA_ASM__c='Varun Nirala'
                );
                insert tstLead2;
                
                Lead tstLead3= new Lead(    
                    Account__c=tstAcc.Id, 
                    Description='Test Lead',
                    Opportunity_Type__c='BGA Aftermarket',
                    Regional_Sales_Manager__c='Andy Gill', 
           //         Contact__c=tstContact.Id,
                    Isconverted = False,
                    recordtypeid = tstRecTyp.id,
                    Company='Honeywell',  
                    Status='Open',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    Aircraft__c=tstFleetAssetDetail.Id,
                    CreatedDate=system.today()-1,
                    Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    LeadSource = 'EBACE 2011',
                    Follow_Up_action_requested__c='Send a brochure ',
                    Cabin__c='PCU',
                    Send_Aircraft_Specific_Brochures__c='Global Express',
                    Thank_you_for_stopping_by_letter__c='Send Letter - Use General Signature',
                    thanksforstopbyemailSent__c=false,
                    BGA_ASM__c='Varun Nirala'
                );
                insert tstLead3;
                
                Lead tstLead4= new Lead(    
                    Account__c=tstAcc.Id, 
                    Description='Test Lead',
                    Opportunity_Type__c='BGA Aftermarket',
                    Regional_Sales_Manager__c='Andy Gill', 
                    Company='Honeywell',  
                    Status='Open',
                    firstname='Test',
                    LastName='Contact Inactive' ,
                    Title='Mr.',
                    CreatedDate=system.today()-1,
                   // Opportunity_Name__c=tstOpp3.id, 
                    Primary_Fax_Number__c='112875739',
                    Email='Test@Test.com',
                    
                    IPAD_Lead_Source__c='iPad Lead - BA'
                );
                insert tstLead4;   */
                
            
                
    }
}
@isTest
public class BGAChannelPartnerInformationCtrl_Test
  {
  public static Account acc=new Account();
  public static Account_Address__c accAdd;
 
   //Test method where the set up data is created. 
   static testMethod void createTestData()
        {
            
           
            acc.Name='testName';
            acc.Customer_Name__c = 'testCustomerName';
            acc.POC__c='testPOC';
            acc.E_mail_address__c='test@Email.com';
            acc.POC_Management__c='testPOCManagement';
            acc.SC_locator_visibility__c=true;
            acc.GTA_number__c='testGTANumber';
            acc.SAP_account_sold_to__c='testSAPAccount';
            acc.Phone='123456789';
            acc.Website='www.google.com';
            acc.City_Name__c='California';
            acc.Region_Name__c='Americas';
            insert acc;
            
            accAdd = new Account_Address__c(Account_Name__c = acc.Id);
            accAdd.AccountOwner_Email__c='testOwner@email.com';
            insert accAdd;
           
        }    
           
    
     static testMethod void testObjectCreation()  
           {  
              
               Test.startTest();
               createTestData();
               PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
               Test.setCurrentPage(pageRef);
               String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
               BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
               System.assertNotEquals(null,BGAObject);
               System.assertEquals('California',acc.City_Name__c);
               System.assertEquals('testOwner@email.com', accAdd.AccountOwner_Email__c);
               Test.stopTest();
       }
       
           
         //Test method for save action          
          static testMethod void testSave() 
             {
              
            Test.startTest();
            createTestData();
            PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
            Test.setCurrentPage(pageRef);
            String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
            BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
            BGAObject.save();
            System.assertEquals('California',acc.City_Name__c);
            BGAObject.edita();
            acc.City_Name__c='test city';
            System.assertEquals('test city',acc.City_Name__c); 
            Test.stopTest();
           }
           
            
        //Test method for cancel action      
           static testMethod void testCancel() 
                
           {
               Test.startTest(); 
               createTestData();
               PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
               Test.setCurrentPage(pageRef);
               String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
               BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
               BGAObject.cancel();
               System.assertEquals(false,BGAObject.editMode);
               Test.stopTest();
            }
            
             
             
            //Test method for Upload   
             static testMethod void testUpload() 
                {
                    Test.startTest(); 
                    createTestData();
                    PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
                    Test.setCurrentPage(pageRef);
                    String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
                    BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
                    BGAObject.upload() ;
                    System.assertNotEquals(null,BGAObject);
                    Test.stopTest();
                }
                 
              //Test method for Open PDF     
                 static testMethod void testOpenPdf() 
                {
                    Test.startTest(); 
                    createTestData();
                    PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
                    Test.setCurrentPage(pageRef);
                    String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
                    BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
                    BGAObject.OpenPdf();
                    System.assertNotEquals(null,BGAObject);
                    Test.stopTest();     
                }
                
               
              //Test method for Back method 
               static testMethod void testBack() 
                {
                    Test.startTest(); 
                    createTestData();
                    PageReference pageRef = Page.BGAChannelPartnerInformationCtrlPage;
                    Test.setCurrentPage(pageRef);
                    String accId = ApexPages.currentPage().getParameters().put('Id',acc.Id);
                    BGAChannelPartnerInformationCtrl BGAObject=new BGAChannelPartnerInformationCtrl(new ApexPages.standardController(acc));
                    BGAObject.back();
                    System.assertEquals(true,BGAObject.editMode);
                    Test.stopTest();     
                }
                
            
   }
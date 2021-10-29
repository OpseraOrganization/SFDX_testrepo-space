/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
 @isTest
private class OVOC_myVOC_ControllerTest
{
    static testMethod void myUnitTest() {
    Test.startTest();
    string test1;
    PageReference pageRef = page.OVOC_MyVOC;
    Test.setCurrentPage(pageRef);
    OVOC_myVOC_Controller ovocsc = new OVOC_myVOC_Controller();
    ovocsc.setParams();
    ovocsc.Generatemailreport();
    ovocsc.Generatepage();
    ovocsc.getCurrentStatus();
    ovocsc.setCurrentStatus('string');
    ovocsc.getSensitiveLevel();
    ovocsc.setSensitiveLevel('string');
    ovocsc.getOrderBy();
    ovocsc.setOrderBy('str');
    ovocsc.getthisformat();
    ovocsc.getGenerateFormat();
    ovocsc.setGenerateFormat('set');
    ovocsc.recordNumber='12345677';
    ovocsc.CustomerNameTitle='Venu';
    ovocsc.HonLead='test User';
    ovocsc.FromDate='06/28/2014';
    ovocsc.FromDate_Mob='06/28/2014';
    ovocsc.ToDate='06/28/2014';
    ovocsc.ToDate_Mob='06/28/2014';
    //ovocsc.CurrentStatus='Test';
    //ovocsc.VOCPurpose='Test';
    //ovocsc.SensitiveLevel='Test';
    //ovocsc.OrderByValue='Record Number';
    ovocsc.AccountName='Venu';
    //ovocsc.GenerateFormat='PDF';
    
    List<OVOC_myVOC_Controller.ProductWrapper> ProductWrapperList = new List<OVOC_myVOC_Controller.ProductWrapper>();
    List<OVOC_myVOC_Controller.ProductWrapper> PurposeWrapperList= new List<OVOC_myVOC_Controller.ProductWrapper>();
    Schema.DescribeFieldResult fieldResult = Voice_of_Customer__c.Product_Family__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
    for( Schema.PicklistEntry f : ple) {
      //options.add(new SelectOption(f.getLabel(), f.getValue()));
       OVOC_myVOC_Controller.ProductWrapper objWrapper= new OVOC_myVOC_Controller.ProductWrapper();
       objWrapper.checked=true;
       objWrapper.pickListEntry = f.getValue();
       ProductWrapperList.add(objWrapper);
       PurposeWrapperList.add(objWrapper);
    } 
    ovocsc.ProductWrapperList=ProductWrapperList;  
    ovocsc.PurposeWrapperList=PurposeWrapperList;
    ovocsc.setParams();
    ovocsc.ToDate='';
    ovocsc.ToDate_Mob='';
    ovocsc.setParams();
    ovocsc.Generatemailreport();
    ovocsc.ToDate='06/28/2014';
    ovocsc.ToDate_Mob='06/28/2014';
    try{ovocsc.Generatemailreport();}catch(Exception e){}
    ovocsc.assignReportFormat();
    //
    try{
    OVOC_myVOC_Controller.getMyVOCRecords('Draft');
    // to insert Voice_of_Customer__c
    Voice_of_Customer__c obj = new Voice_of_Customer__c();
    //obj.RecordTypeId='01Ia0000001u98V';
    obj.Status__c='Draft';
    insert obj;
    VOC_OVOC_Record_Number__c obj1= new VOC_OVOC_Record_Number__c();
    obj1.Name='Reference record';
    insert obj1;
    OVOC_myVOC_Controller.getMyVOCDetails(string.valueOf(obj.Id));
    }
    catch(Exception e){}
    OVOC_myVOC_Controller.getProductLine();
    OVOC_myVOC_Controller.getStatus();
    OVOC_myVOC_Controller.getPurpose();
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','Any','Any','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','RecordNumber');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','Completed','Sensitive Information','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','Status');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','Date');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','HoneywellLead');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','Acc');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','Sensitive');
    //OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','ProductFamily');
    OVOC_myVOC_Controller.sendPdf('xyzscdfyyyhh','venu.gundlapalli@gmail.com');
    OVOC_myVOC_Controller.QueryRecords('RecordNumber','CurrentStatus','SensitiveLevel',string.valueOf(system.today()),string.valueOf(system.today()),'CustomerNameTitle','AccountName','HonLead', 'ProductFamily','VOCPurpose','OrderByValue');
    //OVOC_myVOC_Controller.vocMainList;
    test.stopTest();
     
 }
 
    static testMethod void myUnitTest2() {
        Test.startTest();
        
        VOC_OVOC_Record_Number__c obj1= new VOC_OVOC_Record_Number__c();
        obj1.Name='Reference record';
        obj1.VOC__c = '111';
        obj1.OVOC__c = '222';
        insert obj1;
        
        //Create VOC Account
        VOC_Accounts__c vocAcc = new VOC_Accounts__c();
        vocAcc.Name = 'Test Account';
        insert vocAcc;
        
        //Create VOC Records
        Voice_of_Customer__c voc = new Voice_of_Customer__c();
        voc.VOC_Title__c = 'Test VOC';
        voc.VOC_Date__c = date.newInstance(2014,4,6);
        voc.Honeywell_Lead__c = 'xyz';
        voc.Key_Action_Items__c = 'key action items';
        voc.VOC_Collection__c = 'Test';
        voc.Sensitive__c = false;
        voc.Purpose_of_this_VOC__c = 'Understanding the Market';
        voc.Product_Name__c = 'Test prod';
        voc.Product_Family__c = 'Lighting';
        voc.Key_Takeaways1__c = 'keytakeaways';
        voc.Financial_Implications__c = 'test';
        voc.status__c ='Submitted'; 
        insert voc;
        system.debug('---> voc' +  voc);
        VOC_Customer_Name__c vocCustomer = new VOC_Customer_Name__c();

        vocCustomer.Customer_Name__c = 'Test customer';
        vocCustomer.Customer_s_Title_Role__c = 'Tester';
        vocCustomer.Primary_Customer_s_Email__c = 'Tester@test.com';
        vocCustomer.VOC_Record__c = voc.id;
        vocCustomer.VOC_Account__c = vocAcc.Id;
        insert vocCustomer;
        
        
        PageReference pageRef = page.OVOC_MyVOC;
        Test.setCurrentPage(pageRef);
        
        OVOC_MyVOC_Controller myVOCCont = new OVOC_MyVOC_Controller();
        myVOCCont.HonLead = 'xyz';
        //myVOCCont.SensitiveLevel = 'Any';
        //myVOCCont.purposeFamilyList = 'Understanding the Market';
        myVOCCont.Generatemailreport();
        
        
        
        Test.stopTest();
    }  
    
    static testMethod void myUnitTest3() {
        Test.startTest();
        
        
        VOC_ExportToExcel_controller expOvoc = new VOC_ExportToExcel_controller();
        
        
        Test.stopTest();
    }  
}
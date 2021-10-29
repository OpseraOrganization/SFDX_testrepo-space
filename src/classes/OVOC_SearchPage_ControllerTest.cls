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
@isTest(SeeAllData=true)
private class OVOC_SearchPage_ControllerTest {
    static testMethod void myUnitTest() {
        string test1;
        PageReference pageRef = page.OVOC_Search;
        Test.setCurrentPage(pageRef);
        OVOC_SearchPage_Controller ovocsc = new OVOC_SearchPage_Controller();
        ovocsc.Search_Keyword = 'test';
        ovocsc.Search_StartDate = 'test'; 
        ovocsc.Search_EndDate = 'test';
        ovocsc.Search_Customer_Name = 'test';
        ovocsc.Search_OEM_Account = 'test';
        ovocsc.Search_Honeywell_Lead = 'test';
        ovocsc.Search_Product_Line = 'test';
        ovocsc.Save_Search_Name = 'test';
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        ovocsc.getsave_Search();
        OVOC_SearchPage_Controller.Search_VOC('Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','ProductFamily','VOCTitle','Purpose','RecordNumber','CurrentStatus','SensitiveLevel', 'Normal');
        OVOC_SearchPage_Controller.Search_VOC('Searchtext','06/28/2014','06/28/2014','CustomerNameTitle','AccountName','HonLead','ProductFamily','VOCTitle','Purpose','RecordNumber','CurrentStatus','SensitiveLevel', 'Normal');
        OVOC_SearchPage_Controller.Search_VOC('Searchtext','06/01/2014','06/28/2014','Test','Test','Test','Test','Test','Test','VOC','CurrentStatus','SensitiveLevel', 'Metadata');  
        OVOC_SearchPage_Controller.Search_VOC('','','','','','','','','','','','', '');         
        VOC_OVOC_Record_Number__c obj1= new VOC_OVOC_Record_Number__c();
        obj1.Name='Reference record1';
        obj1.VOC__c = '111';
        obj1.OVOC__c = '222';
        insert obj1;

        //to insert VOC_Save_Search__c
        VOC_Save_Search__c vocss1 = new VOC_Save_Search__c();
        vocss1.Search_Name__c = 'Searchname';
        vocss1.Date_Range_From__c = '06/28/2016';
        insert vocss1;
        OVOC_SearchPage_Controller.SaveSearch( string.valueof(vocss1.id),'searchName','Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','ProductFamily','VOCTitle','Purpose','RecordNumber','CurrentStatus','SensitiveLevel');
        OVOC_SearchPage_Controller.SaveSearch( '','searchName','Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','ProductFamily','VOCTitle','Purpose','RecordNumber','CurrentStatus','SensitiveLevel');
        OVOC_SearchPage_Controller.UpdateSearch(string.valueof(vocss1.id),'searchName','Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','retId','ProductFamily');
        OVOC_SearchPage_Controller.UpdateSearch('','searchName','Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','retId','ProductFamily');
        OVOC_SearchPage_Controller.UpdateSearch(string.valueof(vocss1.id),'searchName','Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','','ProductFamily');

        OVOC_SearchPage_Controller.fetchSaveSearch(string.valueof(vocss1.id));
        OVOC_SearchPage_Controller.getProductLine();
        OVOC_SearchPage_Controller.getsavedSearches();
        OVOC_SearchPage_Controller.getPurpose();
        // OVOC_SearchPage_Controller.getMyVOCDetails('search');
        OVOC_SearchPage_Controller.DeleteSearch(string.valueof(vocss1.id));
        OVOC_SearchPage_Controller.SliderSearch_VOC('search');
        OVOC_SearchPage_Controller.sendPdf('search','test1@gmail.com');
        // to insert Voice_of_Customer__c
        Voice_of_Customer__c obj = new Voice_of_Customer__c();
        obj.Status__c='Draft';
        obj.Account__c = acc.id;
        obj.Honeywell_Lead__c = 'test';
        obj.Product_Family__c = 'ALL';
        obj.VOC_Title__c = 'test';
        obj.Purpose_of_this_VOC__c = 'Concept Testing';
        insert obj;
        OVOC_SearchPage_Controller.getMyVOCDetails(string.valueof(obj.id));

        VOC_Save_Search__c vocss = new VOC_Save_Search__c();

        OVOC_SearchPage_Controller.vocWrapper ovocwap = new OVOC_SearchPage_Controller.vocWrapper(vocss);
        ovocsc.processSelected();
        List<VOC_Save_Search__c> listvoc = new List<VOC_Save_Search__c>();
        listvoc.add(vocss1);
        ovocsc.save_Search_Qry = listvoc;
        List<Voice_of_Customer__c> listv = new List<Voice_of_Customer__c>();
        listv.add(obj);
        ovocsc.Search_VOC_List = listv;
    }
    static testMethod void myUnitTest1() {
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name != 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        system.runAs(usr){
            string test1;
            PageReference pageRef = page.OVOC_Search;
            Test.setCurrentPage(pageRef);
            OVOC_SearchPage_Controller ovocsc = new OVOC_SearchPage_Controller();
            ovocsc.Search_Keyword = 'test';
            ovocsc.Search_StartDate = 'test'; 
            ovocsc.Search_EndDate = 'test';
            ovocsc.Search_Customer_Name = 'test';
            ovocsc.Search_OEM_Account = 'test';
            ovocsc.Search_Honeywell_Lead = 'test';
            ovocsc.Search_Product_Line = 'test';
            ovocsc.Save_Search_Name = 'test';
            ovocsc.getsave_Search();
            OVOC_SearchPage_Controller.Search_VOC('Searchtext',string.valueof(system.today()),string.valueof(system.today()),'CustomerNameTitle','AccountName','HonLead','ProductFamily','VOCTitle','Purpose','RecordNumber','CurrentStatus','SensitiveLevel', 'Normal');
            //OVOC_SearchPage_Controller.Search_VOC('Test for Storing video in the Archive MVI_9391.avi','06/28/2013','06/21/2017','CustomerNameTitle','AccountName','HonLead','None','Test for Storing video in the Archive MVI_9391.avi','','VOC-0855','Any','false', 'Normal');
        }
    }
}
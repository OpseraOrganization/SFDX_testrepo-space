@isTest
public class RedButtonControllerTest {
    
    @isTest
    public static void TestMethod1(){
        Test.startTest();
        string searchOption;
        string searchText;
        searchOption='Case Number';
        searchText='test';
        RedButtonController.fetchCases(searchOption,searchText);
        
        searchOption='Sales Order Number';
        searchText='test';
        RedButtonController.fetchCases(searchOption,searchText);
        
        searchOption='Cust PO Number';
        searchText='test';
        RedButtonController.fetchCases(searchOption,searchText);
        
        searchOption='Quote Number';
        searchText='test';
        RedButtonController.fetchCases(searchOption,searchText);
        
        searchOption='Repair Notification Number';
        searchText='test';
        RedButtonController.fetchCases(searchOption,searchText);
        Test.stopTest();
    }
    
    @isTest
    public static void TestMethod2(){
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            
            Test.startTest();
            
            RedButtonController.fetchAccts('Account Name','Test Account New');
            RedButtonController.fetchAccts('SAP Sold To Number','test');
            Test.stopTest();
        }
        /*Test.startTest();
RedButtonController.fetchAccts('Account Name','test');
RedButtonController.fetchAccts('SAP Sold To Number','test');
Test.stopTest();*/
    }
    
    @isTest
    public static void TestMethod3(){        
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;            
            insert cs; 
            Test.startTest();
            RedButtonController.fetchCaseInfo(cs.Id);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void TestMethod4(){        
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.Status='Open';
            cs.Subject='TestCase';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;            
            insert cs; 
            Test.startTest();

            List<RedButtonContentCreation.FileInfo> fileInList = new List<RedButtonContentCreation.FileInfo>();
            RedButtonContentCreation.FileInfo fileIn = new RedButtonContentCreation.FileInfo();
            
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);
            
            map<String,String> casInfoHelpNeededMap = new map<String,String>();
            casInfoHelpNeededMap.put('casId', cs.Id);
            casInfoHelpNeededMap.put('Comments', 'test');
            casInfoHelpNeededMap.put('EmailId', 'test@test.com');
            
            fileIn.Title='hello.txt';
            fileIn.VersionData=myBlob;
            fileInList.add(fileIn);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>) fileInList;
            
            RedButtonController.updateCaseInfo(lstObj, casInfoHelpNeededMap);
            Test.stopTest();
        }
    }
    
     @isTest
    public static void TestMethod5(){        
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.Status='Open';
            cs.Subject='TestCase';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;            
            insert cs; 
            
            Test.startTest();

            List<RedButtonContentCreation.FileInfo> fileInList = new List<RedButtonContentCreation.FileInfo>();
            RedButtonContentCreation.FileInfo fileIn = new RedButtonContentCreation.FileInfo();
            
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);
            
            map<String,String> casInfoHelpNeededMap = new map<String,String>();
            casInfoHelpNeededMap.put('AccountId', acctest.Id);
            casInfoHelpNeededMap.put('Comments', 'test');
            casInfoHelpNeededMap.put('EmailId', 'test@test.com');
            casInfoHelpNeededMap.put('Complexity', 'No');
            casInfoHelpNeededMap.put('WorkstreamOption', 'ROI');
            casInfoHelpNeededMap.put('Workstream', 'Order Status');
            casInfoHelpNeededMap.put('Subject', 'Order StatusTest');
            
            fileIn.Title='hello.txt';
            fileIn.VersionData=myBlob;
            fileInList.add(fileIn);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>) fileInList;
            
            RedButtonController.createCaseInfo(lstObj, casInfoHelpNeededMap,false);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void TestMethod6(){        
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.Status='Open';
            cs.Subject='TestCase';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;            
            insert cs; 
            Test.startTest();

            List<RedButtonContentCreation.FileInfo> fileInList = new List<RedButtonContentCreation.FileInfo>();
            RedButtonContentCreation.FileInfo fileIn = new RedButtonContentCreation.FileInfo();
            
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);
            
            map<String,String> casInfoHelpNeededMap = new map<String,String>();
            casInfoHelpNeededMap.put('casId', cs.Id);
            casInfoHelpNeededMap.put('Comments', 'test');
            casInfoHelpNeededMap.put('EmailId', 'test@test.com');
            
            fileIn.Title='hello.txt';
            fileIn.VersionData=myBlob;
            fileInList.add(fileIn);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>) fileInList;
            
            RedButtonController.createChildCaseAndUpdateCaseInfo(lstObj, casInfoHelpNeededMap);
            Test.stopTest();
        }
    }
    
    @isTest
    public static void TestMethod7(){        
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
            account acctest= (account)SObjectFactory.create(
                account.sObjectType, new Map<Schema.SObjectField, Object>
                {
                    account.Name => 'Test Account New',
                        account.Customer_Status__c => 'Active',
                        account.Strategic_Business_Unit__c => 'ATR',
                        account.CBT__c => 'Airlines',
                        account.Region_Name__c => 'Americas',
                        account.Sub_Region_Name__c => 'Canada',
                        account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                        account.Type => 'OEM',
                        account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                        account.Market_Name__c => 'Marine'        
                        });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
            con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
            con.Email='nandini.nanjappan@nttdata.com';
            insert con;   
            Set<Id> setCasId= new Set<Id>();
            Id RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Repair_Overhaul').getRecordTypeId(); 
            Case cs= new Case();
            cs.Origin = 'SAP Interface';
            cs.Status='Open';
            cs.Subject='TestCase';
            cs.RecordTypeId = RecordtypeId;
            cs.Classification__c = 'R&O Issue';
            cs.ContactId = con.Id;
            cs.Type_of_Change__c = 'New Account';
            cs.Type = 'Other';
            cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
            cs.Government_Compliance_SM_M_Content__c = 'NO';  
            cs.OwnerId=label.aero_default_user_id;            
            insert cs; 
            Test.startTest();
            
            case casUpdate = new case();
            casUpdate.Id = cs.Id;
            casUpdate.Status='Closed';
            update casUpdate;

            List<RedButtonContentCreation.FileInfo> fileInList = new List<RedButtonContentCreation.FileInfo>();
            RedButtonContentCreation.FileInfo fileIn = new RedButtonContentCreation.FileInfo();
            
            String myString = 'StringToBlob';
            Blob myBlob = Blob.valueof(myString);
            
            map<String,String> casInfoHelpNeededMap = new map<String,String>();
            casInfoHelpNeededMap.put('casId', cs.Id);
            casInfoHelpNeededMap.put('Comments', 'test');
            casInfoHelpNeededMap.put('EmailId', 'test@test.com');
            
            fileIn.Title='hello.txt';
            fileIn.VersionData=myBlob;
            fileInList.add(fileIn);
            List<Object> lstObj = new List<Object>();
            lstObj = (List<Object>) fileInList;
            
            RedButtonController.createChildCaseAndUpdateCaseInfo(lstObj, casInfoHelpNeededMap);
            Test.stopTest();
        }
    }
    
}
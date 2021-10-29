/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_SPEX_Data_Load
* Description           : Test Class to test the functionality of the SPEX Data Load Web service.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 16-Oct-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest
private class TestClass_Spex_Data_Load 
{
    
    static testMethod void TestMthd_SPEXDataLoad()
    {
        String status='';
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryInsert = new Spex_DB_Dataload.PART_SUMMARY_cls[2];
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryUpdate = new Spex_DB_Dataload.PART_SUMMARY_cls[2];
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryDelete = new Spex_DB_Dataload.PART_SUMMARY_cls[2];
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryEmpty = new Spex_DB_Dataload.PART_SUMMARY_cls[0];
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryTransaction = new Spex_DB_Dataload.PART_SUMMARY_cls[1];
        Spex_DB_Dataload.PART_SUMMARY_cls[] arrPartSummaryException = new Spex_DB_Dataload.PART_SUMMARY_cls[2];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryInsert = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[2];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryUpdate = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[2];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryDelete = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[2];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryEmpty = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[0];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryTransaction = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[1];
        Spex_DB_Dataload.PLATFORM_SUMMARY_cls[] arrPlatformSummaryException = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls[2];
            
            Spex_DB_Dataload.PART_SUMMARY_cls objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs01';
            objPartSummary.PART_NUMBER='TestPartNum01';
            objPartSummary.ABC_CODE='A';
            objPartSummary.PRODUCT_FAMILY='Gear Assembly';
            objPartSummary.ASSET_MANAGER='Nabeel Ramzan';
            objPartSummary.DEMAND_BY_AMERICAS=23;
            objPartSummary.DEMAND_BY_EMEA=24;
            objPartSummary.DEMAND_BY_APAC=25;
            objPartSummary.STOCK_BY_AMERICAS=15;
            objPartSummary.STOCK_BY_EMEA=16;
            objPartSummary.STOCK_BY_APAC=17;
            objPartSummary.TRANSACTION_FLAG='N';
            
            arrPartSummaryInsert[0] = objPartSummary;
            arrPartSummaryException[0] = objPartSummary;
            arrPartSummaryException[1] = objPartSummary;
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs02';
            objPartSummary.PART_NUMBER='TestPartNum02';
            objPartSummary.ABC_CODE='B';
            objPartSummary.PRODUCT_FAMILY='Turbine Assembly';
            objPartSummary.ASSET_MANAGER='Nabeel Ramzan';
            objPartSummary.DEMAND_BY_AMERICAS=23;
            objPartSummary.DEMAND_BY_EMEA=24;
            objPartSummary.DEMAND_BY_APAC=25;
            objPartSummary.STOCK_BY_AMERICAS=15;
            objPartSummary.STOCK_BY_EMEA=16;
            objPartSummary.STOCK_BY_APAC=17;
            objPartSummary.TRANSACTION_FLAG='N';
            
            arrPartSummaryInsert[1] = objPartSummary;
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs01';
            objPartSummary.PART_NUMBER='TestPartNum01';
            objPartSummary.ABC_CODE='B';
            objPartSummary.PRODUCT_FAMILY='Fan Assembly';
            objPartSummary.ASSET_MANAGER='John Smith';
            objPartSummary.DEMAND_BY_AMERICAS=21;
            objPartSummary.DEMAND_BY_EMEA=20;
            objPartSummary.DEMAND_BY_APAC=24;
            objPartSummary.STOCK_BY_AMERICAS=17;
            objPartSummary.STOCK_BY_EMEA=15;
            objPartSummary.STOCK_BY_APAC=13;
            objPartSummary.TRANSACTION_FLAG='C';
            
            arrPartSummaryUpdate[0] = objPartSummary;
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs02';
            objPartSummary.PART_NUMBER='TestPartNum02';
            objPartSummary.ABC_CODE='A';
            objPartSummary.PRODUCT_FAMILY='Motor Assembly';
            objPartSummary.ASSET_MANAGER='John Smith';
            objPartSummary.DEMAND_BY_AMERICAS=13;
            objPartSummary.DEMAND_BY_EMEA=14;
            objPartSummary.DEMAND_BY_APAC=15;
            objPartSummary.STOCK_BY_AMERICAS=5;
            objPartSummary.STOCK_BY_EMEA=6;
            objPartSummary.STOCK_BY_APAC=7;
            objPartSummary.TRANSACTION_FLAG='C';
            
            arrPartSummaryUpdate[1] = objPartSummary;
            
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs01';
            objPartSummary.PART_NUMBER='TestPartNum01';
            objPartSummary.ABC_CODE='B';
            objPartSummary.PRODUCT_FAMILY='Fan Assembly';
            objPartSummary.TRANSACTION_FLAG='D';
            
            arrPartSummaryDelete[0] = objPartSummary;
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs02';
            objPartSummary.PART_NUMBER='TestPartNum02';
            objPartSummary.ABC_CODE='A';
            objPartSummary.PRODUCT_FAMILY='Motor Assembly';
            objPartSummary.TRANSACTION_FLAG='D';
            
            arrPartSummaryDelete[1] = objPartSummary;
            
            objPartSummary = new Spex_DB_Dataload.PART_SUMMARY_cls();
            
            objPartSummary.PART_DESCRIPTION='TestPartDecs01';
            objPartSummary.PART_NUMBER='TestPartNum01';
            objPartSummary.ABC_CODE='B';
            objPartSummary.PRODUCT_FAMILY='Fan Assembly';
            objPartSummary.TRANSACTION_FLAG='Z';
            
            arrPartSummaryTransaction[0] = objPartSummary;

            
            Spex_DB_Dataload.PLATFORM_SUMMARY_cls objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();
            
            objPlatformSummary.PART_NUMBER='TestPartNum01';
            objPlatformSummary.PLATFORM='FALCON 900';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.DEMAND_BY_AMERICAS=29;
            objPlatformSummary.DEMAND_BY_EMEA=30;
            objPlatformSummary.DEMAND_BY_APAC=31;
            objPlatformSummary.TRANSACTION_FLAG='N';

            arrPlatformSummaryInsert[0] = objPlatformSummary;
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();

            objPlatformSummary.PART_NUMBER='TestPartNum02';
            objPlatformSummary.PLATFORM='F7X';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.DEMAND_BY_AMERICAS=31;
            objPlatformSummary.DEMAND_BY_EMEA=32;
            objPlatformSummary.DEMAND_BY_APAC=33;
            objPlatformSummary.TRANSACTION_FLAG='N';
            
            
            arrPlatformSummaryInsert[1] = objPlatformSummary;
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();
            
            objPlatformSummary.PART_NUMBER='TestPartNum01';
            objPlatformSummary.PLATFORM='FALCON 900';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.DEMAND_BY_AMERICAS=19;
            objPlatformSummary.DEMAND_BY_EMEA=20;
            objPlatformSummary.DEMAND_BY_APAC=21;
            objPlatformSummary.TRANSACTION_FLAG='C';

            arrPlatformSummaryUpdate[0] = objPlatformSummary;
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();

            objPlatformSummary.PART_NUMBER='TestPartNum02';
            objPlatformSummary.PLATFORM='F7X';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.DEMAND_BY_AMERICAS=21;
            objPlatformSummary.DEMAND_BY_EMEA=22;
            objPlatformSummary.DEMAND_BY_APAC=23;
            objPlatformSummary.TRANSACTION_FLAG='C';

            arrPlatformSummaryUpdate[1] = objPlatformSummary;
            
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();
            
            objPlatformSummary.PART_NUMBER='TestPartNum01';
            objPlatformSummary.PLATFORM='FALCON 900';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.TRANSACTION_FLAG='D';

            arrPlatformSummaryDelete[0] = objPlatformSummary;
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();

            objPlatformSummary.PART_NUMBER='TestPartNum02';
            objPlatformSummary.PLATFORM='F7X';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.TRANSACTION_FLAG='D';

            arrPlatformSummaryDelete[1] = objPlatformSummary;
            
            objPlatformSummary = new Spex_DB_Dataload.PLATFORM_SUMMARY_cls();
            
            objPlatformSummary.PART_NUMBER='TestPartNum01';
            objPlatformSummary.PLATFORM='FALCON 900';
            objPlatformSummary.OEM_NAME='Dassault';
            objPlatformSummary.TRANSACTION_FLAG='Z';

            arrPlatformSummaryTransaction[0] = objPlatformSummary;
            
        
        
       Test.startTest();
       
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryInsert, arrPlatformSummaryInsert); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryUpdate, arrPlatformSummaryUpdate); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryUpdate, arrPlatformSummaryDelete); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryDelete, arrPlatformSummaryEmpty); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryEmpty, arrPlatformSummaryEmpty); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryTransaction, arrPlatformSummaryTransaction); 
        System.assertEquals(status , 'Success!');
        
        status =  Spex_DB_Dataload.SPEX_DB_LOAD_SFDC_OBJECTS(arrPartSummaryException, arrPlatformSummaryEmpty); 
        System.assertEquals(status , 'Failure!');
        
        Test.stopTest(); 
        
        
    }
}
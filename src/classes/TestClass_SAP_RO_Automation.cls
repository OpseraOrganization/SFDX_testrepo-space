/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_SAP_R&O_Automation
* Description           : Test Class to test the functionality of the SAP R & O Automation Web service.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 16-Oct-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_SAP_RO_Automation
{
    
    static testMethod void TestMthd_ROAutomation()
    {
        String status='';
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreate = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreateException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASEClose = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECloseException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
            
        SAP_RandO_Automation_Service.RnO_CASE_cls objCaseCreate = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
    /*        Account a1 = New Account(Name= 'Fedex Corp', Strategic_Business_Unit__c = 'ATR',   CBT__c = 'Airlines', Sbl_Account_Row_Id__c='1B-1JTTEST');
            insert a1;
            Contact cont=new Contact(firstname='Anita',LastName='Cotten',AccountId=a1.Id,Phone_3__c='9986502495',Email='acotten@fedex.com.qa',
            Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='5756710',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
            insert cont; */
            
            objCaseCreate.ACCOUNT_NAME='1B-1JTTEST';
            objCaseCreate.DESCRIPTION='This is a test case for Sales Order 666666';
            objCaseCreate.CONTACT_NAME='acotten@fedex.com';
            objCaseCreate.CLASSIFICATION='CSO Repair/Overhaul';
            objCaseCreate.CUSTOMER_PO_RO_WO_NUM='RO Test';
            objCaseCreate.CUSTOMER_REQUEST_DT='2013-03-28';
            objCaseCreate.ORDER_ENTERED_DT='2013-03-15';
            objCaseCreate.PRODUCT_NUM='3101513-17';
            objCaseCreate.PRODUCT_SERIAL_NUM='RB-12042012-1';
            objCaseCreate.EXPORT_COMPLIANCE_IND='No';
            objCaseCreate.GOVT_COMPLIANCE_IND='No';
            objCaseCreate.REPAIR_LOCATION='1014';
            objCaseCreate.SPEX_EXG_IND='False';
            objCaseCreate.STATUS='Open';
            objCaseCreate.SUB_CLASS='Mechanical (R&amp;O)';
            objCaseCreate.DETAIL_CLASS=null;
            objCaseCreate.SUBJECT='This is a new CASE Test for order 666666';
            objCaseCreate.SAP_ACCOUNT_NAME='1B-1JTTEST';            
            objCaseCreate.SAP_ACCOUNT_INFO='Customer Code 123';
            objCaseCreate.SALES_ORDER_NUMBER='666666';
//            objCaseCreate.RESOLUTION
//            objCaseCreate.SUB_STATUS

SAP_RandO_Automation_Service.RnO_CASE_cls objCaseCreate1 = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
            objCaseCreate1.ACCOUNT_NAME='A-0168137';
            objCaseCreate1.DESCRIPTION='This is a test case for Sales Order  999999';
            objCaseCreate1.CONTACT_NAME='acotten@fedex.com';
            objCaseCreate1.CLASSIFICATION='CSO Repair/Overhaul';
            objCaseCreate1.CUSTOMER_PO_RO_WO_NUM='RO Test';
            objCaseCreate1.CUSTOMER_REQUEST_DT='2013-03-28';
            objCaseCreate1.ORDER_ENTERED_DT='2013-03-15';
            objCaseCreate1.PRODUCT_NUM='3101513-17';
            objCaseCreate1.PRODUCT_SERIAL_NUM='RB-12042012-1';
            objCaseCreate1.EXPORT_COMPLIANCE_IND='No';
            objCaseCreate1.GOVT_COMPLIANCE_IND='No';
            objCaseCreate1.REPAIR_LOCATION='1014';
            objCaseCreate1.SPEX_EXG_IND='False';
            objCaseCreate1.STATUS='Open';
            objCaseCreate1.SUB_CLASS='Mechanical (R&amp;O)';
            objCaseCreate1.DETAIL_CLASS=null;
            objCaseCreate1.SUBJECT='This is a new CASE Test for order 999999';
            objCaseCreate1.SAP_ACCOUNT_NAME='1B-1JTTEST';            
            objCaseCreate1.SAP_ACCOUNT_INFO='Customer Code 123';
            objCaseCreate1.SALES_ORDER_NUMBER='999999';

            
 SAP_RandO_Automation_Service.RnO_CASE_cls objCaseClose = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
            objCaseClose.STATUS='Closed';
            objCaseClose.SALES_ORDER_NUMBER='666666';
            objCaseClose.RESOLUTION='This order was closed in SAP';
            objCaseClose.SUB_STATUS='Closed By SAP';
            
        
       Test.startTest();
        
   //     status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseCreate1); 
   //     System.assertEquals(status , 'Success!!');
       
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
        //System.assertEquals(status , 'Failure!');
       
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseCreate); 
        //System.assertEquals(status , 'Success!!');

        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
        //System.assertEquals(status , 'Failure!');
        
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
       // System.assertEquals(status , 'Failure!');
        

        
        Test.stopTest(); 
        
        
    }
    static testMethod void TestMthd_ROAutomation1()
    {
        String status='';
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreate = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreateException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASEClose = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECloseException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
            
        SAP_RandO_Automation_Service.RnO_CASE_cls objCaseCreate = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
           Account a1 = New Account(Name= 'Fedex Corp', Strategic_Business_Unit__c = 'ATR',   CBT__c = 'Airlines', Sbl_Account_Row_Id__c='1B-1JTTEST');
            insert a1;
            /*Contact cont=new Contact(firstname='Anita',LastName='Cotten',AccountId=a1.Id,Phone_3__c='9986502495',Email='acotten@fedex.com',
            Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='5756710',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
            insert cont; 
            List<Case> cslist = new List<Case>();
            Case cs = new Case();
            cs.Status = 'Open';
            cs.Sales_Order_Number__c = '6666666666';
            cs.Type = 'Order Status';
            cs.RecordTypeId = Label.RnO_Automation_Record_Type;
            cs.Classification__c='CSO Repair/Overhaul';
            cs.Origin='Web';
            cs.Resolution__c='Test';
            cs.OwnerId =UserInfo.getUserId();
            cs.Sub_Status__c = 'Closed By SAP';
            cs.Contact = cont;
            cslist.add(cs);
            insert cslist;*/
        
            objCaseCreate.ACCOUNT_NAME='1B-1JTTEST';
            objCaseCreate.DESCRIPTION='This is a test case for Sales Order 666666';
            objCaseCreate.CONTACT_NAME='acotten@fedex.com';
            objCaseCreate.CLASSIFICATION='CSO Repair/Overhaul';
            objCaseCreate.CUSTOMER_PO_RO_WO_NUM='RO Test';
            objCaseCreate.CUSTOMER_REQUEST_DT='2013-03-28';
            objCaseCreate.ORDER_ENTERED_DT='2013-03-15';
            objCaseCreate.PRODUCT_NUM='3101513-17';
            objCaseCreate.PRODUCT_SERIAL_NUM='RB-12042012-1';
            objCaseCreate.EXPORT_COMPLIANCE_IND='Yes';
            objCaseCreate.GOVT_COMPLIANCE_IND='Yes';
            objCaseCreate.REPAIR_LOCATION='1014';
            objCaseCreate.SPEX_EXG_IND='False';
            objCaseCreate.STATUS='Open';
            objCaseCreate.SUB_CLASS='Mechanical (R&amp;O)';
            objCaseCreate.DETAIL_CLASS=null;
            objCaseCreate.SUBJECT='This is a new CASE Test for order 666666';
            objCaseCreate.SAP_ACCOUNT_NAME='1B-1JTTEST';            
            objCaseCreate.SAP_ACCOUNT_INFO='Customer Code 123';
            objCaseCreate.SALES_ORDER_NUMBER='6666666666';
//            objCaseCreate.RESOLUTION
//            objCaseCreate.SUB_STATUS
            SAP_RandO_Automation_Service.RnO_CASE_cls objCaseClose = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
            objCaseClose.STATUS='Closed';
            objCaseClose.SALES_ORDER_NUMBER='6666666666';
            objCaseClose.RESOLUTION='This order was closed in SAP';
            objCaseClose.SUB_STATUS='Closed By SAP';
        
       Test.startTest();
        SAP_RandO_Automation_Service sap = new SAP_RandO_Automation_Service();
        case cs1 = sap.GET_CASE_OBJ('666666', 'Open');
        
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseCreate); 
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
     
        Test.stopTest(); 
        
        
    }
     static testMethod void TestMthd_ROAutomation3()
    {
        String status='';
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreate = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECreateException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASEClose = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
        SAP_RandO_Automation_Service.RnO_CASE_cls[] arrRnO_CASECloseException = new SAP_RandO_Automation_Service.RnO_CASE_cls[1];
            
        SAP_RandO_Automation_Service.RnO_CASE_cls objCaseCreate = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
    /*        Account a1 = New Account(Name= 'Fedex Corp', Strategic_Business_Unit__c = 'ATR',   CBT__c = 'Airlines', Sbl_Account_Row_Id__c='1B-1JTTEST');
            insert a1;
            Contact cont=new Contact(firstname='Anita',LastName='Cotten',AccountId=a1.Id,Phone_3__c='9986502495',Email='acotten@fedex.com.qa',
            Contact_Is_Employee__c=true,  Contact_Status__c='Active' ,Employee_Number__c='5756710',Honeywell_ID__c ='E7776',Employee_Contact_Role__c='Administrator');
            insert cont; */
            
            objCaseCreate.ACCOUNT_NAME='1B-1JTTEST';
            objCaseCreate.DESCRIPTION='This is a test case for Sales Order 666666';
            objCaseCreate.CONTACT_NAME='acotten@fedex.com';
            objCaseCreate.CLASSIFICATION='CSO Repair/Overhaul';
            objCaseCreate.CUSTOMER_PO_RO_WO_NUM='RO Test';
            objCaseCreate.CUSTOMER_REQUEST_DT='2013-03-28';
            objCaseCreate.ORDER_ENTERED_DT='2013-03-15';
            objCaseCreate.PRODUCT_NUM='3101513-17';
            objCaseCreate.PRODUCT_SERIAL_NUM='RB-12042012-1';
            objCaseCreate.EXPORT_COMPLIANCE_IND='No';
            objCaseCreate.GOVT_COMPLIANCE_IND='No';
            objCaseCreate.REPAIR_LOCATION='1014';
            objCaseCreate.SPEX_EXG_IND='False';
            objCaseCreate.STATUS='Open';
            objCaseCreate.SUB_CLASS='Mechanical (R&amp;O)';
            objCaseCreate.DETAIL_CLASS=null;
            objCaseCreate.SUBJECT='This is a new CASE Test for order 666666';
            objCaseCreate.SAP_ACCOUNT_NAME='1B-1JTTEST';            
            objCaseCreate.SAP_ACCOUNT_INFO='Customer Code 123';
            objCaseCreate.SALES_ORDER_NUMBER='666666';
//            objCaseCreate.RESOLUTION
//            objCaseCreate.SUB_STATUS

SAP_RandO_Automation_Service.RnO_CASE_cls objCaseCreate1 = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
            objCaseCreate1.ACCOUNT_NAME='A-0168137';
            objCaseCreate1.DESCRIPTION='This is a test case for Sales Order  999999';
            objCaseCreate1.CONTACT_NAME='acotten@fedex.com';
            objCaseCreate1.CLASSIFICATION='CSO Repair/Overhaul';
            objCaseCreate1.CUSTOMER_PO_RO_WO_NUM='RO Test';
            objCaseCreate1.CUSTOMER_REQUEST_DT='2013-03-28';
            objCaseCreate1.ORDER_ENTERED_DT='2013-03-15';
            objCaseCreate1.PRODUCT_NUM='3101513-17';
            objCaseCreate1.PRODUCT_SERIAL_NUM='RB-12042012-1';
            objCaseCreate1.EXPORT_COMPLIANCE_IND='No';
            objCaseCreate1.GOVT_COMPLIANCE_IND='No';
            objCaseCreate1.REPAIR_LOCATION='1014';
            objCaseCreate1.SPEX_EXG_IND='False';
            objCaseCreate1.STATUS='Open';
            objCaseCreate1.SUB_CLASS='Mechanical (R&amp;O)';
            objCaseCreate1.DETAIL_CLASS=null;
            objCaseCreate1.SUBJECT='This is a new CASE Test for order 999999';
            objCaseCreate1.SAP_ACCOUNT_NAME='1B-1JTTEST';            
            objCaseCreate1.SAP_ACCOUNT_INFO='Customer Code 123';
            objCaseCreate1.SALES_ORDER_NUMBER='999999';

            
 SAP_RandO_Automation_Service.RnO_CASE_cls objCaseClose = new SAP_RandO_Automation_Service.RnO_CASE_cls();
            
            objCaseClose.STATUS='Closed';
            objCaseClose.SALES_ORDER_NUMBER='666666';
            objCaseClose.RESOLUTION='This order was closed in SAP';
            objCaseClose.SUB_STATUS='Closed By SAP';
            
        
       Test.startTest();
        
   //     status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseCreate1); 
   //     System.assertEquals(status , 'Success!!');
       
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
        //System.assertEquals(status , 'Failure!');
       
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseCreate); 
        //System.assertEquals(status , 'Success!!');

        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
        //System.assertEquals(status , 'Failure!');
        
        status =  SAP_RandO_Automation_Service.SAP_RO_AUTOMATION_PROC(objCaseClose); 
       // System.assertEquals(status , 'Failure!');
        

        
        Test.stopTest(); 
        
        
    }
}
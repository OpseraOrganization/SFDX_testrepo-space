@isTest(seealldata=true)
public class MPMSIMLICENSEOppCloneClsTest
{

static testMethod void myUnitTest() 
{

User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' limit 1 ];
//insert usr;
Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
insert acc;


Contact con = new Contact();
con.LastName = 'testupdate';
con.FirstName = 'sbucon';
con.AccountId = acc.Id;
con.Contact_Function__c='Infosys';
con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
insert con;

Platform__c p=new Platform__c();
p.Name='Test Platform for MPM';
p.Model__c='Test Model';
p.Platform_Type__c='Airplane';
p.Make__c='Airbus';
p.Managing_SBU__c='ATR';
insert p;

Id ortid = [select id from recordtype where name  ='M&PM SIM Licensing'].id;
opportunity opp=new opportunity();
opp.RecordTypeID=ortid;
opp.CBT_HIPI__c='Airbus';
opp.CBT_Team_HIPI__c='AMFS';
opp.Revenue_Structure__c='Test Data';
opp.Year_5__c=Decimal.valueOf(2);
opp.Year_3__c=Decimal.valueOf(2);
opp.Closed_Out_by_IP_Finance__c=date.parse('02/03/2016');
opp.Year_4__c=Decimal.valueOf(3);
opp.Commission_Agency__c='Test Value';
opp.Year_2__c=Decimal.valueOf(4);
opp.Commission_K_Text__c='200';
opp.Value_in_Q4_K_Text__c='312';
opp.Value_in_Current_Year_Jan_Dec_K__c='2000';
opp.Value_in_Q3_K_Text__c='300';
opp.License_Fee_Waived_K_Text__c='70';
opp.Value_in_Q2_K_Text__c='50';
opp.Contract_Term_In_Years__c=Decimal.valueOf(5);
opp.Value_in_Q1_K_Text__c='30';
opp.Record_Data_Owner__c=con.id;
opp.C_CONFIG_LIST__c='yes';
opp.B_LICENSED_DATA__c='yes';
opp.A_LICENSED_SW__c='yes';
opp.D_other__c='yes';
opp.OTHER_TYPE_OF_INVOICE__c='Test Payment';
//opp.OTHER_SBU__c='ATR';
opp.TYPE_OF_INVOICE__c='partial';
opp.SBU__c='ATR';
opp.EXPIRATION_DATE__c=date.parse('01/10/2016');
//opp.AGREEMENT_TERM__c='4';
opp.HIPI_CONTRACT_NUMBER__c='1234';
opp.TS_Agreement_License__c='Test License';
opp.TECHNICAL_SUPPORT_Hrs__c='test';
opp.PART_NUMBER__c='1234';
//opp.Host_Volume_ID_MAC_Address__c='test';
opp.SOFTWARE_LOAD_VERSION__c='3';
opp.PRODUCT_DESCRIPTION__c='MPM SIM Licensing';
opp.LICENSE_PO_DATE__c=date.parse('12/04/2016');
//opp.LICENSE_PO__c='2563';
//opp.OTHER_EXPORT_LICENSE_TAA_Required__c='other';
opp.OTHER_EGPWSim_details__c='other';
//opp.EXPORT_LICENSE_TAA_Required__c='OTHER';
opp.EGPWSim_details__c='OTHER';
opp.OTHER_Simulator_HW_Config__c='other';
opp.OTHER_DEVICE__c='other';
opp.Simulator_HW_Config__c='OTHER';
opp.DEVICE__c='OTHER';
opp.OTHER_LICENSE_CATEGORY__c='other';
opp.OTHER_AGREEMENT_TYPE__c='other';
opp.LICENSE_CATEGORY__c='PIA';
opp.AGREEMENT_TYPE__c='OTHER';
opp.License_fee_Breakdown__c='40';
opp.LICENSE_FEE__c='30';
opp.OTHER_A_C_Product_Status__c='other';
//opp.OTHER_A_C_PLATFORM__c='other';
opp.A_C_Product_Status__c='Development';
//opp.A_C_PLATFORM__c='other';
//opp.EXPORT_LICENSE__c='Test';
opp.CUSTOMER_LICENSE_NEED_DATE__c=date.parse('12/04/2016');
opp.PRICING_APPROVAL_FILE_LINK__c='test';
opp.HON_POC__c='Test';
opp.QTY_OF_DEVICES__c='3';
opp.PROJ_JOB_SER__c='test';
opp.DEVICE_IDENTIFIER__c='';
opp.SIM_DEVICE_OPERATOR_ADDRESS__c='';
opp.SIM_DEVICE_OPERATOR__c='';
opp.SIM_DEVICE_OWNER_ADDRESS__c='';
opp.SIM_DEVICE_OWNER__c='';
opp.CUSTOMER_POC__c='';
opp.OTHER_CUSTOMER_DEVICE_TYPE__c='';
opp.OTHER_HON_DEVICE_TYPE__c='';
opp.CUSTOMER_DEVICE_TYPE__c='';
opp.HON_DEVICE_TYPE__c='';
opp.OTHER_PRICING_APPROVAL_ON_FILE__c='';
opp.OTHER_LICENSEE_ADDRESS__c='';
opp.PRICING_APPROVAL_ON_FILE__c='';
opp.LICENSEE_ADDRESS__c='';
opp.Owner_SBG__c='AER';
opp.Quote_Date__c=date.parse('04/23/2016');
opp.Who_quote_was_sent_to__c='';
opp.Sim_License__c='';
opp.Region1__c='Americas';
opp.Automatic_Renewal__c='';
opp.Country__c='India';
opp.DOS_Number__c='434';
opp.CloseDate=date.parse('04/24/2016');
opp.DOS_Expiration_Date__c=date.parse('04/13/2016');
opp.Deal_Status__c='Green [90%]';
opp.DOS_Approval_Required__c=true;
opp.StageName='Deal Status';
opp.Brand__c='other';
opp.Agmts_Contains_Export_Controlled_Data__c='Yes';
opp.If_Brand_Other_Please_Specify__c='Test';
opp.Agmt_Subject_to_Export_Control__c='Yes';
opp.Are_Patents_Involved__c='';
opp.Is_TLC_Approval_required__c='';
opp.Received_TLC_Approvals__c=date.parse('02/26/2016');
opp.Name = 'Test Opportunity MPM';
opp.List_All_Patent_s_Country_i_e_US__c='';
Opp.Probability =Decimal.valueOf(2);       
Opp.Licensor__c ='other' ;
Opp.Attorney_SBG__c='AER' ;
opp.Request_Contract_Number__c=true; 
opp.If_Licensor_Other_Please_Specify__c='';
opp.Licensee__c='test';
opp.HON_Lead_IP_Attorney__c='Test';
opp.Contract_Type__c='BPA';
opp.If_Other_Enter_the_Name_of_Attorney__c='Test user';
opp.Contract_Title__c='Test Contract for MPM';
opp.Account_Contact_Name__c=con.id;           
opp.contract_sub_type__c = 'other';
opp.Contract_Number__c='5342';
opp.If_Restated_Prior_Contract_Number__c='yes';
opp.ATN_Approval_Date__c=date.parse('04/03/2016');
opp.ATP_Approval_Date__c=date.parse('04/03/2016');
opp.Value_Stream_Category__c='other';
opp.Date_Critical_Data_Delivery_Ship_RFT__c=date.parse('04/15/2016');
opp.Issue_Other_Than_Review__c='Technical Issue';
opp.PO_Received__c=date.parse('05/10/2016');
opp.Workbook__c=date.parse('05/30/2016');
opp.IP_Approval__c=date.parse('04/02/2016');
opp.LicenseDraft__c=true;
opp.License_Review_Issue__c=date.parse('04/20/2016');
opp.Final_Review__c=true;
opp.WorkbookComplete__c=true;
opp.Information_for_Engg__c='Test data';
opp.Engineer_Manager_Review__c=true;
opp.SFDC_Entry_Initiated__c=date.parse('02/02/2016');
opp.License_to_Customer__c=date.parse('03/04/2016');
opp.License_Back_From_Customer__c=date.parse('02/03/2016');
opp.License_Signed_Lic_CoE__c=date.parse('03/14/2016');
opp.Data_Shipped_ECM__c=date.parse('03/14/2016');
opp.Invoice_Requested__c=date.parse('12/14/2016');
opp.OEM__c='Airbus';
//opp.Airline_End_Customer__c='Test customer';
//opp.FFS_or_LLD__c='other';
//opp.EPIC__c='EPIC';
//opp.New_or_Update_or_Upgrade__c='New = new manufacture of FFS or LLD';
opp.Invoice__c='4563';
opp.PO__c='6356';
//opp.Revenue_SBU__c='ATR';
opp.Workstop_Issue__c=date.parse('02/24/2016');
opp.Workstop_Issue_Cleared__c=False;
opp.Review_issue__c='Tecnical issue';
opp.OwnerId=usr.id;
opp.Account_manager_review__c=true;
opp.Accountt_Manager_Review_Comments__c='good';
opp.Engg_Review_Comments__c='test';
opp.Revenue_Recognized__c=true;
opp.Revenue_Recognition_Expected__c=date.parse('02/13/2016');
opp.OTHER_OEM__c='Other';
opp.Other_category_of_IP__c='other';
opp.Invoice_Requested__c=date.parse('05/04/2016');
opp.Quote__c='6457';
opp.Quote_Follow_up_Date__c=date.parse('05/04/2016');
//opp.PO_Revision__c=True;
opp.Revision_Date__c=date.parse('03/04/2016');
opp.Description_of_the_Deal__c='Test';
opp.Special_Terms__c='Testing Purpose';
opp.IP_Ownership_Outside_Honeywell_Intl__c='YES';
opp.Other_IPOwnershipOutsideHoneywellIntl__c='other';
opp.HIPI_Accounts__c='BOMBARDIER INC.'; 
opp.Quote_Expiration_Date__c=date.parse('04/05/2016');
opp.Platform__c=p.id;
opp.InvoiceRequested__c =true ;
opp.Final_review_comments__c='Product is defect free and reliable';
opp.BusinessContact__c=usr.id;  
Opp.Comments__c='Testing purpose' ;
insert opp;

PageReference pgr = page.MPMOppEditPage;
pgr.getparameters().put('Oppid' , opp.id);
Test.SetCurrentPage(pgr);
System.currentPageReference().getparameters().put('Oppid',opp.id);
 
ApexPages.StandardController stdController = new ApexPages.StandardController(opp);
MPMSIMLICENSEOppCloneCls MPM= new MPMSIMLICENSEOppCloneCls(stdController);
MPM.saveandnew(); 
MPM.getOEM();
MPM.setOEM();
MPM.CustomSave();


//MPM.cancel();
//MPM.reset();
//MPM.changelicenseePlatform();

  
//opportunity opp1=new opportunity();
//opp1.id=opp.id;

}

    static testMethod void myUnitTest1() 
    {
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
        insert acc;
        
        Account acc1= new account();
        acc1.name = 'NTT Offshore Test Account121';
        acc1.Report_Address_Line_1__c = '12 Hajecka Us A Hlinku 25/30';
        acc1.Report_Address_Line_2__c = '2 Hajecka Us A Hlinku 25/30';
        acc1.Report_Address_Line_3__c = '11 Hajecka Us A Hlinku 25/30';
        acc1.Report_City_Name__c = 'Brno';
        acc1.Report_State_Code__c = '600021';
        acc1.Report_Postal_Code__c = '618 00';
        acc1.Report_Country_Name__c = 'czech republic';
        acc1.CBT__c = 'BGA Aftermarket';
        acc1.CBT_Team__c  = 'EMEAI BGA';
        acc1.REPORT_ACCOUNT_NAME__c='Wipro Offshore Test Account';
        insert acc1;
        
        opportunity opp1= new opportunity( );
        opp1.Name= 'testopty';
        opp1.Licensor__c= 'HII';
        opp1.Licensee__c= 'Testaccount';
        opp1.Contract_Type__c= 'SIM Military';
        opp1.Attorney_SBG__c= 'AER';
        opp1.CloseDate= Date.newInstance(2016, 2, 1);  
        opp1.Country__c= 'India';
        opp1.Region1__c= 'EMEAI';
        opp1.stagename= 'Phase 2: Detailed Negotiation';
        opp1.AccountId = acc.Id;
        opp1.Request_Contract_Number__c=true;
        opp1.Aircraft_Platform__c = 'A320';
        /*opp.Corp_HIPI_Opportunity_Number__c = '5241';
        opp.Total_Value_of_Agmt_K_Text__c = '111';*/
        opp1.Contract_Term_In_Years__c = 43;
        opp1.Value_in_Q1_K_Text__c = '5241';
        opp1.Value_in_Q2_K_Text__c = '5241';
        opp1.Value_in_Q3_K_Text__c = '5241';
        opp1.Value_in_Q4_K_Text__c = '5241';
        opp1.Year_2__c = 7;
        opp1.OEM__c='Airbus';
        opp1.Year_3__c = 3;
        opp1.HIPI_Accounts__c = 'DUNCAN AVIATION INC - LINCOLN'; 
          
        S2SFRestService__c objS2SF = new S2SFRestService__c();
        objS2SF.Name='S2SFRestService11';
        objS2SF.Client_Id__c='3MVG9dzpc3kWyeYadd5SFIAZYfRT0HTnAJXRkW8Hc7.5LpxdjaVJJ05iuJHTDvKITxa5EZ9Y40iSX47_r53mJ';
        objS2SF.OAuth2End_Point__c='https://test.salesforce.com/services/oauth2/token   ';
        objS2SF.Password__c='testHtygKefAzOUqQtJ3F5pEfjk3';
        objS2SF.Secret_Id__c='17600332615211137021';
        objS2SF.User_Name__c='nandini.nanjappan@honeywell.com';
        
        RESTAPIEndPoint__c restapi=new RESTAPIEndPoint__c();
        restapi.EndpointURL__c='createopty1';
        restapi.Name='CreateOpportunityEndPointURL7';
  
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        CallServicetoCreateClass1 results = new CallServicetoCreateClass1();
        OAuth2 auth = new OAuth2();
        auth.id='121';
        auth.issued_at='11-12-2015';
        auth.instance_url='/testurl';
        auth.signature='test';
        auth.access_token='12987';
      
       
        insert restapi;  
        insert opp1;        
        insert objS2SF;
        
        /*
        MPMAircraftPlatform__c plat = new MPMAircraftPlatform__c();
        plat.OEM__c = 'Airbus';
        plat.Name = 'A320';
        insert plat;
       */
       
        PageReference pgr = page.MPMOppEditPage;
        pgr.getparameters().put('Oppid' , opp1.id);
        Test.SetCurrentPage(pgr);
        System.currentPageReference().getparameters().put('Oppid',opp1.id);
        
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(opp1);
        MPMSIMLICENSEOppCloneCls MPM1= new MPMSIMLICENSEOppCloneCls(stdController1);
        MPM1.changelicensee();    
        MPM1.MyMethod(); 
        MPM1.changelicenseePlatform();
        MPM1.Cancel();
        MPM1.reset();
}

    static testMethod void myUnitTest5() 
    {
        Id ortid = [select id from recordtype where name  ='M&PM SIM Licensing'].id;
        PageReference pgr = page.MPM_SIM_LICENSE;
        pgr.getparameters().put('recTypeId' , ortid );
        Test.SetCurrentPage(pgr);
        System.currentPageReference().getparameters().put('recTypeId',ortid );
        Opportunity opp = new Opportunity();
        opp.name='test';
        opp.Aircraft_Platform__c = 'A320';
        opp.OTHER_Aircraft_Platform__c = 'Test';
        opp.StageName='Closed Won';
        opp.CUSTOMER_DEVICE_TYPE__c = 'Test';
        opp.Other_Products__c = 'tset';
        opp.EPIC__c = 'tset';
        opp.Other_category_of_IP__c = 'Test';
        opp.Win_Loss_Reason_Code__c='Technology';
        opp.EGPWSim_details__c = 'Test';
        opp.SIM_DEVICE_OWNER__c = 'Test';
        opp.PROJ_JOB_SER__c = 'Test';
        opp.Win_Loss_Reason_Text__c='test opp';
        opp.CloseDate= Date.newInstance(2016, 2, 1); 
        opp.HIPI_Accounts__c='CAE INC'; 
        opp.TS_Agreement_License__c = 'Test';
        List<User> userList = [select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' limit 1];
      //  opp.Record_Data_Owner__c = userList[0].Id;
        opp.LicenseDraft__c = true;
        opp.Final_Review__c = true;
        opp.Engineer_Manager_Review__c = true;
        opp.WorkbookComplete__c = true;
        opp.Account_manager_review__c = true;
        opp.Revenue_Recognized__c = true;
        opp.Workstop_Issue_Cleared__c = true;
        opp.InvoiceRequested__c = true;
        insert opp;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(opp);     
        MPMSIMLICENSEOppCloneCls MPM1= new MPMSIMLICENSEOppCloneCls (stdController); 
        MPM1.opp = opp;
        MPM1.CustomSave();
        MPM1.saveandnew();
    }
}
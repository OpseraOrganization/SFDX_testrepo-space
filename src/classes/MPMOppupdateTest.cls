@isTest(SeeAllData=true)
private class MPMOppupdateTest{
    public static testMethod void doget(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive=true limit 1 ];
        System.runAs(usr) 
        {
            Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR');
            insert acc;       
            Contact con = new Contact();
            con.LastName = 'testupdate';
            con.FirstName = 'sbucon';
            con.AccountId = acc.Id;
            con.Contact_Function__c='Infosys';
            con.Primary_Email_Address__c = 'sofiya.peermohamed@nttdata.com';
            insert con;       
            Platform__c p1=new Platform__c();
            p1.Name='Test Platform for MPM1';
            p1.Model__c='Test Model1';
            p1.Platform_Type__c='Airplane1';
            p1.Make__c='Airbus1';
            p1.Managing_SBU__c='ATR1';
            p1.OEM_Name__c=acc.id;
            insert p1;      
            Platform__c p=[select id,name,OEM_Name__c from Platform__c where OEM_Name__c != null limit 1];
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
            opp.LICENSE_PO__c='2563';
            //opp.OTHER_EXPORT_LICENSE_TAA_Required__c='other';
            opp.OTHER_EGPWSim_details__c='OTHER';
            //opp.EXPORT_LICENSE_TAA_Required__c='OTHER';
            opp.EGPWSim_details__c='OTHER';
            opp.OTHER_Simulator_HW_Config__c='other';
            opp.OTHER_DEVICE__c='other';
            opp.Simulator_HW_Config__c='OTHER';
            opp.DEVICE__c='OTHER';
            opp.QTY_OF_DEVICES__c ='4';
            opp.OTHER_LICENSE_CATEGORY__c='other';
            opp.OTHER_AGREEMENT_TYPE__c='other';
            opp.LICENSE_CATEGORY__c='PIA';
            opp.AGREEMENT_TYPE__c='OTHER';
            opp.License_fee_Breakdown__c='40';
            opp.LICENSE_FEE__c='30';
            opp.OTHER_A_C_Product_Status__c='other';
            opp.A_C_Product_Status__c='Development';
            //opp.EXPORT_LICENSE__c='Test';
            opp.CUSTOMER_LICENSE_NEED_DATE__c=date.parse('12/04/2016');
            opp.PRICING_APPROVAL_FILE_LINK__c='test';
            opp.HON_POC__c='Test';
            opp.PROJ_JOB_SER__c='test';
            opp.DEVICE_IDENTIFIER__c='';
            opp.SIM_DEVICE_OPERATOR_ADDRESS__c='';
            opp.SIM_DEVICE_OPERATOR__c='';
            opp.SIM_DEVICE_OWNER_ADDRESS__c='';
            opp.SIM_DEVICE_OWNER__c='Test Customer';
            opp.CUSTOMER_POC__c='';
            opp.OTHER_CUSTOMER_DEVICE_TYPE__c='';
            opp.OTHER_HON_DEVICE_TYPE__c='';
            opp.CUSTOMER_DEVICE_TYPE__c='OTHER';
            opp.PRODUCT_DESCRIPTION__c ='Automobile Products';
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
            opp.Deal_Status__c='Closed Lost';       
            opp.StageName='Closed Lost';
            opp.Win_Loss_Reason_Code__c='Technology';
            opp.Win_Loss_Reason_Text__c='test opp';
            opp.ATR_Actual_Close_Date__c=date.parse('04/13/2016');
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
            opp.Licensee__c='CAE INC';
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
            opp.Invoice__c='';
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
            opp.HIPI_Accounts__c='CAE INC'; 
            opp.Quote_Expiration_Date__c=date.parse('04/05/2016');
            opp.Platform__c=p.id;
            opp.InvoiceRequested__c =true ;
            opp.Final_review_comments__c='Product is defect free and reliable';
            opp.BusinessContact__c=usr.id;  
            Opp.Comments__c='Testing purpose' ;
            insert opp;
            opp.Submit_to_Licensing__c=true;
            update opp;             
            string opp1='';
            try{ 
                opportunity opp2=[select id,Opportunity_Number__c from opportunity where Opportunity_Number__c != null limit 1];
                if(opp2.Opportunity_Number__c != null)
                {
                    opp1=opp2.Opportunity_Number__c;
                    system.debug('----->opp num'+opp1);
                    if(opp1 !=null && opp1 !='')
                    {         
                        MPMOppupdate.MPMOppupdate(opp1,'101', 'Closed Won','','24234');
                    }
                }
            }        
            Catch(Exception e){}   
            opp.Deal_Status__c='Closed/Won';
            opp.StageName ='Closed Won';   
            update opp;
       }        
    }   
    public static testMethod void doget1(){    
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive=true limit 1 ];
        System.runAs(usr) 
        { 
        MPMOppupdate.MPMOppupdate('','', '','',''); 
        }       
    }
    public static testMethod void doget2(){    
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive=true limit 1 ];
        System.runAs(usr) 
        {
            opportunity opp2=[select id,Opportunity_Number__c from opportunity where Opportunity_Number__c != null limit 1];
            string opp1='';
            if(opp2.Opportunity_Number__c != null)
            {
                opp1=opp2.Opportunity_Number__c;
                system.debug('----->opp num'+opp1);
                if(opp1 !=null && opp1 !='')
                {         
                    MPMOppupdate.MPMOppupdate(opp1,'101', 'Closed Lost','','24234');
                }
            } 
            opp2.Deal_Status__c='Closed/Lost';
            opp2.StageName ='Closed Lost';   
            opp2.Reason_for_Closed_Lost__c = 'Undisclosed';
            opp2.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
            update opp2;
       }        
    } 
    /*static testmethod void doget3(){
        
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'D&S Sales API Spiral User' limit 1 ];
        User usr1 =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive=true limit 1 ];
        System.runAs(usr1) 
        {
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 
                
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity';
        opp1.SBU__c = 'D&S';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        //opp.opportunity_Type__c = 'Competitive';
        opp1.StageName = 'Cultivate';
        opp1.RecordtypeId='01230000000ZIv6';
        opp1.CloseDate = System.today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        //opp1.Platform__c = p.Id; 
        opp1.Active__c = TRUE;
        opp1.Certification_Requirements__c = 'FAR 15 Tina';
        opp1.Proposal_Complexity__c ='Pre-work initiated';
        opp1.Ship_Set_Quantity__c = 1;
        opp1.Ship_Set_Parts__c ='1234';
        opp1.ATR_Aircraft_Quantity__c = 1;
        opp1.Proposal_Complexity_Description__c = 'test';
        opp1.RFP_Expected_Date__c =System.today(); 
        opp1.Ship_Set_Delivery_Period__c= 'test';
        opp1.Is_Restricted_Opportunity__c = true;
        opp1.Is_Follow_On_Opportunity__c = true;
        opp1.Parent_Opportunity__c = [select id from opportunity WHERE Amount = 0 and SBU__c = 'D&S' and Win_Only_Opportunity__c = false limit 1].id; 
        opp1.Win_Only_Opportunity__c = true;
        opp1.Win_Loss_Amount__c = 10000;
        opp1.Win_Loss_Proposal_Amount__c =10000;
        opp1.Win_Probability__c = 100;
        opp1.Win_Loss_Reason_Text__c = 'test';
        opp1.StageName = 'Cultivate';
        Test.startTest();
        TriggerInactive.TestOppRequiredFields = true;
        //TriggerInactive.TestOppUpdate_UpdateStage = false;              
        insert opp1;   
        Test.stopTest();
        }
    } */  
}
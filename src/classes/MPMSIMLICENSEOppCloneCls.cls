/********************
Created By: NTTDATA
Use : This controller is used for the Cloning Opportunity Page.
*********************/
public without sharing class MPMSIMLICENSEOppCloneCls{
    public MPMSIMLICENSEOppCloneCls(ApexPages.StandardSetController controller) {}                       
    public string pickname{get;set;}
    public Decimal TotalSRO{get;set;}
    public Opportunity Opp {get;set;}   
    Public Opportunity Opp1{get;set;}
    Public String recordtypename{set;get;}
    
    public Boolean profileSubmitCheck{get; set;}
    public Boolean isOtherOEM {get;set;}
    
    Public String Clone1; 
    Public String firstName{set;get;}
    Public String lastName{set;get;}    
    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String ProflieName = PROFILE[0].Name;
    public Opportunity oppTemp{get;set;}
    public String AccountName{get;set;}
    public Id recordTypeId;
    List<RecordType> recTypeConList = [SELECT Id, Name FROM RecordType WHERE Name = 'HIPI LMS Contact'];    
    public List<RecordType> recTypeAccList;
    public String ID{get;set;}
    String OppyId= ApexPages.currentPage().getParameters().get('id');      
    
    public MPMSIMLICENSEOppCloneCls(ApexPages.StandardController controller) 
    {
        isOtherOEM  = false;
        Clone1= ApexPages.currentPage().getParameters().get('Cloneid'); 
        pickname = ApexPages.currentPage().getParameters().get('Oppid');       
        Opp = new Opportunity();
        TotalSRO = 0.00;
        opp1 = new Opportunity();   
        profileSubmitCheck = false;
        User userObj = [SELECT UserRole.Name, Profile.Name FROM User where ID = :UserInfo.getUserId() LIMIT 1];
        System.Debug('userObj:'+userObj);
        System.Debug('userObj.Profile.Name:'+userObj.Profile.Name);
        if(userObj.Profile.Name.equalsIgnoreCase('System Administrator') || userObj.Profile.Name.equalsIgnoreCase('Contract Admin')){
        profileSubmitCheck = true;
        } 
        if(pickname !=null){   
            try{
                opp1 = [select id,Name,Probability,RecordTypeID,Win_Loss_Reason_Text__c,If_Licensor_Other_Please_Specify__c,ATP_Approval_Date__c,Issue_Other_Than_Review__c,If_Restated_Prior_Contract_Number__c,ATN_Approval_Date__c,Are_Patents_Involved__c,Is_TLC_Approval_required__c,List_All_Patent_s_Country_i_e_US__c,Received_TLC_Approvals__c,Brand__c,Agmt_Subject_to_Export_Control__c,If_Brand_Other_Please_Specify__c,Agmts_Contains_Export_Controlled_Data__c,StageName,       
                Attorney_SBG__c,Licensee__c,Win_Loss_Reason_Code__c,Request_Contract_Number__c,CBT_HIPI__c,CBT_Team_HIPI__c,Licensor__c,OwnerId,contract_sub_type__c,Account_Contact_Name__c,Comments__c, HON_Lead_IP_Attorney__c,Contract_Type__c, If_Other_Enter_the_Name_of_Attorney__c,Contract_Title__c, Contract_Number__c,AccountId,DOS_Approval_Required__c,Deal_Status__c,DOS_Expiration_Date__c,CloseDate,DOS_Number__c,Automatic_Renewal__c,Country__c,Region1__c,Owner_SBG__c,Quote_Date__c,Who_quote_was_sent_to__c,Sim_License__c,LICENSEE_ADDRESS__c,PRICING_APPROVAL_ON_FILE__c,OTHER_LICENSEE_ADDRESS__c,OTHER_PRICING_APPROVAL_ON_FILE__c,HON_DEVICE_TYPE__c,CUSTOMER_DEVICE_TYPE__c,OTHER_HON_DEVICE_TYPE__c,OTHER_CUSTOMER_DEVICE_TYPE__c,CUSTOMER_POC__c,SIM_DEVICE_OWNER__c,SIM_DEVICE_OWNER_ADDRESS__c,SIM_DEVICE_OPERATOR__c,SIM_DEVICE_OPERATOR_ADDRESS__c,DEVICE_IDENTIFIER__c,PROJ_JOB_SER__c,QTY_OF_DEVICES__c,HON_POC__c,PRICING_APPROVAL_FILE_LINK__c,CUSTOMER_LICENSE_NEED_DATE__c,A_C_Product_Status__c,OTHER_A_C_Product_Status__c,LICENSE_FEE__c,License_fee_Breakdown__c,AGREEMENT_TYPE__c,LICENSE_CATEGORY__c,OTHER_AGREEMENT_TYPE__c,OTHER_LICENSE_CATEGORY__c,DEVICE__c,Simulator_HW_Config__c,OTHER_DEVICE__c,OTHER_Simulator_HW_Config__c,EGPWSim_details__c,OTHER_EGPWSim_details__c,LICENSE_PO_DATE__c,PRODUCT_DESCRIPTION__c,SOFTWARE_LOAD_VERSION__c,PART_NUMBER__c,TECHNICAL_SUPPORT_Hrs__c,TS_Agreement_License__c,HIPI_CONTRACT_NUMBER__c,EXPIRATION_DATE__c,HIPI_SBU__c,TYPE_OF_INVOICE__c,OTHER_TYPE_OF_INVOICE__c,A_LICENSED_SW__c,D_other__c,B_LICENSED_DATA__c,C_CONFIG_LIST__c,Total_Value_of_Agmt_K_Text__c,Value_in_Q1_K_Text__c,Contract_Term_In_Years__c,Value_in_Q2_K_Text__c,License_Fee_Waived_K_Text__c,Value_in_Q3_K_Text__c,Value_in_Current_Year_Jan_Dec_K__c,Value_in_Q4_K_Text__c,Commission_K_Text__c,Year_2__c,Commission_Agency__c,Year_4__c,Closed_Out_by_IP_Finance__c,Year_3__c,Year_5__c,Revenue_Structure__c,Value_Stream_Category__c,Date_Critical_Data_Delivery_Ship_RFT__c,PO_Received__c,Workbook__c,License_Draft__c,License_Review_Issue__c,License_Review__c,SFDC_Entry_Initiated__c,License_to_Customer__c,License_Back_From_Customer__c,License_Signed_Lic_CoE__c,Data_Shipped_ECM__c,Invoice_Requested__c,Invoice__c,PO__c,Workstop_Issue__c,Workstop_Issue_Cleared__c,Review_issue__c,Engineer_Manager_Review__c,Engineer_Manager_Review_Date__c,LicenseDraft__c,Final_Review__c,WorkbookComplete__c,Workbook_Complete__c,Information_for_Engg__c,Business_Contact__c,BusinessContact__c,Account_Contact_Name__r.lastname,Account_Contact_Name__r.firstname,Account_Contact_Name__r.name,Account_manager_review__c,Accountt_Manager_Review_Comments__c,Engg_Review_Comments__c,Revenue_Recognized__c,Revenue_Recognized_Date__c,Revenue_Recognition_Expected__c,Record_Data_Owner__c,Workstop_Issue_Cleared_date__c,OTHER_OEM__c,OEM__c,Other_category_of_IP__c,InvoiceRequested__c,Invoice_Requested_date__c,Quote__c,Quote_Follow_up_Date__c,Revision_Date__c,IP_Ownership_Outside_Honeywell_Intl__c,Other_IPOwnershipOutsideHoneywellIntl__c,Description_of_the_Deal__c,Special_Terms__c,HIPI_Accounts__c,Quote_Expiration_Date__c,Platform__c,Platform__r.name,Final_review_comments__c,License_Drafter__c,Final_Reviewer__c,Products__c,Other_Products__c,Aircraft_Platform__c,Deal_Requires_Hardware__c,Hardware_PO__c,ATN_Approval_Required__c,Process_Step__c,License_Need_date_per_PO__c,OTHER_Aircraft_Platform__c,Host_Volume_ID_MAC_Address__c,EPIC__c from Opportunity where id=:ApexPages.currentPage().getParameters().get('Oppid')];      
                ID recid = Opp1.RecordTypeID;
                Recordtype Rectype =[Select id,name,developername from RecordType where sObjecttype='Opportunity' AND  id =: recid  limit 1];
                recordtypename = Rectype.Name;
                Opp.RecordTypeID = recid ;
            }
            Catch(Exception e)
            { 
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));     
            }   
            opp.id = opp1.id;
            opp.Revenue_Structure__c=opp1.Revenue_Structure__c;
            opp.Year_5__c=opp1.Year_5__c;
            opp.Year_3__c=opp1.Year_3__c;
            opp.Win_Loss_Reason_Text__c=opp1.Win_Loss_Reason_Text__c;
            opp.Win_Loss_Reason_Code__c=opp1.Win_Loss_Reason_Code__c;
            opp.Closed_Out_by_IP_Finance__c=opp1.Closed_Out_by_IP_Finance__c;
            opp.Year_4__c=opp1.Year_4__c;
            opp.Commission_Agency__c=opp1.Commission_Agency__c;
            opp.Year_2__c=opp1.Year_2__c;
            opp.Commission_K_Text__c=opp1.Commission_K_Text__c;
            opp.Value_in_Q4_K_Text__c=opp1.Value_in_Q4_K_Text__c;
            opp.Value_in_Current_Year_Jan_Dec_K__c=opp1.Value_in_Current_Year_Jan_Dec_K__c;
            opp.Value_in_Q3_K_Text__c=opp1.Value_in_Q3_K_Text__c;
            opp.License_Fee_Waived_K_Text__c=opp1.License_Fee_Waived_K_Text__c;
            opp.Value_in_Q2_K_Text__c=opp1.Value_in_Q2_K_Text__c;
            opp.Contract_Term_In_Years__c=opp1.Contract_Term_In_Years__c;
            opp.Value_in_Q1_K_Text__c=opp1.Value_in_Q1_K_Text__c;
            opp.Record_Data_Owner__c=opp1.Record_Data_Owner__c;
            opp.C_CONFIG_LIST__c=opp1.C_CONFIG_LIST__c;                        
            opp.B_LICENSED_DATA__c=opp1.B_LICENSED_DATA__c;
            opp.A_LICENSED_SW__c=opp1.A_LICENSED_SW__c;
            opp.D_other__c=opp1.D_other__c;
            opp.OTHER_TYPE_OF_INVOICE__c=opp1.OTHER_TYPE_OF_INVOICE__c;
            //opp.OTHER_SBU__c=opp1.OTHER_SBU__c;
            opp.TYPE_OF_INVOICE__c=opp1.TYPE_OF_INVOICE__c;
            opp.HIPI_SBU__c=opp1.HIPI_SBU__c;
            opp.EXPIRATION_DATE__c=opp1.EXPIRATION_DATE__c;
            //opp.AGREEMENT_TERM__c=opp1.AGREEMENT_TERM__c;
            opp.HIPI_CONTRACT_NUMBER__c=opp1.HIPI_CONTRACT_NUMBER__c;
            opp.TS_Agreement_License__c=opp1.TS_Agreement_License__c;
            opp.TECHNICAL_SUPPORT_Hrs__c=opp1.TECHNICAL_SUPPORT_Hrs__c;
            opp.PART_NUMBER__c=opp1.PART_NUMBER__c;
            opp.Host_Volume_ID_MAC_Address__c=opp1.Host_Volume_ID_MAC_Address__c;
            opp.SOFTWARE_LOAD_VERSION__c=opp1.SOFTWARE_LOAD_VERSION__c;
            opp.PRODUCT_DESCRIPTION__c=opp1.PRODUCT_DESCRIPTION__c;
            opp.LICENSE_PO_DATE__c=opp1.LICENSE_PO_DATE__c;
            //opp.LICENSE_PO__c=opp1.LICENSE_PO__c;
            //opp.OTHER_EXPORT_LICENSE_TAA_Required__c=opp1.OTHER_EXPORT_LICENSE_TAA_Required__c;
            opp.OTHER_EGPWSim_details__c=opp1.OTHER_EGPWSim_details__c;
            //opp.EXPORT_LICENSE_TAA_Required__c=opp1.EXPORT_LICENSE_TAA_Required__c;
            opp.EGPWSim_details__c=opp1.EGPWSim_details__c;
            opp.OTHER_Simulator_HW_Config__c=opp1.OTHER_Simulator_HW_Config__c;
            opp.OTHER_DEVICE__c=opp1.OTHER_DEVICE__c;
            opp.Simulator_HW_Config__c=opp1.Simulator_HW_Config__c;
            opp.DEVICE__c=opp1.DEVICE__c;
            opp.OTHER_LICENSE_CATEGORY__c=opp1.OTHER_LICENSE_CATEGORY__c;
            opp.OTHER_AGREEMENT_TYPE__c=opp1.OTHER_AGREEMENT_TYPE__c;
            opp.LICENSE_CATEGORY__c=opp1.LICENSE_CATEGORY__c;
            opp.AGREEMENT_TYPE__c=opp1.AGREEMENT_TYPE__c;
            opp.License_fee_Breakdown__c=opp1.License_fee_Breakdown__c;
            opp.LICENSE_FEE__c=opp1.LICENSE_FEE__c;
            opp.OTHER_A_C_Product_Status__c=opp1.OTHER_A_C_Product_Status__c;
            //opp.OTHER_A_C_PLATFORM__c=opp1.OTHER_A_C_PLATFORM__c;
            opp.A_C_Product_Status__c=opp1.A_C_Product_Status__c;
            //opp.A_C_PLATFORM__c=opp1.A_C_PLATFORM__c;
            //opp.EXPORT_LICENSE__c=opp1.EXPORT_LICENSE__c;
            opp.CUSTOMER_LICENSE_NEED_DATE__c=opp1.CUSTOMER_LICENSE_NEED_DATE__c;
            opp.PRICING_APPROVAL_FILE_LINK__c=opp1.PRICING_APPROVAL_FILE_LINK__c;
            opp.HON_POC__c=opp1.HON_POC__c;
            opp.QTY_OF_DEVICES__c=opp1.QTY_OF_DEVICES__c;
            opp.PROJ_JOB_SER__c=opp1.PROJ_JOB_SER__c;
            opp.DEVICE_IDENTIFIER__c=opp1.DEVICE_IDENTIFIER__c;
            opp.SIM_DEVICE_OPERATOR_ADDRESS__c=opp1.SIM_DEVICE_OPERATOR_ADDRESS__c;
            opp.SIM_DEVICE_OPERATOR__c=opp1.SIM_DEVICE_OPERATOR__c;
            opp.SIM_DEVICE_OWNER_ADDRESS__c=opp1.SIM_DEVICE_OWNER_ADDRESS__c;
            opp.SIM_DEVICE_OWNER__c=opp1.SIM_DEVICE_OWNER__c;
            opp.CUSTOMER_POC__c=opp1.CUSTOMER_POC__c;
            opp.OTHER_CUSTOMER_DEVICE_TYPE__c=opp1.OTHER_CUSTOMER_DEVICE_TYPE__c;
            opp.OTHER_HON_DEVICE_TYPE__c=opp1.OTHER_HON_DEVICE_TYPE__c;
            opp.CUSTOMER_DEVICE_TYPE__c=opp1.CUSTOMER_DEVICE_TYPE__c;
            opp.HON_DEVICE_TYPE__c=opp1.HON_DEVICE_TYPE__c;
            opp.OTHER_PRICING_APPROVAL_ON_FILE__c=opp1.OTHER_PRICING_APPROVAL_ON_FILE__c;
            opp.OTHER_LICENSEE_ADDRESS__c=opp1.OTHER_LICENSEE_ADDRESS__c;
            opp.PRICING_APPROVAL_ON_FILE__c=opp1.PRICING_APPROVAL_ON_FILE__c;
            opp.LICENSEE_ADDRESS__c=opp1.LICENSEE_ADDRESS__c;
            opp.Owner_SBG__c=opp1.Owner_SBG__c;
            opp.Quote_Date__c=opp1.Quote_Date__c;
            opp.Who_quote_was_sent_to__c=opp1.Who_quote_was_sent_to__c;
            opp.Sim_License__c=opp1.Sim_License__c;
            opp.Region1__c=opp1.Region1__c;
            opp.Automatic_Renewal__c=opp1.Automatic_Renewal__c;
            opp.Country__c=opp1.Country__c;
            opp.DOS_Number__c=opp1.DOS_Number__c;
            opp.CloseDate=opp1.CloseDate;
            opp.DOS_Expiration_Date__c=opp1.DOS_Expiration_Date__c;
            opp.Deal_Status__c=opp1.Deal_Status__c;
            opp.DOS_Approval_Required__c=opp1.DOS_Approval_Required__c;
            opp.StageName=opp1.StageName;
            opp.Brand__c=opp1.Brand__c;
            opp.Agmts_Contains_Export_Controlled_Data__c=opp1.Agmts_Contains_Export_Controlled_Data__c;
            opp.If_Brand_Other_Please_Specify__c=opp1.If_Brand_Other_Please_Specify__c;
            opp.Agmt_Subject_to_Export_Control__c=opp1.Agmt_Subject_to_Export_Control__c;
            opp.Are_Patents_Involved__c=opp1.Are_Patents_Involved__c;
            opp.Is_TLC_Approval_required__c=opp1.Is_TLC_Approval_required__c;
            opp.Received_TLC_Approvals__c=opp1.Received_TLC_Approvals__c;
            Opp.Name = Opp1.Name;
            opp.List_All_Patent_s_Country_i_e_US__c=opp1.List_All_Patent_s_Country_i_e_US__c;
            Opp.Probability =Opp1.Probability ;       
            Opp.Licensor__c =Opp1.Licensor__c ;
            Opp.Attorney_SBG__c=Opp1.Attorney_SBG__c ;
            opp.Request_Contract_Number__c=opp1.Request_Contract_Number__c; 
            opp.If_Licensor_Other_Please_Specify__c=opp1.If_Licensor_Other_Please_Specify__c;
            opp.Licensee__c=opp1.Licensee__c;
            opp.HON_Lead_IP_Attorney__c=opp1.HON_Lead_IP_Attorney__c;
            opp.Contract_Type__c=opp1.Contract_Type__c;
            opp.If_Other_Enter_the_Name_of_Attorney__c=opp1.If_Other_Enter_the_Name_of_Attorney__c;
            opp.Contract_Title__c=opp1.Contract_Title__c;
            opp.Account_Contact_Name__c=opp1.Account_Contact_Name__c;           
            Opp.contract_sub_type__c = Opp1.contract_sub_type__c;
            opp.Contract_Number__c=opp1.Contract_Number__c;
            opp.If_Restated_Prior_Contract_Number__c=opp1.If_Restated_Prior_Contract_Number__c;
            opp.ATN_Approval_Date__c=opp1.ATN_Approval_Date__c;
            opp.ATP_Approval_Date__c=opp1.ATP_Approval_Date__c;
            opp.Value_Stream_Category__c=opp1.Value_Stream_Category__c;
            opp.Date_Critical_Data_Delivery_Ship_RFT__c=opp1.Date_Critical_Data_Delivery_Ship_RFT__c;
            opp.Issue_Other_Than_Review__c=opp1.Issue_Other_Than_Review__c;
            opp.PO_Received__c=opp1.PO_Received__c;
            opp.Workbook__c=opp1.Workbook__c;
           // opp.IP_Approval__c=opp1.IP_Approval__c;
            opp.LicenseDraft__c=opp1.LicenseDraft__c;
            opp.License_Review_Issue__c=opp1.License_Review_Issue__c;
            opp.Final_Review__c=opp1.Final_Review__c;
            opp.WorkbookComplete__c=opp1.WorkbookComplete__c;
            opp.Information_for_Engg__c=opp1.Information_for_Engg__c;
            opp.Engineer_Manager_Review__c=opp1.Engineer_Manager_Review__c;
            opp.SFDC_Entry_Initiated__c=opp1.SFDC_Entry_Initiated__c;
            opp.License_to_Customer__c=opp1.License_to_Customer__c;
            opp.License_Back_From_Customer__c=opp1.License_Back_From_Customer__c;
            opp.License_Signed_Lic_CoE__c=opp1.License_Signed_Lic_CoE__c;
            opp.Data_Shipped_ECM__c=opp1.Data_Shipped_ECM__c;
            opp.Invoice_Requested__c=opp1.Invoice_Requested__c;
            opp.OEM__c=opp1.OEM__c;
            //opp.Airline_End_Customer__c=opp1.Airline_End_Customer__c;
            //opp.FFS_or_LLD__c=opp1.FFS_or_LLD__c;
            opp.EPIC__c=opp1.EPIC__c;
            //opp.New_or_Update_or_Upgrade__c=opp1.New_or_Update_or_Upgrade__c;
            opp.Invoice__c=opp1.Invoice__c;
            opp.PO__c=opp1.PO__c;
            //opp.Revenue_SBU__c=opp1.Revenue_SBU__c;
            opp.Workstop_Issue__c=opp1.Workstop_Issue__c;
            opp.Workstop_Issue_Cleared__c=opp1.Workstop_Issue_Cleared__c;
            opp.Review_issue__c=opp1.Review_issue__c;
            opp.OwnerId=Opp1.OwnerId;
            opp.Account_manager_review__c=opp1.Account_manager_review__c;
            opp.Accountt_Manager_Review_Comments__c=opp1.Accountt_Manager_Review_Comments__c;
            opp.Engg_Review_Comments__c=opp1.Engg_Review_Comments__c;
            opp.Revenue_Recognized__c=opp1.Revenue_Recognized__c;
            opp.Revenue_Recognition_Expected__c=opp1.Revenue_Recognition_Expected__c;
            opp.OTHER_OEM__c=opp1.OTHER_OEM__c;
            opp.Other_category_of_IP__c=opp1.Other_category_of_IP__c;
            opp.Invoice_Requested__c=opp1.Invoice_Requested__c;
            opp.Quote__c=opp1.Quote__c;
            opp.Quote_Follow_up_Date__c=opp1.Quote_Follow_up_Date__c;
            //opp.PO_Revision__c=opp1.PO_Revision__c;
            opp.Revision_Date__c=opp1.Revision_Date__c;
            opp.Description_of_the_Deal__c=opp1.Description_of_the_Deal__c;
            opp.Special_Terms__c=opp1.Special_Terms__c;
            opp.IP_Ownership_Outside_Honeywell_Intl__c=opp1.IP_Ownership_Outside_Honeywell_Intl__c;
            opp.Other_IPOwnershipOutsideHoneywellIntl__c=opp1.Other_IPOwnershipOutsideHoneywellIntl__c;
            opp.HIPI_Accounts__c=opp1.HIPI_Accounts__c; 
            opp.Quote_Expiration_Date__c=opp1.Quote_Expiration_Date__c;
            opp.Platform__c=opp1.Platform__c;
            opp.InvoiceRequested__c =opp1.InvoiceRequested__c ;
            opp.Final_review_comments__c=opp1.Final_review_comments__c;
            opp.BusinessContact__c=opp1.BusinessContact__c;         
            User u = [select firstname,lastname from user where id = :Opp1.OwnerId];
            firstName = u.firstname;
            lastname  = u.lastname ;  
            Opp.Comments__c=Opp1.Comments__c ;
            OEM=opp1.OEM__c;
            opp.CBT_HIPI__c=opp1.CBT_HIPI__c; 
            opp.CBT_Team_HIPI__c=opp1.CBT_Team_HIPI__c;    
            opp.Products__c=opp1.Products__c;
            opp.Other_Products__c=opp1.Other_Products__c;             
            opp.License_Drafter__c=opp1.License_Drafter__c;
            //opp.Date_Drafted__c=opp1.Date_Drafted__c;
            opp.Final_Reviewer__c=opp1.Final_Reviewer__c;     
            opp.Aircraft_Platform__c = opp1.Aircraft_Platform__c;
            opp.Deal_Requires_Hardware__c= opp1.Deal_Requires_Hardware__c;
            opp.Hardware_PO__c= opp1.Hardware_PO__c;
            opp.ATN_Approval_Required__c = opp1.ATN_Approval_Required__c ;
            opp.License_Need_date_per_PO__c= opp1.License_Need_date_per_PO__c;
            opp.OTHER_Aircraft_Platform__c = opp1.OTHER_Aircraft_Platform__c;
            //opp.Process_Step1__c = opp1.Process_Step1__c;
            opp.Workbook_Complete__c = opp1.Workbook_Complete__c;
            opp.License_Draft__c = opp1.License_Draft__c ;
            if(opp.OEM__c != null && opp.OEM__c.containsIgnoreCase('Other'))
            {
                isOtherOEM = true;  
            }
            
        }  
        Id OpportunityId = ApexPages.currentPage().getParameters().get('Oppid');
        System.debug('id:'+OpportunityId);
    }
    //This Method is for getting Unique Licensee Names
    public Void changelicensee() {   
       Opp.Licensee__c = opp.HIPI_Accounts__c;             
        List<S2SFRestService__c> restAPIProps = new List<S2SFRestService__c>();
        restAPIProps = S2SFRestService__c.getALL().values() ;
        S2SFRestService__c objS2SF = new S2SFRestService__c();
        if(restAPIProps.size()>0)
        {
            objS2SF = restAPIProps[0];
        }           
        String clientId =objS2SF.client_Id__c;
        String clientSecret = objS2SF.Secret_Id__c;
        String username=objS2SF.User_Name__c;
        String password=objS2SF.Password__c;   
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;           
        HttpRequest req = new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');  
        req.setTimeout(120000);  
        req.setEndpoint(objS2SF.OAuth2End_Point__c);       
        Http h = new Http();
        HttpResponse res = new HttpResponse();
        String resBody;
        String resMsg;
        String resBody1;      
        if(!Test.isRunningTest())       
        {
            res = h.send(req);
            resBody = res.getbody();
            resMsg = res.getStatus();
        }
        else{
            resBody = '{"access_token":"00D560000008mxZ!ARIAQAm6ceQGeloxsMyLmmPPj_ZM3VOVkR8mVR7jR03ML1jq.YV9iU3AMwk94Gnfqx4EaFBjgOpIHyoLfbc9o7CjaqYH.Hhx","instance_url":"https://cs42.salesforce.com","id":"https://test.salesforce.com/id/00D560000008mxZEAQ/005a0000009Lhn6AAC","token_type":"Bearer","issued_at":"1453358389670","signature":"OkGVCiTOySRyf6hJ5A8rfoauHsZCGse4AGQkQZtqRq4="}';
            resMsg = 'ok';
        }
        OAuth2 objAuthenticationInfo = (OAuth2)JSON.deserialize(resBody, OAuth2.class);         
        HttpRequest req1 = new HttpRequest();
        Map<string,RestAPIEndPoint__c> mapEndPointURLs = new Map<String,RestAPIEndPoint__c>();
        mapEndPointURLs = RestAPIEndPoint__c.getAll();        
        if(mapEndPointURLs.size()>0)
        {
            
            req1.setEndpoint(mapEndPointURLs.get('CreateOpportunityEndPointURL2').EndPointURL__c); 
        }
        req1.setHeader('Content-Type','application/json;charset=UTF-8');
        req1.setHeader('Authorization','Bearer '+objAuthenticationInfo.access_token);        
        req1.setMethod('POST');
        HttpResponse res1 = new HttpResponse();
        Http httpCall1 = new Http();             
        if(opp.HIPI_Accounts__c!=null){
            
            string accname='';           
            accname=opp.HIPI_Accounts__c;           
            String body = '{"HIPIAccountName":"'+opp.HIPI_Accounts__c +'"}';
            system.debug('body----->'+body);
            req1.setBody(body);                    
            try{
                if(!Test.isRunningTest()){
                    res1 = httpCall1.send(req1);
                    resBody1 = res.getbody();
                }
                else{
                    resBody1 = '[{"attributes":{"type":"Opportunity","url":"/services/data/v35.0/sobjects/Opportunity/006e000000BhdttAAB"},"Id":"006e000000BhdttAAB","Name":"(SC-04) MSC CASE-11892500","Contract_Type__c":"Tech Pub","Contract_Title__c":"Test Take 5 UAT","Description":"test","Comments__c":"Account Name:DUNCAN AVIATION INC - LINCOLN\nAccount Type:Dealer\nAccount Address:3701 Aviation Rd  Lincoln Airport  , Lincoln, NE, USA\nContactName:Venkatesh Athanti\nPrimary Work Number:128806558\nPrimary Email Address:venkatesh.athanti@honeywell.com.qa"}]';
                }
            }
            catch(exception ex){
                system.debug('inside exceptiom'+ex.getMessage());               
            }
            if(resMsg =='ok')
            {
                String FileNames ='';
                string Filename1;
                string Filename2;
                string Filename3;
                string Filename4;
                string Filename5;
                string Filename6;
                string Filename7;
                JSONParser parser = JSON.createParser(res1.getBody());   //Pass your response string here    
                System.debug('parser>>>>>>'+ parser);
                while(parser.nextToken() != null) 
                {
                    System.debug('Parser1>>');
                    System.debug('parser.getCurrentToken>>'+parser.getCurrentToken());
                    System.debug('JSONToken.FIELD_NAME>>'+JSONToken.FIELD_NAME);
                    System.debug('JSONToken.VALUE_STRING>>'+JSONToken.VALUE_STRING);              
                    String fieldName1 = parser.getText();
                    System.debug('BeforeFields1>>'+fieldName1);
                    if (parser.getCurrentToken() == JSONToken.START_ARRAY){
                    
                        String fieldName2 = parser.getText();
                        System.debug('BeforeFields2>>'+fieldName2);  
                        while(parser.nextToken() != null){
                            String fieldName3 = parser.getText();
                            System.debug('BeforeFields3>>'+fieldName3);                                
                            String fieldName = parser.getText();
                                if (fieldName == 'Address_Name__c') {
                                    parser.nextToken();                                   
                                    Filename1 = parser.getText();
                                    if(Filename1!=null && Filename1!='' )
                                    FileNames+= Filename1+',';                   
                                    System.debug('Filename Type>>'+Filename1);
                                    System.debug('FileNames1>>'+FileNames);
                                    }
                                    else if (fieldName == 'Address_Line_1__c') {
                                        parser.nextToken();
                                        Filename2 = parser.getText();
                                        if(Filename2!=null && Filename2!='' )
                                        System.debug('Filename Type>>'+Filename2);
                                        FileNames+= Filename2+',';
                                        }
                                        else if (fieldName == 'Address_Line_2__c') {
                                            parser.nextToken();
                                            Filename3 = parser.getText();
                                            if(Filename3!=null && Filename3!='' )
                                            System.debug('Filename Type>>'+Filename3);
                                            FileNames+= Filename3+',';
                                            }
                                            else if (fieldName == 'City__c') {
                                                parser.nextToken();
                                                Filename4 = parser.getText();
                                                if(Filename4!=null && Filename4!='' )
                                                FileNames+= Filename4+',';
                                                System.debug('Filename Type>>'+Filename4);
                                                }
                                                else if (fieldName == 'State__c') {
                                                    parser.nextToken();
                                                    Filename5 = parser.getText();
                                                    if(Filename5!=null && Filename5!='' )
                                                    FileNames+= Filename5+',';
                                                    System.debug('Filename Type>>'+Filename5);
                                                    }
                                                    else if (fieldName == 'Telephone__c') {
                                                         parser.nextToken();
                                                         Filename6 = parser.getText();
                                                         if(Filename6!=null && Filename6!='' )
                                                         FileNames+= Filename6+',';
                                                         System.debug('Filename Type>>'+Filename6);
                                                         }
                                                         else if (fieldName == 'Type__c') {
                                                             parser.nextToken();
                                                             Filename7 = parser.getText();
                                                             if(Filename7!=null && Filename7!='' )
                                                             FileNames+= Filename7;
                                                             System.debug('FileNames>>'+ Filename7);
                                                             System.debug('FileNames>>'+ FileNames);
                                                             opp.LICENSEE_ADDRESS__c=FileNames;
                                                             System.debug('FileNames>>'+ FileNames);                                                              
                                                            }
    
                        }   
                    }
                }    
            } 
        JSONParser parser = JSON.createParser(resBody1);                       
        }            
    }   
    public Void MyMethod(){
        system.debug(ApexPages.currentPage().getParameters().get('Oppid')+' test my method');
       pickname=ApexPages.currentPage().getParameters().get('Oppid');           
    }
    
     Date today1 = date.valueof(system.today());        
    public pagereference CustomSave(){
        Id Oppid = ApexPages.currentPage().getParameters().get('Oppid');
        string name='';
        system.debug('Opp.Platform__c----->'+Opp.Platform__c);
        system.debug('Opp.Platform__r.name----->'+Opp.Platform__r.name);
        /*if(Opp.Platform__c!=null )
        {
            Platform__c pl=[select id,name,OEM_Name__c,OEM_Name__r.name from Platform__c where id=:opp.Platform__c];
            if(pl.name != null)
            {
               Name+=pl.name+'_';
            }
            Opp.OEM__c = pl.OEM_Name__r.name;               
        } 
        */
        if(opp.Aircraft_Platform__c !=null){
        Name+=opp.Aircraft_Platform__c+'_';
        string AircraftName =opp.Aircraft_Platform__c;    
        OEM = MPMAircraftPlatform__c.getvalues(AircraftName).OEM__c; 
        Opp.OEM__c =OEM; 
        }
        if(opp.OTHER_Aircraft_Platform__c!=null){
        Name+=opp.OTHER_Aircraft_Platform__c+'_';
        }     
        if(opp.CUSTOMER_DEVICE_TYPE__c!=null && opp.CUSTOMER_DEVICE_TYPE__c!= '')
        {
          Name+=opp.CUSTOMER_DEVICE_TYPE__c+''; 
        }       
        /*if(opp.PRODUCT_DESCRIPTION__c !=null && opp.PRODUCT_DESCRIPTION__c != '')
        {
          Name+=opp.PRODUCT_DESCRIPTION__c+''; 
        }   */
         if(opp.Products__c  !=null && opp.Products__c != '')
        {
          Name+=opp.Products__c +''; 
        } 
         if(opp.Other_Products__c!=null && opp.Other_Products__c!= '')
        {
          Name+=opp.Other_Products__c+''; 
        }        
        if(opp.EGPWSim_details__c !=null && opp.EGPWSim_details__c!= '')
        {
          Name+=opp.EGPWSim_details__c+''; 
        }       
        if(opp.SIM_DEVICE_OWNER__c!=null && opp.SIM_DEVICE_OWNER__c!= '')
        {
          Name+=opp.SIM_DEVICE_OWNER__c+''; 
        }    
        if(opp.QTY_OF_DEVICES__c !=null && opp.QTY_OF_DEVICES__c != '')
        {
          Name+=opp.QTY_OF_DEVICES__c+''; 
        }      
        if(opp.PROJ_JOB_SER__c !=null && opp.PROJ_JOB_SER__c != '')
        {
          Name+=opp.PROJ_JOB_SER__c+''; 
        }
        if(opp.TS_Agreement_License__c !=null && opp.TS_Agreement_License__c != '')
        {
          Name+=opp.TS_Agreement_License__c+''; 
        }       
        if(Name!= null && Name!= ''){
           // opp.name = Name;
        }
        if(opp.Aircraft_Platform__c != Null && opp.Aircraft_Platform__c != '')
        {
            if(!opp.Aircraft_Platform__c.containsIgnoreCase('Other'))
            {
                opp.OTHER_Aircraft_Platform__c='';
                Opp.OTHER_OEM__c = '';
            }
        }
        
        if((opp.A_C_Product_Status__c == null || opp.A_C_Product_Status__c  == '') || opp.A_C_Product_Status__c != null && opp.A_C_Product_Status__c  != '' && !opp.A_C_Product_Status__c.containsIgnoreCase('Other'))
        {
            opp.OTHER_A_C_Product_Status__c = '';
        }
        
        if((opp.Products__c == Null || opp.Products__c == '') || (opp.Products__c != Null && opp.Products__c != '' && !opp.Products__c.containsIgnoreCase('Other')))
        {
            opp.Other_Products__c ='';
        }
        
        if((opp.EPIC__c == Null || opp.EPIC__c == '') || (opp.EPIC__c != Null && opp.EPIC__c != '' && !opp.EPIC__c.containsIgnoreCase('Other')))
        {
            opp.Other_category_of_IP__c='';
        }
              
        if((opp.HON_DEVICE_TYPE__c == null || opp.HON_DEVICE_TYPE__c == '') || (opp.HON_DEVICE_TYPE__c != null && opp.HON_DEVICE_TYPE__c != '' && !opp.HON_DEVICE_TYPE__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_HON_DEVICE_TYPE__c = '';
        }        
        
        if((opp.CUSTOMER_DEVICE_TYPE__c == null || opp.CUSTOMER_DEVICE_TYPE__c == '') || (opp.CUSTOMER_DEVICE_TYPE__c != null && opp.CUSTOMER_DEVICE_TYPE__c != '' && !opp.CUSTOMER_DEVICE_TYPE__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_CUSTOMER_DEVICE_TYPE__c = '';
        }
        
        if((opp.AGREEMENT_TYPE__c == null  || opp.AGREEMENT_TYPE__c == '') || (opp.AGREEMENT_TYPE__c != null && opp.AGREEMENT_TYPE__c != '' && !opp.AGREEMENT_TYPE__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_AGREEMENT_TYPE__c = '';
        }
        
        if((opp.DEVICE__c == null  || opp.DEVICE__c == '') || (opp.DEVICE__c != null && opp.DEVICE__c != '' && !opp.DEVICE__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_DEVICE__c = '';
        }    
        
        if((opp.LICENSE_CATEGORY__c == null  || opp.LICENSE_CATEGORY__c == '') || (opp.LICENSE_CATEGORY__c != null && opp.LICENSE_CATEGORY__c != '' && !opp.LICENSE_CATEGORY__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_LICENSE_CATEGORY__c = '';
        }
        
        if((opp.Simulator_HW_Config__c == null  || opp.Simulator_HW_Config__c == '') || (opp.Simulator_HW_Config__c != null && opp.Simulator_HW_Config__c != '' && !opp.Simulator_HW_Config__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_Simulator_HW_Config__c = '';
        }
        
        if((opp.TYPE_OF_INVOICE__c == null  || opp.TYPE_OF_INVOICE__c == '') || (opp.TYPE_OF_INVOICE__c != null && opp.TYPE_OF_INVOICE__c != '' && !opp.TYPE_OF_INVOICE__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_TYPE_OF_INVOICE__c = '';
        }
             
        if((opp.EGPWSim_details__c == Null || opp.EGPWSim_details__c == '') || (opp.EGPWSim_details__c != Null && opp.EGPWSim_details__c != '' && !opp.EGPWSim_details__c.containsIgnoreCase('Other')))
        {
            opp.OTHER_EGPWSim_details__c='';
        }
        if(opp.BusinessContact__c != null)
        {
            user u=[select id,name from user where id=:opp.BusinessContact__c];
            if(u.name != null)
            opp.Business_Contact__c=u.name;
        }
        if(opp.Record_Data_Owner__c != null)
        {
            contact con=[select id,name from contact where id=:opp.Record_Data_Owner__c];
            if(con.name != null)
            opp.Appendix_Review_Engineer_Name__c=con.name;
        }
        system.debug('opp1.LicenseDraft__c---->'+opp1.LicenseDraft__c);
        system.debug('opp1.Final_Review__c---->'+opp1.Final_Review__c);
        system.debug('opp1.Engineer_Manager_Review__c---->'+opp1.Engineer_Manager_Review__c);
        system.debug('opp1.WorkbookComplete__c---->'+opp1.WorkbookComplete__c);
        system.debug('opp1.Account_manager_review__c---->'+opp1.Account_manager_review__c);
        system.debug('opp1.Revenue_Recognized__c---->'+opp1.Revenue_Recognized__c);
        if(opp1.LicenseDraft__c == false && opp.LicenseDraft__c == true)
        {
            opp.License_Draft__c = today1;
        }else        
        if(opp1.Final_Review__c == false && opp.Final_Review__c == true)
        {
            opp.License_Review__c = today1;
        }
        if(opp.Engineer_Manager_Review__c == true && opp1.Engineer_Manager_Review__c == false)
        {
            opp.Engineer_Manager_Review_Date__c = today1;
        }
        if(opp.WorkbookComplete__c == true && opp1.WorkbookComplete__c == false)
        {
            opp.Workbook_Complete__c = today1;
        }
        if(opp.Account_manager_review__c == true && opp1.Account_manager_review__c == false)
        {
            opp.Account_manager_review_Date__c = today1;
        }
        if(opp.Revenue_Recognized__c == true && opp1.Revenue_Recognized__c == false)
        {
            opp.Revenue_Recognized_Date__c = today1;
        }
        if(opp.Workstop_Issue_Cleared__c == true && opp1.Workstop_Issue_Cleared__c == false)
        {
            opp.Workstop_Issue_Cleared_date__c=today1;
        } 
        if(opp.InvoiceRequested__c == true && opp1.InvoiceRequested__c == false)  
        {
            opp.Invoice_Requested_date__c = today1;
        }
        if(opp.License_Need_date_per_PO__c != null && opp.CUSTOMER_LICENSE_NEED_DATE__c == Null){
        opp.CUSTOMER_LICENSE_NEED_DATE__c = opp.License_Need_date_per_PO__c ;   
        }
        //opp.Lead_Description__c = opp1.Process_Step__c;
        /*if(opp.HIPI_CONTRACT_NUMBER__c != null){
            opp.Request_Contract_Number__c = false;
        }*/
        system.debug('license feee value---'+opp.LICENSE_FEE__c);       
        integer valuesum;
        integer value1=0;
        integer value2=0;
        integer value3=0;
        integer value4=0;
        
        /*if(opp.Value_in_Q1_K_Text__c != null)
        value1=integer.valueof(opp.Value_in_Q1_K_Text__c);
        if(opp.Value_in_Q2_K_Text__c != null)
        value2=integer.valueof(opp.Value_in_Q2_K_Text__c);
        if(opp.Value_in_Q3_K_Text__c != null)
        value3=integer.valueof(opp.Value_in_Q3_K_Text__c);
        if(opp.Value_in_Q4_K_Text__c != null)
        value4=integer.valueof(opp.Value_in_Q4_K_Text__c);
        system.debug('license  value1---'+value1);
        valuesum=value1+value2+value3+value4;
        system.debug('license sum value---'+valuesum);
        if(opp.LICENSE_FEE__c != null)
        {
            integer licensefee=0;
            licensefee=integer.valueof(opp.LICENSE_FEE__c);
            if(licensefee != valuesum)  
            {
                system.debug('inside license sum');
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'SUM of Financial Information is not equal to LICENSE FEE ($K)');
                ApexPages.addMessage(myMsg);
                return null;            
            }
        }*/           
        try{
            if(Clone1=='1'){
                Opp.id = null;
                insert Opp;
            }
            else{
                if((Opp.StageName =='Closed/Won')|| (Opp.Deal_Status__c == 'Closed/Won'))
                {
                    Opp.StageName ='Closed/Won';
                    Opp.Deal_Status__c = 'Closed/Won';
                }
                System.debug('Update:'+opp);
                opp.Id = Oppid;
                Update Opp;
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/'+Opp.id);                          
    }   
    public pagereference saveandnew(){   
        Id Oppid = ApexPages.currentPage().getParameters().get('Oppid');
        string name='';
        String newString;
        /*if(Opp.Platform__c!=null )
        {
            Platform__c pl=[select id,name from Platform__c where id=:opp.Platform__c];
            if(pl.name != null)
               Name+=pl.name+'_'; 
        }   
        */
        if(opp.Aircraft_Platform__c !=null){
        Name+=opp.Aircraft_Platform__c+'_';
        string AircraftName =opp.Aircraft_Platform__c;      
        OEM = MPMAircraftPlatform__c.getvalues(AircraftName).OEM__c; 
        Opp.OEM__c =OEM; 
        }   
              
        if(opp.CUSTOMER_DEVICE_TYPE__c!=null && opp.CUSTOMER_DEVICE_TYPE__c!= '')
        {
          Name+=opp.CUSTOMER_DEVICE_TYPE__c+''; 
        }       
        /*if(opp.PRODUCT_DESCRIPTION__c !=null && opp.PRODUCT_DESCRIPTION__c != '')
        {
          Name+=opp.PRODUCT_DESCRIPTION__c+''; 
        }  */ 
        if(opp.Products__c  !=null && opp.Products__c != '')
        {
          Name+=opp.Products__c +''; 
        }       
        if(opp.EGPWSim_details__c !=null && opp.EGPWSim_details__c!= '')
        {
          Name+=opp.EGPWSim_details__c+''; 
        }       
        if(opp.SIM_DEVICE_OWNER__c!=null && opp.SIM_DEVICE_OWNER__c!= '')
        {
          Name+=opp.SIM_DEVICE_OWNER__c+''; 
        }    
        if(opp.QTY_OF_DEVICES__c !=null && opp.QTY_OF_DEVICES__c != '')
        {
          Name+=opp.QTY_OF_DEVICES__c+''; 
        }      
        if(opp.PROJ_JOB_SER__c !=null && opp.PROJ_JOB_SER__c != '')
        {
          Name+=opp.PROJ_JOB_SER__c+''; 
        }
        if(opp.TS_Agreement_License__c !=null && opp.TS_Agreement_License__c != '')
        {
          Name+=opp.TS_Agreement_License__c+''; 
        } 
              
        if(Name!= null && Name!= ''){
            //opp.name = Name;
            newString = Name.substring(0,Name.length()-1); 
            opp.name = newString;
        }
        if(opp.BusinessContact__c != null)
        {
            user u=[select id,name from user where id=:opp.BusinessContact__c];
            if(u.name != null)
            opp.Business_Contact__c=u.name;
        }
        if(opp.Record_Data_Owner__c != null)
        {
            contact con=[select id,name from contact where id=:opp.Record_Data_Owner__c];
            if(con.name != null)
            opp.Appendix_Review_Engineer_Name__c=con.name;
        }
        if(opp1.LicenseDraft__c == false && opp.LicenseDraft__c == true)
        {
            opp.License_Draft__c = today1;
        }
        if(opp1.Final_Review__c == false && opp.Final_Review__c == true)
        {
            opp.License_Review__c = today1;
        }
        if(opp.Engineer_Manager_Review__c == true && opp1.Engineer_Manager_Review__c == false)
        {
            opp.Engineer_Manager_Review_Date__c = today1;
        }
        if(opp.WorkbookComplete__c == true && opp1.WorkbookComplete__c == false)
        {
            opp.Workbook_Complete__c = today1;
        }
        if(opp.Account_manager_review__c == true && opp1.Account_manager_review__c == false)
        {
            opp.Account_manager_review_Date__c = today1;
        }
        if(opp.Revenue_Recognized__c == true && opp1.Revenue_Recognized__c == false)
        {
            opp.Revenue_Recognized_Date__c = today1;
        }
        if(opp.Workstop_Issue_Cleared__c == true && opp1.Workstop_Issue_Cleared__c == false)
        {
            opp.Workstop_Issue_Cleared_date__c=today1;
        }
        if(opp.InvoiceRequested__c == true  && opp1.InvoiceRequested__c == false)  
        {
            opp.Invoice_Requested_date__c = today1;
        }
       // Opp.OEM__c = OEM;       
        try{
            if(Clone1=='1')
            {
            Opp.id = null;
            insert Opp;
            }
            else
            {
            opp.Id = Oppid;
            Update Opp;
            }
        }
        catch(Exception e){
        ApexPages.addMessages(e);
        return null;
        }  
        PageReference pageRef = new PageReference(label.M_PM_Page_Reference);       
        pageRef.setRedirect(false);
        return pageRef;      
    }
    // Defining the Cancel() method
    public pagereference Cancel(){                 
            return new pagereference('/'+pickname);                     
    }           
    public void reset(){
        Opp = new Opportunity();
    }
    public String OEM {get;set;}
    public string setOEM() {                    
        return OEM;
    }
    public string getOEM() {               
        OEM=opp.OEM__c;
        return OEM;
    }
    public Void changelicenseePlatform() {
        //Opp.OEM__c = opp.Platform__c;
       /* Platform__c pl=[select id,name,OEM_Name__c,OEM_Name__r.name from Platform__c where id=:opp.Platform__c];
        OEM=pl.OEM_Name__r.name;    
        */
        isOtherOEM = false;
        string Name =opp.Aircraft_Platform__c;      
        OEM = MPMAircraftPlatform__c.getvalues(Name).OEM__c;
        if(opp.Aircraft_Platform__c.containsIgnoreCase('Other'))
        {
            isOtherOEM = true;  
        }
    }
}
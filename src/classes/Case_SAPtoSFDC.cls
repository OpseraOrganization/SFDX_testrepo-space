/**************************Change Log*****************************
Date        Name         Description
8-21-2014   Shrivaths    Change in Origin - AERO.Aero_SAP - Defect #87886 
******************************************************************/
global class Case_SAPtoSFDC{
    
    // Create the variables to be integrated with PI(SAP)
    global class CaseData{
        webservice string dateTimeOpened_RMDAT;
        webservice string url_CQCP;
        webservice string additionalDesc_EVENT_CATEGORY;
        webservice string accountName_KUNNR;
        webservice string aircraftType;// Added per new mapping list
        webservice string aircraftTailNumber;
        webservice string aircraftSerialNumber;
        webservice string aircraftLocation;// Added per new mapping list
        webservice string productNumber_MATNR;
        webservice string productSerialNumber_SERIALNR;
        webservice string subject_YYINCIDENT_DESCR;
        webservice string description;
        webservice string resolution_RES_COMMENT;        
        webservice string additionalDesc2_ECATS;
        webservice string hyperlinkToCQCP;        
        webservice string contactPrimAddress_CONTACT_EMAIL;
        webservice string resolutionTool;
        webservice string userVNName_INNAM;
        webservice string dateTimeClosed_DATUM;
        webservice string customer_Request_Date;// Added per new mapping list
        webservice string classification;
        
               
    }
    // Added the method to resolve SAP PI Issue
    global class DataSFDCTOSAP{
        webservice string caseNumber;
        webservice string caseUrl;
        webservice string error;
    }
    // Added the method to resolve SAP PI Issue
    static String details = '';
    webservice static DataSFDCTOSAP createCase(CaseData sapCase){
       
        //Create new case
        Case sfdcCase = new Case();
        DataSFDCTOSAP cse = new DataSFDCTOSAP();
                
        //Boolean for success
        Integer countRequired = 0;
        string invalidProductError = null;
        //////////////////Start - Required fields//////////////////
            
        sfdcCase.Origin = Label.FixNow_Origin;//AERO.Aero_SAP - Defect #87886
        /* Added for RAPD - 3343 */
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();   
		 string truncateIP = '';
        truncateIP = string.valueOf(sapCase);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        } 
        /* RAPD -- 3343 */
        if(sapCase.resolution_RES_COMMENT != null && string.isBlank(sapCase.resolution_RES_COMMENT)){
        if(sapCase.resolution_RES_COMMENT.startsWith('Removal') && sapCase.resolution_RES_COMMENT.Endswith('Customer Damage')){
            sfdcCase.RecordTypeId = Label.Case_Return_RecordType;
            sfdcCase.ownerid = Label.Case_Returns_Owner;//TOC Team as Owner
            
           
        }else{
            sfdcCase.RecordTypeId = Label.Case_Technical_Issue_RecordType;//Technical Issue - '01230000000ZJvU'
            sfdcCase.ownerid = Label.Case_TOC_Owner;//TOC Team as Owner
        }
        }else{
            /* Added for RAPD - 3343 */
            SApInterface.sapException='No resolution_RES_COMMENT has been found';
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        
        sfdcCase.Export_Compliance_Content_ITAR_EAR__c = 'No';
        sfdcCase.Government_Compliance_SM_M_Content__c = 'No';
        //sfdcCase.ownerid = Label.Case_TOC_Owner;//TOC Team as Owner
        //sfdcCase.Supported_Products__c = Label.Demo_Product;
        
        //Field Subject - YQMT_CQPC-YYINCIDENT_DESCR
        if(sapCase.subject_YYINCIDENT_DESCR != null && sapCase.subject_YYINCIDENT_DESCR !=''){
            sfdcCase.subject = sapCase.subject_YYINCIDENT_DESCR; 
            countRequired ++;     
        }else{
            details += ' INCIDENT_DESCR,';
            system.debug('--->' + details);
            /* Added for RAPD - 3343 */
            SApInterface.sapException=details;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
       
        }
        
        //Field Contact Email - YQMT_CONTACT_DETAILS-CONTACT_EMAIL
        if(sapCase.contactPrimAddress_CONTACT_EMAIL != null && sapCase.contactPrimAddress_CONTACT_EMAIL != ''){
            
            if(getContactId(sapCase.contactPrimAddress_CONTACT_EMAIL) !=null){
                sfdcCase.ContactId = getContactId(sapCase.contactPrimAddress_CONTACT_EMAIL);
                //countRequired ++;
                sfdcCase.Primary_Email__c = sapCase.contactPrimAddress_CONTACT_EMAIL;
            }
            else{
                //details += ' CONTACT_EMAIL(Primary Email),';
                sfdcCase.AccountId = Label.Default_Account_For_CQCP;
            }
        }else{
            sfdcCase.AccountId = Label.Default_Account_For_CQCP;
            //system.debug('sfdcCase.AccountId-->' + sfdcCase.AccountId);
        }
        
        //Field Classification
        boolean hasClassification = false;
        if(sapCase.classification != null && sapCase.classification !=''){
            for(Tech_Issue_Classification__c tempValue: Tech_Issue_Classification__c.getall().values())
            {
                if(tempValue.classification__c == sapCase.classification){
                    hasClassification = true;
                }
            }
            if(hasClassification == true){
                sfdcCase.Classification__c = sapCase.classification;
                //Assign dependent fields
                for(Case_Classification_Denedencies__c caseDeps: Case_Classification_Denedencies__c.getAll().values()){
                    
                    if(sfdcCase.Classification__c == caseDeps.Name){
                        sfdcCase.Sub_Class__c = caseDeps.sub_class__c;
                        sfdcCase.Detail_class__c = caseDeps.detail_class__c;
                    }
                }
                                                
                countRequired ++;
            }else{
                details += ' Classification,';
            }
        }else{
            details += ' Classification,';
            system.debug('--->' + details);
            /* Added for RAPD - 3343 */
              SApInterface.sapException='Invalid Classification..!' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        //////////////////End - Required fields//////////////////
       } 
        //Field CreatedDate  - YQMT_CQCP-RMDAT
        boolean isDateValid = true;
        if(sapCase.dateTimeOpened_RMDAT != null && sapCase.dateTimeOpened_RMDAT!= ''){
            if(stringToDate(sapCase.dateTimeOpened_RMDAT) != null){
                sfdcCase.CreatedDate = stringToDate(sapCase.dateTimeOpened_RMDAT);
                system.debug('Created date...'+ sfdcCase.CreatedDate);
            }else{
                details += ' RMDAT, ';
                isDateValid = false;
                /* Added for RAPD - 3343 */
                SApInterface.sapException='Invalid Created Date..!' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =string.valueOf(sapCase);
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            }
        }
        
               
        //Field Resolution - RES_COMMENT
        if(sapCase.resolution_RES_COMMENT != null && sapCase.resolution_RES_COMMENT != '')
        {
            sfdcCase.Resolution__c = sapCase.resolution_RES_COMMENT;
        }
        else{
            /* Added for RAPD- 3343 */
             SApInterface.sapException='Invalid resolution_RES_COMMENT' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        
        //Field Resolution Tool - resolutionTool
        if(sapCase.resolutionTool != null && sapCase.resolutionTool != ''){
            sfdcCase.Resolution_Tool__c = sapCase.resolutionTool;  
        }  
else{
    /* Added for Rapd - 3343 */
             SApInterface.sapException='Invalid resolutionTool' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
    /* Ended */
        }       
        //Field Description  - description
        sfdcCase.Description = sapcase.description;
        if(sapCase.additionalDesc_Event_Category != null && sapCase.additionalDesc_Event_Category != '')
        {
            sfdcCase.Description = sfdcCase.Description + '\n'+sapCase.additionalDesc_Event_Category;
        }
        else{
            /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid additionalDesc_Event_Category' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        if(sapCase.additionalDesc2_ECATS != null && sapCase.additionalDesc2_ECATS != ''){
            integer indexFirstSemiColon = sapCase.additionalDesc2_ECATS.indexOf(';');
            if(indexFirstSemiColon != -1){
                string desc1 = sapCase.additionalDesc2_ECATS.substring(0,indexFirstSemiColon); 
                string desc2 = sapCase.additionalDesc2_ECATS.substring(indexFirstSemiColon+1);
                if(desc1 != ''){ 
                    sfdcCase.Description = sfdcCase.Description + '\n'+ desc1 + '\n' + desc2;
                }else{
                    sfdcCase.Description = sfdcCase.Description + '\n'+ desc2;
                }
            }else{
                sfdcCase.Description = sfdcCase.Description + '\n'+ sapCase.additionalDesc2_ECATS;
            }
        }
        else{
            /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid additionalDesc2_ECATS' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =string.valueOf(sapCase);
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
/* Ended */
        }   
        //Field Tail Number  - YQMT_CQCP-YACTYPE
        if(sapCase.aircraftTailNumber != null && sapCase.aircraftTailNumber != '')
        {
            sfdcCase.Aircraft_Tail_Number__c = sapCase.aircraftTailNumber;
        }
        else{
             SApInterface.sapException='Invalid aircraftTailNumber' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }   
            
        if(sapCase.aircraftSerialNumber != null && sapCase.aircraftSerialNumber != '')
        {
            sfdcCase.Aircraft_Serial_Number__c = sapCase.aircraftSerialNumber;
        }
        else{
            /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid aircraftSerialNumber' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
            
        if(sapCase.aircraftType != null && sapCase.aircraftType != ''){
            Id platformId = getPlatformId(sapCase.aircraftType);
            if( platformId != null)
                sfdcCase.AIRCRAFT_TYPE__C = platformId;
            
           
        }
        else{
            /* Added for Rapd - 3343 */
             SApInterface.sapException='Invalid aircraftType' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
            
        if(sapCase.aircraftLocation != null && sapCase.aircraftLocation != '')
        {
            sfdcCase.Aircraft_Location__c = sapCase.aircraftLocation;
        }
        else{
            /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid aircraftLocation' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
/* Ended */
        }   
            
        boolean isProductValid = true;    
        if(sapCase.productNumber_MATNR != null && sapCase.productNumber_MATNR!= ''){
            if(getProductId(sapCase.productNumber_MATNR) != null){
                sfdcCase.Product_Number__c = getProductId(sapCase.productNumber_MATNR);
            }/*else{
                details += ' Product Number,';
                isProductValid = false;
            }*/
        }
        else{
            /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid productNumber_MATNR' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /*Ended */
        }   

        if(sapCase.productSerialNumber_SERIALNR != null && sapCase.productSerialNumber_SERIALNR !='') 
        {           
            sfdcCase.Product_Serial_Number__c = sapCase.productSerialNumber_SERIALNR;
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid productSerialNumber_SERIALNR' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
        
        
        boolean isuserVNNameValid = true;
        if(sapCase.userVNName_INNAM!=null && sapCase.userVNName_INNAM!= ''){
            if(getUserId(sapCase.userVNName_INNAM) !=null){
                sfdcCase.User_VN_Name__c = getUserId(sapCase.userVNName_INNAM);
            }
            else{
                //isuserVNNameValid = false;
                //details += ' INNAM,';
                
                //Used denied party user if User VN Name is invalid
                sfdcCase.User_VN_Name__c = Label.DeniedPartyScreening_APIUser_ID;
            }
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid userVNName_INNAM' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
        if(sapCase.dateTimeOpened_RMDAT != null && sapCase.dateTimeOpened_RMDAT!= '') 
        {    
            if(stringToDate(sapCase.dateTimeOpened_RMDAT) != null){
                sfdcCase.HON_Commit_Date__c = stringToDate(sapCase.dateTimeOpened_RMDAT);
                //sfdcCase.Customer_Request_Date__c = sfdcCase.HON_Commit_Date__c.date();
            }
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid dateTimeOpened_RMDAT' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
        if(sapCase.customer_Request_Date != null && sapCase.customer_Request_Date != '') 
        {    
            if(stringToDate(sapCase.customer_Request_Date) != null){
                sfdcCase.Customer_Request_Date__c = stringToDate(sapCase.customer_Request_Date);
            }
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid customer_Request_Date' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
        if(sapCase.url_CQCP != null && sapCase.url_CQCP != '')
        {
            sfdcCase.URL_CQCP__c = sapCase.url_CQCP;
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid url_CQCP' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
        
        
        if(sapCase.hyperlinkToCQCP != null && sapCase.hyperlinkToCQCP != '')
        {
            sfdcCase.Hyperlink_To_CQCP__c = sapCase.hyperlinkToCQCP;
        }
        else{
               /* Added for RAPD - 3343 */
             SApInterface.sapException='Invalid hyperlinkToCQCP' ;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }   
          
        Savepoint sp = Database.setSavepoint();            
        // Insert the case
        boolean isInserted = false;
        try{
        system.debug('Count Required::::'+countRequired);
            if(countRequired == 2 && isDateValid == true && isProductValid == true && isuserVNNameValid == true){
                insert sfdcCase;
                isInserted = true;
            }else{
                cse.error = 'Invalid -' + details;
                /* Added for RAPD - 3343 */
                 SApInterface.sapException= cse.error;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            }
            
        }catch(Exception ex)
        {
            cse.error = 'Invalid - ' + ex.getMessage();
               /* Added for RAPD - 3343 */
            SApInterface.sapException= cse.error;
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue = truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
            
        }
        if(invalidProductError != null)
            cse.error += invalidProductError;
        
        if(isInserted == true){
        try{
            cse.casenumber = getCaseNumber(sfdcCase.id);
            cse.caseUrl = Label.ServerName +'/'+ sfdcCase.id;
            // Update the owner and close the case
            if(sfdcCase.User_VN_Name__c == null){
                sfdcCase.ownerid = Label.DeniedPartyScreening_APIUser_ID;
            }
            else{
                sfdcCase.ownerid = sfdcCase.User_VN_Name__c;
            }
            sfdcCase.Status = 'Done';
            
            // Update the case
            update sfdcCase;
        }catch(Exception ex)
        {
            cse.error = 'Case could not be closed ';
            cse.error += ex.getMessage();
        }
        }
        if(cse.error != null && cse.error != ''){
            Database.rollback(sp);
            cse.casenumber = null;
            cse.caseUrl = null;
        }
        
        return cse;
    }
    
    public static string getCaseNumber(Id caseId){
        Case sfdccase = [select id,CaseNumber from case where id=: caseId];
             
        return sfdccase.caseNumber ; 
    }
    
   public static Date stringToDate(string dateString){
        String strdt = '';
        strdt = dateString + ' 00:00:00';
        Date sfdcdate = null;
         SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();   // Aero RAPD - 3368
        try{
            sfdcdate  = date.ValueOf(strdt);
        }catch(exception ex){
           SYSTEM.DEBUG('Wrong date format:' + ex.getMessage()); 
            /* Added for RAPD - 3343 */
           SApInterface.sapException=ex.getMessage();
                     SApInterface.Name = 'Case_SAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                     //     SApInterface.caseNumber = string.valueOf(update_case.caseNumber);
                           SApInterface.inputValue = dateString;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        return sfdcdate; 
    }
    
    public static Id getProductId(string productNumber){
    
        List<Product2> listProduct = [select id from product2 where Product_Number__c =: productNumber limit 1];
        if(listProduct .size()> 0)
            return listProduct[0].Id;
        else
            return null;
    }
    public static Id getUserId(string employeeNumber){
        
        List<User> listUser = [select id from User where UserType='Standard' and EmployeeNumber =: employeeNumber and IsActive = true limit 1];
        
        if(listUser.size()>0){
            return listUser[0].Id;
        }else
        {
            return null;
        }
        
    }
    
    public static Id getContactId(string contactEmail){
        
        List<Contact> listContact = [select id from Contact where email=: contactEmail limit 1];
         
        if(listContact.size() > 0)
             return listContact[0].id;
        else
            return null;
    }
    
    public static Id getPlatformId(string model){
    
        List<Platform__c> listPlatform = [select id from Platform__c where Model__c =: model];
         
        if(listPlatform.size() > 0)
             return listPlatform[0].id;
        else
            return null;
    }
}
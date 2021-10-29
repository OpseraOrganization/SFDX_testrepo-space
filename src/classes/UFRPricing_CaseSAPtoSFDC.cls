/*******************************************************************************
Name            :   UFRPricing_CaseSAPtoSFDC
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <Phase-II>, <UFR Pricing> 
Created Date    :   28-August-2015
Usages          :   Creating Case based on SAP and sending response as Case Number 
Updates         :   New changes for Manual Intervention Cases to update owner & Status 
Modified By     :   NTT Data
Usage           :   As part of SI Project changes using this class stop case creation and update case    
Usage           :   Added changes for ROI Quote creation
*******************************************************************************/
global class UFRPricing_CaseSAPtoSFDC{
    global class CaseData{
        webservice string CUSTOMER_PO_RO_WO_NUM;
        webservice string SALES_ORDER_NUM;
        webservice string DESCRIPTION;
        webservice string PRODUCT_NUM;
        webservice string PRODUCT_SERIAL_NUM;
        webservice string SUBJECT;
        webservice string SAP_PLANT_CODE;
        webservice string QUOTATION_NUMBER;
        webservice string CUST_EMAIL_ADDR;
        webservice Decimal UFR_PRICING_AMT;
        webservice string SAP_SITE_CODE;
        webservice string TYPE;  
        webservice string AttBody;
        webservice String AttFileName;
        webservice String AttContentType;
        webservice String NOTIFICATION_NUMBER;
        webservice String UFR_SBU;
    }
    global class CaseDataSFDCtoSAP{
        webservice string caseNumber;
        webservice string message;
    }
    
    /* Added RAPD - 3343 */
    global class SapExceptionCapture{
        webservice String outputValue;
        webservice String inputValue;
        webservice String sapException;
        webservice String name;
        webservice String notification;
        webservice String createdDate;
        webservice String createdBy;
        webservice String caseNumber;
        
    }
    /* Ended */
    webservice static CaseDataSFDCtoSAP createCase(CaseData cs){
        /* Added RAPD - 3343 */
        string truncateIP = '';
        truncateIP = string.valueOf(cs);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        /* Ended */
        CaseDataSFDCtoSAP cse = new CaseDataSFDCtoSAP();
        system.debug('cs---'+cs);
        if(cs.SAP_SITE_CODE != null)
        {
            system.debug('cs.SAP_SITE_CODE----'+cs.SAP_SITE_CODE);
            string CASENUMBER='CASE-'+cs.SAP_SITE_CODE;
            string NotificationNumber = cs.NOTIFICATION_NUMBER;
           
            //Case cas = [select id,casenumber,Type,Requestor_Email__c,Classification__c from case where casenumber=:CASENUMBER limit 1];
            List<Case> cas = [select id,CaseNumber,type,Requestor_Email__c,Repair_Notification_Number__c,UFR_Standard_Price_Amount__c,(select id,Case_object__c,Manual_Intervention_Last_Modified_Date__c,UFR_SBU__c from CASE.Case_Extensions__r) from case where casenumber=: CASENUMBER  limit 1];
            List<Case_Extension__c> UFRCasExlist = new List<Case_Extension__c>();
          
            // ROI Code starts to insert Quote
           
            if(cas != null && cas.size()>0 && cs.SUBJECT == 'ROI_Quote' && ((cs.AttBody!=null && cs.AttBody!='') && (cs.AttFileName!=null && cs.AttFileName!='') && (cs.AttContentType!=null && cs.AttContentType!='')))
            {
                system.debug('----->ROIATTBody'+cs.AttBody);
                system.debug('----->ROIATTBody'+cs.AttBody.length());
                Blob ROIbody = EncodingUtil.base64Decode(cs.AttBody);
                /*Attachment a = new Attachment();
                a.Body = ROIbody;
                a.ContentType = cs.AttContentType;
                a.Name = cs.AttFileName;
                a.ParentId = cas[0].id;*/
                ContentVersion conVer = new ContentVersion();
                conVer.PathOnClient = cs.AttFileName; // file name with extension
                conVer.Title = cs.AttFileName; // file name to display. Usually specify the extension here also
                conVer.VersionData = ROIbody;
                try{
                    //insert a;
                    insert conVer;
                    ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
                    ContentDocumentlink objCDL = new ContentDocumentlink();
                    objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
                    objCDL.linkedentityId = cas[0].id;
                    objCDL.Sharetype = 'I';
                    insert objCDL;
                    cse.caseNumber = cs.SAP_SITE_CODE;
                    cse.message = 'Attachment inserted successfully';
                }catch(Exception aEx){
                    system.debug('Invalid--->'+aEx.getMessage());
                    cse.caseNumber = cs.SAP_SITE_CODE;
                     cse.message = 'Invalid: '+aEx.getMessage();
                    /* Added for RAPD - 3343 */
                    SApInterface.sapException= cse.message;
                     SApInterface.Name = 'UFRPricing_CaseSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = CASENUMBER;
                          SApInterface.notification =NotificationNumber;
                           SApInterface.inputValue = truncateIP;
                           SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /* Ended */
                }
            }
            // ROI Code end to insert Quote
            else
            {
                for(Case c:cas){
                    Case_Extension__c CasExt = new Case_Extension__c();
                    if(c.Case_Extensions__r!=null && c.Case_Extensions__r.size()>0){
                        system.debug('---->If');
                        CasExt = c.Case_Extensions__r;
                    }else{
                        system.debug('---->else');
                        CasExt.Case_object__c = c.id;                
                    }
                    CasExt.UFR_SBU__c = cs.UFR_SBU;
                    UFRCasExlist.add(CasExt);
                }
                Boolean isInserted = false;
                try{
               if(cas != null && cas.size()>0){
                    if((cas[0].Requestor_Email__c != null && cs.CUST_EMAIL_ADDR != null && cas[0].Requestor_Email__c != cs.CUST_EMAIL_ADDR) || (cas[0].Type != cs.TYPE) || (cas[0].Requestor_Email__c == null || (cas[0].UFR_Standard_Price_Amount__c != cs.UFR_PRICING_AMT)))
                    {    
                        system.debug('------------------------------>in');
                        if(cs.CUST_EMAIL_ADDR != null && cs.CUST_EMAIL_ADDR != '' && cas[0].Requestor_Email__c != cs.CUST_EMAIL_ADDR){
                            cas[0].Requestor_Email__c = cs.CUST_EMAIL_ADDR;
                        } 
                        if(cs.TYPE == 'UFR Unfunded PO')                
                        {
                            cas[0].Type='Unfunded PO';
                        }
                        else if(cs.TYPE == 'UFR PO Mismatch')
                        {
                            cas[0].Type='PO Mismatch';
                        }
                        else
                        {
                            cas[0].Type = cs.TYPE;
                        }
                        if(cas[0].UFR_Standard_Price_Amount__c != cs.UFR_PRICING_AMT)
                        {
                            cas[0].UFR_Standard_Price_Amount__c=cs.UFR_PRICING_AMT;
                        }
                        update cas[0];
                        upsert UFRCasExlist;
                        isInserted = true;
                    }
                    else
                    {
                       system.debug('------------------------------>else');
                       isInserted = true;
                    }
                   }
                }catch(DMLException e){
                system.debug('Entered 134 line');
                    cse.message = 'Invalid - '+e.getMessage();
                    /* Added for RAPD - 3343 */
                    SApInterface.sapException= cse.message;
                     SApInterface.Name = 'UFRPricing_CaseSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = CASENUMBER;
                           SApInterface.notification =NotificationNumber;
                          SApInterface.inputValue = truncateIP;
                          SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /* Ended */
                }
                if(isInserted == true){
                    try{
                    //cse.caseNumber = getCaseNumber(cas.id,cs.UFR_SBU);
                    cse.caseNumber = cs.SAP_SITE_CODE;
                    cse.message = 'Success!'; 
                    if((cs.AttBody!=null && cs.AttBody!='') && (cs.AttFileName!=null && cs.AttFileName!='') && (cs.AttContentType!=null && cs.AttContentType!='')){
                        system.debug('----->UFRATTBody'+cs.AttBody);
                        system.debug('----->UFRATTBody'+cs.AttBody.length());
                        Blob tstbody = EncodingUtil.base64Decode(cs.AttBody);
                        /*Attachment att = new Attachment();
                        att.Body = tstbody;
                        att.ContentType = cs.AttContentType;
                        att.Name = cs.AttFileName;
                        att.ParentId = cas[0].id;*/
                        ContentVersion conVer = new ContentVersion();
                        conVer.PathOnClient = cs.AttFileName; // file name with extension
                        conVer.Title = cs.AttFileName; // file name to display. Usually specify the extension here also
                        conVer.VersionData = tstbody;
                        try{
                            //insert att;
                            insert conVer;
                            ContentVersion conVerAftCreate = [SELECT Id,Title,ContentDocumentId from ContentVersion where Id =: conVer.Id AND IsLatest = true limit 1];
                            ContentDocumentlink objCDL = new ContentDocumentlink();
                            objCDL.ContentDocumentId = conVerAftCreate.ContentDocumentId;
                            objCDL.linkedentityId = cas[0].id;
                            objCDL.Sharetype = 'I';
                            insert objCDL;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                            /* Added for RAPD - 3343 */
                            SApInterface.sapException=attEx.getMessage();
                             SApInterface.Name = 'UFRPricing_CaseSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = CASENUMBER;
                           SApInterface.notification =NotificationNumber;
                            SApInterface.inputValue = truncateIP;
                          SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                            /* Ended */
                        }
                    }
                    system.debug('------------------------------>ufremail');
                    if(!(cs.subject=='Cafe Report' || cs.subject=='Service Report'))
                    {
                    UFRPricing_EmailSending.EmailSend(cas[0].id,cs.UFR_SBU);
                    }
                }
                catch(Exception sapException){
                    system.debug('Exception Captured....!'+sapException);
                    /* Added for RAPD - 3343 */
                          SApInterface.sapException=sapException.getmessage();
                          SApInterface.Name = 'UFRPricing_CaseSAPtoSFDC';
                          SApInterface.createdDate =Datetime.valueof(Datetime.now());
                          SApInterface.caseNumber = CASENUMBER;
                           SApInterface.notification =NotificationNumber;
                            SApInterface.inputValue = truncateIP;
                          SApInterface.createdBy = UserInfo.getName();
                 SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                    /* Ended */
                }
                }
            }
            
        }
        return cse;
    }
    /*public static string getCaseNumber(Id caseId, String UFR_SBU){
        string casenumber='';
        List<Case> sfdccase = [select id,CaseNumber,(select id,Case_object__c,Manual_Intervention_Last_Modified_Date__c,UFR_SBU__c from CASE.Case_Extensions__r) from case where id=: caseId];
        List<Case_Extension__c> UFRCasExlist = new List<Case_Extension__c>();
        for(Case c:sfdccase){
            Case_Extension__c CasExt = new Case_Extension__c();
            if(c.Case_Extensions__r!=null && c.Case_Extensions__r.size()>0){
                system.debug('---->If');
                CasExt = c.Case_Extensions__r;
            }else{
                system.debug('---->else');
                CasExt.Case_object__c = c.id;                
            }
            CasExt.UFR_SBU__c = UFR_SBU;
            UFRCasExlist.add(CasExt);
        }
        upsert UFRCasExlist;
        casenumber=sfdccase[0].caseNumber.replaceAll('CASE-', '');
        return caseNumber; 
    } */      
}
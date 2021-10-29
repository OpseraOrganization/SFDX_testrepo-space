/** * File Name: REG_Case_Service 

* Description  methods for inserting/updating case

* * @author : TCS 

Date 
02/18/2019                      Created
09/29/2020  SCTASK3629121       Changes to include sub class population for Warranty Verification 

* */

public with sharing class REG_Case_Service{
    public static REG_Result fncCreateCase(REG_API_Case.CaseData cs){   
      
        REG_Result result = new REG_Result();   
        CaseResponse cr = new CaseResponse();
        List<Attachment> attlist = new List<Attachment>();    
        List<Case_Line_Item__c> Lnit1 = new List<Case_Line_Item__c>();
        List<contact> con=new List<contact>();  
        String rtn;
        String ContactEmail;
        String ContactInformation='';  
        Map<string,SitecoreCaseType__c> Mapcasetype = new Map<string,SitecoreCaseType__c>();
        String Casenum = '';
        string conid=Label.UFR_Cont_Id;
        List<case> cas1=new List<case>();
        Boolean caseupdate=false;
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();  
        Messaging.SingleEmailMessage msg1 = new Messaging.SingleEmailMessage();
        List<Messaging.SingleEmailMessage> msgList1 = new List<Messaging.SingleEmailMessage>();
        List<Messaging.SingleEmailMessage> bulkEmails1 = new List<Messaging.SingleEmailMessage>();
        List<string> ccAddress = new List<string>();
        List<string> Billingadd1 =new List<string>();
        List<string> Billingadd2 =new List<string>();
        List<string> Billingadd3 =new List<string>();
        List<string> Billingadd4 =new List<string>();
        List<string> Billingadd5 =new List<string>();
        List<string> Billingadd6 =new List<string>();
        List<string> Billingadd7 =new List<string>();       
        Mapcasetype = SitecoreCaseType__c.getAll();
        Service_Request__c serRq = new Service_Request__c();        
        case cas = new case();
        cas.Status = 'Open';   
        cas.Additional_Web_Form_Info__c=cs.AdditionalWebFormInfo;
        cas.Order_Type__c = cs.OrderType;
        cas.Order_Status_Info_Requested__c=cs.OrderStatusInfoRequested;
        cas.SuppliedEmail = cs.EmailAddress;
        cas.Owner_Operator_Information__c =cs.PortalContactEmail;
        cas.Honeywell_ID__c=cs.HoneywellID;
        cas.Classification__c = cs.Classification;
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Description = cs.DESCRIPTION; 
        cas.Invoice_Number__c = cs.InvoiceNumber;                    
        cas.Aircraft_Serial_Number__c = cs.AircraftSerialNumber;  
        cas.Intended_Use__c = cs.IntendedUse;
        cas.End_Use_for_this_Part_Assembly__c = cs.EndUseforthisPartAssembly;
        cas.End_User_Address__c = cs.EndUserAddress;
        cas.Honeywell_Order_Number__c = cs.HoneywellOrderNumber;    
        cas.Change_Type__c = cs.ChangeType;
        cas.Additional_Information__c = cs.AdditionalAircraftInfo;
        cas.Product_Part_Number__c = cs.PartNumber;   
        
        //For Outside Purchase Request Form
        if (cs.FormName == 'OutSidePurchaseRequest')  {
            cas.Part_Number_Needed__c = cs.PartNumber;
        }
         
        cas.Sales_Order_Number__c = cs.SalesOrderNumber;
        cas.Last_Part_To_Clear_The_Engine__c = cs.LastPartToClearTheEngine;
        
        cas.Aircraft_Tail_Number__c = cs.AircraftTailNumber;
        cas.Top_Level_Assembly_Part_Number__c = cs.TopLevelAssemblyPartNumber;
        cas.Top_Level_Assembly_Serial_Number__c = cs.TopLevelAssemblySerialNumber;
        cas.Reason_For_Removal__c = cs.ReasonForRemoval;
        cas.Honeywell_Invoice_Number__c = cs.HoneywellInvoiceNumber;
        cas.Customer_Reference_Number__c = cs.CUSTOMER_PO_RO_WO_NUM;
        cas.Customer_Reference_Number__c = cs.Customer_PO_Number;
        cas.Service_Bulletin_Number__c = cs.ServiceBulletinNumber;  
        cas.Make__c = cs.AircraftMake;
        cas.Model__c = cs.AircraftModel; 
        cas.Job_Title__c = cs.SubClass;
        cas.Citizenship__c = cs.DetailClass;
        cas.Phase_of_Flight__c = cs.PHASE_OF_FLIGHT;
        cas.Fault_Messages__c = cs.Fault_Code;
        cas.ATA_Chapter__c = cs.ATAChapter;
        if(cs.FormName != 'GeneralTechnicalIssues') { // only if added by kayal
        cas.Due_Date__c = cs.DueDate;
        }
        if(cs.FormName == 'GeneralTechnicalIssues') {
        cas.Customer_Request_Date__c = cs.DueDate; //added by kayal
        }
                
        cas.Engine_S_N__c = cs.Engine_SN;
        cas.Engine_Model__c = cs.Engine_Model;
        cas.Engine_Received_Date__c = cs.Engine_Received_Date;
        cas.Engine_Out_Date__c = cs.Engine_Out_Date;
        cas.Customer_PO_RO_WONumber__c = cs.Customer_PO_RO_WO;
        cas.HON_Commit_Date__c = cs.Honeywell_Commit_Date;
        
        
        if(cs.AOG == true){
        cas.Expected_Update__c=cs.DueDate;
            cas.AOG__c = cs.AOG;
        }        
        cas.Part_Number__c = cs.PartNumberDescription;
        //cas.Quantity__c  = cs.Quantity;
        cas.Quantity_Needed__c = cs.QuantityNeeded;
        cas.S_N_Of_Part_Being_Installed__c  = cs.SN_Part_Being_Installed;
        cas.Proposed_Supplier__c  = cs.Proposed_Supplied;
        cas.Price__c  = cs.Price;
        cas.Contract_Number__c  = cs.ContractNumber;    
        
        if(!String.isBlank(cs.CustomerType)){
             cas.Customer_Type__c  = cs.CustomerType;
        }
        
        if(!String.isBlank(cs.PartStatus)){
            cas.Part_Status__c   = cs.PartStatus;  
        }
        
        if(!String.isBlank(cs.IsTheAircraftSupportedWithARental)){
            cas.Is_The_Aircraft_Supported_With_A_Rental__c  = cs.IsTheAircraftSupportedWithARental; 
        }
        
        if(!String.isBlank(cs.CopyOf8130Tag_ifAvailable)){
            cas.Copy_Of_8130_Tag_if_available__c  = cs.CopyOf8130Tag_ifAvailable; 
        }
        cas.Copy_Of_8130_Tag_Issued_By__c  = cs.CopyOf8130TagIssuedBy;
        
        if(!String.isBlank(cs.ILSChecked)){
            cas.ILS_Checked__c = cs.ILSChecked; 
        }
        
        if(!String.isBlank(cs.OtherServiceCentersChecked)){
            cas.Other_Service_Centers_Checked__c  = cs.OtherServiceCentersChecked;
        }
        
        if(String.isBlank(cs.FormName)){
            result.handleError(400, 'Form Name Not Found.', 'Form name could not be blank or null');
            return result;
        } 
        
        if(Mapcasetype.containsKey(cs.FormName)){
            if(Mapcasetype.get(cs.FormName).Case_Type__c!='Services-AOG'){
                cas.OwnerId = Mapcasetype.get(cs.FormName).Case_Owner__c;
                cas.RecordtypeId = Mapcasetype.get(cs.FormName).Case_Record_Type__c;
               cas.Subject = Mapcasetype.get(cs.FormName).Subject__c;     
                cas.Origin = Mapcasetype.get(cs.FormName).Origin__c;
                cas.Type = Mapcasetype.get(cs.FormName).Case_Type__c;
                system.debug('cas.OwnerId11'+cas.OwnerId);
            }else if(Mapcasetype.get(cs.FormName).Case_Type__c=='Services-AOG' && cs.OrderType == 'Services'){
                cas.OwnerId = Mapcasetype.get(cs.FormName).Case_Owner__c;
                cas.RecordtypeId = Mapcasetype.get(cs.FormName).Case_Record_Type__c;
                cas.Subject = Mapcasetype.get(cs.FormName).Subject__c;
                cas.Origin = Mapcasetype.get(cs.FormName).Origin__c;
                cas.Type = Mapcasetype.get(cs.FormName).Case_Type__c;
                 system.debug('cas.OwnerId22'+cas.OwnerId);
            }else{
                result.handleError(400, 'Invalid Details', 'Please provide valid Input');
                return result;  
            }
            if(cs.FormName == 'GeneralTechnicalIssues') {
                      cas.Subject = cs.CaseSubject;
             }
            
        }else{
            result.handleError(400, 'Invalid Form Name', 'Please provide valid Form Name');
            return result;  
        }
       
        
        system.debug('cs.ContactId***'+cs.ContactId);
        //If contact is not blank
        if((!String.isBlank(cs.ContactId)) &&  cs.ContactId!='null' && cs.ContactId!=null ){
            con=[select id,Contact_Status__c,accountid,account.name,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where id=:cs.ContactId];
        }else if(cs.EmailAddress!= null && cs.EmailAddress!= '' && cs.EmailAddress!= 'null'){
            con=[select id,Contact_Status__c,accountid,account.name,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email=:cs.EmailAddress limit 1];
        }
        
        
        if(con.size()>0){
            if(con[0].Contact_Status__c=='Active'){
                cas.ContactId=con[0].id;
                cas.AccountId=con[0].accountid;
                cas.SuppliedEmail = con[0].email;
                ContactEmail=con[0].email;
                ContactInformation = getContactInformation(con[0]);
            }else{
                 result.handleError(400, 'Bad Data' , 'Contact Status is Inactive');
                 return result;  
            }
        }
        
        
        //newly inserted section from QA
        String submitPoReason;
        String submitPoOtherReason;
        if( cas.Type == 'Orders'){
            submitPoReason = getInbetweenValues(cs.DESCRIPTION, 'Reason for submitting Paper PO:', '\n');
            
            if(cs.OrderType == 'Services'){
                 cas.OwnerId =  Mapcasetype.get('Services-AOG').Case_Owner__c; //'00G30000001zX92';
                system.debug('cas.OwnerId11 '+cas.OwnerId );
                cas.RecordtypeId = Mapcasetype.get('Services-AOG').Case_Record_Type__c; // '01230000000Zemy';
                system.debug('cas.RecordtypeId11'+cas.RecordtypeId);
                cas.Classification__c = 'AOG';//'CSO Repairs / Overhaul';
                cas.Sub_Class__c = 'AOG';
                cas.Order_Type__c = 'Repair / Overhaul';
                cas.Workstrem__c = 'Repair and Overhaul';
                cas.Type = 'Repair Inquiry';
                
                if(String.isNotBlank(submitPoReason) && submitPoReason.contains('Other')){
                    submitPoReason = 'Other';
                    submitPoOtherReason = getInbetweenValues(cs.DESCRIPTION, 'Other Service Reason:', '\n');
                }
                
            }else if(cs.OrderType == 'Spares'){
                cas.Classification__c = 'CSO Spares';
                if(cs.ProductType == 'Microelectronics & Precision Sensors'){
                cas.Sub_Class__c = 'Plymouth';
                }
                if(String.isNotBlank(submitPoReason) && submitPoReason.contains('Other')){
                    submitPoReason = 'Other';
                    submitPoOtherReason = getInbetweenValues(cs.DESCRIPTION, 'Other Spare Reason:', '\n');
                }
            }
            
            cas.Paper_PO_Reason__c = submitPoReason;
            cas.Paper_PO_Other_Reason__c = submitPoOtherReason;
        }
        
        /** SCTASK3629121 Changes **/
        if(cas.Type == 'Warranty' && cas.Subject == 'MyAerospace WarrantyCoverageCheck'){
            cas.Sub_Class__c = 'Warranty Verification';
        }        
              
        if(cs.ProductType!=null && cs.ProductType!=''){
            List<Supported_Products__c> sp = [SELECT id,Name,Product_Type__c,Status__c FROM Supported_Products__c where Status__c ='Active' and Name=:cs.ProductType limit 1];
            if(sp!=null && sp.size()>0)
                cas.Supported_Products__c = sp[0].id;
        }
        if(cs.DateofFailure != null && cs.DateofFailure != '')
        {
            cas.Date_of_Failure__c = Date.valueof(cs.DateofFailure);
        }
        if(cs.LaborTime != null && cs.LaborTime != '' )
        {
            cas.Labor_Time__c = decimal.valueOf(cs.LaborTime);
        } 
        if(cs.LaborRate != null && cs.LaborRate !='' )
        {
            cas.Labor_Rate__c = decimal.valueOf(cs.LaborRate);
        }
        if(cs.LaborCharges != null && cs.LaborCharges != '')
        {
            cas.Labor_Charges__c = decimal.valueOf(cs.LaborCharges);
        }
        if(cs.AmountofMaterialClaim != null && cs.AmountofMaterialClaim != '')
        {
            cas.Amount_of_Material_Claim_USD__c = decimal.valueOf(cs.AmountofMaterialClaim);
        }
        if(cs.AmountofFreightClaim != null && cs.AmountofFreightClaim != '')
        {
            cas.Amount_of_Freight_Claim_USD__c = decimal.valueOf(cs.AmountofFreightClaim);
        }
        if(cs.AmountofTotalClaim != null && cs.AmountofTotalClaim != '')
        {
            cas.Amount_of_Claim__c = decimal.valueOf(cs.AmountofTotalClaim);
        }
        if(cs.AircraftMake!=null && cs.AircraftMake!='' && cs.AircraftModel!=null && cs.AircraftModel!=''){
            List<Platform__c> pf = [SELECT id,Name,Make__c,Model__c,Active__c FROM Platform__c where Make__c=:cs.AircraftMake and Model__c=:cs.AircraftModel and Active__c = true limit 1];
            if(pf!=null && pf.size()>0)
                cas.Aircraft_Type__c = pf[0].id;
        }
        if(cs.DESCRIPTION!=null){
            if(cs.DESCRIPTION.contains('Type of Product: Bendix King')){                
                cas.OwnerId = Label.ATS_BK_Team;
                cas.Classification__c = 'GTO';
                cas.Sub_Class__c = 'Bendix/King';
            }else if(cs.DESCRIPTION.contains('Type of Product: Electrical') || cs.DESCRIPTION.contains('Type of Product: Lighting')){
                cas.OwnerId = Label.ATS_Elect_Team;
                cas.Classification__c = 'GTO';
                cas.Sub_Class__c = 'Electrical';
            }else if(cs.DESCRIPTION.contains('Type of Product: Mechanical') || cs.DESCRIPTION.contains('Type of Product: Wheels & Brakes')){
                cas.OwnerId = Label.ATS_Mech_Team;
                cas.Classification__c = 'GTO';
                cas.Sub_Class__c = 'Mechanical';
            }else if(cs.DESCRIPTION.contains('Type of Product: Not Listed') || cs.DESCRIPTION.contains('Type of Product: Services') || cs.DESCRIPTION.contains('Type of Product: Unnamed')){
                cas.OwnerId = Label.ATS_Team;
            }
        }
        system.debug('case-description');
        // Added for Auto Close of Orders records created by Billing Questions
        if(cas.Subject == 'MyAerospace Request Copy of Invoice' || cas.Subject == 'MyAerospace Billing General Inquiry' || cas.Subject == 'MyAerospace Sending Payment' || (cas.Subject == label.MyAerospace_Warranty_Credit_Request )) 
            //commenting as per Cindy comments to have case with open status
            //|| (cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request ))
        {
            cas.OwnerId = label.aero_default_user_id;
            cas.Status = 'Closed';
        }     
        Boolean isInserted = false;
        try
        {
            try{   
                insert cas;
                isInserted = true;   
                // TCS - added for service request change
                SitecoreCaseType__c caseTypeForGlobalCustCom = Mapcasetype.get('Global Customer Committee SR');
                system.debug('caseTypeForGlobalCustCom.Case_Type__c'+caseTypeForGlobalCustCom.Case_Type__c); 
                if(caseTypeForGlobalCustCom!=Null && caseTypeForGlobalCustCom.Case_Type__c == cas.type){
                    for(string description : cs.DESCRIPTION.split('\n')){
                        if(description.contains('Process/Services Affected')){
                            serRq.Customer_Impact__c = description.split(':',2)[1];
                        }
                        if(description.contains('Proposed Solution / Criteria to close')){
                            serRq.Deliverable__c= description.split(':',2)[1];
                        }
                    } 
                    serRq.Case_Number__c = cas.Id;
                    serRq.RecordtypeId = Mapcasetype.get('Global Customer Committee SR').Case_Record_Type__c;
                    serRq.EmailId__c = cs.EmailAddress;
                    serRq.Problem_Description__c = cs.DESCRIPTION;
                    serRq.Customer_Due_Date__c = system.now() + 30;
                    serRq.Atr__c = 'Responsiveness';
                    serRq.Attribute_Sub__c = 'C&PS SBU';
                    serRq.Subject__c = cs.SUBJECT;
                    serRq.Issue_Type__c = 'Technical';
                    serRq.status__c = 'Queue';
                    serRq.Priority__c = 'Routine';
                    serRq.Function_Responsible__c = 'C&PS SBU'; 
                    if(serRq != null){
                        try{
                            insert serRq;
                        }catch(Exception serexception){
                            result.handleException(400, serexception.getMessage(), serexception);
                        }
                    }
                }   
                
                if(cas.id != null && cs.Attachments !=null)
                {
                    system.debug(logginglevel.info,'case.id****' +cas.id);
                    List<REG_API_Case.Attachmentlist> Attach = new List<REG_API_Case.Attachmentlist>();
                    List<ContentVersion> conVerList = new List<ContentVersion>();
                    Attach = cs.Attachments;
                    system.debug(logginglevel.info,'Attach ****' +Attach);
                    for(REG_API_Case.Attachmentlist att: Attach ){
                        if((att.AttBody!=null && att.AttBody!='' && att.AttBody!='null') && (att.AttFileName!=null && att.AttFileName!='' && att.AttFileName!='null') && (att.AttContentType!=null && att.AttContentType!='' && att.AttContentType!='null'))
                        {
                            Blob tstbody = EncodingUtil.base64Decode(att.AttBody);
                            /*Attachment att1 = new Attachment();
                            att1.Body = tstbody;
                            att1.ContentType = att.AttContentType;
                            att1.Name = att.AttFileName;
                            att1.ParentId = cas.id;
                            attlist.add(att1);*/
                            ContentVersion conVer = new ContentVersion();
                            conVer.PathOnClient = att.AttFileName; // file name with extension
                            conVer.Title = att.AttFileName; // file name to display. Usually specify the extension here also
                            conVer.VersionData = tstbody;
                            conVerList.add(conVer);
                        }
                    }
                    /*if(attlist.size()>0){
                        try{
                            insert attlist;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                            // result.handleException(400, attEx.getMessage(), attEx);
                        }
                    }*/
                    if(conVerList.size()>0){
                        try{
                            insert conVerList;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                            // result.handleException(400, attEx.getMessage(), attEx);
                        }
                    }
                    set<id> setConvID = new set<id>();
                    for(ContentVersion objCon1 : conVerList){
                        if(objCon1 != null){
                            setConvID.add(objCon1.Id);
                        }
                    }
                    system.debug('setConvID: '+setConvID);
                    List<ContentDocumentlink> lstConDoclink = new List<ContentDocumentLink>();
                    
                    if(setConvID != null && setConvID.size()>0){
                        for(ContentVersion objCon : [SELECT Id,Title,ContentDocumentId from ContentVersion where Id IN: setConvID AND IsLatest = true]){
                            ContentDocumentlink objCDL = new ContentDocumentlink();
                            objCDL.ContentDocumentId = objCon.ContentDocumentId;
                            objCDL.linkedentityId = cas.id;
                            objCDL.Sharetype = 'I';
                            objCDL.Visibility = 'AllUsers';
                            lstConDoclink.add(objCDL);                        
                        }
                    }
                    if(lstConDoclink != null && lstConDoclink.size()>0){
                        Insert lstConDoclink;  
                        system.debug('check::::::'+lstConDoclink);
                    }
                }
                
                if(cs.PARTPRODUCT !=null && cs.PARTPRODUCT.size() > 0)
                {
                    List<REG_API_Case.PARTPRODUCTDETAILS> part = new List<REG_API_Case.PARTPRODUCTDETAILS>();
                    part = cs.PARTPRODUCT;
                    for(REG_API_Case.PARTPRODUCTDETAILS Pt: part){
                        Case_Line_Item__c LI = new Case_Line_Item__c();
                        LI.Case_Number__c = cas.id;
                        LI.Cage_Code__c = Pt.CageCode;
                        LI.Part_Number__c = Pt.PartNumber;
                        LI.Serial_Number_Shipped__c = Pt.SerialNumberShipped;
                        LI.Comments__c = Pt.AdditionalLineInfo;
                        if(Pt.Quantity!= null && Pt.Quantity != '')
                        {
                            LI.Quantity__c= Decimal.valueof(Pt.Quantity);
                        }
                        if(Pt.NetPrice != null && Pt.NetPrice != '')
                        {
                            LI.Price__c = decimal.valueof(Pt.NetPrice);
                        }
                        if(Pt.DateNeeded != null && Pt.DateNeeded != '')
                        {
                            LI.Date_Needed__c= Date.valueof(Pt.DateNeeded);
                        }
                        Lnit1.add(LI);
                    }
                    
                    if(Lnit1.size()>0)
                    {
                        try{
                            insert Lnit1;
                        }catch(Exception lnitemEx){
                            system.debug('Invalid--->'+lnitemEx.getMessage());
                        }
                    }
                }
                
                cr.caseNumber = [select id,CaseNumber,OwnerId from case where id= :cas.id][0].casenumber;
                
                if(isInserted == true && (cas.Subject != label.MyAerospace_Warranty_Credit_Request && cas.Subject != label.MyAerospace_BendixKing_Warranty_Credit_Request))
                {    
                    cr.message = 'Success!';         
                } 
                else if(isInserted == true && (cas.Subject == label.MyAerospace_Warranty_Credit_Request || cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request))        
                { 
                    cr.message = 'Success!';
                }
                
                result.Data = cr;
                result.StatusCode = 200;
                result.StatusMessage = 'Success';
            }    
            catch(Exception e){ 
                system.debug('e.getMessage()'+e.getMessage());
                result.handleError(500, 'Failure', 'Failure creating/updating SFDC case' +e.getMessage());
            }//end of try-catch  
            
            // Generic Email Notification for Customers submitting Contact Form
            if(cas.id != null && (cas.Subject != 'MyAerospace Sending Payment' && cas.Subject != 'MyAerospace Request Copy of Invoice' && cas.Subject != 'MyAerospace Address Updates' && cas.Subject != 'MyAerospace Billing General Inquiry' && cas.Subject != label.MyAerospace_Warranty_Credit_Request && cas.Subject != label.MyAerospace_BendixKing_Warranty_Credit_Request)) // && cas.Subject != 'MyAerospace Warranty / Claims Other'))
            { 
                Billingadd6.addAll(cas.SuppliedEmail.split(','));
                if(cas.Subject == 'CP Authorization Part Number Needed'){
                System.debug('Entered line 466 :'+cs.ccEmailAddress);
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_creation_Email_template,cas.id,label.AeroNo_Reply_email_ID,Billingadd6,ccAddress);                        
                    //Mail send to account team member
                    REG_CPAuthorization.saveCPAuthorizationCase(cs.ContactId,cas.id,cs.EmailAddress); 
                }
                else if(cas.Subject != 'MyAerospace Technical Issue (Product Specific)'){
                System.debug('Entered line 472 :'+cs.ccEmailAddress);
                    system.debug('inside sub__________');
                    if (String.isNotBlank(cs.ccEmailAddress))
                        ccAddress.addAll(cs.ccEmailAddress.split(','));
                     REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_creation_Email_template,cas.id,label.AeroNo_Reply_email_ID,Billingadd6,ccAddress);                        
                }else{  
                    if (String.isNotBlank(cs.ccEmailAddress))
                        ccAddress.addAll(cs.ccEmailAddress.split(','));
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_creation_Email_template,cas.id,label.AeroNo_Reply_email_ID,Billingadd6,ccAddress);                        
                }
            }
            
            // Added for Billing question Email confirmation to Customer without Status field
            // Updated condition for SCTASK3993721            
            else if((cas.id != null && cas.Type=='Orders' && (cas.Subject == 'MyAerospace Sending Payment' || cas.Subject == 'MyAerospace Request Copy of Invoice' || cas.Subject == 'MyAerospace Address Updates' || cas.Subject == 'MyAerospace Billing General Inquiry' ))||(cas.id != null && cas.Type=='Customer Master' && cas.Subject == 'MyAerospace Address Updates'))
            {      
                //Billingadd6.add('Sharri.Gauna@Honeywell.com');
                Billingadd6.addAll(cas.SuppliedEmail.split(','));
                system.debug('Billingadd6***'+Billingadd6);
                REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Creation1,cas.id,label.AeroNo_Reply_email_ID,Billingadd6,ccAddress);                    
            }
            
            
            //Added for Billing questions Email Notification to Billing Team  
            //Updated condition for SCTASK3993721          
            if((cas.id != null  && cas.Type=='Orders' && (cas.Subject == 'MyAerospace Sending Payment' || cas.Subject == 'MyAerospace Request Copy of Invoice'  || cas.Subject == 'MyAerospace Billing General Inquiry' || cas.Subject == 'MyAerospace Address Updates' ))||(cas.id != null && cas.Type=='Customer Master' && cas.Subject == 'MyAerospace Address Updates')){
                system.debug('cs.EmailAddress'+cs.EmailAddress);
                if(cs.EmailAddress == ContactEmail && cas.Subject != 'MyAerospace Address Updates')
                { 
                     system.debug('test1');
                    Billingadd3.addAll(label.Billing_question_confirm_Email.split(','));
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Confirmation_for_Billing_team1,cas.id,label.AeroNo_Reply_email_ID,Billingadd3,ccAddress);                      
                }
                else if(cs.EmailAddress == ContactEmail && cas.Subject == 'MyAerospace Address Updates')
                {
                      system.debug('test2');
                    Billingadd2.addAll(label.Billing_question_address_update_confirm_Email.split(','));
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Confirmation_for_Billing_team1,cas.id,label.AeroNo_Reply_email_ID,Billingadd2,ccAddress); 
                }
                else if(cas.Subject != 'MyAerospace Address Updates' && cs.EmailAddress != ContactEmail)
                {
                     system.debug('test3');
                    Billingadd3.addAll(label.Billing_question_confirm_Email.split(','));
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Confirmation_for_Billing_team,cas.id,label.AeroNo_Reply_email_ID,Billingadd3,ccAddress);   
                }
                else if(cas.Subject == 'MyAerospace Address Updates' && cs.EmailAddress != ContactEmail)
                {
                     system.debug('test4');
                    Billingadd2.addAll(label.Billing_question_address_update_confirm_Email.split(','));
                    REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Confirmation_for_Billing_team,cas.id,label.AeroNo_Reply_email_ID,Billingadd2,ccAddress); 
                }
            }
            
            // Added for Sending Email Confirmation to BendixKing Instance from SFDC
            if(cas.id != null && (cas.Subject == label.MyAerospace_Warranty_Credit_Request || cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request)) // || cas.Subject =='MyAerospace Warranty / Claims Other'))
            {  
                system.debug('inside bendixking:');          
                string htmlBody='';
                string subject='';
                String formatted;
                subject += getCaseNumber(cas.id);
                if(cas.Subject =='MyAerospace Warranty / Claims Other'){
                    subject += ' '+'MyAerospace Warranty / Claims Other';
                }else{
                    subject += ' '+'MyAerospace BendixKing Warranty Credit Request';
                }
                emailTemplate et = [SELECT HtmlValue FROM EmailTemplate WHERE DeveloperName = 'MyAerospace_BendixKing_Warranty_Credit_Request'];
                string HTMLver = et.HtmlValue ;
                List<Object> parameters = new List<Object>();
                
                
                if(ContactInformation == '')
{
parameters = new List<Object> {(cas.Description).replace('\n', '<br>') ,cas.SuppliedEmail ,cas.Additional_Web_Form_Info__c ,(cas.Owner_Operator_Information__c).replace('\n', '<br>'),getCaseNumber(cas.id)};
}
else if(ContactInformation != null)
{   
parameters = new List<Object> {(cas.Description).replace('\n', '<br>') ,ContactInformation ,cas.Additional_Web_Form_Info__c ,(cas.Owner_Operator_Information__c).replace('\n', '<br>'),getCaseNumber(cas.id)};
}
                formatted = String.format(HTMLver, parameters); 
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];           
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();               
                String[] toAddresses = new String[]{};
                String[] ccAddr = new String[]{};
                String Bendixadd = label.Bendixking_Instance;              
                 //SCTASK2668239 start              
                //toAddresses.add(Bendixadd);
                //SCTASK2668239 end
                if(con[0].email!= null)
                 toAddresses.add(con[0].email);
                system.debug('toAddresses***'+toAddresses);
                mail.setToAddresses(toAddresses);
               // if(!ccAddr.isEmpty())
               /* ccAddr.addAll(cs.ccEmailAddress.split(','));
                system.debug('ccAddr'+ccAddr);
                mail.setccAddresses(ccAddr);*/
                if (owea.size() > 0) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setSubject(subject);
                //mail.setHtmlBody(htmlBody);
                mail.setHtmlBody(formatted);
                /*List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId =: cas.id]){
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    fileAttachments.add(efa);
                }
                system.debug('Attachments++:'+fileAttachments);
                mail.setFileAttachments(fileAttachments);*/
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });  
            }
        }
        catch(exception e)
        {
            //Billingadd1.addAll(label.ADEcaseexception.split(','));
            //Billingadd1.addAll('amits.kate@tcs.com'.split(','));
            //REG_RegistrationUtility.emailMessage(conid,label.ADE_Case_Exception_mail_to_Customer,cas.id,label.AeroNo_Reply_email_ID,Billingadd1,ccAddress);            
        }
        
        return result;
        
        
    }//fncCreateCase
    
    public static string getCaseNumber(Id caseId){
        List<Case> sfdccase = [select id,CaseNumber,OwnerId from case where id=: caseId];           
        system.debug('cas------888'+sfdccase);  
        return sfdccase[0].caseNumber; 
    }
    public class CaseResponse{
        string caseNumber;
        string message;
    }
    //Description Pacing for order Type
    public static String getInbetweenValues(String inputString, String startStr, String endStr){
        String resultStr;
        if(String.isNotBlank(inputString) && String.isNotBlank(startStr)){
            resultStr = inputString.substringBetween(startStr, endStr);
            if(String.isNotBlank(resultStr))
                resultStr.trim();
        }
        return resultStr;
    }
    
    public static REG_Result getCasePickListVlaues(String inputfieldname){
       string fieldname = inputfieldname.tolowercase();
        REG_Result result = new REG_Result();
        List<String> lstPickListValues = new List<String>();
        Map<String, String> mapFieldMap = new Map<String, String>{'atachapter' =>'ATA_Chapter__c','producttype' => 'Product_Type__c', 'ordertype'=>'Order_Type__c', 'changetype'=>'Change_Type__c','exportcompliancecontent'=>'Export_Compliance_Content_ITAR_EAR__c', 'governmentcompliancecontent'=>'Government_Compliance_SM_M_Content__c'};
            try{
                if(mapFieldMap.containsKey(fieldname)){
                    lstPickListValues = REG_RegistrationUtility.getPickListVlaues('Case', mapFieldMap.get(fieldname));
                    result.data = lstPickListValues;
                    
                    if(lstPickListValues.size()>0){
                        result.StatusCode=200;
                        result.StatusMessage='OK';
                    }else{
                        result.handleError(400, 'Data Not Found', 'PickList values not found for given field name.');
                    }
                }
                else{
                    result.handleError(400, 'Invalid Field Name', 'Field not configured for picklist values.');
                }
            }catch(Exception e){
                result.handleException(500, e.getMessage(), e);
            }
        return result;
        
    }//getCasePickListVlaues
    
    public static String getContactInformation(Contact con){
        system.debug('getContactInformation:start');
            String ContactInformation=''; 
            
            if(con.Account.name != null)
                ContactInformation +=  con.Account.name;
            if(con.name != null)
                ContactInformation +=  ','+con.name;
            if(con.Primary_Email_Address__c != null)
                ContactInformation +=  ', Email:'+con.Primary_Email_Address__c;
            if(con.Phone_1__c != null)
                ContactInformation += ','+con.Phone_1__c;
            if(con.Address_Line_1__c != null)
                ContactInformation += ','+con.Address_Line_1__c;
            if(con.Address_Line_2__c != null)
                ContactInformation += ','+con.Address_Line_2__c;
            if(con.City_Name__c != null)
                ContactInformation += ','+con.City_Name__c;
            if(con.State_Code__c != null)
                ContactInformation += ','+con.State_Code__c;
            if(con.Country_Name__c != null)
                ContactInformation += ','+con.Country_Name__c;
            if(con.Postal_Code__c != null)
                ContactInformation += ','+con.Postal_Code__c;
            
            return ContactInformation;
        
    }
    
}
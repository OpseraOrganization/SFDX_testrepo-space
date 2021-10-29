/*******************************************************************************
Name                :   CaseCreationSitecoretoSFDC
Created By          :   Nandini Nanjappan
Company Name        :   NTT Data
Project             :   <ADE> 
Created Date        :   13-Sep-2016
Usages              :   Creating Case based on Sitecore and sending response as Case Number     
Modification History
Date            Version No.     Modified by     Brief Description of Modification
16-Aug-2017     1.1             NTTDATA         Added fields for INC000012264047 
28-Mar-2018     1.2             NTTDATA         Modified code to populate Aircraft Type for INC0000337872
09-Apr-2018     1.3             NTTDATA         Modified code to populate Classification, Sub Class and Owner for INC0000460726. Deployed by TCS on agreement with client
*******************************************************************************/
global class CaseCreationSitecoretoSFDC{
    global class CaseData{
        webservice string CaseNumber;
        webservice string EmailAddress;
        webservice string CaseSubject;
        webservice string SubClass;
        webservice string DetailClass;
        webservice string AdditionalWebFormInfo;
        webservice string Origin;
        webservice string OrderType;
        webservice string OrderStatusInfoRequested;
        webservice string Contactid;
        webservice string PortalContactEmail;
        webservice string HoneywellID;
        webservice string Priority; 
        webservice string TYPE;  
        webservice String Classification;
        webservice string CUSTOMER_PO_RO_WO_NUM;
        webservice string SALES_ORDER_NUM;
        webservice string ExportCompliance;
        webservice string GovernmentCompliance;
        webservice string Status;     
        webservice string DESCRIPTION;    
        webservice string SUBJECT; 
        webservice string InvoiceNumber;
        webservice string Aircrafttype;
        webservice string AircraftSerialNumber;  
        webservice string ProductType;
        webservice string IntendedUse;
        webservice string EndUseforthisPartAssembly;
        webservice string EndUserAddress;
        webservice string HoneywellOrderNumber;    
        webservice string ChangeType;
        webservice string AdditionalAircraftInfo;
        webservice string PartNumber;
        webservice string AircraftTailNumber;
        webservice string TopLevelAssemblyPartNumber;
        webservice string TopLevelAssemblySerialNumber;
        webservice string DateofFailure;
        webservice string ReasonForRemoval;
        webservice string HoneywellInvoiceNumber;
        webservice string ExternalRef;
        webservice string ServiceBulletinNumber;
        webservice string AmountofFreightClaim;
        webservice string LaborTime; 
        webservice string LaborRate;
        webservice string LaborCharges;
        webservice string AmountofMaterialClaim;
        webservice string AmountofTotalClaim;
        webservice string AttachmentType;
        webservice string FileAttachment;
        webservice string AircraftMake;
        webservice string AircraftModel;       
        webservice List<Attachmentlist> Attachments;        
        webservice List<LINEITEMDETAILS> LINEITEMS;
        webservice List<PARTPRODUCTDETAILS> PARTPRODUCT;
        webservice List<ITEMIZEDPARTS> LINEITEMPARTS; 
        // Added fields for INC000012264047
        webservice string PHASE_OF_FLIGHT;
        webservice string Fault_Code;
        webservice string Part_Number;
        // End for adding fields for INC000012264047
    }
    global class LINEITEMDETAILS{
        webservice string PartNumber;
        webservice String SerialNumberShipped;
        webservice String AdditionalLineInfo;
        webservice String Quantity;
        webservice String NetPrice;
        webservice String CaselineitemNumber;
        webservice String ProductName;
        webservice String ProductNumber;
        webservice String CaseNumber;
        webservice String DeliveryDate;
        webservice String LeadTime;
        webservice String Discount;
    }
    global class PARTPRODUCTDETAILS{
        webservice string PartNumber;
        webservice String SerialNumberShipped;
        webservice String AdditionalLineInfo;
        webservice String CageCode;
        webservice String DateNeeded;
        webservice String Quantity;
        webservice String NetPrice;
        webservice String CaselineitemNumber;
        webservice String ProductName;
        webservice String ProductNumber;
        webservice String CaseNumber;      
        webservice String Discount;
    }
    global class ITEMIZEDPARTS{
        webservice string PartNumber;
        webservice String SerialNumberShipped;
        webservice String AdditionalLineInfo;
        webservice String Quantity;
        webservice String NetPrice;
        webservice String CaselineitemNumber;
        webservice String ProductName;
        webservice String ProductNumber;
        webservice String CaseNumber;
        webservice String DeliveryDate;
        webservice String LeadTime;
        webservice String Discount;
    }
    global class Attachmentlist{
        webservice string AttBody;
        webservice String AttFileName;
        webservice String AttContentType;
    }
    global class CaseDataSFDCtoSitecore{
        webservice string caseNumber;
        webservice string message;
    }
    
    webservice static CaseDataSFDCtoSitecore createCase(CaseData cs){
    List<contact> con=new List<contact>();
    List<Platform__c> platformname= new List<Platform__c>();
    List<Attachment> attlist = new List<Attachment>();
    List<Attachment> taskattlist = new List<Attachment>();
    List<case_line_item__c> Lnitmlist;
    List<Case_Line_Item__c> Lnit1 = new List<Case_Line_Item__c>();
    String ccEmails;//Change to add CC Email for Technical issue 
    String rtn;
    String Casenum = '';
    string conid=Label.UFR_Cont_Id;
    List<case> cas1=new List<case>();
    Boolean caseupdate=false;
    String ContactEmail;
    String ContactInformation='';
    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
    List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> bulkEmails = new List<Messaging.SingleEmailMessage>();  
    Messaging.SingleEmailMessage msg1 = new Messaging.SingleEmailMessage();
    List<Messaging.SingleEmailMessage> msgList1 = new List<Messaging.SingleEmailMessage>();
    List<Messaging.SingleEmailMessage> bulkEmails1 = new List<Messaging.SingleEmailMessage>(); 
    CaseDataSFDCtoSitecore cse = new CaseDataSFDCtoSitecore();
    Map<string,SitecoreCaseType__c> Mapcasetype = new Map<string,SitecoreCaseType__c>();
    Mapcasetype = SitecoreCaseType__c.getAll();
    // Code Added for INC0002166886 Start    
    if(cs.SUBJECT == 'MyAerospace FileUpload Request'){
        cse.caseNumber = 'NA';
        if(cs.Attachments!=Null){
            List<Attachmentlist> attachList = cs.Attachments;
            List<Document> docList = new List<Document>();
            List<Folder> folderList = [SELECT id, Name FROM Folder WHERE DeveloperName='Channel_Partner_Sales_Data'];
            id folderId = (!folderList.isEmpty())?folderList[0].Id:Null;
            List<Contact>conList= [select id,accountid,account.name,email,name,Primary_Email_Address__c from contact where email=:cs.EmailAddress limit 1];
            String custDesc = '';
            if(!conList.isEmpty()){
                custDesc += 'Customer Name: '+conList[0].Name+'\n';
                custDesc += 'Customer Email: '+cs.EmailAddress+'\n';
                custDesc += 'Account Name: '+conList[0].account.name+'\n';
            }
            for(Attachmentlist attach : attachList){
                Document d = new Document();
                d.name = attach.AttFileName;
                d.Body = Blob.valueOf(attach.AttBody);
                d.ContentType = attach.AttContentType;
                D.Description = custDesc;
                d.FolderId = folderId;
                docList.add(d);
            }
            try{
                if(!docList.isEmpty()){
                    insert docList;
                }
                cse.message = 'Success';
            }catch(Exception ex){
                cse.message = 'Fail';
            }
        }else{
            cse.message = 'No Attachment found.';
        }
        
        return cse;
    }
    // Code Added for INC0002166886 Ends
    Case cas = new Case();
    cas.Status = 'Open';
    Service_Request__c serRq = new Service_Request__c();
    system.debug('cs Type------'+cs.TYPE);
    if(Mapcasetype.get('TechnicalIssueInquiry').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('TechnicalIssueInquiry').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('TechnicalIssueInquiry').Case_Record_Type__c;
        // Code Added for INC0002166886 Start
        String aogVal = getInbetweenValues(cs.DESCRIPTION, 'Are you AOG:', '\n');
        String dueDateVal = getInbetweenValues(cs.DESCRIPTION, 'Due Date:', '\n');
        String aircraftType = getInbetweenValues(cs.DESCRIPTION, 'Aircraft Type:', '\n');
        ccEmails = getInbetweenValues(cs.DESCRIPTION, 'CC Email Address:', '\n');
        if(String.isBlank(cs.AircraftSerialNumber)){
            cs.AircraftSerialNumber = getInbetweenValues(cs.DESCRIPTION, 'Aircraft Serial Number:', '\n');
        }
        if(String.isBlank(cs.PHASE_OF_FLIGHT)){
            cs.PHASE_OF_FLIGHT = getInbetweenValues(cs.DESCRIPTION, 'Phase of Flight:', '\n');
        }
        if(String.isBlank(cs.Part_Number)){
            cs.Part_Number = getInbetweenValues(cs.DESCRIPTION, 'Part Number:', '\n');
        }
        
        
        try{
            if(String.isNotBlank(aircraftType)){
                List<Platform__c> platformList = [SELECT id, name FROM Platform__c WHERE Name = :aircraftType LIMIT 1];
                if(!platformList.isEmpty())
                    cas.Aircraft_Type__c = platformList[0].Id;
            }
            if(String.isNotBlank(dueDateVal)){
                cas.Due_Date__c = Date.parse(dueDateVal);
                cas.Expected_Update__c = cas.Due_Date__c;
            }
        }catch(Exception e){
            System.debug('Exception '+e.getMessage());
        }
        if(aogVal != Null && aogVal.toLowerCase() =='yes' && cas.Expected_Update__c!=Null){
            cas.AOG__c = true;
        }
        // Code Added for INC0002166886 Ends
    }
    if(Mapcasetype.get('EGPWS').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('EGPWS').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('EGPWS').Case_Record_Type__c;
    }
        
    //HoneywellAvionicsProtectionProgram Deleted in QA, added null check deployed with INC0002166886
    if(Mapcasetype.get('HoneywellAvionicsProtectionProgram') !=Null && Mapcasetype.get('HoneywellAvionicsProtectionProgram').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('HoneywellAvionicsProtectionProgram').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('HoneywellAvionicsProtectionProgram').Case_Record_Type__c;
    }
    if(Mapcasetype.get('MaintenanceServicePrograms').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('MaintenanceServicePrograms').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('MaintenanceServicePrograms').Case_Record_Type__c;
    }      
    if(Mapcasetype.get('NavDBandEGPWS').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('NavDBandEGPWS').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('NavDBandEGPWS').Case_Record_Type__c;
    }  
    
    //Added to create cases for Orders record type  
    //OnlineOrdering Deleted in QA, added null check deployed with INC0002166886    
    if(Mapcasetype.get('OnlineOrdering')!=Null && Mapcasetype.get('OnlineOrdering').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('OnlineOrdering').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('OnlineOrdering').Case_Record_Type__c;

    
    /* if(cs.CUSTOMER_PO_RO_WO_NUM != null &&  cs.CUSTOMER_PO_RO_WO_NUM != '' && Mapcasetype.get('OnlineOrdering').Case_Type__c == 'Orders' && (cs.SUBJECT == 'MyAerospace Submit a Paper PO' || cs.SUBJECT == 'MyAerospace Change an Existing Order' ))
    {
        cas1= [select id,contactid,Customer_PO_RO_WONumber__c,Aircraft_Type__c,recordtypeid from case  where Customer_PO_RO_WONumber__c =: cs.CUSTOMER_PO_RO_WO_NUM  and isclosed = false and recordtypeid =: label.Order_RecordType limit 1]; 
        if(cas1.size()>0 && cas1[0].Customer_PO_RO_WONumber__c != null && Mapcasetype.get('OnlineOrdering').Case_Type__c == 'Orders')
        {
            caseupdate=true;
            string caseid=cas1[0].id;
            string casesubject=cs.subject;
            task newtask = new task();
            newtask.OwnerId = Label.aero_default_user_id;
            if(cs.contactid != null && cs.contactid!= '')
            {
            newtask.WhoId = cs.contactid;
            }
            else
            {
            newtask.WhoId = cas1[0].contactid;
            }
            newtask.WhatId = cas1[0].id;
            newtask.subject = casesubject;
            newtask.RecordTypeId = Label.R_O_Activity_Label;
            newtask.Priority= cs.Priority;
            newtask.Description= cs.AdditionalWebFormInfo;
            newtask.Description__c= cs.Description;
            newtask.Status= cs.Status;
            try
            {
                insert newtask;
                if(newtask.id != null)
                {
                    cse.caseNumber = getCaseNumber(caseid);
                    cse.message = 'Success'; 
                    List<Attachmentlist> TaskAttach = new List<Attachmentlist>();
                    TaskAttach = cs.Attachments;
                    for(Attachmentlist ta: TaskAttach){
                    if((ta.AttBody!=null && ta.AttBody!='' && ta.AttBody!='null') && (ta.AttFileName!=null && ta.AttFileName!='' && ta.AttFileName!='null') && (ta.AttContentType!=null && ta.AttContentType!='' && ta.AttContentType!='null'))
                    {
                        Blob tstbody = EncodingUtil.base64Decode(ta.AttBody);
                        Attachment att = new Attachment();
                        att.Body = tstbody;
                        att.ContentType = ta.AttContentType;
                        att.Name = ta.AttFileName;
                        att.ParentId = newtask.id;
                        att.OwnerId = newtask.OwnerId;
                        taskattlist.add(att);
                    }   
                    }
                    if(taskattlist.size()>0){
                    try
                        {
                            insert taskattlist;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                        }
                    }
                    
                }
                cse.caseNumber = getCaseNumber(caseid);
                cse.message = 'Success'; 
            }
            catch(exception e)
            {
                system.debug('inside catch');
                cse.message = 'Invalid - '+e.getMessage();
            }
        }       
    
    }*/
    }
    
    if(Mapcasetype.get('PilotNewsandAlertsSign-up').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('PilotNewsandAlertsSign-up').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('PilotNewsandAlertsSign-up').Case_Record_Type__c;
    }
     
    //Added to create cases with Web Support Record Type for Registration tool access and website issues topic
    if(Mapcasetype.get('WebsiteIssues/Registrationtoolaccess').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('WebsiteIssues/Registrationtoolaccess').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('WebsiteIssues/Registrationtoolaccess').Case_Record_Type__c;
    }
    
    //Added to create cases for warranty 
    if(Mapcasetype.get('WarrantyClaims') != Null && Mapcasetype.get('WarrantyClaims').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('WarrantyClaims').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('WarrantyClaims').Case_Record_Type__c;
    }
    
     //Added for cases related to BendixKing warranty claims
     if(Mapcasetype.get('BK Warranty').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('BK Warranty').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('BK Warranty').Case_Record_Type__c;
    }
    
    
    //Added to create cases for Registration tool access topic
    if(Mapcasetype.get('WebPortalRegistration').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('WebPortalRegistration').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('WebPortalRegistration').Case_Record_Type__c;
    }
    
    //Added to create cases with TechPubs Type for Registration tool access topic
    if(Mapcasetype.get('TechPubs').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('TechPubs').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('TechPubs').Case_Record_Type__c;
    }
    
     //Added to create cases with Training Type 
    if(Mapcasetype.get('Technical Training Services').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('Technical Training Services').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('Technical Training Services').Case_Record_Type__c;
    }
    
      //Added to create cases with Global Customer Committee Type 
    if(Mapcasetype.get('Global Customer Committee').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('Global Customer Committee').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('Global Customer Committee').Case_Record_Type__c;
       
    }
    
    //Added to create cases with General record Type 
    if(Mapcasetype.get('Product Stewardship - general').Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = Mapcasetype.get('Product Stewardship - general').Case_Owner__c;
        cas.RecordtypeId = Mapcasetype.get('Product Stewardship - general').Case_Record_Type__c;
    }
        
     //Added to create cases with General record Type 
    SitecoreCaseType__c siteCoreType = Mapcasetype.get('Services-AOG');
    if(siteCoreType!=Null && siteCoreType.Case_Type__c == cs.TYPE)
    {
        if(cs.OrderType == 'Services'){
            cas.OwnerId = siteCoreType.Case_Owner__c;
            cas.RecordtypeId = siteCoreType.Case_Record_Type__c;
        }
    }
        
    SitecoreCaseType__c siteCoreType1 = Mapcasetype.get('Customer Master Data');
    if(siteCoreType1!=Null && siteCoreType1.Case_Type__c == cs.TYPE)
    {
        cas.OwnerId = siteCoreType1.Case_Owner__c;
        cas.RecordtypeId = siteCoreType1.Case_Record_Type__c;
    }
    
    cas.Origin = cs.Origin; 
    cas.Type = cs.TYPE;
    cas.Additional_Web_Form_Info__c=cs.AdditionalWebFormInfo;
    cas.Order_Type__c = cs.OrderType;
    cas.Order_Status_Info_Requested__c=cs.OrderStatusInfoRequested;
    cas.SuppliedEmail = cs.EmailAddress;
    if(cs.EmailAddress!= null && cs.EmailAddress!= '' && cs.EmailAddress!= 'null')
    system.debug('Inside emailaddress');
    {    
        con= [select id,accountid,account.name,email,name,Primary_Email_Address__c,Phone_1__c,Address_Line_1__c,Address_Line_2__c,Honeywell_ID__c,City_Name__c,State_Code__c,Country_Name__c,Postal_Code__c,Job_Title__c from contact where email=:cs.EmailAddress limit 1]; 
        system.debug('Inside emailaddress con' +con);
        if(con.size()>0)
        {
            system.debug('Inside emailaddress1');
            cas.ContactId=con[0].id;
            cas.AccountId=con[0].accountid;
            ContactEmail = con[0].email;
            if(con[0].Account.name != null)
            ContactInformation +=  con[0].Account.name;
            if(con[0].name != null)
            ContactInformation +=  ','+con[0].name;
            if(con[0].Primary_Email_Address__c != null)
            ContactInformation +=  ', Email:'+con[0].Primary_Email_Address__c;
            if(con[0].Phone_1__c != null)
            ContactInformation += ','+con[0].Phone_1__c;
            if(con[0].Address_Line_1__c != null)
            ContactInformation += ','+con[0].Address_Line_1__c;
            if(con[0].Address_Line_2__c != null)
            ContactInformation += ','+con[0].Address_Line_2__c;
            if(con[0].City_Name__c != null)
            ContactInformation += ','+con[0].City_Name__c;
            if(con[0].State_Code__c != null)
            ContactInformation += ','+con[0].State_Code__c;
            if(con[0].Country_Name__c != null)
            ContactInformation += ','+con[0].Country_Name__c;
            if(con[0].Postal_Code__c != null)
            ContactInformation += ','+con[0].Postal_Code__c;
        }
        else
        {
            cas.SuppliedEmail = cs.EmailAddress; 
        }
    }
    
    
    cas.Owner_Operator_Information__c =cs.PortalContactEmail;
    cas.Honeywell_ID__c=cs.HoneywellID;
    cas.Classification__c = cs.Classification;
    String submitPoReason;
    String submitPoOtherReason;
        if(cs.TYPE == 'Orders'){
            submitPoReason = getInbetweenValues(cs.DESCRIPTION, 'Reason for submitting Paper PO:', '\n');
            
            if(cs.OrderType == 'Services'){
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
                
                if(String.isNotBlank(submitPoReason) && submitPoReason.contains('Other')){
                    submitPoReason = 'Other';
                    submitPoOtherReason = getInbetweenValues(cs.DESCRIPTION, 'Other Spare Reason:', '\n');
                }
            }
            
            cas.Paper_PO_Reason__c = submitPoReason;
            cas.Paper_PO_Other_Reason__c = submitPoOtherReason;
            cas.Customer_PO_RO_WONumber__c = getInbetweenValues(cs.DESCRIPTION, 'Purchase Order Number:', '\n');
        }
    
   
    cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cas.Government_Compliance_SM_M_Content__c = 'No';
    cas.Subject = cs.SUBJECT;
    cas.Description = cs.DESCRIPTION; 
    cas.Invoice_Number__c = cs.InvoiceNumber;                    
    cas.Aircraft_Serial_Number__c = cs.AircraftSerialNumber;  
    // Modified Code for INC000012264047
    //cas.Product_Type__c = cs.ProductType;
    if(cs.ProductType!=null && cs.ProductType!=''){
        List<Supported_Products__c> sp = [SELECT id,Name,Product_Type__c,Status__c FROM Supported_Products__c where Status__c ='Active' and Name=:cs.ProductType limit 1];
        if(sp!=null && sp.size()>0)
            cas.Supported_Products__c = sp[0].id;
    }
    // End code for INC000012264047
    cas.Intended_Use__c = cs.IntendedUse;
    cas.End_Use_for_this_Part_Assembly__c = cs.EndUseforthisPartAssembly;
    cas.End_User_Address__c = cs.EndUserAddress;
    cas.Honeywell_Order_Number__c = cs.HoneywellOrderNumber;    
    cas.Change_Type__c = cs.ChangeType;
    cas.Additional_Information__c = cs.AdditionalAircraftInfo;
    cas.Product_Part_Number__c = cs.PartNumber; // Modified Code for INC000012264047    
    cas.Aircraft_Tail_Number__c = cs.AircraftTailNumber;
    cas.Top_Level_Assembly_Part_Number__c = cs.TopLevelAssemblyPartNumber;
    cas.Top_Level_Assembly_Serial_Number__c = cs.TopLevelAssemblySerialNumber;
    if(cs.DateofFailure != null && cs.DateofFailure != '')
    {
        cas.Date_of_Failure__c = Date.valueof(cs.DateofFailure);
    }
    cas.Reason_For_Removal__c = cs.ReasonForRemoval;
    cas.Honeywell_Invoice_Number__c = cs.HoneywellInvoiceNumber;
    cas.Customer_Reference_Number__c = cs.CUSTOMER_PO_RO_WO_NUM;
    cas.Service_Bulletin_Number__c = cs.ServiceBulletinNumber;
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
    // Added code for INC0000337872
    if(cs.AircraftMake!=null && cs.AircraftMake!='' && cs.AircraftModel!=null && cs.AircraftModel!=''){
        List<Platform__c> pf = [SELECT id,Name,Make__c,Model__c FROM Platform__c where Make__c=:cs.AircraftMake and Model__c=:cs.AircraftModel limit 1];
        if(pf!=null && pf.size()>0)
            cas.Aircraft_Type__c = pf[0].id;
    }
    // End code for INC0000337872
    cas.Make__c = cs.AircraftMake;
    cas.Model__c = cs.AircraftModel; 
    cas.Job_Title__c = cs.SubClass;
    cas.Citizenship__c = cs.DetailClass;
    
    // Added code for INC000012264047
    cas.Phase_of_Flight__c = cs.PHASE_OF_FLIGHT;
    cas.Fault_Messages__c = cs.Fault_Code;
    cas.ATA_Chapter__c = cs.CaseSubject;
    cas.Part_Number__c = cs.Part_Number;
    // End code for INC000012264047
    // Added code for INC0000460726. TCS- Deployed to prod after agreemnent from client
    system.debug('++++IN '+cas.OwnerId);
    system.debug('++++ '+cs.DESCRIPTION);
    if(cs.DESCRIPTION!=null){
        system.debug('++++1 '+cs.DESCRIPTION);
        if(cs.DESCRIPTION.contains('Type of Product: Bendix King')){
            system.debug('Bendix King');
            system.debug('++++2 '+cs.DESCRIPTION);
            system.debug('Label.ATS_BK_Team '+Label.ATS_BK_Team);
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
    system.debug('++++OUT'+cas.OwnerId);
    // End code for INC0000460726
    // Added for Auto Close of Orders records created by Billing Questions
    if(cas.Subject == 'MyAerospace Request Copy of Invoice' || cas.Subject == 'MyAerospace Address Updates' || cas.Subject == 'MyAerospace Billing General Inquiry' || cas.Subject == 'MyAerospace Sending Payment' || (cas.Subject == label.MyAerospace_Warranty_Credit_Request )) 
    //commenting as per Cindy comments to have case with open status
    //|| (cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request ))
    {
    system.debug('cas.Subject------'+cas.Subject);
    cas.OwnerId = label.aero_default_user_id;
    cas.Status = 'Closed';
    }
    
    Boolean isInserted = false;
    try
    {
    try
    {   
        system.debug('Case Record is:'+cas);
        insert cas;
        system.debug('cas------'+cas);
        isInserted = true;
        // TCS - added for service request change
        if(Mapcasetype.get('Global Customer Committee SR').Case_Type__c == cs.TYPE){
             //serRq.OwnerId = '00530000006rlCS';
            for(string description : cs.DESCRIPTION.split('\n')){
                system.debug('***** description'+ description );
                if(description.contains('Process/Services Affected')){
                    system.debug('***** description Process'+ description.split(':',2)[1]);
                    serRq.Customer_Impact__c = description.split(':',2)[1];
                }
               if(description.contains('Proposed Solution / Criteria to close')){
                        system.debug('***** description Proposed '+ description );
                        serRq.Deliverable__c= description.split(':',2)[1];
               }
            
            
            }
            serRq.Case_Number__c = cas.Id;
            serRq.RecordtypeId = Mapcasetype.get('Global Customer Committee SR').Case_Record_Type__c;
            //serRq.SR_Type__c = cs.TYPE;
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
                insert serRq;
            }
            system.debug('*****serRq*****' +serRq);
        }       
        // TCS - Change for service request ended
        system.debug('cs.Attachments------'+cs);
        if(cas.id != null && cs.Attachments !=null)
        {
            system.debug('Inside att');
            List<Attachmentlist> Attach = new List<Attachmentlist>();
            Attach = cs.Attachments;
            for(Attachmentlist att: Attach ){
                if((att.AttBody!=null && att.AttBody!='' && att.AttBody!='null') && (att.AttFileName!=null && att.AttFileName!='' && att.AttFileName!='null') && (att.AttContentType!=null && att.AttContentType!='' && att.AttContentType!='null'))
                {
                    Blob tstbody = EncodingUtil.base64Decode(att.AttBody);
                    Attachment att1 = new Attachment();
                    att1.Body = tstbody;
                    att1.ContentType = att.AttContentType;
                    att1.Name = att.AttFileName;
                    att1.ParentId = cas.id;
                    attlist.add(att1);
                }
            }
            if(attlist.size()>0){
                try{
                    insert attlist;
                }catch(Exception attEx){
                    system.debug('Invalid--->'+attEx.getMessage());
                }
            }             
        }
        
        if(cs.PARTPRODUCT.size() > 0 && cs.PARTPRODUCT !=null )
        {
            List<PARTPRODUCTDETAILS> part = new List<PARTPRODUCTDETAILS>();
            part = cs.PARTPRODUCT;
            for(PARTPRODUCTDETAILS Pt: part){
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
    }   
    catch(Exception e)
        { 
           rtn='Failure creating/updating SFDC case ';
           rtn=rtn+e;
        }    
 
    // Generic Email Notification for Customers submitting Contact Form
    if(cas.id != null && (cas.Subject != 'MyAerospace Sending Payment' && cas.Subject != 'MyAerospace Request Copy of Invoice' && cas.Subject != 'MyAerospace Address Updates' && cas.Subject != 'MyAerospace Billing General Inquiry' && cas.Subject != label.MyAerospace_Warranty_Credit_Request && cas.Subject != label.MyAerospace_BendixKing_Warranty_Credit_Request))
    { 
        system.debug('TestSubject------>1'+cas.Subject);
        msg.setTargetObjectId(conid);
        msg.setsaveAsActivity(false);
        msg.setTemplateId(label.ADE_Case_creation_Email_template);
        msg.setWhatId(cas.id);
        msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
        msgList.add(msg);
        system.debug(msgList);
        system.debug('cas.SuppliedEmail' +cas.SuppliedEmail);
        String[] toAddresses = new String[] {cas.SuppliedEmail};    
        //TCS - CC Address added on demand of customer. Can be disabled in QA but should be there in Prod.
       // String[] ccAddresses = new String[]{'Alejandro.Gonzalez6@Honeywell.com', 'Orlanda.Munoz@Honeywell.com', 'Olivier.Desplanques@Honeywell.com'};
        Savepoint sp = Database.setSavepoint();                 
        if(msg.getTemplateId()!=null)
            Messaging.sendEmail(msgList);
            Database.rollback(sp);
            if(msgList.size()>0){
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);
                    //TCS - CC Address added on demand of customer. Can be disabled in QA but should be there in Prod.
                   /* if(cas.Subject == 'MyAerospace GCC General Inquiry' || cas.Subject == 'MyAerospace GCC Propose New Issue' || cas.Subject == 'MyAerospace GCC Become a Member'){
                        emailToSend.setCCAddresses(ccAddresses);                                
                    }*/
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(String.isNotBlank(ccEmails))
                        emailToSend.setCcAddresses(ccEmails.split(','));
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails);
                }
            }                         
    }
    
    // Added for Billing question Email confirmation to Customer without Status field
   
    else if(cas.id != null && cas.Type=='Orders' && (cas.Subject == 'MyAerospace Sending Payment' || cas.Subject == 'MyAerospace Request Copy of Invoice' || cas.Subject == 'MyAerospace Address Updates' || cas.Subject == 'MyAerospace Billing General Inquiry' ))
    { 
        system.debug('TestSubject------>1'+cas.Subject);
        msg.setTargetObjectId(conid);
        msg.setsaveAsActivity(false);
        msg.setTemplateId(label.ADE_Case_Creation1);
        msg.setWhatId(cas.id);
        msg.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
        msgList.add(msg);
        system.debug(msgList);
        String[] toAddresses = new String[] {cas.SuppliedEmail};    
        Savepoint sp = Database.setSavepoint();                 
        if(msg.getTemplateId()!=null)
            Messaging.sendEmail(msgList);
            Database.rollback(sp);
            if(msgList.size()>0){
                for(Messaging.SingleEmailMessage email : msgList){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails);
                }
            }                         
    }
    
    if(bulkEmails.size()>0)
    {
        Messaging.sendEmail(bulkEmails);
    }
    
    //Added for Billing questions Email Notification to Billing Team
    
    if(cas.id != null  && cas.Type=='Orders' && (cas.Subject == 'MyAerospace Sending Payment' || cas.Subject == 'MyAerospace Request Copy of Invoice'  || cas.Subject == 'MyAerospace Billing General Inquiry' || cas.Subject == 'MyAerospace Address Updates' )){
        system.debug('cs.EmailAddress'+cs.EmailAddress);
        if(cs.EmailAddress == ContactEmail && cas.Subject != 'MyAerospace Address Updates')
        { 
            system.debug('TestSubject------>1'+cas.Subject);
            msg1.setTargetObjectId(conid);
            msg1.setsaveAsActivity(false);
            msg1.setTemplateId(label.ADE_Case_Confirmation_for_Billing_team1);
            msg1.setWhatId(cas.id);
            msg1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
            msgList1.add(msg1);
            system.debug(msgList1);
           //String[] toAddresses = new String[]{'RSPHXCOTASAPINVOICIN@Honeywell.com'};    
            //String[] toAddresses = new String[] {'nandini.nanjappan@nttdata.com'};
            String[] toAddresses = new String[]{};
            String Billingadd = label.Billing_question_confirm_Email;
            toAddresses.add(Billingadd);
            Savepoint sp = Database.setSavepoint();                 
            if(msg1.getTemplateId()!=null)
            Messaging.sendEmail(msgList1);
            Database.rollback(sp);
            if(msgList1.size()>0){
                for(Messaging.SingleEmailMessage email : msgList1){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails1.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails1);
                }
            }                         
        }
        else if(cs.EmailAddress == ContactEmail && cas.Subject == 'MyAerospace Address Updates')
        {
            system.debug('TestSubject------>1'+cas.Subject);
            msg1.setTargetObjectId(conid);
            msg1.setsaveAsActivity(false);
            msg1.setTemplateId(label.ADE_Case_Confirmation_for_Billing_team1);
            msg1.setWhatId(cas.id);
            msg1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
            msgList1.add(msg1);
            system.debug(msgList1);
            //String[] toAddresses = new String[]{'COTADistribution@Honeywell.com'};    
            //String[] toAddresses = new String[] {'emily.davis@honeywell.com'};
            String[] toAddresses = new String[]{};
            String Billingadd1 = label.Billing_question_address_update_confirm_Email;
            toAddresses.add(Billingadd1);
            Savepoint sp = Database.setSavepoint();                 
            if(msg1.getTemplateId()!=null)
            Messaging.sendEmail(msgList1);
            Database.rollback(sp);
            if(msgList1.size()>0){
                for(Messaging.SingleEmailMessage email : msgList1){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails1.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails1);
                }
            }    
        }
        else if(cas.Subject != 'MyAerospace Address Updates' && cs.EmailAddress != ContactEmail)
        {
         system.debug('TestSubject------>1'+cas.Subject);
            msg1.setTargetObjectId(conid);
            msg1.setsaveAsActivity(false);
            msg1.setTemplateId(label.ADE_Case_Confirmation_for_Billing_team);
            msg1.setWhatId(cas.id);
            msg1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
            msgList1.add(msg1);
            system.debug(msgList1);
            //String[] toAddresses = new String[]{'RSPHXCOTASAPINVOICIN@Honeywell.com'};    
            //String[] toAddresses = new String[] {'emily.davis@honeywell.com'};
            String[] toAddresses = new String[]{};
            String Billingadd = label.Billing_question_confirm_Email;
            toAddresses.add(Billingadd);
            Savepoint sp = Database.setSavepoint();                 
            if(msg1.getTemplateId()!=null)
                Messaging.sendEmail(msgList1);
            Database.rollback(sp);
            if(msgList1.size()>0){
                for(Messaging.SingleEmailMessage email : msgList1){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails1.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails1);
                
                }
            }
        }
        else if(cas.Subject == 'MyAerospace Address Updates' && cs.EmailAddress != ContactEmail)
        {
         system.debug('TestSubject------>1'+cas.Subject);
            msg1.setTargetObjectId(conid);
            msg1.setsaveAsActivity(false);
            msg1.setTemplateId(label.ADE_Case_Confirmation_for_Billing_team);
            msg1.setWhatId(cas.id);
            msg1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
            msgList1.add(msg1);
            system.debug(msgList1);
            //String[] toAddresses =  new String[]{'COTADistribution@Honeywell.com'};
            //String[] toAddresses = new String[] {'emily.davis@honeywell.com'}; 
            String[] toAddresses = new String[]{};
            String Billingadd1 = label.Billing_question_address_update_confirm_Email;
            toAddresses.add(Billingadd1);           
            Savepoint sp = Database.setSavepoint();                 
            if(msg1.getTemplateId()!=null)
                Messaging.sendEmail(msgList1);
            Database.rollback(sp);
            if(msgList1.size()>0){
                for(Messaging.SingleEmailMessage email : msgList1){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails1.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails1);
                
                }
            }
        }
    }
    
    // Added for Sending Email Confirmation to BendixKing Instance from SFDC
    if(cas.id != null && (cas.Subject == label.MyAerospace_Warranty_Credit_Request || cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request))
    {  
        system.debug('inside bendixking:');          
        string htmlBody='';
        string subject='';
        subject += getCaseNumber(cas.id);
        subject += ' '+'MyAerospace BendixKing Warranty Credit Request';
    
        if(ContactInformation == '')
        {
        system.debug('cas.Contact.Name####'+cas.Contact.Name );
        htmlBody+= '<b>'+'Case Description: '+'</b>'+ cas.Description+ '<br/>'; 
        htmlbody+= '<b>'+'Contact Information: '+'</b>Email:'+ cas.SuppliedEmail+ ',<br/>';
        system.debug('htmlBody####'+htmlBody);
        }
        else if(ContactInformation != null)
        {
        htmlBody+= '<b>'+'Case Description:' +'</b>'+cas.Description+ '<br/>';
        htmlBody+= '<b>'+'Contact Information: '+'</b>'+ContactInformation+''+ '<br/>';
        system.debug('ContactInformation:####'+ContactInformation);
        system.debug('htmlBody####'+htmlBody);            
        }
        htmlbody+= '\n'+ '<b>'+'Additional Web form info: '+ '</b>'+cas.Additional_Web_Form_Info__c + '<br/>';
        htmlbody+= '\n'+ '<b>'+'Owner/Operator Information: '+ '</b>'+cas.Owner_Operator_Information__c;
        system.debug('htmlBody:'+htmlBody);            
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'aerodonotreply@honeywell.com'];           
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'BK-IT-Requests@bendixking.com'};   
        //String[] toAddresses = new String[]{'warranty@bendixking.com'};
        String[] toAddresses = new String[]{};
        String Bendixadd = label.Bendixking_Instance;
        toAddresses.add(Bendixadd);
        mail.setToAddresses(toAddresses);
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId =: cas.id]){
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
        efa.setFileName(a.Name);
        efa.setBody(a.Body);
        fileAttachments.add(efa);
        }
        system.debug('Attachments:'+fileAttachments);
        mail.setFileAttachments(fileAttachments);
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });  
    }
    
    if(bulkEmails1.size()>0)
    {
        Messaging.sendEmail(bulkEmails1);
        system.debug('bulkEmails1------>1'+bulkEmails1);
    }
    }
    catch(exception e)
    {
         // Send an email to the TO list if exception occurs.
          /*  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
            List<String> mailToAddresses = new List<String>(); 
            String[] emailAddressArr = (label.ADEcaseexception).split(',');        
            if(emailAddressArr.size() > 0){            
                for(String i : emailAddressArr){
                    mailToAddresses .add(i);
                }
            }        
            mail.setToAddresses(mailToAddresses );
            mail.setSubject('MyAerospace Webform Case Failure Occurred.');
            String bodyText = '';
            if(!Test.isRunningTest())
            {
               bodyText +='\n\n' +'Case creation or Email message exception in SFDC with the following error message at the Line Number:\t' + e.getLineNumber()
                + '\n' + e.getMessage() 
                + '\n of Type ' + e.getTypeName() 
                + '\n of Type ' + e.getCause()
                + '\n\nStacktrace: ' + e.getStacktraceString();
            }
            mail.setPlainTextBody(bodyText);
            if(!(Test.isRunningTest()))
            {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });               
            }*/
         
         {
        system.debug('TestSubject------>1'+cas.Subject);
        msg1.setTargetObjectId(conid);
        msg1.setsaveAsActivity(false);
        msg1.setTemplateId(label.ADE_Case_Exception_mail_to_Customer);
        msg1.setWhatId(cas.id);
        msg1.setOrgWideEmailAddressId(label.AeroNo_Reply_email_ID);  
        msgList1.add(msg1);
        system.debug(msgList1);
        String[] toAddresses = new String[]{};
        String Billingadd1 = label.ADEcaseexception;
        toAddresses.add(Billingadd1);           
        Savepoint sp = Database.setSavepoint();                 
        if(msg1.getTemplateId()!=null)
            Messaging.sendEmail(msgList1);
            Database.rollback(sp);
            if(msgList1.size()>0){
                for(Messaging.SingleEmailMessage email : msgList1){
                    Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                    emailToSend.setToAddresses(toAddresses);                                
                    emailToSend.setPlainTextBody(email.getPlainTextBody());
                    emailToSend.setHTMLBody(email.getHTMLBody());
                    emailToSend.setSubject(email.getSubject());
                    emailToSend.setOrgWideEmailAddressId(email.getOrgWideEmailAddressId());
                    if(emailToSend.getHTMLBody()!=null)
                        bulkEmails1.add(emailToSend);
                        system.debug('Invalid--->bulkEmails'+bulkEmails1);
                
            }
    }
    }
     if(bulkEmails1.size()>0)
    {
        Messaging.sendEmail(bulkEmails1);
        system.debug('bulkEmails1------>1'+bulkEmails1);
    }
      }
    system.debug('cas------870'+isInserted);
    system.debug('cas------870'+cas.status);  
    if(isInserted == true && (cas.Subject != label.MyAerospace_Warranty_Credit_Request && cas.Subject != label.MyAerospace_BendixKing_Warranty_Credit_Request))
    {   
        system.debug('cas------873'+cas);  
        cse.caseNumber = getCaseNumber(cas.id);   
        cse.message = 'Success!';         
    } 
    else if(isInserted == true && (cas.Subject == label.MyAerospace_Warranty_Credit_Request || cas.Subject == label.MyAerospace_BendixKing_Warranty_Credit_Request))        
    {
        system.debug('cas------879'+cas);  
        cse.message = 'Case has been succesfully created in Aero Instance!';
        cse.caseNumber = getCaseNumber(cas.id);
    }
    return cse;
    }
    
    public static string getCaseNumber(Id caseId){
    List<Case> sfdccase = [select id,CaseNumber,OwnerId from case where id=: caseId];           
    system.debug('cas------888'+sfdccase);  
    return sfdccase[0].caseNumber; 
    }
    
    //Description Pacing for order Type
    public static String getInbetweenValues(String inputString, String startStr, String endStr){
        String resultStr;
        if(String.isNotBlank(inputString) && String.isNotBlank(startStr)){
            resultStr = inputString.substringBetween(startStr, endStr);
            if(String.isNotBlank(resultStr))
                resultStr = resultStr.trim();
        }
        return resultStr;
    }
    
}
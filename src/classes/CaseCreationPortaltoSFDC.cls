/*******************************************************************************
Name            :   CaseCreationPortaltoSFDC
Created By      :   Honeywell
Company Name    :   Honeywell
Project         :   <MyAeroPortal> 
Created Date    :   23-May-2015
Update Date     :   19-April-2021
Usages          :   Creating Case based on Portal and sending response as Case Number        
*******************************************************************************/
global class CaseCreationPortaltoSFDC{
    global class CaseData{
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
        webservice string AttBody;
        webservice String AttFileName;
        webservice String AttContentType; 
        webservice String Username;     
        webservice String TypeOfRequest;
        webservice String ICaseNumber;
    }
    global class CaseDataSFDCtoPortal{
        webservice string caseNumber;
        webservice string message;
        webservice string isClosedmorethan7days;

    }
    webservice static CaseDataSFDCtoPortal createCase(CaseData cs){
        String DefaultAcctId=System.Label.RnO_Automation_Default_Account; // HONEYWELL DEFAULT ACCOUNT
        String DefaultContId=System.Label.RnO_Automation_Default_Contact; // HONEYWELL Default Contact
        String Orders_Rec_ID=System.Label.Orders_Rec_ID; // Orders RecordType
        CaseDataSFDCtoPortal cse = new CaseDataSFDCtoPortal();

            List<case> cas1=new List<case>();
            string casesubject=cs.subject;
            
            if(isPortalUser(cs) && cs.OrderType=='Spares'){
                cse = createCaseFromCaseData(cs,cse,DefaultAcctId, DefaultContId);
                return cse;
            }
                        
                cas1= [select id,ownerid,contactid,isclosed,Customer_PO_RO_WONumber__c,status, OwnerName__c,Recordtype.DeveloperName, ClosedDate, Additional_Web_Form_Info__c, Subject,Type_of_Request__c,ParentId,Workstrem__c from case  where case_Number__C =: cs.ICaseNumber And isclosed = false]; 
            if(cas1.size()>0)
            {
                    string caseid=cas1[0].id;                                   
                    system.debug('casesubject----'+casesubject);                                       
                    Task newtask = initTask(cs, cas1);
                    try
                    {
                        insert newtask;                                              
                        system.debug('newtask----'+newtask);
                    }
                    catch(exception e)
                    {
                        system.debug('inside catch');
                        cse.message = 'Invalid - '+e.getMessage();
                    } 
                    cse.caseNumber = getCaseNumber(caseid);
                    cse.message = 'Success';  
                    
                    
                                     
                    if(cas1[0].status=='On Hold')
                    {
                        cas1[0].status='On Hold – Response Received';
                    }
                    // && cas1[0].Recordtype.DeveloperName=='Repair_Overhaul'
                    else if(cas1[0].status=='Open' ){
                        cas1[0].Status = 'Open-Comment-Attachment';                      
                    }
                    if(cas1[0].OwnerName__c == 'Aero Default')
                    {
                        cas1[0].OwnerId = Label.CSO_R_O_Team;
                    }
                    cas1[0].Additional_Web_Form_Info__c =  String.isNotBlank(cs.AdditionalWebFormInfo)?cs.AdditionalWebFormInfo:'';
                    //cas1[0].Type_of_Request__c = String.isNotBlank(cs.TypeOfRequest)?cs.TypeOfRequest:'';
                    //cas1[0].Type = String.isNotBlank(cs.TYPE)?cs.TYPE:'';
                    update cas1;    
                    
                    if((cs.AttBody!=null && cs.AttBody!='' && cs.AttBody!='null') && (cs.AttFileName!=null && cs.AttFileName!='' && cs.AttFileName!='null') && (cs.AttContentType!=null && cs.AttContentType!='' && cs.AttContentType!='null'))
                    {
                        system.debug('----->ATTBody'+cs.AttBody);
                        system.debug('----->ATTBody'+cs.AttBody.length());
                        Blob tstbody = EncodingUtil.base64Decode(cs.AttBody);
                        Attachment att = new Attachment();
                        att.Body = tstbody;
                        att.ContentType = cs.AttContentType;
                        att.Name = cs.AttFileName;
                        att.ParentId = cas1[0].id;
                        try{
                            insert att;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                        }
                    }     
            }
            else
            {
               cas1= [select id,ownerid,contactid,isclosed,Customer_PO_RO_WONumber__c,status, Recordtype.DeveloperName, ClosedDate, Additional_Web_Form_Info__c, Subject,Type_of_Request__c,ParentId,Workstrem__c from case  where case_Number__C =: cs.ICaseNumber and isclosed = true]; 
               if(cas1.size()>0 && isClosedLessthan7Days(cs,cas1)){               
                    string caseid=cas1[0].id;                                   
                    system.debug('casesubject----'+casesubject);                                       
                    Task newtask = initTask(cs, cas1);
                    try
                    {
                        insert newtask;                                              
                        system.debug('newtask----'+newtask);
                    }
                    catch(exception e)
                    {
                        system.debug('inside catch');
                        cse.message = 'Invalid - '+e.getMessage();
                    } 
                        
                    cse.caseNumber = getCaseNumber(caseid);
                    cse.message = 'Success';     
                    cas1[0].Status = 'Open-Comment-Attachment';                                                      
                    cas1[0].Additional_Web_Form_Info__c =  String.isNotBlank(cs.AdditionalWebFormInfo)?cs.AdditionalWebFormInfo:'';
                    // cas1[0].Type_of_Request__c = String.isNotBlank(cs.TypeOfRequest)?cs.TypeOfRequest:'';
                    // cas1[0].Type = String.isNotBlank(cs.TYPE)?cs.TYPE:'';
                    update cas1;
                    
                    if((cs.AttBody!=null && cs.AttBody!='' && cs.AttBody!='null') && (cs.AttFileName!=null && cs.AttFileName!='' && cs.AttFileName!='null') && (cs.AttContentType!=null && cs.AttContentType!='' && cs.AttContentType!='null'))
                    {
                        system.debug('----->ATTBody'+cs.AttBody);
                        system.debug('----->ATTBody'+cs.AttBody.length());
                        Blob tstbody = EncodingUtil.base64Decode(cs.AttBody);
                        Attachment att = new Attachment();
                        att.Body = tstbody;
                        att.ContentType = cs.AttContentType;
                        att.Name = cs.AttFileName;
                        att.ParentId = cas1[0].id;
                        try{
                            insert att;
                        }catch(Exception attEx){
                            system.debug('Invalid--->'+attEx.getMessage());
                        }
                    }
                                   
                }else if(cas1.size()>0){
                
                    cse = createCaseFromCaseData(cs,cse,DefaultAcctId, DefaultContId);
                    cse.isClosedmorethan7days = 'true';
                                                                           
                }else{
                    cse = createCaseFromCaseData(cs,cse,DefaultAcctId, DefaultContId);
                }  
             }
             return cse;
    }
    public static string getCaseNumber(Id caseId){
        List<Case> sfdccase = [select id,CaseNumber from case where id=: caseId];       
        return sfdccase[0].caseNumber; 
    }   
    /* Method to get SFDC Account Id based on Contact Name from the Contact object/table */
    public static String GET_ACCOUNT_ID(String Conid)
    {
        String AcctId ='';
        if (Conid !=null && Conid !='')
        {           
            list <Contact> ContIdList = [select Id,accountid from Contact where id=:Conid LIMIT 1];
            if (ContIdList.size() > 0)
            {
                for(Contact temp:ContIdList) 
                {
                    AcctId= temp.accountid; 
                }
            }
            else
            {
                AcctId=Label.RnO_Automation_Default_Account;
            }
        }
        else
        {
            AcctId=Label.RnO_Automation_Default_Account;
        }
        return AcctId;  
    } 
    
    /*Method to find Portal username*/
    public static boolean isPortalUser(CaseData cs){
        if(cs.Username != null && cs.Username.contains('myaerospace@honeywell.com'))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
   
        /*Method to update closed 7 days logic*/
    public static Boolean isClosedLessthan7Days(CaseData cs, List<case> cas1)
    {
        Boolean isClosedForLessThanSevenDays = false;
        List<case> cas2 =new List<case>();
        cas2 = [select id,Customer_PO_RO_WONumber__c,isclosed, ClosedDate from case where Case_Number__C =: cs.ICaseNumber and isclosed = true and closedDate = LAST_N_DAYS:7];
        if(cas2.size()>0)
        {
            return true;
        }   
        else
        {
            return false;
        }
    } 
    
    
    /*Method to update parent case*/
    public static String GetparentcaseNumer(CaseData cs)
    {
         List<case> ParentCase =new List<case>();
         ParentCase = [select id,isclosed, ClosedDate from case where Case_Number__C =: cs.ICaseNumber and isclosed = true And closedDate < LAST_N_DAYS:7];    
         if(ParentCase.size()>0)
         {
         return ParentCase[0].id;
         }
         else
         {
         return null;
         }
    }     
 
    /*Method to create case*/
    public static CaseDataSFDCtoPortal createCaseFromCaseData(CaseData cs, CaseDataSFDCtoPortal cse,String DefaultAcctId,String DefaultContId)
    {
        Case cas = new Case();                              
        cas.RecordtypeId = Label.Orders_Rec_ID;
        cas.Origin = cs.Origin; 
        cas.Type = cs.TYPE;
        cas.Additional_Web_Form_Info__c=cs.AdditionalWebFormInfo;
        cas.Order_Type__c = cs.OrderType;
        cas.Order_Status_Info_Requested__c=cs.OrderStatusInfoRequested;
        cas.Portal_Contact_Email__c=cs.PortalContactEmail;
        cas.Honeywell_ID__c=cs.HoneywellID;
        cas.Priority= String.isNotBlank(cs.Priority)? cs.Priority:'Normal';//cs.Priority;
        cas.Classification__c = cs.Classification;
        cas.Customer_PO_RO_WONumber__c =  String.isNotBlank(cs.CUSTOMER_PO_RO_WO_NUM)?cs.CUSTOMER_PO_RO_WO_NUM:'';
        cas.Sales_Order_Number__c = cs.SALES_ORDER_NUM;     
        cas.Export_Compliance_Content_ITAR_EAR__c = cs.ExportCompliance;
        cas.Government_Compliance_SM_M_Content__c = cs.GovernmentCompliance;
        cas.Subject = cs.SUBJECT;
        cas.OwnerId = Label.CSO_R_O_Team;
        cas.Description = cs.DESCRIPTION; 
        cas.Type_of_Request__c = cs.TypeOfRequest; 
        if(cs.OrderType != 'Spares' && GetparentcaseNumer(cs) != null)
        {  
            cas.ParentId = GetparentcaseNumer(cs); 
        }
        
        if(isPortalUser(cs)){
            cas.status = 'Open';
            if(cs.OrderType=='Spares'){
                cas.OwnerId=Label.Owner_Order_Status_Team;
            }
        }
        else
        {
            cas.Status = cs.status;
        }
        
        
        if(cs.Contactid != null && cs.Contactid != ''){
            cas.ContactId = cs.Contactid; 
            cas.AccountId = GET_ACCOUNT_ID(cs.Contactid);           
        }
        else
        {
            cas.AccountId=DefaultAcctId;
            cas.ContactId=DefaultContId;          
        } 
        
        
        Boolean isInserted = false;
        try{
            system.debug('------------------------------>in');
            insert cas;
            isInserted = true;
        }catch(DMLException e){
            cse.message = 'Invalid - '+e.getMessage();
        }
        
        
        if(isInserted == true){
            cse.caseNumber = getCaseNumber(cas.id);
            cse.message = 'Success'; 
        }
            
            
        if((cs.AttBody!=null && cs.AttBody!='' && cs.AttBody!='null') && (cs.AttFileName!=null && cs.AttFileName!='' && cs.AttFileName!='null') && (cs.AttContentType!=null && cs.AttContentType!='' && cs.AttContentType!='null'))
        {
            system.debug('----->ATTBody'+cs.AttBody);
            system.debug('----->ATTBody'+cs.AttBody.length());
            Blob tstbody = EncodingUtil.base64Decode(cs.AttBody);
            Attachment att = new Attachment();
            att.Body = tstbody;
            att.ContentType = cs.AttContentType;
            att.Name = cs.AttFileName;
            att.ParentId = cas.id;
            try{
                insert att;
            }catch(Exception attEx){
                system.debug('Invalid--->'+attEx.getMessage());
            }
        }
               
        return cse; 
    }
    /* Method to initialize tasks*/
    public static Task initTask(CaseData cs,List<case> cas1){
        Task newtask = new Task();
        newtask.OwnerId = Label.aero_default_user_id;
        newtask.Subject = cs.Subject;
        if(cs.contactid != null && cs.contactid!= ''){
            newtask.WhoId = cs.contactid;
        }else{
            if(cas1.size() > 0 ){
                newtask.WhoId = cas1[0].contactid;
            }
            else {
                newtask.WhoId = null;
            }
        }
        if(cas1.size() > 0 ){
            newtask.WhatId = cas1[0].id;
        }
        else {
            newtask.WhatId = null;
        }
        newtask.RecordTypeId = Label.R_O_Activity_Label;
        newtask.Priority=  String.isNotBlank(cs.Priority)? cs.Priority:'Normal';//cs.Priority;
        newtask.Description= cs.AdditionalWebFormInfo;
        newtask.Description__c= cs.Description;
        if(isPortalUser(cs)){
        newtask.status = 'Open';
        }
        else
        {
        newtask.Status = cs.status;
        }
                return newtask;
    } 
      
}
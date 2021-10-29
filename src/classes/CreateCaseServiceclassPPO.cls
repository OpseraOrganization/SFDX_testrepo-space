global class CreateCaseServiceclassPPO{

global class CaseDataSFDCtoSAP{
        webservice string caseNumber;        
        webservice string message;
       }        

webservice static SAPtoSFDCServiceclass.CaseDataSFDCtoSAP CREATE_CASE(SAPtoSFDCServiceclass.RnO_CASE_cls  new_case) 
    {
        String rtn='';        
        String message='';
        String caseNum=''; 
        Boolean isUpserted = false; 
        Boolean isAttachment = false; 
        List<contact> con=new List<contact>();
        List<Attachment> attlist = new List<Attachment>();
        
        List<SAPtoSFDCServiceclass.Attachmentlist> Attach= new List<SAPtoSFDCServiceclass.Attachmentlist>();
        Attach= new_case.Attachments; 
        //system.debug('Attach count'+Attach);
        //system.debug('Attach count'+Attach.size());
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        try
        {
        if(new_case !=null)
        {
            system.debug('Inside Create Case: '+new_case);
            //Case cas = (((new_case.CASENUMBER == '' || new_case.CASENUMBER == null)&& new_case.APUWorkcenter=='ZRA') ? new Case() : [select id,OwnerId,CaseOwnerChanged__c,AccountId,Subject,Product_Serial_Number__c,plant__c,Product_Number__c,RecordtypeId,Requestor_Email__c,Type,Resolution__c,Sub_Status__c,Sales_Order_Number__c,Description,Status,CaseNumber from case where CaseNumber =:new_case.CASENUMBER for Update] );
            Case cas;
            if((new_case.CASENUMBER == 'null' || new_case.CASENUMBER == '') && new_case.APUWorkcenter=='ZRA'){
                system.debug('Inside ZRA Case create--->');
                cas = new Case();
            }
            else {
                system.debug('Else PPO---->');
                cas = [select id,OwnerId,CaseOwnerChanged__c,AccountId,Subject,Product_Serial_Number__c,plant__c,Product_Number__c,RecordtypeId,Requestor_Email__c,Type,Resolution__c,Sub_Status__c,Sales_Order_Number__c,Description,Status,CaseNumber from case where CaseNumber =:new_case.CASENUMBER];
            }
            system.debug('case:'+cas);
            CreateCaseServiceclassPPO cls_obj= new CreateCaseServiceclassPPO(); 
            if(new_case.APUWorkcenter=='ZRA')
            {
                system.debug('ZRA Case');
                system.debug('ZRA Case Number:'+ cas.Sales_Order_Number__c);
                if((new_case.SALES_ORDER_NUMBER!='null' && new_case.SALES_ORDER_NUMBER!='') && cas.Sales_Order_Number__c!=new_case.SALES_ORDER_NUMBER)
                {
                    system.debug('Inside sales order number');
                    cas.Sales_Order_Number__c = new_case.SALES_ORDER_NUMBER; 
                } 
                cas.Origin = 'Web'; 
                
                if(new_case.CUSTOMER_REQUEST_DT!= null && new_case.CUSTOMER_REQUEST_DT!= '' )
                {
                
                    cas.Customer_Request_Date__c = date.parse(new_case.CUSTOMER_REQUEST_DT);
                } 
                if(new_case.CUSTOMER_PO_RO_WO_NUM != 'null' && new_case.CUSTOMER_PO_RO_WO_NUM !='') 
                {   
                    cas.Customer_PO_RO_WONumber__c = new_case.CUSTOMER_PO_RO_WO_NUM;
                }
                cas.SPEX_Exchange__c = False;
                cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
                cas.Government_Compliance_SM_M_Content__c = 'No';
                if(new_case.CLASSIFICATION!= 'null' && new_case.CLASSIFICATION!= '') 
                {
                    cas.Classification__c = new_case.CLASSIFICATION; 
                }          
                if(new_case.SUBJECT != 'null' && new_case.SUBJECT!= '') 
                {
                    cas.Subject = new_case.SUBJECT;
                }
                if(new_case.SAP_ACCOUNT_INFO!='null' && new_case.SAP_ACCOUNT_INFO!='')
                {
                    cas.SAP_Account_Information__c=new_case.SAP_ACCOUNT_INFO;
                }
                cas.RecordtypeId=Label.OEM_Spares;
            
                if((new_case.SAP_ACCOUNT_NAME != null && new_case.SAP_ACCOUNT_NAME!= '')&&(new_case.REPAIR_LOCATION != null && new_case.REPAIR_LOCATION!= '')||new_case.CONTACT_EMAIL!= 'null' && new_case.CONTACT_EMAIL!= ''){
                    system.debug('req email'+new_case.CONTACT_EMAIL );
                    cas.Status='Open';
                    cas.OwnerId = Label.aero_default_user_id;
                    cas.Description = new_case.DESCRIPTION;
                    system.debug('Test:'+cas.OwnerId );
                }else{
                    system.debug('------Inside Else Email');                 
                     cas.Status='Open';
                     cas.OwnerId = Label.CSO_OEM_Spares;
                     cas.Description = new_case.DESCRIPTION+' Update requester email address';
                     system.debug('Test1:'+cas.OwnerId );
                }
                
            }
            if(new_case.APUWorkcenter=='ZRPR')
            
            {
                    system.debug('ZRPR Case');
                    system.debug('ZRPR Case Number:'+ cas.Sales_Order_Number__c);
                    cas.Status='Open';
                    
                  if((new_case.SALES_ORDER_NUMBER!='null' && new_case.SALES_ORDER_NUMBER!='') && cas.Sales_Order_Number__c!=new_case.SALES_ORDER_NUMBER)
                    {
                        system.debug('Inside sales order number ZRPR');
                        cas.Sales_Order_Number__c = new_case.SALES_ORDER_NUMBER; 
                    } 
                   
                    if(new_case.CUSTOMER_REQUEST_DT!= null && new_case.CUSTOMER_REQUEST_DT!= '' )
                    {
                        cas.Customer_Request_Date__c = date.parse(new_case.CUSTOMER_REQUEST_DT);
                    } 
                    if(new_case.CUSTOMER_PO_RO_WO_NUM != 'null' && new_case.CUSTOMER_PO_RO_WO_NUM !='') 
                    {              
                        cas.Customer_PO_RO_WONumber__c = new_case.CUSTOMER_PO_RO_WO_NUM;
                    }
                        
                    if(new_case.SUBJECT != 'null' && new_case.SUBJECT!= '') 
                    {
                        cas.Subject = new_case.SUBJECT;
                    }
                    if(new_case.SAP_ACCOUNT_INFO!='null' && new_case.SAP_ACCOUNT_INFO!='')
                    {
                        cas.SAP_Account_Information__c=new_case.SAP_ACCOUNT_INFO;
                    }
                    cas.RecordtypeId=Label.Repair_Overhaul_RT_ID;
              
            }
        
            if(new_case.CONTACT_EMAIL != 'null' && new_case.CONTACT_EMAIL!= '')
            {
             System.debug('Contact Email NOT Null:'+new_case.CONTACT_EMAIL);                        
                con= [select id,accountid from contact where email=:new_case.CONTACT_EMAIL limit 1]; 
                    if(con.size()>0)
                    {
                        cas.ContactId=con[0].id;
                        cas.AccountId=con[0].accountid;
                        cas.Requestor_Email__c = new_case.CONTACT_EMAIL;
                        System.debug('Contact Email NOT Null1:'+cas.Requestor_Email__c);             
                    }
                    else
                    {
                        cas.Requestor_Email__c = new_case.CONTACT_EMAIL;
                    }
            
            }
            System.debug('Contact Email Null:'+cas.Requestor_Email__c);
            
            
            if(new_case.REPAIR_LOCATION != null && new_case.REPAIR_LOCATION != '')
            {
                cas.plant__c = getPlantCodeId(new_case.REPAIR_LOCATION);
            }
            if(con.size()==0 && new_case.ACCOUNT_NAME != null)
            {
                cas.AccountId = getAccountId(new_case.ACCOUNT_NAME); 
                system.debug('Test1:'+cas.AccountId);            
            }
                     
           if((new_case.SAP_ACCOUNT_NAME != null && new_case.SAP_ACCOUNT_NAME!= '')&&(new_case.REPAIR_LOCATION != null && new_case.REPAIR_LOCATION!= ''))
            {
                cas.CaseOwnerChanged__c = CSWIEmailsList.getEmailAddress(new_case.SAP_ACCOUNT_NAME,new_case.REPAIR_LOCATION); 
                
                system.debug('Test11:'+cas.CaseOwnerChanged__c);
            }
       
            caseNum=new_case.CASENUMBER;
            system.debug('caseNum'+caseNum);
            
            system.debug('caserecordtype'+cas.RecordtypeId);
            upsert cas; 
            isUpserted=true;
            if(isUpserted == true)
            {   
                system.debug('Isupsert owner:'+cas.ownerId);    
                system.debug('Isupsert rectype:'+cas.RecordtypeId);        
                cse.caseNumber = cls_obj.getCaseNumber(cas.id,new_case.APUWorkcenter);
                cse.message = 'Success!';
                List<ContentVersion> conVerList = new List<ContentVersion>();
                for(SAPtoSFDCServiceclass.Attachmentlist Att:Attach)
                {
                    
                    system.debug('Attach count');
                    if((Att.AttBody!=null && Att.AttBody!='')&&(Att.AttFileName!=null && Att.AttFileName!='')&&(Att.AttContentType!=null && Att.AttContentType!=''))
                    {
                        //Attachment attmt = new Attachment();
                        system.debug('----->ATTBody'+Att.AttBody);
                        system.debug('----->ATTBody'+Att.AttBody.length());
                        Blob tstbody = EncodingUtil.base64Decode(Att.AttBody);                        
                       /* attmt.Body = tstbody;
                        attmt.ContentType = Att.AttContentType;
                        attmt.Name = Att.AttFileName;
                        attmt.ParentId = cas.id; 
                        attlist.add(attmt);*/
                        ContentVersion conVer = new ContentVersion();
                        conVer.PathOnClient = Att.AttFileName; // file name with extension
                        conVer.Title = Att.AttFileName; // file name to display. Usually specify the extension here also
                        conVer.VersionData = tstbody;
                        conVerList.add(conVer);
                    }
                }
                System.debug('attlist' +conVerList.size());
                /* if(attlist.size()>0)
					insert attlist;*/
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
                        //objCDL.Visibility = 'AllUsers';
                        lstConDoclink.add(objCDL);                        
                    }
                }
                if(lstConDoclink != null && lstConDoclink.size()>0){
                    Insert lstConDoclink;  
                    system.debug('check::::::'+lstConDoclink);
                }
               
             system.debug('Email SBU:'+new_case.CaseType);
            // PPO_EmailSending.EmailSend(cas.id,new_case.CaseType);
           // PPO_EmailSending.EmailSend(cas.id);
             
            }  
        }
          system.debug('CASE NUMBER:'+cse.caseNumber );
       }
     catch(exception e)
     {
         rtn='Failure creating a new SFDC case';
         rtn=rtn+e;
         caseNum = rtn;
     }
       return  cse;
    }
    
     public string getCaseNumber(Id caseId,String PPO_Status)
     { 
        system.debug('inside get case number:');
        List<Case> sfdccase = [select id,CaseNumber,(select id,Case_object__c,Manual_Intervention_Last_Modified_Date__c,UFR_SBU__c,SAP_SalesOrder_Status__c from CASE.Case_Extensions__r) from case where id=: caseId];
        List<Case_Extension__c> UFRCasExlist = new List<Case_Extension__c>();
        for(Case c:sfdccase){
            Case_Extension__c CasExt = new Case_Extension__c();
            if(c.Case_Extensions__r!=null && c.Case_Extensions__r.size()>0){
                system.debug('---->If:'+c.Case_Extensions__r);
                CasExt = c.Case_Extensions__r;
            }else{
                system.debug('---->else'+c.Case_Extensions__r);
                CasExt.Case_object__c = c.id;                
            }
            CasExt.SAP_SalesOrder_Status__c = PPO_Status;
            UFRCasExlist.add(CasExt);
        }
        upsert UFRCasExlist;
        return sfdccase[0].caseNumber; 
    }
     
     public static id getPlantCodeId(String plantid)
     {
        List<Plant_Code_Master__c> pcmid = [Select ID,SAP_Plant_Code__c,UFR_SAP_Plant_Name__c from Plant_Code_Master__c where SAP_Plant_Code__c=:plantid limit 1];
        if(pcmid.size()>0)
            return pcmid[0].id;
        else
            return null;
    }
    
     public static string getAccountId(String AcctName){
        system.debug('test accounting');
        String AcctId ='';
        list <Account> AcctIdList = [select Id,REPORT_ACCOUNT_NAME__c from Account where Sbl_Account_Row_Id__c=:AcctName and (NOT REPORT_ACCOUNT_NAME__c like '%VARIOUS%') LIMIT 1];
        if (AcctIdList.size() > 0)
        {
            for(Account temp:AcctIdList) 
            {
                AcctId = temp.Id; 
            }
        }
        else
        {
            AcctId=null;
        }
        return AcctId;  
    }
  
}
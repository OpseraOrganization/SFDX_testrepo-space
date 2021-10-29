global class SAP_RandO_Automation_Service {
     String DefaultAcctId=System.Label.RnO_Automation_Default_Account; // HONEYWELL DEFAULT ACCOUNT
     String DefaultContId=System.Label.RnO_Automation_Default_Contact; // HONEYWELL Default Contact
     String DefaultOwnerId=System.Label.RnO_Automation_Default_Owner; // Aero Default
     String DefaultSAPAcctName=System.Label.RnO_Automation_Default_SAP_Acct;
     String RnORecordTypeId=System.Label.RnO_Automation_Record_Type; // Repair and Overhaul RecordType
    
       /* This class represents the fields in the CASE object will be provided/updated by SAP */    
        global class RnO_CASE_cls
        {
        
            webservice  String ACCOUNT_NAME;
            webservice  String DESCRIPTION;
            webservice  String CONTACT_NAME;
            webservice  String CLASSIFICATION;
            webservice  String CUSTOMER_PO_RO_WO_NUM;
            webservice  String CUSTOMER_REQUEST_DT;
            webservice  String ORDER_ENTERED_DT;
            webservice  String PRODUCT_NUM;
            webservice  String PRODUCT_SERIAL_NUM;
            webservice  String EXPORT_COMPLIANCE_IND;   
            webservice  String GOVT_COMPLIANCE_IND;
            webservice  String REPAIR_LOCATION;
            webservice  String SPEX_EXG_IND;
            webservice  String STATUS;
            webservice  String SUB_CLASS;
            webservice  String DETAIL_CLASS;
            webservice  String SUBJECT;
            webservice  String SAP_ACCOUNT_NAME;
            webservice  String SAP_ACCOUNT_INFO;
            webservice  String SALES_ORDER_NUMBER;
            webservice  String RESOLUTION;
            webservice  String SUB_STATUS;
            
        }   
        
       /* SAP/PI will make a call out to this webservie method to create/update cases */  
        webservice static String SAP_RO_AUTOMATION_PROC(RnO_CASE_cls RO_CASE) {
            String rtn=' ';//return variable set based on success/failure
            String caseNum='';
            String salesOrdNum='';
            String transType;
            Case lkupCase=null;
            
                    
           
            /* Added for RAPD - 3343 */
                    SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
                    
                    string truncateIP = '';
        truncateIP = string.valueOf(RO_CASE);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
            /* Ended */

             system.debug('*****Case Request****'+ RO_CASE);
             
             try
             {
             SAP_RandO_Automation_Service cls_obj1 = new SAP_RandO_Automation_Service();//class obj to call methods defined for modularisation
             
             if (RO_CASE != null)
             {
             if (RO_CASE.STATUS=='Open')
            rtn = cls_obj1.CREATE_CASE(RO_CASE);
             else if (RO_CASE.STATUS=='Closed')
            rtn = cls_obj1.UPDATE_CASE(RO_CASE); 
            else
            rtn = 'Status was undefined or null. No Operation performed';
             
             }
             
             
             salesOrdNum = RO_CASE.SALES_ORDER_NUMBER;
             transType = RO_CASE.STATUS;
            
            if (rtn=='Create Success!' || rtn=='Update Success!' )
            {
            lkupCase = cls_obj1.GET_CASE_OBJ(RO_CASE.SALES_ORDER_NUMBER,'Open');
            }
            else
            {
            lkupCase = cls_obj1.GET_CASE_OBJ(RO_CASE.SALES_ORDER_NUMBER,'Closed');
            }    
            
            if (lkupCase !=null)
            caseNum = lkupCase.Case_Number__c;    
        
        }
         catch(exception e)
         {
          rtn='Failure creating/updating SFDC case ';
          rtn=rtn+e;
              /* Added for RAPD - 3343 */
                               SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
              /* ENDED */
         }
         if(rtn=='Create Success!') 
            {
         /* RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Success!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Description__c = 'Case Number ' + caseNum + ' successfully created';
            insert tlog; */
            return 'Success!!';
            }
          else if (rtn=='Closed Success!')
           {
         /* RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Success!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Description__c = 'Case Number ' + caseNum + ' successfully closed';
            insert tlog; */
            return 'Success!!';
            }
          else if (rtn=='Update Success!')
           {
         /* RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Success!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Description__c = 'Case Number ' + caseNum + ' successfully updated. New task created';
            insert tlog; */
            return 'Success!!';
            }
            else if (rtn == 'Case Not Found!' && caseNum =='')
            {
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Failed!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Transaction_Type__c = transType;
            tlog.XML_Request__c = String.valueof(RO_CASE);
            tlog.Description__c = 'No Case Number found for the given Sales Order Number' ;
            insert tlog;
                 /* Added for RAPD - 3343 */
             SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                 /* ENDED */
            return 'Failure!';
            }
            else if (rtn == 'Case Not Found!' && caseNum != '')
            {
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Failed!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Transaction_Type__c = transType;
            tlog.XML_Request__c = String.valueof(RO_CASE);
            tlog.Description__c = 'Case was already closed in SFDC' ;
            insert tlog;
                 /* Added for RAPD - 3343 */
             SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            return 'Failure!';
            }
        else
            {
            RnO_Automation_Transaction_Log__c tlog = new RnO_Automation_Transaction_Log__c();
            tlog.Transaction_Time__c = datetime.now();
            tlog.Status__c = 'Failed!';
            tlog.Sales_Order_Num__c = salesOrdNum;
            tlog.Case_Num__c = caseNum;
            tlog.Transaction_Type__c = transType;
            tlog.XML_Request__c = String.valueof(RO_CASE);
            if(string.valueof(rtn).length()>32766)
            tlog.Description__c = string.valueof(rtn.substring(0,32756));
            else 
            tlog.Description__c = string.valueof(rtn);
            insert tlog;
                 /* Added for RAPD - 3343 */
             SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                /* Ended */
            return 'Failure!';
            }      
        }
        
        /* Method to create CASE record in the CASE object/table */ 
        public String CREATE_CASE(RnO_CASE_cls new_case)
        {
        String rtn=' ';
        Date OdrEntDt = null;
        Date CustReqDt = null;
        String AcctId ='';
        String ContId ='';
        String OwnerId='';
        String SAPAcctId ='';
        String SAPPlantName='';
        String ProdId ='';
         /* Added for RAPD - 3343 */
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
                    
                    string truncateIP = '';
        truncateIP = string.valueOf(new_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        /* Ended */
         try
            { 
            if(new_case !=null)
             {
                SAP_RandO_Automation_Service cls_obj= new SAP_RandO_Automation_Service();//class obj to call methods defined for modularisation
                Case my_case = new Case();
                
                OdrEntDt = cls_obj.FORMAT_DATE(new_case.ORDER_ENTERED_DT);
                CustReqDt = cls_obj.FORMAT_DATE(new_case.CUSTOMER_REQUEST_DT);
                AcctId = cls_obj.GET_ACCOUNT_ID(new_case.ACCOUNT_NAME);
                ContId = cls_obj.GET_CONTACT_ID(new_case.CONTACT_NAME, AcctId);
        //        OwnerId = cls_obj.GET_CASE_OWNER(AcctId);
                SAPAcctId = cls_obj.GET_SAP_ACCOUNT_NAME(new_case.SAP_ACCOUNT_NAME, AcctId);
                SAPPlantName = cls_obj.GET_SAP_PLANT_NAME(new_case.REPAIR_LOCATION);
                ProdId = cls_obj.GET_PRODUCT_NUM(new_case.PRODUCT_NUM);
                
                if (AcctId!=DefaultAcctId)
                {
                SAPAcctId=null;
                }
                
                my_case.AccountId=AcctId;
                my_case.Classification__c=new_case.CLASSIFICATION;
                my_case.ContactId=ContId;
                my_case.Customer_PO_RO_WONumber__c=new_case.CUSTOMER_PO_RO_WO_NUM;
                my_case.Customer_Request_Date__c=CustReqDt;
                my_case.Description=new_case.DESCRIPTION;
                my_case.Export_Compliance_Content_ITAR_EAR__c=new_case.EXPORT_COMPLIANCE_IND;
                my_case.Government_Compliance_SM_M_Content__c=new_case.GOVT_COMPLIANCE_IND;
                my_case.Origin='Web';
                my_case.Order_Entered__c=OdrEntDt;
                my_case.OwnerId=DefaultOwnerId;
                if (ProdId != NULL && ProdId !='')
                {
                my_case.Product_Number__c=ProdId;
                }
                my_case.Product_Serial_Number__c=new_case.PRODUCT_SERIAL_NUM;
                my_case.RecordTypeId=RnORecordTypeId;
                my_case.Repair_Location__c=SAPPlantName;
                my_case.SPEX_Exchange__c=false;
                my_case.Status='Open';
                my_case.Sub_Class__c=new_case.SUB_CLASS;
                my_case.Subject=new_case.SUBJECT;
                my_case.Type='Order Status';  
                //my_case.Type='SAP-Created';
                if (SAPAcctId != NULL && SAPAcctId !='')
                {
                my_case.SAP_Account_Number__c=SAPAcctId;
                }
                my_case.Sales_Order_Number__c=new_case.SALES_ORDER_NUMBER;
                
                insert my_case;
                rtn = 'Create Success!';  
             }               
                 
            }
             catch(exception e)
        {
            rtn='Failure creating a new SFDC case';
            rtn=rtn+e;
             /* Added for RAPD - 3343 */
               SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                     //     SApInterface.caseNumber = caseNum;
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            /* Ended */
        }
        return rtn;  
        }
        
        /* Method to update/close CASE record in the CASE object/table */
        public String UPDATE_CASE(RnO_CASE_cls update_case)
        {
         String rtn='';
         Case UpdCase=null;
         String caseId='';
         Integer taskCount=0;
         String caseOwnerId='';
         boolean isClosed=true;
             /* Added for RAPD - 3343 */
          SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput(); 
                    
                    string truncateIP = '';
        truncateIP = string.valueOf(update_case);
         if(truncateIP.length() > 131072){
        truncateIP = truncateIP.subString(0,131072);
        }
        /*Ended*/
        try
        {
        SAP_RandO_Automation_Service cls_obj= new SAP_RandO_Automation_Service();//class obj to call methods defined for modularisation
        if (update_case !=null && update_case.SALES_ORDER_NUMBER !=null)
        {
        UpdCase = cls_obj.GET_CASE_OBJ(update_case.SALES_ORDER_NUMBER, 'Open');
        }
        if (UpdCase !=null)
        {
        caseId = UpdCase.Id;
        caseOwnerId = UpdCase.OwnerId; 
        
        list <Task> CaseTaskList = [SELECT Id FROM Task where Status!='Completed' and WhatId=:caseId];
        if (CaseTaskList.size() > 0)
            {
                for(Task temp:CaseTaskList) 
                    {
                        taskCount = taskCount + 1; 
                    }
            }
           System.debug('*****SFDC Case Task Count****'+ taskCount);
            if (taskCount > 0)
            {
             Task newTask = new Task(Description = 'Order has been closed in SAP and is ready to be closed in SFDC',
                                        Priority = 'Normal',
                                        Status = 'In Progress',
                                        Subject = 'Order Closed in SAP',
                                        OwnerId = caseOwnerId,
                                        WhatId = caseId); 
                                   //     Issue_Initiation_Date__c = System.today()            
                insert newTask;
                UpdCase.Sub_Status__c = 'Ready to Close';
                isClosed=false;
            }
            else
            {
        
        UpdCase.Status='Done';
        UpdCase.Resolution__c=update_case.RESOLUTION;
        UpdCase.Sub_Status__c=update_case.SUB_STATUS;
            }
        
        update UpdCase;
        if(isClosed)
        rtn='Closed Success!';
        else
        rtn='Update Success!';
        }
        else
        rtn='Case Not Found!';
        }
        catch(exception e)
        {
            rtn='Failure updating or closing the SFDC case ';
            rtn=rtn+e;
             /* Added for RAPD - 3343 */
              SApInterface.sapException=rtn;
                     SApInterface.Name = 'SAP_RandO_Automation_Service';
                          SApInterface.createdDate =Date.valueof(Datetime.now());
                          //To maintain case number consistency adding CASE
                          SApInterface.caseNumber = string.valueOf(caseId);
                           SApInterface.inputValue =truncateIP;
                            SApInterface.createdBy = UserInfo.getName();
                   SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
             /* Ended */
        }
        return rtn;  
        }
        
        /* Method to get SFDC Account Id based on Account Name from the Account object/table */
        public Id GET_ACCOUNT_ID(String AcctName)
        {
        String AcctId ='';
       if (AcctName !=null && AcctName !='')
       {
        list <Account> AcctIdList = [select Id, REPORT_ACCOUNT_NAME__c from Account where Sbl_Account_Row_Id__c=:AcctName and (NOT REPORT_ACCOUNT_NAME__c like '%VARIOUS%') LIMIT 1];
     //     list <Account> AcctIdList = [select Id from Account where Sbl_Account_Row_Id__c=:AcctName LIMIT 1];
        if (AcctIdList.size() > 0)
            {
                for(Account temp:AcctIdList) 
                {
                AcctId = temp.Id; 
     //           RptAcctNm = temp.REPORT_ACCOUNT_NAME__c; 
                }
            }
            else
            {
             //return a place holder Account ID
             AcctId=DefaultAcctId;
            }
       }
       else
       {
        AcctId=DefaultAcctId;
       }
        
        return AcctId;  
        }
        
        /* Method to get SFDC Product Id based on Product Number from the Product2 object/table */
        public String GET_PRODUCT_NUM(String ProdNum)
        {
         String ProdId ='';
          if (ProdNum !=null && ProdNum !='')
         {
         list <Product2> ProdIdList = [SELECT Id FROM Product2 where Product_Number__c=:ProdNum LIMIT 1];
         if (ProdIdList.size() > 0)
            {
                for(Product2 temp:ProdIdList) 
                     {
                        ProdId= temp.Id; 
                     }
             }
             else
             {
             ProdId = null;
             }
        
          }
          else
          {
            ProdId = null;
             //return a place holder Product ID
          }
        return ProdId;  
        }
        
        /* Method to get SFDC Contact Id based on Contact Name from the Contact object/table */
        public String GET_CONTACT_ID(String ConEmail, String AcctId)
        {
         String orgId = UserInfo.getOrganizationId();
         String ContId ='';
         if (ConEmail !=null && ConEmail !='')
         {
           if(orgId=='00De0000000DcwDEAS')
           {
           ConEmail = ConEmail + '.qa';
           }
         list <Contact> ContIdList = [select Id from Contact where Email=:ConEmail and AccountId=:AcctId LIMIT 1];
         if (ContIdList.size() > 0)
            {
                for(Contact temp:ContIdList) 
                     {
                        ContId= temp.Id; 
                     }
        
            }
            else
            {
             //return a place holder Contact ID
             ContId=DefaultContId;
            }
            }
            else
            {
             //return a place holder Contact ID
             ContId=DefaultContId;
            }
             
        return ContId;
        }
        
 /*       public String GET_CASE_OWNER(String AcctID)
        {
        String CaseOwnerId ='';
        list <AccountTeamMember> OwnerIdList = [SELECT UserId FROM AccountTeamMember where TeamMemberRole='Customer Service Rep(CSR)' and AccountId=:AcctID LIMIT 1];
        if (OwnerIdList.size() > 0)
            {
                for(AccountTeamMember temp:OwnerIdList) 
                    {
                        CaseOwnerId= temp.UserId; 
                    }
        
            }
            else
            {
                CaseOwnerId=DefaultOwnerId;
            //return a place holder SAP Account ID
            }
        return CaseOwnerId;  
        }
  */
        
        /* Method to get SFDC Account Cross Ref Id based on Account Name and matched Case Account ID from the Account_Cross_Ref object/table */
        public String GET_SAP_ACCOUNT_NAME(String SAPAcctName, String AcctID)
        {
        String SAPAcctId ='';
         if (SAPAcctName !=null && SAPAcctName !='')
         {
         list <Account_Cross_Ref__c> SAPAcctIdList = [SELECT Id FROM Account_Cross_Ref__c where Account_Name__c=:AcctID and External_Account_ID__c=:SAPAcctName LIMIT 1];
         if (SAPAcctIdList.size() > 0)
            {
                for(Account_Cross_Ref__c temp:SAPAcctIdList) 
                    {
                        SAPAcctId= temp.Id; 
                    }
        
            }
            else
            {
                SAPAcctId=DefaultSAPAcctName;
            //return a place holder SAP Account ID
            }
         }
         else
         {
         SAPAcctId=DefaultSAPAcctName;
         }
        return SAPAcctId;  
        }
        
        /* Method to get SAP Plant name based on SAP Plant Code from the Plant_Code_Master__c  */
        public String GET_SAP_PLANT_NAME (String PlantCd)
        {
        
        String SAPPlantName ='';
        list <Plant_Code_Master__c> SAPPlantList =[SELECT Name FROM Plant_Code_Master__c where SAP_Plant_Code__c=:PlantCd];
        if (SAPPlantList.size() > 0)
            {
            for (Plant_Code_Master__c temp:SAPPlantList)
                {
                SAPPlantName = temp.Name;
                }
            }
        
        return SAPPlantName;
        }
        
         /* Method to get CASE number based on sales order number  */
        public Case GET_CASE_OBJ (String salesOdr, String status)
        {
        
        Case UpdateCase =null;
        List<Case> caseIdList = new List<Case>();
        if(status=='Open')
        {
        caseIdList = [SELECT Case_Number__c, Id, Status, Resolution__c, Sub_Status__c, OwnerId FROM Case 
        where RecordTypeId=:RnORecordTypeId and Origin='Web' and Classification__c='CSO Repair/Overhaul' 
        and Type='Order Status' and Status !='Done' and Sales_Order_Number__c=:salesOdr LIMIT 1];
        }
        else
        {
        caseIdList = [SELECT Case_Number__c, Id, Status, Resolution__c, Sub_Status__c, OwnerId FROM Case 
        where RecordTypeId=:RnORecordTypeId and Origin='Web' and Classification__c='CSO Repair/Overhaul' 
        and Type='Order Status' and Status !='Open' and Sales_Order_Number__c=:salesOdr LIMIT 1];
        }
       system.debug('caseIdList===>'+caseIdList+'salesOdr===>'+salesOdr+'status===>'+status);
        if (caseIdList.size() > 0)
            {
            for (Case temp:CaseIdList)
                {
                UpdateCase = temp;
                }
            }
        
        System.debug('*****SFDC Case Number ****'+ UpdateCase);    
        return UpdateCase;
        }
        
         /* Method to get SFDC formated date from the SAP provided date string */
        public Date FORMAT_DATE(String dt)
        {
        
        String strdt = '';
        strdt = dt + ' 00:00:00';
        Date newdate = date.ValueOf(strdt);
             
        return newdate; 
        }
        
        
}
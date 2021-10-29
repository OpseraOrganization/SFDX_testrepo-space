/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : CreateSurveyURL 
* Description           : Trigger to Send survey 
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* FEB-13-2013      1.1            NTTData               SR# 357371 - Code changes to send survey to GDC related record typesan R&O
* MAR-04-2013      1.2            NTTData               SR# 375781 - Code changes to send survey to EBIZ Web Support
* AUG-13-2013      1.3            NTTData               SR# 387834 - Code changes to stop sending surveys to the accounts as per the req
* SEP-16-2013      1.4            NTTData               SR# 413455 & SR# 406298 - Code changes to send survey to NavDb accnts & MSP Contract
* NOV-08-2013      1.5            NTTData               SR# 430934 - Code changes to stop sending surveys to mail Ids containing @honeywell.com
***********************************************************************************************************/

// Clicktools 2nd September 2010

trigger CreateSurveyURL on Case (after update) 
{/*commenting inactive trigger code to improve code coverage-----
    User objUser;
    // avoid calling for mass update because of governor limits  
    if(trigger.new.size() == 1) 
    {
        Case new_c = trigger.new[0];
        Case old_c = trigger.old[0];
        String strSurveyType = '';
        String strRecord ='None';
        Boolean bolEBizCondFlag  = false;
        Boolean bolWebSupport = false;
        Boolean bolOtherSurveySent = false;
        Boolean MspContract = false;
        Boolean NavDbaccounts = false;
        // changed to status to one of Done, Completed, Closed, Approved
        if((String.valueOf(new_c.OwnerId).startsWith('005')) && ((old_c.status != 'Done' && new_c.status == 'Done') || 
        (old_c.status != 'Completed' && new_c.status == 'Completed') || 
        (old_c.status != 'Closed' && new_c.status == 'Closed') || 
        (old_c.status != 'Approved' && new_c.status == 'Approved') ||        
        ////////////(old_c.status != 'Denied' && new_c.status == 'Denied') ||
        (old_c.status != 'Partially Accepted' && new_c.status == 'Partially Accepted') ||
        (old_c.status != 'Closed/Collected' && new_c.status == 'Closed/Collected') ||
        (old_c.status != 'Closed with Credit' && new_c.status == 'Closed with Credit') 
        ///////// (old_c.status != 'Cancelled' && new_c.status == 'Cancelled')
        ) && 
        new_c.ContactId != null && new_c.AccountId != null && !CreateSurveyURL.updateFromFutureCall) 
        {
            RecordType[] rts = [select Id from RecordType where SobjectType = 'Case' and (
                            DeveloperName = 'AOG' or
                            DeveloperName = 'Orders' or 
                            DeveloperName = 'Quotes' or
                            DeveloperName = 'Returns' or
                            DeveloperName = 'ERB' or 
                            DeveloperName = 'WEB_Support' or
                            DeveloperName = 'Technical_Issue' or 
                            DeveloperName = 'Invoice_Disputes'  or
                            DeveloperName = 'Tech_Pubs' 
                            //DeveloperName = 'Serv_GDC_Accounts_Record_Type'
                            // or
                            //DeveloperName = 'Serv_GDC_Tech_Issue' or
                            //DeveloperName = 'Serv_GDC_Operations_Email' or
                            //DeveloperName = 'Serv_GDC_Call'
                            //Stopping Survey for Repair and Overhall record types as per Cindy request 10/26/2012
                            // or    DeveloperName = 'Repair_Overhaul' 
                            )]; 
            Set<ID> setRTID = new Set<ID>();
            for(RecordType rtid:rts)
                setRTID.add(rtid.id);              
            // is of one of valid record types     
            if((setRTID.contains(new_c.RecordTypeId) || (new_c.RecordTypeId == rts[6].Id && new_c.Account.Stop_to_Send_Surveys__c!='Stop Sending Surveys'))&&
            (new_c.Service_Level__c == 'Comprehensive' || new_c.Service_Level__c == 'Standard' || new_c.Service_Level__c == 'Superior') &&
            (new_c.User_CBT__c == 'GTO' || new_c.User_CBT__c == 'CSO') && (new_c.SBU__c == 'ATR' || new_c.SBU__c == 'BGA' || new_c.SBU__c == 'D&S'))
            {
                strRecord = 'Others';
                strSurveyType = 'NotGDC';
            }else if(new_c.RecordTypeId == label.GDC_Accounts)
            {
                strRecord = 'GDC Accounts';
                strSurveyType = 'GDC';
            }else if(new_c.RecordTypeId == label.GDC_Tech_Issue && new_c.status!='Review' && new_c.status!='Project')
            {
                strRecord = 'GDC Tech';
                strSurveyType = 'GDC';
            }
            else if((new_c.RecordTypeId == label.GDC_Call || new_c.RecordTypeId == label.GDC_Operations_Email)
              && new_c.status!='Review' && new_c.status!='Project' && new_c.type != 'Routine')
            {
                strRecord = 'GDC Call/Oprn';
                strSurveyType = 'GDC';
            }
            else
            {
                strRecord = 'None';
            }
            if(new_c.RecordTypeId == label.Web_Support_Rec_Type_ID && new_c.type == 'MyAero web portal issue' && new_c.status == 'Done')
            {
                bolWebSupport = true;
            }
            if(new_c.RecordTypeId == label.MSP_Contract && (new_c.Status == 'Done'||new_c.Status == 'Closed') && new_c.Sub_Status__c != 'Final Notice Sent')
            {
                MspContract = true;
            }
            if(new_c.RecordTypeId == label.NavDB_Accts && new_c.Status == 'Done' && new_c.Classification__c != 'In Arrears')
            {
                NavDbaccounts = true;
            }
            //u = [select FirstName, LastName, Functional_Role__c,
            //ManagerId, Global_Job_Function__c, Workgroup__c, Location__c from User where Id = :new_c.OwnerId]; 
          
            if(strRecord == 'Others' || strRecord == 'GDC Accounts'|| strRecord == 'GDC Tech' || strRecord == 'GDC Call/Oprn' || bolWebSupport || MspContract || NavDbaccounts)
            {         
                //Stopping Survey for Repair and Overhall record types as per Cindy request 10/26/2012
                // || (new_c.RecordTypeId == rts[9].Id && (new_c.Owner_Manager__c== 'Kirk Ebert' ||new_c.Owner_Manager__c=='Lance       Lajara'))      
                 
                Contact con = [select Id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
                from Contact where Id = :new_c.ContactId];
                             
                // if email missing or @honeywell not valid - this is not validating the email
                boolean validEmail = con.Email == null || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                //validEmail = true;
                // has a survey been completed in the last 60 days
                Date lastSent = con.Last_Survey_Date__c;
                Integer daysBetween = 91;
                
                if(lastSent != null) 
                { // may never have been set      
                  daysBetween = lastSent.daysBetween(Date.today());
                }
                //daysBetween = 91;
                Boolean bolGDCCondFlag = false;
                List<ID> lstuserGpId = new List<ID>();
                if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No')) 
                {
                    if(validEmail && daysBetween > 60 && (strRecord == 'GDC Accounts'|| strRecord == 'GDC Tech' || strRecord == 'GDC Call/Oprn'))
                    {
                        List<id> listQueueid = new List<id>{label.GDC_Accounts_Queue,label.GDCTech,label.GFO};
                        List<GroupMember> lstGDCOwner = [Select Id, GroupId, UserOrGroupId From GroupMember where groupid in: listQueueid ];
                        //String strUserOrGpId;
                        lstuserGpId = new List<ID>();
                        Id idUserOrGpId;
                        for(integer j = 0; j < lstGDCOwner.size(); j++)
                        {
                            idUserOrGpId = lstGDCOwner[j].userorgroupid;
                            if(!bolGDCCondFlag && idUserOrGpId == new_c.OwnerId )
                            {
                                bolGDCCondFlag = true;
                            }
                        }
                        if(!bolGDCCondFlag)
                        {   
                            bolGDCCondFlag = getGroupIds(lstGDCOwner,new_c.OwnerId);
                        }
                        if(bolGDCCondFlag)
                        {
                            objUser = getUserDetails(new_c.ownerid);
                            SendSurvey(new_c,con,strSurveyType,objUser);
                        }
                    }
                    else if(validEmail && daysBetween > 60 && (strRecord == 'Others'))
                    {
                      objUser = getUserDetails(new_c.ownerid); 
                      if(objUser!=null && objUser.Functional_Role__c == 'Customer Service Rep' || objUser.Functional_Role__c == 'Tech Ops Center' || objUser.Functional_Role__c == 'Tech Ops Center Olathe' || objUser.Functional_Role__c == 'Product Support Engineer')
                      {
                        bolOtherSurveySent=true;
                        SendSurvey(new_c,con,strSurveyType,objUser);
                      }
                    }
                    if (validEmail && !bolOtherSurveySent && bolWebSupport && daysBetween > 90 && con.Email != null)
                    {
                        List<GroupMember> lstEbizmemb = [Select Id, GroupId, UserOrGroupId From GroupMember where groupid = '00G30000002Yx5k'];
                        //String strUserOrGpId;
                        lstuserGpId = new List<ID>();
                        Id idUserOrGpId;
                        for(integer j = 0; j < lstEbizmemb.size(); j++)
                        {
                            idUserOrGpId = lstEbizmemb[j].userorgroupid;
                            if(!bolEBizCondFlag && idUserOrGpId == new_c.OwnerId )
                            {
                                bolEBizCondFlag = true;
                            }
                        }
                        if(!bolEBizCondFlag)
                        {   
                            bolEBizCondFlag = getGroupIds(lstEbizmemb,new_c.OwnerId);
                        }

                        if(bolEBizCondFlag)
                        {
                            if(objUser==null)
                            {
                                objUser = getUserDetails(new_c.ownerid);
                            }
                            SendSurvey(new_c,con,'Web_Support',objUser);
                        }           
                    }
                    if (validEmail && MspContract && con.Email != null)
                    {
                        objUser = getUserDetails(new_c.ownerid);
                        if(objUser != null){
                            SendSurvey(new_c,con,'MSP_Contract',objuser);
                        }
                    }
                    if (validEmail && NavDbaccounts && con.Email != null)
                    {
                        objUser = getUserDetails(new_c.ownerid);
                        if(objUser != null){
                            SendSurvey(new_c,con,'NavDB_Accounts',objuser);
                        }
                    }
                }
            }   
        }
    }
    private User getUserDetails(Id OwnerId)
    {
        List<User> lstUser = [select FirstName, LastName, Functional_Role__c,
        ManagerId, Global_Job_Function__c, Workgroup__c, Location__c from User where Id = :OwnerId];
        User usr;    
        if(lstUser!=null&&lstUser.size() > 0)
        {
        usr=lstUser[0];
        }
        return usr;
    }
    private boolean getGroupMembers(List<ID> lstuserGpId, Id idOwner)
    {
        Boolean bolFlag = false;
        List<GroupMember> lstUser = [Select UserOrGroupId From GroupMember where GroupId in :lstuserGpId];
        for(integer i = 0; i < lstUser.size(); i++)
        {
            if(!bolFlag && lstUser[i].userorgroupid == idOwner)
            {
                bolFlag = true;
            }
        }
        if(!bolFlag)
        {   
            bolFlag = getGroupIds(lstUser,idOwner);
        }
        return bolFlag;
    }
    private boolean getGroupIds(List<GroupMember> lstGpMembers, Id idOwner)
    {
        Boolean bolFlag = false;
        Id idUserOrGpId;
        List<ID> lstuserGpId = new List<ID>();
        for(integer j = 0; j < lstGpMembers.size(); j++)
        {
            idUserOrGpId = lstGpMembers[j].userorgroupid;        
            if(String.valueOf(idUserOrGpId).startsWith('00G'))
            {
                lstuserGpId.add(idUserOrGpId);
            }
        }
        if(!bolFlag && lstuserGpId!=null && lstuserGpId.size()>0)
        {
            bolFlag = getGroupMembers(lstuserGpId,idOwner);
        }
        return bolFlag;
    }
    private void SendSurvey(Case new_c, Contact con, String strSurveyType,User objCaseOwner)
    {           
        RecordType rt = [select Name from RecordType where Id = :new_c.RecordTypeId];
        Map<String,String> m = new Map<String,String>();                
        //1 - Case record ID  1 - Text  Case - {!Case.Id}
        m.put('&q1', new_c.Id);
        //2 - Contact record ID 2 - Text  Case - {!Case.ContactId}
        m.put('&q2', new_c.ContactId);
        //3 - Account record ID 3 - Text  Account linked to case - {!Case.AccountId}
        m.put('&q3', new_c.AccountId);
        //4 - Case owner manager user record ID 4 - Text
        m.put('&q4', objCaseOwner.ManagerId);
        //5 - Case number 5 - Text  Case - {!Case.CaseNumber}
        m.put('&q5', new_c.CaseNumber);
        //6 - Case created date 6 - Text  Case - {!Case.CreatedDate}
        m.put('&q6', String.valueOf(new_c.CreatedDate));
        //7 - Case owner global job function  7 - Text  Field on the case owner record - {!User.Global_Job_Function__c}
        m.put('&q7', objCaseOwner.Global_Job_Function__c);
        //8 - Case subject  8 - Text  Case - {!Case.Subject}
        m.put('&q8', new_c.Subject);
        //9 - Case owner FSE name 9 - Text  Case - {!Case.OwnerFullName}
        m.put('&q9', objCaseOwner.FirstName+' '+objCaseOwner.LastName);
        //10 - Case origin  10 - Text Case - {!Case.Origin}
        m.put('&q10', new_c.Origin);
        //11 - Case owner CBT 11 - Text Case - {!Case.User_CBT__c}
        m.put('&q11', new_c.User_CBT__c);
        //12 - Case account SBU 12 - Text Case (Formula field derived from Account) - {!Case.SBU__c}
        m.put('&q12', new_c.SBU__c);
        //13 - Case account region  13 - Text Case (Formula field derived from Account) - {!Case.Region__c}
        m.put('&q13', new_c.Region__c);
        //14 - Workgroup  14 - TBC  User - {User.Workgroup__c}
        m.put('&q14', objCaseOwner.Workgroup__c);
        //15 - Case owner manager name  15 - Text Case (derived from User record) - {!Case.Owner_Manager__c}
        m.put('&q15', new_c.Owner_Manager__c);
        //16 - Case owner functional role 16 - Text Field on case owner record - {!User.Functional_Role__c}
        m.put('&q16', objCaseOwner.Functional_Role__c);
        //17 - Case owner location  17 - Text Case owner user record - {!User.Location__c}
        m.put('&q17', objCaseOwner.Location__c);
        //18 - Case account name  18 - Text Case (Account name) - {!Case.Account}
        m.put('&q18', new_c.Account_Name__c);
        //19 - Case account service level 19 - Text Case (formula derived from Account picklist) - {!Case.Service_Level__c}
        m.put('&q19', new_c.Service_Level__c);
        //20 - Case record type name  20 - Text Case Record type name
        m.put('&q20', rt.Name);
        //21 - Case classification  21 - Text Case - {!Case.Classification__c}
        m.put('&q21', new_c.Classification__c);
        //22 - Case sub-class 22 - Text Case - {!Case.Sub_Class__c}
        m.put('&q22', new_c.Sub_Class__c);
        //23 - Case detail class  23 - Text Case - {!Case.Detail_Class__c}
        m.put('&q23', new_c.Detail_Class__c);
        //24 - Case contact primary work phone  24 - Text {!Case.Primary_Work_Phone__c}
        m.put('&q24', new_c.Primary_Work_Number__c);
        //25 - Response status  25 - Radio &q25=1
        m.put('&q25', '1');

        // we have to update contact here to avoid calling another future
        // method from createSurvey future method not ideal as the date will
        // be set even if the survey creation fails
        con.Last_Survey_Date__c = Date.today();
        con.Last_Survey_Type__c = 'NSS';   
        try
        {
        update con;      
        }
        catch(Exception objExp)
        {
            System.debug('Exception occured while saving contact in CreateSurveyURL trigger '+objExp);
        }
        // call asynchronous method to allow call out to create and pre-populate survey
        CreateSurveyURL.createSurvey(new_c.Id, strSurveyType, m);    
    }*/
}
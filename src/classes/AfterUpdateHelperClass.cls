/*******************************************************************************
Name         : AfterUpdateHelperClass
Created By   : Anusuya Murugiah
Company Name : NTT Data
Project      : <Phase-II>, <HealthCheck - Sprint 2>
Created Date : 22 October 2013
Usages       : This Class is to consolidate the AfterUpdate functionality which
splited across in different triggers.
Updates      : Changes done for Effortless Orders to send the attachments to SAP
Updates      : 8/17/15 //Fix for production ticket INC000009017683
Updates      : Changes done for UFR Pricing to send case details to UFRPricing_EmailSending when email updates manually.
Usages       : Changes done for INC000008986324
Updates      : INC000009169188 - BRD On Hold Consolidation
Updates      : INC000009995133 - Time to SBU Determined
Updates      : INC000011232884 - Allow users to select only value of Reason for Hold (even though it is a multi-select picklist field)
Updates      : INC000010983535 - TCS Team Added Code for Stopping NSS survey for Fedex Account
updates      : PRJ11585-- added new recordtypes and modified the survey for MSPcontrat, gdc accounts, NAVdb, HAPP,FSS technical servieces, techpubs
updates      : Removed afterUpdateMethod and InsertReasonForHold and moved to Case Service Classes dated 28 Nov 2017 Team : IBM India

 *******************************************************************************/
public with sharing class AfterUpdateHelperClass{
    public static User getUserDetails(Id OwnerId) {
                    List < User > lstUser = [select FirstName, LastName, Functional_Role__c,
                        ManagerId, Global_Job_Function__c, Workgroup__c, Location__c from User where Id = : OwnerId];
                    User usr;
                    if (lstUser != null && lstUser.size() > 0) {
                        usr = lstUser[0];
                    }
                    return usr;
    }
    public static boolean StopduplicatSurveyRecur = false;
    
    public static boolean getGroupMembers(List < ID > lstuserGpId, Id idOwner) {
                    Boolean bolFlag = false;
                    List < GroupMember > lstUser = [Select UserOrGroupId From GroupMember where GroupId in: lstuserGpId];
                    for (integer i = 0; i < lstUser.size(); i++) {
                        if (!bolFlag && lstUser[i].userorgroupid == idOwner) {
                            bolFlag = true;
                        }
                    }
                    if (!bolFlag) {
                        bolFlag = getGroupIds(lstUser, idOwner);
                    }
                    return bolFlag;
                }

    public static boolean getGroupIds(List < GroupMember > lstGpMembers, Id idOwner) {
                    Boolean bolFlag = false;
                    Id idUserOrGpId;
                    List < ID > lstuserGpId = new List < ID > ();
                    for (integer j = 0; j < lstGpMembers.size(); j++) {
                        idUserOrGpId = lstGpMembers[j].userorgroupid;
                        if (String.valueOf(idUserOrGpId).startsWith('00G')) {
                            lstuserGpId.add(idUserOrGpId);
                        }
                    }
                    if (!bolFlag && lstuserGpId != null && lstuserGpId.size() > 0) {
                        bolFlag = getGroupMembers(lstuserGpId, idOwner);
                    }
                    return bolFlag;
    }
    
    public static void SendSurvey(Case new_c, Contact con, String strSurveyType, User objCaseOwner) {
        RecordType rt = [select Name from RecordType where Id = : new_c.RecordTypeId];
        Map < String,
        String > m = new Map < String,
        String > ();
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
        m.put('&q9', objCaseOwner.FirstName + ' ' + objCaseOwner.LastName);
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
        //26 - PO Number  26 - text &q26=1
         m.put('&q26',new_c.Customer_PO_RO_WONumber__c);

        // we have to update contact here to avoid calling another future
        // method from createSurvey future method not ideal as the date will
        // be set even if the survey creation fails
         //INC0000370606 should not update for Phone vkt
           //SCTASK1163527 start change condition
        if(new_c.Origin != 'Phone' || //if condition is un-commented for SCTASK2407239
           //start of changes made for SCTASK2276811 , SCTASK2191901
        strSurveyType == 'Services_Support' || strSurveyType == 'Falcon_Connect' || new_c.recordtypeid==String.valueof(schema.sobjecttype.case.getrecordtypeinfosbyName().get('Service Intro').getrecordtypeid()).substring(0, 15)){ //if condition is un-commented for SCTASK2407239
         //end of changes made for SCTASK2276811 , SCTASK2191901 
            con.Last_Survey_Date__c = Date.today();
            con.Last_Survey_Type__c = 'NSS';
        }
        //INC0000370606 end
        try {
            system.debug('=vkt===before update=con===='+con);
            update con;
            system.debug('=vkt===after update=con===='+con);
        } catch (Exception objExp) {
            System.debug('Exception occured while saving contact in CreateSurveyURL trigger ' + objExp);
        }
        // call asynchronous method to allow call out to create and pre-populate survey
          if(!StopduplicatSurveyRecur){
            StopduplicatSurveyRecur = true;
            CreateSurveyURL.createSurvey(new_c.Id, strSurveyType, m);
            
         }
    }
    public static void SendSurvey(Case new_c, String strSurveyType, User objCaseOwner) {
        RecordType rt = [select Name from RecordType where Id = : new_c.RecordTypeId];
        Map < String,
        String > m = new Map < String,
        String > ();
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
        m.put('&q9', objCaseOwner.FirstName + ' ' + objCaseOwner.LastName);
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
        //26 - PO Number  26 - text &q26=1
         m.put('&q26',new_c.Customer_PO_RO_WONumber__c);

        // we have to update contact here to avoid calling another future
        // method from createSurvey future method not ideal as the date will
        // be set even if the survey creation fails
         //INC0000370606 should not update for Phone vkt
           //SCTASK1163527 start change condition
        //if(new_c.Origin != 'Phone'){
            //con.Last_Survey_Date__c = Date.today();
            //con.Last_Survey_Type__c = 'NSS';
        //}
        //INC0000370606 end
        //try {
            //system.debug('=vkt===before update=con===='+con);
            //update con;
            //system.debug('=vkt===after update=con===='+con);
        //} catch (Exception objExp) {
            //System.debug('Exception occured while saving contact in CreateSurveyURL trigger ' + objExp);
        //}
        // call asynchronous method to allow call out to create and pre-populate survey
          if(!StopduplicatSurveyRecur){
            StopduplicatSurveyRecur = true;
            CreateSurveyURL.createSurvey(new_c.Id, strSurveyType, m);
            
         }
    }
}
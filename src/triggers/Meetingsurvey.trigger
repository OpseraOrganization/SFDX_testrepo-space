trigger Meetingsurvey on Planned_Meeting__c (before update) 
{
    public User objUser;
    public Planned_Meeting__c new_c;  
    if(trigger.new.size() == 1) 
    {
    Planned_Meeting__c PM = trigger.new[0];
    new_c = [select id,Meeting_Purpose__c,Meeting_Type__c,Completed_Date__c, Contact_name__r.id, Account_name__r.id, ownerid, Account_Name__r.Stop_to_Send_Surveys__c, AccountSBU__c,
    Meeting_Status__c,RecordTypeId,TCM_Survey_Link__c,Email_Field__c,send_survey__c  from Planned_Meeting__c  where id =: pm.id];
    Planned_Meeting__c old_c = trigger.old[0];      
    String strRecord ='None';
    String strSurveyType = '';
    Boolean bolOtherSurveySent = false;
    // changed Meeting_Status__c to Done
    system.debug('updateFromFutureCall-----'+CreateSurveyURL.updateFromFutureCall);
    system.debug('updateFromFutureCall-----'+!CreateSurveyURL.updateFromFutureCall);
    system.debug('status-----'+old_c.Meeting_Status__c);
    system.debug('new status-----'+new_c.Meeting_Status__c);
    system.debug('new survey-----'+new_c.TCM_Survey_Link__c);
    system.debug('new contact-----'+new_c.Contact_Name__c);
    system.debug('new send_survey__c-----'+new_c.send_survey__c);
    
    if((old_c.Meeting_Status__c != 'Done' && new_c.Meeting_Status__c == 'Done' && new_c.TCM_Survey_Link__c == null && new_c.Send_Survey__c == true) && 
    new_c.Contact_Name__c != null && !CreateSurveyURL.updateFromFutureCall) 
    {
       
        system.debug('inside if');
        RecordType[] rts = [select Id from RecordType where SobjectType = 'Planned_Meeting__c' and DeveloperName = 'Contact_Plan'];          
        if(new_c.RecordTypeId == rts[0].id)
        {
        strRecord = 'ContactPlan';     
        }
        else
        {
        strRecord = 'None';
        }

    if(strRecord == 'ContactPlan' )
    {                       
    Contact con = [select Id, Email, Last_Survey_Date_TCM__c, Last_Survey_Type__c, Survey_Opt_Out__c, NPS_Survey__c, SBU_Contact__c
    from Contact where Id = :new_c.Contact_Name__c];         
    boolean validEmail = con.Email == null || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;           
    Date lastSent = con.Last_Survey_Date_TCM__c;
    Integer daysBetween =75;
    System.debug('con.Email # '+con);
    if(lastSent != null) 
    {       
    daysBetween = lastSent.daysBetween(Date.today());
    }     
    System.debug('daysBetween # '+daysBetween );   
    System.debug('validEmail # '+validEmail+' '+strRecord ); 
    if(CreateSurveyURL.testing == true || (con.Survey_Opt_Out__c == False)) 
    {
    if(validEmail && daysBetween >= 75 && (strRecord == 'ContactPlan')){
    System.debug('ownerid'+new_c.ownerid);
    objUser = getUserDetails(new_c.ownerid); 
    System.debug('ownerid'+objUser.ManagerId );
    bolOtherSurveySent=true;
    strSurveyType = 'TCM';                  
    SendSurvey(new_c,con,strSurveyType,objUser);
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

    private void SendSurvey(Planned_Meeting__c PM, Contact con,String strSurveyType, User objCaseOwner)
    {           
    RecordType rt = [select Name from RecordType where Id = :new_c.RecordTypeId];
    Map<String,String> m = new Map<String,String>();                

    m.put('&q1', PM.Id); 
    m.put('&q2', PM.Contact_Name__r.id);
    m.put('&q3', PM.Account_Name__r.id);
    m.put('&q4', objUser.ManagerId);
    m.put('&q5', 'One or more detractor scores have been given by this customer or customer has requested contact. Follow-up to understand the problem and put corrective action in place.');
    m.put('&q6', PM.Meeting_Purpose__c);
    m.put('&q7', PM.Meeting_Type__c);
    m.put('&q8', string.valueof(PM.Completed_Date__c));
    // we have to update contact here to avoid calling another future
    // method from createSurvey future method not ideal as the date will
    // be set even if the survey creation fails
    con.Last_Survey_Date_TCM__c = Date.today();
    con.Last_Survey_Type__c = 'TCM';   
    try
    {
    update con;      
    }
    catch(Exception objExp)
    {
    System.debug('Exception occured while saving contact in CreateSurveyURL trigger '+objExp);
    }
    //System.debug('new_c.Email_Field__c'+new_c.Email_Field__c);
    //System.debug('con.Email'+con.Email);
    // call asynchronous method to allow call out to create and pre-populate survey
    CreateSurveyURL.createSurvey(pm.Id,strSurveyType, m);    
    }
}
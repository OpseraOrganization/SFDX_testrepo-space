/** * File Name: CaseClosure
Used in: Controller for VF page CaseClosureApproval
change 7/26 - adding No of Contacts to Resolve option
 * */
public class CaseClosure{
    String App;
    String Rej;
    string Caseid = null;
    public case c {get; set;}
    Public User objUser;
    list<task> tasklist = new list<task> ();
    //public contact con;
    public Boolean AOG {
        get;
        set;
    }
    
    public Boolean SPEX_AOG {
        get;
        set;
    }
    
    public Boolean ATS {
        get;
        set;
    }
    public Boolean Approve {
        get;
        set;
    }
    public Boolean Reject {
        get;
        set;
    }
    public Boolean COAOG {
        get;
        set;
    }
    public Boolean PCAOG {
        get;
        set;
    }
    public Boolean COATS {
        get;
        set;
    }
    public Boolean PCATS {
        get;
        set;
    }
    public Boolean cmts {
        get;
        set;
    }
    public Boolean confirm {
        get;
        set;
    }
    public string confirmmessage {
        get;
        set;
    }
    public Boolean cancel {
        get;
        set;
    }
    public Boolean OPTNPS = false;
    // public Boolean SendSur = false;
    // public Integer daysBetween = 0;
    public Boolean NOC {
        get;
        set;
    }
    public Boolean NOC1 {
        get;
        set;
    }
    public String FeedbackSurvey {
        get;
        set;
    }
    
    public String overallSatisfy{get; set;}
    public String extentStr {get; set;}
    public String timesStr {get; set;}
   // public String recommendStr {get; set;}
    public String conNumStr {get; set;}
    public String reasonforopenAOG {get; set;}
    public String reasonforopenATS {get; set;}
    public String issueResolution {get; set;}
    public String phoneCallRequestAOG {get; set;}
    public String phoneCallRequestATS {get; set;}
    
    //public string uniqueURL;
    //Getting the response from the URL clicked
    public CaseClosure() {
        this.App = ApexPages.currentPage().getParameters().get('Approve');
        this.Rej = ApexPages.currentPage().getParameters().get('Reject');
        this.Caseid = ApexPages.currentPage().getParameters().get('Caseid');
        isDisabled = true;
        confirm = false;
    }
    string comments = null;
    public String getComments() {
        return Comments;
    }
    public void setComments(String Comments) {
        this.Comments = Comments;
    }

    String CaseOpenAOG = null;
    public List < SelectOption > getItems() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('My order has not been received', 'My order has not been received'));
        options.add(new SelectOption('I have a remaining open item',
                'I have a remaining open item'));
        return options;
    }
    public String getCaseOpenAOG() {
        return CaseOpenAOG;
    }
    public void setCaseOpenAOG(String CaseOpenAOG) {
        this.CaseOpenAOG = CaseOpenAOG;
    }

    String CaseOpenATS = null;
    public List < SelectOption > getItems2() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('I have not been contacted by Honeywell', 'I have not been contacted by Honeywell'));
        options.add(new SelectOption('The instructions provided to me are not clear', 'The instructions provided to me are not clear'));
        options.add(new SelectOption('I’m still confirming or testing the solution',
                'I’m still confirming or testing the solution'));
        options.add(new SelectOption('I have a follow-on question to the response',
                'I have a follow-on question to the response'));
        return options;
    }
    public String getCaseOpenATS() {
        return CaseOpenATS;
    }
    public void setCaseOpenATS(String CaseOpenATS) {
        this.CaseOpenATS = CaseOpenATS;
    }

    String PhoneCallAOG = null;
    public List < SelectOption > getItems1() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Yes, have a specialist call me', 'Yes, have a specialist call me'));
        options.add(new SelectOption('Yes, have a member of the management team call me',
                'Yes, have a member of the management team call me'));
        options.add(new SelectOption('No, but continue to follow up with me via email',
                'No, but continue to follow up with me via email'));
        return options;
    }
    public String getPhoneCallAOG() {
        return PhoneCallAOG;
    }
    public void setPhoneCallAOG(String PhoneCallAOG) {
        this.PhoneCallAOG = PhoneCallAOG;
    }
    
    //Added as part of RAPD-2702
    public Boolean OEMOrders{
        get;
        set;
    }

    String PhoneCallATS = null;
    public List < SelectOption > getItems3() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('Yes, have a Technical Support Engineer call me',
                'Yes, have a Technical Support Engineer call me'));
        //options.add(new SelectOption('Yes, have a member of the management team call me',
        //'Yes, have a member of the management team call me'));
        // options.add(new SelectOption('No, do not call me','No, do not call me'));
        options.add(new SelectOption('No, but continue to follow up with me via email',
                'No, but continue to follow up with me via email'));
        return options;
    }

    public String getPhoneCallATS() {
        return PhoneCallATS;
    }
    public void setPhoneCallATS(String PhoneCallATS) {
        this.PhoneCallATS = PhoneCallATS;
    }

    public List < SelectOption > getItems4() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5+', '5 or more'));
        return options;
    }
     public List < SelectOption > getItems4ch() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5+', '或更多次'));
        return options;
    }
    public List < SelectOption > getItems4FRA() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5+', '5 ou plus'));
        return options;
    }
    
    public List < SelectOption > getItems4GER() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5+', '5 oder mehr'));
        return options;
    }
    
    
    public List < SelectOption > getItems4POR() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5+', '5 ou mais'));
        return options;
    }
    
    
    
    String NoOfContacts = null; 
    //String NoOfContacts = '';
    public String getNoOfContacts() {
        return NoOfContacts;
    }
    public void setNoOfContacts(String NoOfContacts) {
        this.NoOfContacts = NoOfContacts;
    }

    public List < SelectOption > getItems5() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }
    Integer OverallSat = null;
    public Integer getOverallSat() {
        return OverallSat;
    }
    public void setOverallSat(Integer OverallSat) {
        this.OverallSat = OverallSat;
    }

    /*Integer NpsRec = null;
    public Integer getNpsRec() {
        return NpsRec;
    }
    public void setNpsRec(Integer NpsRec) {
        this.NpsRec = NpsRec;
    }*/

    public List < SelectOption > getItems6() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'Strongly disagree'));
        options.add(new SelectOption('2', 'Disagree'));
        options.add(new SelectOption('3', 'Somewhat disagree'));
        options.add(new SelectOption('4', 'Neutral'));
        options.add(new SelectOption('5', 'Somewhat agree'));
        options.add(new SelectOption('6', 'Agree'));
        options.add(new SelectOption('7', 'Strongly agree'));
        return options;
    }
    
    public List < SelectOption > getItemsjp() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'まったく同意できない'));
        options.add(new SelectOption('2', '同意できない'));
        options.add(new SelectOption('3', '少し同意できない'));
        options.add(new SelectOption('4', 'どちらとも言えない'));
        options.add(new SelectOption('5', '少し同意できる'));
        options.add(new SelectOption('6', '同意できる'));
        options.add(new SelectOption('7', '非常に同意でき'));
        return options;
    }
    
    public List < SelectOption > getItemsch() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', '非常不同意'));
        options.add(new SelectOption('2', '不同意'));
        options.add(new SelectOption('3', '有点不同意'));
        options.add(new SelectOption('4', '一般'));
        options.add(new SelectOption('5', '有点同意'));
        options.add(new SelectOption('6', '同意'));
        options.add(new SelectOption('7', '非常同意'));
        return options;
    }
    
    public List < SelectOption > getItemsGER() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'Überhaupt nicht zutreffend'));
        options.add(new SelectOption('2', 'Nicht zutreffend'));
        options.add(new SelectOption('3', 'Kaum zutreffend'));
        options.add(new SelectOption('4', 'Neutral'));
        options.add(new SelectOption('5', 'Gering zutreffend'));
        options.add(new SelectOption('6', 'zutreffend'));
        options.add(new SelectOption('7', 'Vollkommen zutreffend'));
        return options;
    }
    
     public List < SelectOption > getItemsFRA() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'Désaccord total'));
        options.add(new SelectOption('2', 'Désaccord'));
        options.add(new SelectOption('3', 'Désaccord faible'));
        options.add(new SelectOption('4', 'Neutre'));
        options.add(new SelectOption('5', 'Plutôt d’accord'));
        options.add(new SelectOption('6', 'D’accord'));
        options.add(new SelectOption('7', 'Totalement d’accord'));
        return options;
    }
    
    public List < SelectOption > getItemsPOR() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'Discordo fortemente'));
        options.add(new SelectOption('2', 'Discordo'));
        options.add(new SelectOption('3', 'Discordo parcialmente'));
        options.add(new SelectOption('4', 'Neutro'));
        options.add(new SelectOption('5', 'condordo parcialmente'));
        options.add(new SelectOption('6', 'condordo'));
        options.add(new SelectOption('7', 'condordo fortemente'));
        return options;
    }
    
    
    String NoCon = null;
    public String getNoCon() {
        return NoCon;
    }
    public void setNoCon(String NoCon) {
        this.NoCon = NoCon;
    }

    public List < SelectOption > getItems7() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'Yes'));
        options.add(new SelectOption('2', 'No'));
        return options;
    }
    
    
    public List < SelectOption > getItems7ch() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', '是'));
        options.add(new SelectOption('2', '否'));
        return options;
    }
    
     public List < SelectOption > getItems7FRA() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'OUI'));
        options.add(new SelectOption('2', 'NON'));
        return options;
    }
    
    public List < SelectOption > getItems7GER() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'JA'));
        options.add(new SelectOption('2', 'NEIN'));
        return options;
    }
    
    public List < SelectOption > getItems7POR() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption('1', 'SIM'));
        options.add(new SelectOption('2', 'NAO'));
        return options;
    }

    Integer CesScore = null;
    public Integer getCesScore() {
        return CesScore;
    }
    public void setCesScore(Integer CesScore) {
        this.CesScore = CesScore;
    }

    public static User getUserDetails(Id OwnerId) {
        List < User > lstUser = [select FirstName, LastName, Functional_Role__c,
            ManagerId, Global_Job_Function__c, Workgroup__c, Location__c from User where Id = : OwnerId];
        User usr;
        if (lstUser != null && lstUser.size() > 0) {
            usr = lstUser[0];
        }
        return usr;
    }

    public Pagereference updateApprovalrecord() {
        if (Caseid != null) {
            System.debug('@@@@##TestDebug##');
            c = [select id, recordtypeid, recordtype.name, Emailbox_Origin__c, status, Account.Stop_to_Send_Surveys__c, isclosed,
                Service_Level__c, contactid, ownerid, Accountid, CaseNumber, Createddate, subject, origin, User_CBT__c,
                sbu__c, Account_Name__c, region__c, Owner_Manager__c, sub_class__c, contact.email, owner.email, contact.name,
                detail_class__c, classification__c, primary_work_number__c, ownerid__r.managerid from case where id = : caseid];
                if (c.contactid != null) {
                    //con = [select id, Email, Last_Survey_Date__c, Last_Survey_Type__c, Survey_Opt_Out__c
                    //,NPS_Survey__c from contact where id=:c.contactid];
                    // system.debug('opt '+con.Survey_Opt_Out__c);
                    //system.debug('nps '+con.NPS_Survey__c);
                    if (c.status != 'Propose to Close') {
                        confirm = true;
                        if (c.isclosed == false) {
                            confirmMessage = 'We are currently working the case. We will update you when we have further information.';
                            NOC1 = false;
                        } else if (c.isclosed == true && (c.recordtype.name == 'AOG'|| c.recordtype.name == 'Exchange') && c.Emailbox_Origin__c !='Email-crc-spex') {//added for AOG/Spex Case Record Type Split
                            confirmMessage = 'This Case is already closed. Please create a new request at ' +
                                '<a href="mailto:AOG@Honeywell.com">AOG@Honeywell.com.</a>';
                            NOC1 = false;
                        } else if (c.isclosed == true && (c.recordtype.name == 'AOG'|| c.recordtype.name == 'Exchange') && c.Emailbox_Origin__c =='Email-crc-spex') {//added for AOG/Spex Case Record Type Split
                            confirmMessage = 'This SPEX Case is already closed. Please create a new request at ' +
                                '<a href="mailto:spex-bgaorders@honeywell.com">spex-bgaorders@honeywell.com.</a>';
                            NOC1 = false;   
                            
                        }
                        //As a Part of RAPD - 2702
                        else if(c.isclosed == true && (((c.recordtype.name == 'OEM Quotes Orders' && c.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' ) || 
                                (c.recordtype.name =='OEM/Spares') || 
                                (c.recordtype.name=='Orders' && c.Emailbox_Origin__c == 'Email-Orders')) || 
                                ((c.recordtype.name =='OEM Quotes Orders') || (c.recordtype.name =='OEM/Spares') || (c.recordtype.name =='Orders') ) ))
                        {      
                        System.debug('Testing 2702 OEM');          
                          confirmMessage = 'This Case is already closed. Please create a new request at ' +
                                '<a href="mailto:Orders@Honeywell.com">Orders@Honeywell.com.</a>';
                            NOC1 = false;
                        } 
                        else {
                            NOC1 = false;
                            confirmMessage = 'This Case is already closed. Please create a new request at ' +
                                '<a href="mailto:Aerotechsupport@Honeywell.com">Aerotechsupport@Honeywell.com.</a>';
                        }
                    }
                    /* start of Stopping NSS Survey functinality
                    if (con.Survey_Opt_Out__c == False && con.NPS_Survey__c == 'No'){
                    OPTNPS = true;
                    }
                    objUser = getUserDetails(c.ownerid);
                    if(((c.RecordType.name == 'Technical Issue' && c.Account.Stop_to_Send_Surveys__c!='Stop Sending Surveys') ||
                    c.RecordType.name == 'AOG' || c.RecordType.name == 'Exchange' ) && (c.Service_Level__c == 'Comprehensive' || c.Service_Level__c == 'Standard'
                    || c.Service_Level__c == 'Superior') && (c.SBU__c == 'ATR' || c.SBU__c == 'BGA' || c.SBU__c == 'D&S') ){//added for AOG/Spex Case Record Type Split
                    boolean validEmail = con.Email == null || con.Email.contains('@honeywell.com') || con.Email.contains('@HONEYWELL.COM') ? false : true;
                    // has a survey been completed in the last 30 days
                    Date lastSent;
                    Try{
                    lastSent = con.Last_Survey_Date__c;
                    if(lastSent != null ) {
                    daysBetween = lastSent.daysBetween(Date.today());
                    }else{// may never have been set
                    daysBetween = 31;
                    }
                    }catch(exception e){
                    system.debug('Error CaseClosure class'+e);
                    //daysBetween = 31;
                    }
                    if (daysBetween > 30){
                    if(objUser!=null && objUser.Functional_Role__c == 'Customer Service Rep' || objUser.Functional_Role__c == 'Tech Ops Center' || objUser.Functional_Role__c == 'Tech Ops Center Olathe' || objUser.Functional_Role__c == 'Product Support Engineer' ||  c.RecordType.name == 'Technical Issue'){
                    SendSur = true;
                    }
                    }
                    } end of stopping NSS Survey*/

                }
                System.debug('@@@@$$Testdebug$$:'+App);
                if (App == 'True') {
                    System.debug('@@@@%%Debug%%'+c.status);
                    Approve = true;
                    if (c.status == 'Propose to Close') {
                        System.debug('SOFITEST4'+c.status);
                        confirm = true;
                        NOC = false;
                        NOC1 = true;
                        //confirmMessage = 'To help us improve our support to you, would you please answer below questions based on the support provided.';
                        
                        list < Case_on_hold_log__c > cohl = [select id from Case_on_hold_log__c where Hold_Stop__c = null and(case_number__c = : caseid)];
                        list < Case_on_hold_log__c > cohl2 = new list < Case_on_hold_log__c > ();
                        for (Case_on_hold_log__c cohl1: cohl) {
                            cohl1.Hold_Stop__c = system.now();
                            cohl2.add(cohl1);
                        }
                        try {
                            update c;
                            if (!cohl2.isempty()) {
                                update cohl2;
                            }
                        } catch (Exception e) {
                            System.debug('exception..................' + e);
                        }
                        System.debug('@@@@&&Testdebug'+c.status);
                        /* start of stopping nss survey functionality
                        System.debug('exception..................'+SendSur);
                        System.debug('exception..................'+OPTNPS);
                        //System.debug('exception..................'+ Daysbetween > 31);
                        if( SendSur && OPTNPS ) {
                        try{
                        System.debug('exception..................'+c+ ' '+con+' '+objUser);
                        SendSurvey(c,con,'AOGATS',objUser);
                        //c.P2C_sent__c=1;
                        }catch(exception e){
                        System.debug('exception..................'+e);
                        }
                        }
                        end of stopping nss survey functionality*/
                    }
                } else if (rej == 'True') {
                    Reject = true;
                    
                }
                if ((c.recordtype.name == 'AOG'|| c.recordtype.name == 'Exchange' ) && c.Emailbox_Origin__c != 'Email-crc-spex') {//added for AOG/Spex Case Record Type Split
                        AOG = True;
                }
                
                if((c.recordtype.name == 'AOG'|| c.recordtype.name == 'Exchange' ) && c.Emailbox_Origin__c == 'Email-crc-spex'){//added for AOG/Spex Case Record Type Split
                            SPEX_AOG = TRUE;
                } 
                // Added as partof RAPD-2702
                if(((c.recordtype.name == 'OEM Quotes Orders' && c.Emailbox_Origin__c == 'Email-BGAOEMQuoteOrders' ) || 
                (c.recordtype.name =='OEM/Spares') || 
                (c.recordtype.name=='Orders' && c.Emailbox_Origin__c == 'Email-Orders')) || ((c.recordtype.name =='OEM Quotes Orders') || (c.recordtype.name =='OEM/Spares') || (c.recordtype.name =='Orders') )  )
                {      
                System.debug('Testing 2702 OEM');          
                   OEMOrders = True;
                }
                
                if (c.recordtype.name == 'Technical Issue') {
                        ATS = True;
                }
        }

        //Pagereference pg=new Pagereference(c.NSS_Survey_Link__c);
        return null;
    }
    public void updateNoOfContacts() {
        setVariables();
        system.debug('called updateNoOfContacts');
        if (NoCon == null) {
            NOC = true;
        }
        system.debug('called NoCon ===>'+NoCon );
        system.debug('called NOC===>'+NOC);
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'NoOfContacts: '+NoCon));
        if (NoCon != null) {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'NoOfContacts: '+NoCon));
            
            if (NoOfContacts != null) {
                    c.No_of_Contacts_to_Resolve__c = NoOfContacts;
                } else {
                    c.No_of_Contacts_to_Resolve__c = NoCon;
                }
            }
            if (OverallSat != null) {
            c.Overall_sat__c = OverallSat;
            system.debug('@@@@OverallSat'+c.Overall_sat__c);
            }
            /*if (NpsRec != null) {
            c.NPS_Recommend__c = NpsRec;
            system.debug('@@@@NpsRec'+c.NPS_Recommend__c);
            }*/
            if (CesScore != null) {
            c.CES_Score__c = CesScore;
            system.debug('@@@@CesScore'+c.CES_Score__c);
            }
            if (FeedbackSurvey != null) {
            c.P2C_Survey_Comments__c = FeedbackSurvey;
            system.debug('@@@@c.P2C_Survey_Comments__c'+c.P2C_Survey_Comments__c);
            }
            c.Survey_Response__c = 1;
            c.status = 'Closed-Approved';
            c.Response_Date__c = system.today();
            NOC1 = false;
            confirm = true;
            confirmMessage = 'Thank you for your response.';
            System.debug('!!!!!!!case before update ' + c);
            try {
                system.debug('c====>'+c);
                update c;
                FeedbackSurvey = null;
            } catch (exception e) {}
            system.debug('@@@@outside@@@');
            try {
                if ((OverallSat != null && OverallSat <= 2) /*|| (NpsRec != null && NpsRec <= 6)*/ || (CesScore != null && CesScore <= 3)) {
                    system.debug('@@@@inside@@@');
                    Task newTask = new Task();
                    newTask.subject = 'Case Survey Follow-Up with Customer is Required';
                    newTask.whatId = c.Id;
                    if(String.isNotBlank(c.ownerid__r.managerid)) {
                    newTask.ownerId = c.ownerid__r.managerid;
                    }
                    else 
                    {
                    newTask.ownerId = c.ownerid__c;
                    }
                    newTask.status = 'Open';
                    newTask.Priority = 'Normal';
                    /*newTask.Description = 'Survey rating given by customer is very low:' +
                        ' Review the feedback, contact the case owner and take appropriate action.';*/
                    newTask.recordtypeid = label.Survey_followup_task;
                    newtask.whoid = c.contactid;
                    //insert  newTask;
                    Database.DMLOptions dmlOptions = new Database.DMLOptions();
                    //dmlOptions.EmailHeader.TriggerUserEmail = TRUE;
                    Database.Insert(newTask, dmlOptions);
                    tasklist.add(newTask);
                    system.debug('@@@@newtaskinsert@@@'+newTask.id);
                }
                
            } catch (exception e) {
                system.debug ('@@@@exception sendEmailUtils'+e);
            }
            
        //return null;
    }
    
    public void setVariables()
    {
        overallSatisfy = ApexPages.currentPage().getParameters().get('satisfyHidden2');
        extentStr = ApexPages.currentPage().getParameters().get('extentHidden2');
        timesStr = ApexPages.currentPage().getParameters().get('timesHidden2');
        //recommendStr = ApexPages.currentPage().getParameters().get('recommendHidden2');
        conNumStr = ApexPages.currentPage().getParameters().get('conNumHidden2');
        
        if(String.isNotBlank(overallSatisfy))
            setOverallSat(Integer.valueOf(overallSatisfy));
        
        if(String.isNotBlank(extentStr))
            setCesScore(Integer.valueOf(extentStr));
        
        if(String.isNotBlank(timesStr))
            setNoOfContacts(timesStr);
        
        //if(String.isNotBlank(recommendStr))
           // setNpsRec(Integer.valueOf(recommendStr));
        
        if(String.isNotBlank(conNumStr))
            setNoCon(conNumStr);
    }
    
    public void setRejectVariables()
    {
        caseopenAOG = ApexPages.currentPage().getParameters().get('paramforopenAOG');
        caseopenATS = ApexPages.currentPage().getParameters().get('paramforopenATS');
        phonecallAOG = ApexPages.currentPage().getParameters().get('phoneCallparamAOG');
        phonecallATS = ApexPages.currentPage().getParameters().get('phoneCallparamATS');
    }
    
    public pagereference updateRejectedrecord() {
        //case c = new case (id=caseid);
        setRejectVariables();
        EmailMessage message = new EmailMessage();
        message.toAddress = c.owner.email;
        message.FromAddress = c.contact.email;
        message.FromName = c.contact.name;
        message.MessageDate = datetime.now();
        message.subject = 'Propose to Close rejected by Customer';
        message.TextBody = 'Customer Rejected Case Closure with below comments.\n';
        if (AOG == true) {
            if (caseopenAOG == null) {
                COAOG = true;
            }
            if (phonecallAOG == null) {
                PCAOG = true;
            }
            c.rejection_reason__c = caseopenAOG;
            c.contactrequested__c = phonecallAOG;
            message.TextBody += 'Rejection Reason: ' + caseopenAOG + '\n';
            message.TextBody += 'Contact Requested: ' + phonecallAOG + '\n';
        }
        if (ATS == true ) {
            if (caseopenATS == null) {
                COATS = true;
            }
            if (phonecallATS == null) {
                PCATS = true;
            }
            c.rejection_reason__c = caseopenATS;
            c.contactrequested__c = phonecallATS;
            c.FCR__c = 'No';
            message.TextBody += 'Rejection Reason: ' + caseopenATS + '\n';
            message.TextBody += 'Contact Requested: ' + phonecallATS + '\n';
        }
        if (OEMOrders == true) {
            
            c.rejection_reason__c = caseopenAOG;
            c.contactrequested__c = phonecallAOG;
            message.TextBody += 'Rejection Reason: ' + caseopenAOG + '\n';
            message.TextBody += 'Contact Requested: ' + phonecallAOG + '\n';
        }
        if (comments == '') {
            cmts = true;
        }
        if ((phonecallAOG != null && caseopenAOG != null && comments != '')
             || (phonecallATS != null && caseopenATS != null && comments != '')) {
            c.rejection_comments__c = comments;
            message.TextBody += 'Comments: ' + comments;
            message.parentid = c.id;
            c.status = 'Open-Rejected';
            list < Case_on_hold_log__c > cohl = [select id from Case_on_hold_log__c where Hold_Stop__c = null and(case_number__c = : caseid)];
            list < Case_on_hold_log__c > cohl2 = new list < Case_on_hold_log__c > ();
            for (Case_on_hold_log__c cohl1: cohl) {
                cohl1.Hold_Stop__c = system.now();
                cohl2.add(cohl1);
            }
            Case_on_hold_log__c cohl3 = new Case_on_hold_log__c();
            cohl3.Case_Number__c = c.id;
            cohl3.Hold_Start__c = system.now();
            cohl3.Status__c = c.Status;
            try {
                update c;
            } catch (Exception e) {
                System.debug('exception..................' + e);
            }
            try {
                insert message;
            } catch (Exception e) {
                System.debug('exception..................' + e);
            }
            try {
                System.debug('exception..................' + cohl2);
                System.debug('exception..................' + cohl3);
                if (cohl2 != null) {
                    System.debug('exception..................' + cohl2);
                    update cohl2;
                }
                if (cohl3 != null) {
                    System.debug('exception..................' + cohl3);
                    insert cohl3;
                }
                if ((PhoneCallAOG != null && PhoneCallAOG.contains('Yes,')) || (PhoneCallATS != null && PhoneCallATS.contains('Yes,'))) {
                    confirm = true;
                    confirmMessage = 'We will keep this case open. Someone from support team will contact you.';
                }
                if ((PhoneCallAOG != null && PhoneCallAOG.contains('No,')) || (PhoneCallATS != null && PhoneCallATS.contains('No,'))) {
                    confirm = true;
                    confirmMessage = 'We will continue working the case and update you once we have further information.';
                }
            } catch (Exception e) {
                System.debug('exception..................' + e);
            }
            return null;
        } else {
            return null;
        }
    }

    public Pagereference cancel1() {
        cancel = true;
        return null;
    }
    public Pagereference cancel2() {
        NOC = false;
        NOC1 = false;
        confirm = true;
        confirmMessage = 'Thank you for your response.';
        return null;
    }
    /* start of stopping nss survey functionality
    public static void SendSurvey(Case new_c, Contact con, String strSurveyType,User objCaseOwner){
    //RecordType rt = [select Name from RecordType where Id = :new_c.RecordTypeId];
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
    m.put('&q20', new_c.recordtype.name);
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
    try{
    update con;
    }
    catch(Exception objExp){
    System.debug('Exception occured while saving contact in CreateSurveyURL trigger '+objExp);
    }
    // call asynchronous method to allow call out to create and pre-populate survey
    createSurvey(new_c.Id, strSurveyType, m);
    } 

    // use this static to prevent recursion. We set it to true before the
    // update call and it is checked by the trigger code. this will only stay
    // true for the context of the current apex transaction
    public static boolean updateFromFutureCall = false;

    // use this static to enable testing where criteria is unsettable due to
    // readonly fields e.g. Case.Service_Level__c
    public static boolean testing = false;

    static String AOGATS_url = 'https://app.clicktools.com/app/rest/addnewresponse?instance_id=2m8fqkkfodhy4';

    //changes for INC000006793729  end
     @ future(callout = true)
    public static void createSurvey(String caseId, String strSurveyType, Map < String, String > params) {

        String clicktools_url;
        System.debug('clicktools_url' + clicktools_url);

        if ('AOGATS' == strSurveyType) {
            clicktools_url = AOGATS_url;
        }

        for (String key: params.keySet()) {
            clicktools_url += '&' + key + '=' + urlStr(params.get(key));
        }
        HttpRequest req = new HttpRequest();
        req.setEndpoint(clicktools_url);
        req.setMethod('GET');

        Http http = new Http();
        HTTPResponse res;
        IF(!TEST.isRunningTest()) {
            res = http.send(req);
        }
        if (res != null && res.getStatusCode() == 200) {
            string uniqueURL = res.getBody();
            if('AOGATS'==strSurveyType){
            system.debug('%%%%%%%%%%%inside Case Close AOGATS');
            Case c = new Case(Id = caseId,NSS_Survey_Link__c = uniqueURL, Survey_Sent__c = 1,P2C_sent__c = 1, Survey_Type__c =strSurveyType);
            // set variable to prevent recursion
            updateFromFutureCall = true;
            update c;
            }
            else{
            Case c = new Case(Id = caseId, NSS_Survey_Link__c = uniqueURL, Survey_Sent__c = 1, Survey_Type__c = strSurveyType);
            // set variable to prevent recursion
            updateFromFutureCall = true;
            update c;
            //}
        }
    }
    static String urlStr(String s) {
        String r = '';
        if (s != null) {
            r = EncodingUtil.urlEncode(s, 'UTF-8');
        }
        return r;
    }
end of stopping nss survey functionality*/
    public boolean isDisabled {
        set;
        get;
    }

    public void disable() {
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'NoOfContacts: '+NoCon));
        if (NoCon == '1') {
            isDisabled = true;
        }
        if (NoCon == '2') {
            isDisabled = false;
        }
    }

}
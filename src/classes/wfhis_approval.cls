/*  * File Name: WorkFlowSearchController
* Description: To Approve a workflow approval history record.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* @author : wipro
* Modification Log ===============================================================
Ver Date Author Modification --- ---- ------ -------------*
*/
// Controller

public class wfhis_approval {
    public Id userID{get;set;}
    // collection of the user's id
    
    public Id profileID{get;set;}
    //collection of the profile id.
    
    public string id{get;set;}
    public string uid{get;set;}
    public wfhis_approval(ApexPages.StandardController controller) {
        WFRec = Apexpages.CurrentPage().getParameters().get('id');
        userID = UserInfo.getUserID();
        profileID = UserInfo.getProfileId();
        uid = string.valueof(userID).substring(0,15);
        id = string.valueof(profileID).substring(0,15);        
        if(WFRec != null)
            // Checking whether the WFRec is null or not.
            System.debug('****'+id);
        WFAppRec = [select Id,OwnerId,Name,Accepted__c,RejectedBy__c,Approval_Status__c,Workflow_details__r.Status__c,Comments__c,Actual_Approval_Rejection_Date__c,Declined__c from WorkFlow_Approval_History__c where Id =: WFRec];
    }
    public WorkFlow_Approval_History__c  WFAppRec;
    string WFRec=null;
    public String comments{get;set;}
    // collection of the comments. 
    
    // method invoked from the visual force page when the 'Submit' button is clicked.
    public Pagereference ok()
    {
        if(WFRec!=null)
        {        
            System.debug('****'+comments);
            {
                WFAppRec.Accepted__c=True;
                WFAppRec.Approval_Status__c='Approved';
                WFAppRec.Comments__c=comments;
                WFAppRec.Actual_Approval_Rejection_Date__c=system.today();
            }
            //Start SCTASK2265162 (Error warn on approving already rejected Egs)
            if(WFAppRec.Workflow_details__r.Status__c == 'Rejected' || WFAppRec.Approval_Status__c == 'No Action Needed')
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'This egs is rejected by ' +WFAppRec.RejectedBy__c+ ', so no action is required now.');
                ApexPages.addMessage(msg);
                return null;
            }
            //End SCTASK2265162 (Error warn on approving already rejected Egs)
            
            // Checking whether the comments field is empty. If the comments field is empty, a message is showed.           
            /*    if(comments == null || comments == ' ' || comments.length() == 0)
{  
ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Please Enter Comment');
ApexPages.addMessage(msg);
return null;
}
else
{*/
            // upserting the records of the workflow approval history.
            upsert WFAppRec;
            //  }
        }
        Pagereference pg=new Pagereference('/'+WFRec);
        pg.setRedirect(true);
        return pg; 
    }
    static testmethod void Testwfhis_accept(){
        Profile prf = [Select id from profile where name = 'System Administrator'];
        UserRole rl = [select id from userrole where name='GTO AM DS FSE 6A'];
        
        User usr =new User(EmployeeNumber='E123456',firstname='Test',lastname='test',
                           Username='dfdsf@fff.com', Email='akila.rajmahadev@nttdata.com', Alias='sdfsdf', CommunityNickname='sdfsd',
                           TimeZoneSidKey='America/Phoenix',LocaleSidKey='en_US',EmailEncodingKey='UTF-8',LanguageLocaleKey='en_US',           
                           ProfileId=prf.id,userroleid=rl.id);         
        insert usr;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs ( thisUser ) {       
            Test.StartTest();
            Platform__c PLFrec= new Platform__c();
            PLFrec.name='PLF_Test_rec';
            insert PLFrec;
            
            Account AccRec = new Account();
            AccRec.name='Acc_Text_rec';
            AccRec.Type='OEM';
            AccRec.Strategic_Business_Unit__c='ATR';
            AccRec.CBT__c='Airbus';
            AccRec.Customer_Status__c='Active';
            AccRec.Region_Name__c='Americas';
            AccRec.Sub_Region_Name__c='Canada';
            AccRec.Service_Level__c='Standard';
            
            insert AccRec;
            
            Approver__c APPRec_CA= new Approver__c();
            APPRec_CA.name='Test_App_rec';
            APPRec_CA.Approver_Name__c=usr.id;
            APPRec_CA.Business_Unit__c='ATR';
            APPRec_CA.Region__c='Americas';
            APPRec_CA.Tier__c='Aero Tier 0';
            APPRec_CA.Approver_type__c='Contract Approver';
            
            insert APPRec_CA;
            Workflow_details__c wfDetailTest = new Workflow_details__c(Status__c = 'In Progress');
            insert wfDetailTest ;
            WorkFlow_Approval_History__c tstWfAppHstry = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
            
            insert tstWfAppHstry;
            
            WorkFlow_Approval_History__c tstWfAppHstry1 = new WorkFlow_Approval_History__c(Approver__c='Test Approver',Workflow_details__c=wfDetailTest.Id,Approval_Status__c='Pending Approval',CreatedDate=system.today()-1,Reminder__c = 'Manual',Select_Approver__c=APPRec_CA.id);
            insert tstWfAppHstry1;
            test.stoptest();
            ApexPages.CurrentPage().getParameters().Put('id',tstWfAppHstry.id);
            ApexPages.StandardController std = new ApexPages.StandardController(tstWfAppHstry);
            wfhis_approval test1 = new wfhis_approval(std);
            test1.comments = 'Test';
            test1.ok();
            
            ApexPages.CurrentPage().getParameters().Put('id',tstWfAppHstry1.id);
            ApexPages.StandardController std1 = new ApexPages.StandardController(tstWfAppHstry1);
            wfhis_approval test2 = new wfhis_approval(std1);
            test2.ok();
        } 
    }
}
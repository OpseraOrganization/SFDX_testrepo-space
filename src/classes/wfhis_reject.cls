/*  * File Name: WorkFlowSearchController
* Description: To Reject a workflow approval history record.
* Copyright : Wipro Technologies Limited Copyright (c) 2010
* @author : wipro
* Modification Log ===============================================================
Ver Date Author Modification --- ---- ------ -------------*
*/
// Controller
public class wfhis_reject {
    public Id userID{get;set;}
    public string UID{get;set;}
    // collection of the user's id.
    
    public Id profileID{get;set;}
    //collection of the profile id.
    
    public string id{get;set;}
    public wfhis_reject(ApexPages.StandardController controller) {
        WFRec = Apexpages.CurrentPage().getParameters().get('id');
        userID = UserInfo.getUserID();
        UID = string.valueof(userID).substring(0,15);
        profileID = UserInfo.getProfileId(); 
        id = string.valueof(profileID).substring(0,15);        
        // Checking whether the WFRec is null or not.
        if(WFRec != null)
            System.debug('****'+id);
        WFAppRec = [select Id,OwnerId,Name,Workflow_details__r.Status__c,RejectedBy__c,Accepted__c,Approval_Status__c,Comments__c,Actual_Approval_Rejection_Date__c,Declined__c from WorkFlow_Approval_History__c where Id =: WFRec];
    }
    
    public WorkFlow_Approval_History__c  WFAppRec;
    string WFRec=null;
    public String comments{get;set;} 
    // collection of the comments
    
    // method invoked from the visual force page when the 'Submit' button is clicked.
    public Pagereference ok()
    {
        if(WFRec!=null)
        {            
            System.debug('****'+comments);
            {
                WFAppRec.Declined__c=True;
                WFAppRec.Approval_Status__c='Rejected';
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
            // Checking whether the comments field is empty. If the comments field is empty a message is showed.           
            if(comments == null || comments == ' ' || comments.length() == 0)
            {  
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Please Enter Comment');
                ApexPages.addMessage(msg);
                return null;
            }
            else
            {
                // upserting the records of the workflow approval history.
                upsert WFAppRec;
            }
        }
        Pagereference pg=new Pagereference('/'+WFRec);
        pg.setRedirect(true);
        return pg; 
    }
    static testmethod void Testwfhis_reject(){
        
        Profile pf= [select id from Profile where name = 'System Administrator'];
        User usr = new User(LastName = 'Test UserEgreen',Username = 'tu1egreen@test.com',Email = 'testuser@test.com',Alias = 'tu1' ,
                            CommunityNickname= 'tu1cso' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
                            ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
        insert usr;
        test.starttest();
        Approver__c APPRec_BA= new Approver__c();
        APPRec_BA.name='Test_App_rec';
        APPRec_BA.Approver_Name__c=usr.id;
        APPRec_BA.Business_Unit__c='BGA';
        APPRec_BA.Region__c='Americas';
        APPRec_BA.Tier__c='Aero Tier 0';
        APPRec_BA.Approver_type__c='Business Approver';
        
        insert APPRec_BA;
        
        Approver__c APPRec_CA= new Approver__c();
        APPRec_CA.name='Test_App_rec';
        APPRec_CA.Approver_Name__c=usr.id;
        APPRec_CA.Business_Unit__c='BGA';
        APPRec_CA.Region__c='Americas';
        APPRec_CA.Tier__c='Aero Tier 0';
        APPRec_CA.Approver_type__c='Contract Approver';
        
        insert APPRec_CA;
        
        
        Workflow_details__c wd = new Workflow_details__c();
        insert wd;
        
        Workflow_details__c wd1 = new Workflow_details__c();
        insert wd1;
        
        WorkFlow_Approval_History__c w= new WorkFlow_Approval_History__c();
        w.Workflow_details__c=wd.id;
        w.Select_Approver__c=APPRec_BA.id;
        insert w;
        
        WorkFlow_Approval_History__c w1= new WorkFlow_Approval_History__c();
        w1.Workflow_details__c=wd1.id;
        w.Select_Approver__c=APPRec_CA.id;
        insert w1;
        test.stoptest();
        ApexPages.CurrentPage().getParameters().Put('id',w.id);
        ApexPages.StandardController std = new ApexPages.StandardController(w);
        wfhis_reject test1 = new wfhis_reject(std);
        test1.comments = 'Test';
        test1.ok();
        
        ApexPages.CurrentPage().getParameters().Put('id',w1.id);
        ApexPages.StandardController std1 = new ApexPages.StandardController(w1);
        wfhis_reject test2 = new wfhis_reject(std1);
        test2.ok();
    }
}
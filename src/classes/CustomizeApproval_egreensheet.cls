/* This class is used in the site home page.this will save the comment entered in the page
and also update the status value to Approved or Reject */


public class CustomizeApproval_egreensheet
{
    public String inputText1{get;set;}
    public CustomizeApproval_egreensheet(ApexPages.StandardController controller) 
    {
        //fetching the values which are in the url
        
        WFaccept=ApexPages.currentPage().getParameters().get('WFAccepted');
        WFdecline=ApexPages.currentPage().getParameters().get('WFRejected');
        WFRec=ApexPages.currentPage().getParameters().get('WFAppRec');
        
        
        //querying workflow approval history record with passed id
        if( WFRec !=null)
        {
            WFAppRec=[Select Comments__c,Approval_Status__c,Workflow_details__r.Status__c,Accepted__c,RejectedBy__c,Declined__c from WorkFlow_Approval_History__c where id=:WFRec];
            WFAppRec1=[Select Comments__c,Approval_Status__c,Workflow_details__r.Status__c,Accepted__c,RejectedBy__c,Declined__c from WorkFlow_Approval_History__c where id=:WFRec];
        }
    }
    
    //variable declartion
    
    WorkFlow_Approval_History__c  WFAppRec;
    WorkFlow_Approval_History__c  WFAppRec1;
    
    
    String WFaccept=null;
    string WFdecline=null;
    string WFRec=null;
    
    public WorkFlow_Approval_History__c getWFAppRec1()
    {
        return WFAppRec1;
    }
    
    public void setWFAppRec1()
    {
        this.WFAppRec=WFAppRec1;
    }
    //update status and comment field
    public Pagereference ok()
    {
        
        if(WFRec!=null)
        {
            //Start SCTASK2265162 (Error warn on approving already rejected Egs)
            if(WFAppRec1.Workflow_details__r.Status__c == 'Rejected' || WFAppRec1.Approval_Status__c == 'No Action Needed')
            {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'This egs is rejected by '+WFAppRec1.RejectedBy__c+', so no action is required now.');
                ApexPages.addMessage(msg);
                return null;
            }
            //End SCTASK2265162 (Error warn on approving already rejected Egs)
            
            if(WFaccept=='True')
            {
                WFAppRec.Accepted__c=True;
                WFAppRec.Approval_Status__c='Approved';
                WFAppRec.Comments__c=inputText1;
                WFAppRec.Actual_Approval_Rejection_Date__c=system.today();
            }
            else if(WFdecline=='True')
            {
                WFAppRec.Declined__c=True;
                WFAppRec.Approval_Status__c='Rejected';
                WFAppRec.Comments__c=inputText1;
                WFAppRec.Actual_Approval_Rejection_Date__c=system.today();
            }
            
            if(WFdecline=='True' && inputText1=='')
            {  
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Info,'Please Enter Comment');
                ApexPages.addMessage(msg);
                return null;
            }
            else
            {
                
                upsert WFAppRec;
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.Info,'Thanks for your response');
                ApexPages.addMessage(msg1);
                
                //pg.setRedirect(true);
                
            }
        }
        Pagereference pg=new Pagereference('/apex/CustomizeApproval_eGreensheet');
        pg.setRedirect(true);
        return pg; 
        
    }
    
    
}
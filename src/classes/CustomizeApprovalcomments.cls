public class CustomizeApprovalcomments{

   String App,Rej,RecordId,CampaignRecord;
    Campaign_Gate_Approval_History__c campapprec;
    Opportunity_Gate_Approval_History__c apprec;
 public CustomizeApprovalcomments()
   {
      App=ApexPages.currentPage().getParameters().get('Accept');
      Rej=ApexPages.currentPage().getParameters().get('Reject');
      RecordId=ApexPages.currentPage().getParameters().get('Record');
      CampaignRecord=ApexPages.currentPage().getParameters().get('CampaignRecord');
       if(RecordId!=null)
       {
        apprec=[Select Approval_Status__c from Opportunity_Gate_Approval_History__c where id=:RecordId];
       }
       if(CampaignRecord!=null)
       {
        campapprec=[Select Approval_Status__c from Campaign_Gate_Approval_History__c where id=:CampaignRecord];
        system.debug('campapprec -- > '+campapprec);
       }
   }
   public Pagereference ok(){
   system.debug('App -- > '+App);
      if(App=='True')
      {
        if(RecordId!=null)
        {
        apprec.comments__c = comments;
        apprec.Approval_Status__c='Approved';
        update apprec;
        }
        if(CampaignRecord!=null)
        {
         campapprec.comments__c = comments;
        campapprec.Approval_Status__c='Approved';
         }
      }
      else if(Rej=='True')
       {
        if(RecordId!=null)
        {
        apprec.comments__c = comments;
        apprec.Approval_Status__c='Rejected';
        }
        if(CampaignRecord!=null)
        {
        campapprec.Approval_Status__c='Rejected';
        campapprec.comments__c = comments;
        }
      }  
    if(RecordId!=null)
     update apprec;
      if(CampaignRecord!=null)
       update campapprec;
   Pagereference pg=new Pagereference('/apex/CustomizeApproval');
    return pg;
    }
    public string comments;
   public string getcomments()
   {
   return comments;
   }
   public void setcomments(string comments)
   {
  this.comments = comments;
   }
}
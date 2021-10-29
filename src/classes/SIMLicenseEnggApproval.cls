public class SIMLicenseEnggApproval{

    String App,RecordId;
    Opportunity opp;
    Date today1 = date.valueof(system.today());
    public boolean approvelink{get;set;}
    public boolean sucessmessage{get;set;}
    public boolean sucessmessage1{get;set;}     
    public SIMLicenseEnggApproval()
    {
        App=ApexPages.currentPage().getParameters().get('review');
        RecordId=ApexPages.currentPage().getParameters().get('Oppid');
        approvelink=true;
        sucessmessage=false;
        system.debug('App------>'+App);
        system.debug('RecordId------>'+RecordId);
        if(RecordId!=null)
        {
            system.debug('insideRecordId------>'+RecordId);
            opp=[Select id,name,Account_manager_review__c,Engg_Review_Comments__c,Accountt_Manager_Review_Comments__c,Account_manager_review_Date__c,Final_Review__c,License_Review__c,Engineer_Manager_Review__c,Engineer_Manager_Review_Date__c from Opportunity where id=:RecordId];
            system.debug('opp------>'+opp);
        }       
    }
    public Pagereference Approve(){
        system.debug('App -- > '+App);
        system.debug('App -- > '+RecordId);
        if(App != null && RecordId!=null)
        {
            system.debug('insideApp -- > '+App);
            if(App == 'engapprove')
            {
                opp.Engineer_Manager_Review__c = true;
                opp.Engineer_Manager_Review_Date__c=today1;
                if(opp.Engg_Review_Comments__c != null)
                //opp.Engg_Review_Comments__c +='\n'+comments;
                opp.Engg_Review_Comments__c = comments +'\n'+opp.Engg_Review_Comments__c;
                else
                opp.Engg_Review_Comments__c =comments;
                system.debug('insideopp -- > '+opp.Account_manager_review_Date__c);
                update opp;
                approvelink=false;
                sucessmessage=true;
            }
            if(App == 'mngapprove')
            {
                opp.Account_manager_review__c = true;
                opp.Account_manager_review_Date__c=today1;               
                if(opp.Accountt_Manager_Review_Comments__c != null)
                //opp.Accountt_Manager_Review_Comments__c +='\n'+comments;
                opp.Accountt_Manager_Review_Comments__c =comments+'\n'+opp.Accountt_Manager_Review_Comments__c;
                else
                opp.Accountt_Manager_Review_Comments__c =comments;
                system.debug('insideopp -- > '+opp.Account_manager_review_Date__c);
                update opp;
                approvelink=false;
                sucessmessage1=true;
            }
        }
        Pagereference pg=new Pagereference('/apex/AppendixEngApprove?oppid='+RecordId+'&review='+App);
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
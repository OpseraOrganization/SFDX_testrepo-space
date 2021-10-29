public class RedirecttoSchedule
{
    private final Opportunity opp;
    public list<OpportunityLineItem>OpportunityLineItemlist {get;set;}
    public string opplineid{get;set;}
    public Id oppid{get;set;}
    public Opportunity opplist{get;set;}
    public Boolean closedatechange{get;set;}
    public Boolean popvariable{get;set;}
    public redirecttoschedule(ApexPages.StandardController stdController )
    {
        oppid=stdController.getId();
        this.opp=[select id,Close_date_changed__c from opportunity where id=:oppid];
        closedatechange=opp.Close_date_changed__c;
        OpportunityLineItemlist =[select id,OpportunityId, Revenue_Start_Date__c from OpportunityLineItem where OpportunityId=:opp.id and Revenue_Start_Date__c != null order by createddate desc limit 1];
        if(OpportunityLineItemlist.size()>0)
         opplineid=OpportunityLineItemlist[0].Id;
        //popvariable=false;
    }
    public void updatesave()
    {
       system.debug('inside update********');
       opp.Close_date_changed__c=false;
       Update opp;
       popvariable=true;
    }
}
public class RedirectToProductPage {
opportunity opp=new opportunity();
list<OpportunityLineItem >opplinelist=new list<OpportunityLineItem>();
public string opplineid{get;set;}
public boolean iscreated{get;set;}
Id oppid;

    public RedirectToProductPage(ApexPages.StandardController controller) 
    {
       this.opp= (opportunity)controller.getRecord();
       oppid=opp.id;
        opp=[select id,Is_Product_Created__c from opportunity where id =:oppid];
        iscreated=opp.Is_Product_Created__c;
        if(iscreated==true)
        {
        	opplinelist=[select id from OpportunityLineItem  where OpportunityId=:oppid order by createddate Desc limit 1];
            opplineid=opplinelist[0].Id;
        }
        
    }
    public void productredirect()
    {
       if(opp.Is_Product_Created__c==true)
       {
        opp.Is_Product_Created__c=false;
        update opp;
        system.debug('opplineid**********'+opplineid);
      /** PageReference pageRef = new PageReference('https://cs15.salesforce.com/'+opplineid);
        pageRef.setRedirect(true);
       system.debug('opplineid**********'+pageRef);
       return pageRef ;**/
        }
      
    }

}
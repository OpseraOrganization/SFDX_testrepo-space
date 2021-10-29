public class AgentContributionArticleController {
    public AgentContributionArticleController() {}
   /* public void AgentContributionArticleController(){
        system.debug('constructor');
    }*/
    // The constructor must take a ApexPages.KnowledgeArticleVersionStandardController as an argument
   /* public AgentContributionArticleController(ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();   //this is the SObject for the new article. 
                                             //It can optionally be cast to the proper article type, e.g. FAQ__kav article = (FAQ__kav) ctl.getRecord();
        
        String sourceId = ctl.getSourceId(); //this returns the id of the case that was closed.
        Case c = [select subject, aircraft_type__c, sw_version__c,Phase_of_flight__c,supported_products__c,fault_messages__c,fde_event__c,Product_Part_Number__c from Case where id=:sourceId];
        
        article.put('title', c.subject);  //this overrides the default behavior of pre-filling the title of the article with the subject of the closed case. 
        article.put('AC_Type__c',c.aircraft_type__c);  
        article.put('Supported_Products__c',c.Supported_Products__c);  
        article.put('sw_version__c',c.sw_version__c);  
        article.put('Phase_of_flight__c',c.Phase_of_flight__c);  
        article.put('fault_messages__c',c.fault_messages__c);  
        article.put('fde_event__c',c.fde_event__c);  
        article.put('pn__c',c.Product_Part_Number__c);
        //article.put('Details__c',c.description);  
        
        //ctl.selectDataCategory('Geography','USA');  //Only one category per category group can be specified.
        //ctl.selectDataCategory('Topics','Maintenance');                        
    }*/
}
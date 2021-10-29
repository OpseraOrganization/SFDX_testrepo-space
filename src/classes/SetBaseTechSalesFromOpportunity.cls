/**
 * Created by Nikolay Kolev on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 * @description Used in the tech sales builder factory for the OLI triggers.
 */

public class SetBaseTechSalesFromOpportunity implements TechSalesSettable {
    private OpportunityLineItem lineItem;
    private Opportunity opportunity;
    private Map<String, Id> users;

    public SetBaseTechSalesFromOpportunity(OpportunityLineItem lineItem, Opportunity opportunity, Map<String, Id> users) {
        this.lineItem = lineItem;
        this.opportunity = opportunity;
        this.users = users;
    }

    /**
     * @param lineItem Corresponds to the line item which tech sales will be updated.
     * @param opportunity Corresponds to the opportunity object which data will be used to populate
     * the line item's tech sales.
     */
    public void setTechSales() {
        lineItem.Tech_Sales__c = opportunity.Tech_Sales__c;
        lineItem.Tech_Sales_Product__c = opportunity.Tech_Sales_Product_Area__c;
        lineItem.Tech_Sales_Manager__c = users.get(opportunity.Tech_Sales1__c);
        lineItem.OpportunityAccountChange__c = false;
    }
}
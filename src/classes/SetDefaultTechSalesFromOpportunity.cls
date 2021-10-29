/**
 * Created by Nikolay Kolev on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 * @description Used in the tech sales builder factory for the OLI triggers.
 */

public class SetDefaultTechSalesFromOpportunity implements TechSalesSettable {
    private OpportunityLineItem lineItem;
    private Opportunity opportunity;

    public SetDefaultTechSalesFromOpportunity(OpportunityLineItem lineItem, Opportunity opportunity) {
        this.lineItem = lineItem;
        this.opportunity = opportunity;
    }
    /**
     * @param lineItem Corresponds to the line item which tech sales will be updated.
     * @param opportunity Corresponds to the opportunity object which data will be used to populate
     * the line item's tech sales.
     */
    public void setTechSales() {
        lineItem.Tech_Sales__c = opportunity.Default_Tech_Sales__c;
        lineItem.Tech_Sales_Product__c = opportunity.Default_Tech_Sales_Product__c;
        lineItem.Tech_Sales_Manager__c = opportunity.Default_Tech_Sales_Manager__c;
        lineItem.OpportunityAccountChange__c = false;
    }
}
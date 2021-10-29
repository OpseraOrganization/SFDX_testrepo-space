/**
 * Created by Nikolay Kolev on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 * @description Used in the tech sales builder factory for the OLI triggers.
 */

public class SetTechSalesFromProductLineTechSale implements TechSalesSettable {

    private OpportunityLineItem lineItem;
    private Product_Line_Tech_Sales__c productLineTechSale;

    public SetTechSalesFromProductLineTechSale(OpportunityLineItem lineItem, Product_Line_Tech_Sales__c productLineTechSale) {
        this.lineItem = lineItem;
        this.productLineTechSale = productLineTechSale;
    }

    /**
     * @param lineItem Corresponds to the line item which tech sales will be updated.
     * @param productLineTechSale Corresponds to the product line tech sales object which data will be used to populate
     * the line item's tech sales.
     */
    public void setTechSales() {
        lineItem.Tech_Sales__c = productLineTechSale.Tech_Sales__c;
        lineItem.Tech_Sales_Product__c = productLineTechSale.Tech_Sales_Product__c;
        lineItem.Tech_Sales_Manager__c = productLineTechSale.Tech_Sales_Manager__c;
        lineItem.OpportunityAccountChange__c = false;
    }
}
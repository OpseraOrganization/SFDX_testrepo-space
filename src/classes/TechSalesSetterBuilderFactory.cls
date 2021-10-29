/**
 * Created by Nikolay Kolev on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TechSalesSetterBuilderFactory {
    // Will return the correct setter implementation based on different criteria.
    public static TechSalesSettable getTechSalesSetter(
            Opportunity opportunity,
            OpportunityLineItem lineItem,
            Map<Integer, Product_Line_Tech_Sales__c> productLineTechSales,
            Map<String, Id> userMap
    ) {
        /**
         * Default tech sales fields hold manually populated values related to exceptions/deviations of the
         * standard logic that usually gets applied to the tech sales fields on opportunity line item.
         */
        if (opportunity.Default_Tech_Sales__c != null || opportunity.Default_Tech_Sales_Product__c != null) {
            return new SetDefaultTechSalesFromOpportunity(lineItem, opportunity);
        /**
         * If there were no default tech sales on Opportunity then try to assign from the product line tech sales.
         */
        } else {
            // Builds a hashKey based on the three values provided by the lineItem.
            TechSalesHashBuilder lineItemHash = new TechSalesHashBuilder()
                    .setName(lineItem.Tech_Sales_Product_Line__c)
                    .setSbu(lineItem.SBU__c)
                    .setRegion(lineItem.Tech_Sales_Region__c)
                    .setCountry(lineItem.Tech_Sales_Country__c);
            // Try matching the line item to product line tech sales by matching on all criteria.
            if (productLineTechSales.containsKey(lineItemHash.getHash(TechSalesHashBuilder.Criteria.ALL))) {
                return new SetTechSalesFromProductLineTechSale(
                        lineItem,
                        productLineTechSales.get(lineItemHash.getHash(TechSalesHashBuilder.Criteria.ALL))
                );
                // Try without country.
            } else if (productLineTechSales.containsKey(lineItemHash.getHash(TechSalesHashBuilder.Criteria.NO_COUNTRY))) {
                return new SetTechSalesFromProductLineTechSale(
                        lineItem,
                        productLineTechSales.get(lineItemHash.getHash(TechSalesHashBuilder.Criteria.NO_COUNTRY))
                );
                /**
                 * If no product line tech sale matched the criteria then pull from opportunity.
                 */
            } else {
                return new SetBaseTechSalesFromOpportunity(
                        lineItem,
                        opportunity,
                        userMap
                );
            }
        }
    }
}
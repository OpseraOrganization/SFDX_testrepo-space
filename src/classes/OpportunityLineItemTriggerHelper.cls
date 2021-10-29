/**
 * Created by SatyaMohanty on 3/26/2019.
 * OWNED BY THE CRM SALES TEAM.
 * @description Used a support class for the OLI(Opportunity Line Item) triggers.
 */

public class OpportunityLineItemTriggerHelper {

    /**
     * @description Used to retrieve the Product Line object. The cross ref Id takes precedence because
     * it's a required field on the page layout.
     * @param productLineCrossRefIds - Ids of the lookup relationship on OLI related to Product_Line_Tech_Sales__c.
     * @param productLineIds - Ids of the lookup relationship on OLI related to Product_Line__c
     *
     * @return Map of Id of the product line object to the object itself. If both Sets of ids are mepty then return an
     * empty map and don't query for anything.
     */
    public static Map<Id, Product_Line__c> getProductLines(Set<Id> productLineCrossRefIds, Set<Id> productLineIds) {
        // Using a string to dynamically populate the query for the product line.
        String productLineQuery =
                        'SELECT ' +
                                'Id, ' +
                                'Name, ' +
                                '(' +
                                    'SELECT ' +
                                            'CBT__c, ' +
                                            'SBU__c, ' +
                                            'Tech_Sales__c, ' +
                                            'Tech_Sales_Product__c, ' +
                                            'Product_Type__c, ' +
                                            'Tech_Sales_Manager__r.Name, ' +
                                            'Tech_Sales_Manager__c, ' +
                                            'Product_Line__c, ' +
                                            'Region__c, ' +
                                            'Country__c ' +
                                    'FROM Product_Line_Tech_Sales__r ' +
                                '), ' +
                                '(' +
                                    'SELECT ' +
                                            'Id, ' +
                                            'Name, ' +
                                            'Product_Line__c ' +
                                    'FROM Product_Line_Cross_Ref__r ' +
                                ') ' +
                        'FROM Product_Line__c ';

        // If there's productLineCrossRefIds available use those to query for the product lines.
        if (!productLineCrossRefIds.isEmpty()) {
            productLineQuery += 'WHERE Id IN (' +
                                    'SELECT Product_Line__c ' +
                                    'FROM Product_Line_Cross_Ref__c ' +
                                    'WHERE Id IN: productLineCrossRefIds' +
                                  ')';
        // If the productLineCrossRefIds try to use the productLineIds to pull the product lines.
        } else if (!productLineIds.isEmpty()) {
            productLineQuery += 'WHERE Id IN: productLineIds';
        // If there's no productLineCrossRefIds and no productLineIds then return an empty map.
        } else {
            return new Map<Id, Product_Line__c>();
        }
        return new Map<Id, Product_Line__c> (
                (List<Product_Line__c>)Database.query(productLineQuery)
        );
    }
    /**
     * @param usernames The usernames of the Tech Sales people. Comes from Opportunity.Tech_Sales1__c.
     * @return Map of Name to the Id of the user.
     */
    public static List<user> m = [SELECT Id, Name FROM User WHERE IsPortalEnabled = FALSE AND IsActive =TRUE];
    public static Map<String, Id> getUserMap(Set<String> userNames) {
        Map<String, Id> userMap = new Map<String, Id>();        
        if (userNames.size() > 0) {
            //List<user> urs = [SELECT Id, Name FROM User WHERE Name IN :userNames AND IsPortalEnabled = FALSE AND IsActive =TRUE];
            for (User user : m){
                for(String st : userNames){
                    if(user.Name == st){
                        userMap.put(user.Name, user.Id);
                    }
                }
            }
        }
        return userMap;
    }
    /**
     * @param productIds Product2 Ids.
     * @return Map of Rmu Product Id to Rmu Id.
     */
    public static Map<Id, Id> getProductRmuIdToRmuValueId(Set<Id> productIds) {
        Map<Id, Id> productRmuIdToRmuValueId = new Map<Id, Id>();
        for (RMU_Product__c rmuProduct : [
                SELECT
                        RMU__c,
                        RMU_Product__c
                FROM RMU_Product__c
                WHERE RMU_Product__c IN :productIds
        ]) {
            productRmuIdToRmuValueId.put(rmuProduct.RMU_Product__c, rmuProduct.RMU__c);
        }
        return productRmuIdToRmuValueId;
    }
    /**
     * @param platformIds Ids corresponding to Platform__c
     * @return Map of Rmu_Value__c Id to a List of OFFERING_MAPPER__c.
     */
    public static Map<Id, List<OFFERING_MAPPER__c>> getRmuValueToOfferingMappers(Set<Id> platformIds) {
        Map<Id, List<OFFERING_MAPPER__c>> rmuValueToOfferingMappers = new Map<Id, List<OFFERING_MAPPER__c>>();
        for (OFFERING_MAPPER__c offeringMapper : [
                SELECT
                        Id,
                        RMU_VALUE__c,
                        Name,
                        Aircraft_Platform__c
                FROM OFFERING_MAPPER__c
                WHERE Aircraft_Platform__c IN :platformIds
        ]) {
            List<OFFERING_MAPPER__c> mapperList = new List<OFFERING_MAPPER__c>();
            mapperList.add(offeringMapper);
            if (rmuValueToOfferingMappers.get(offeringMapper.RMU_VALUE__c) == null) {
                rmuValueToOfferingMappers.put(offeringMapper.RMU_VALUE__c, mapperList);
            } else {
                rmuValueToOfferingMappers.get(offeringMapper.RMU_VALUE__c).addAll(mapperList);
            }
        }
        return rmuValueToOfferingMappers;
    }
    /**
     * @param opportunityIds the ids of the parent opportunities associated with the OLIs.
     * @return a Map of the parent opportunities.
     */
    public static Map<Id, Opportunity> getOpportunities(Set<Id> opportunityIds) {
        return new Map<Id, Opportunity> ([
                SELECT
                        Id,
                        Aircraft_Ref__r.Platform_Name__c,
                        Combined_Probability__c,
                        StageName,
                        ATR_Probability__c,
                        Program_Go_Probability__c,
                        Is_Product_Created__c,
                        Default_Tech_Sales__c,
                        Default_Tech_Sales_Product__c,
                        Default_Tech_Sales_Manager__c,
                        Tech_Sales__c,
                        Tech_Sales_Product_Area__c,
                        Tech_Sales1__c
                FROM Opportunity
                WHERE Id = :opportunityIds
        ]);
    }
    /**
     * @description Verifies if the user that triggered the process has an "admin" profile or not.
     * @return Boolean based on if the user has the "admin" profile.
     */
    public static Boolean isUserAnAdmin() {
        Set<Id> adminIds = new Set<Id> {
                Label.Honeywell_System_Administrator_US_Label,
                Label.Honeywell_System_Administrator_Label,
                Label.D_S_Sales_Spiral_API_User_Label,
                Label.D_S_Sales_API_User_Label,
                Label.DFS_API_User_Label,
                Label.Honeywell_System_Administrator_Non_US
        };
    
        //DS Sales Admin List is a custom setting that contains Ids of admin profiles
        for (DS_Sales_Adminlist__c adminSetting: DS_Sales_Adminlist__c.getAll().values()) {
            adminIds.add(adminSetting.D_S_Admin_ProfileId__c);
        }

        // TODO: Dangerous practice.
        Id profileId = UserInfo.getProfileId().substring(0, 15);

        return adminIds.contains(profileId);
    }
    public static Boolean is_D_S_API_User() {
    Set<Id> apiUserIds = new Set<Id> {
        Label.D_S_Sales_Spiral_API_User_Label,
        Label.D_S_Sales_API_User_Label,
        Label.DFS_API_User_Label
    };

    Id profileId = UserInfo.getProfileId().substring(0, 15);

    return apiUserIds.contains(profileId);
    }
}
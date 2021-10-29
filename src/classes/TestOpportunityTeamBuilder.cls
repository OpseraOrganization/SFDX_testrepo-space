/**
 * Created by Satya Mohanty on 4/25/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestOpportunityTeamBuilder {

    private String name = 'testOpportunityTeam';
    private Id opportunityId;
    private Id userId;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestOpportunityTeamBuilder() {}

    public TestOpportunityTeamBuilder setOpportunityId(Id opportunityId){
        this.opportunityId = opportunityId;

        return this;
    }
    public TestOpportunityTeamBuilder setUserId(Id userId) {
        this.userId = userId;

        return this;
    }
    public TestOpportunityTeamBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Opportunity_Sales_Team__c build() {
        Opportunity_Sales_Team__c opportunityTeam = new Opportunity_Sales_Team__c();
        opportunityTeam.User__c = userId;
        opportunityTeam.Opportunity__c = opportunityId;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            opportunityTeam.put(field, value);
        }
        return opportunityTeam;
    }
    public Opportunity_Sales_Team__c generate() {
        Opportunity_Sales_Team__c opportunityTeam = build();
        Database.insert(opportunityTeam);
        return opportunityTeam;
    }
}
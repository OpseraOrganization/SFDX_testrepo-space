/**
 * Created by Satya Mohanty on 4/19/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestOpportunityLineItemScheduleBuilder {

    private Id opportunityLineItemId;
    private Integer revenue  = 10;
    private String type = 'Revenue';
    private Date scheduledDate = Date.today().addDays(30);
    private Map<String, Object> fields = new Map<String, Object>();

    public TestOpportunityLineItemScheduleBuilder() {}

    public TestOpportunityLineItemScheduleBuilder setOpportunityLineItemId(Id opportunityLineItemId){
        this.opportunityLineItemId = opportunityLineItemId;

        return this;
    }
    public TestOpportunityLineItemScheduleBuilder setRevenue(Integer revenue){
        this.revenue = revenue;

        return this;
    }
    public TestOpportunityLineItemScheduleBuilder setType(String type){
        this.type = type;

        return this;
    }
    public TestOpportunityLineItemScheduleBuilder setScheduledDate(Date scheduledDate){
        this.scheduledDate = scheduledDate;

        return this;
    }
    public TestOpportunityLineItemScheduleBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public OpportunityLineItemSchedule build() {
        OpportunityLineItemSchedule lineItemSchedule = new OpportunityLineItemSchedule();
        lineItemSchedule.Revenue = Revenue;
        lineItemSchedule.OpportunityLineItemId = opportunityLineItemId;
        lineItemSchedule.Type = type;
        lineItemSchedule.ScheduleDate = scheduledDate;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            lineItemSchedule.put(field, value);
        }

        return lineItemSchedule;
    }
    public OpportunityLineItemSchedule generate() {
        OpportunityLineItemSchedule lineItemSchedule = build();
        Database.insert(lineItemSchedule);
        return lineItemSchedule;
    }
}
/**
 * Created by Satya Mohanty on 4/9/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestOpportunityLineItemBuilder {


    private Date serviceDate = Date.today().addDays(30);
    private Id productCrossReferenceId;
    private Id opportunityId;
    private Integer unitPrice = 100;
    private Integer quantity = 1;
    private String type = 'Forecast';
    private Id pricebookEntryId;
    private Map<String,Object> fields = new Map<String, Object>();

    public TestOpportunityLineItemBuilder() {}

    public TestOpportunityLineItemBuilder setServiceDate(Date ServiceDate){
        this.serviceDate = ServiceDate;

        return this;
    }
    public TestOpportunityLineItemBuilder setUnitPrice(Integer UnitPrice){
        this.unitPrice = UnitPrice;

        return this;
    }
    public TestOpportunityLineItemBuilder setOpportunityId(Id opportunityId){
        this.opportunityId = opportunityId;

        return this;
    }
    public TestOpportunityLineItemBuilder setProductCrossReferenceId(Id productCrossReferenceId){
        this.productCrossReferenceId = productCrossReferenceId;

        return this;
    }
    public TestOpportunityLineItemBuilder setPricebookEntryId(Id pricebookEntryId){
        this.pricebookEntryId = pricebookEntryId;

        return this;
    }
    public TestOpportunityLineItemBuilder setQuantity(Integer quantity){
        this.quantity =  quantity;

        return this;
    }
    public TestOpportunityLineItemBuilder setType(String type){
        this.type = type;

        return this;
    }
    public TestOpportunityLineItemBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public OpportunityLineItem build() {
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.ServiceDate = serviceDate;
        oli.M_PM_Product__c = productCrossReferenceId;
        oli.UnitPrice = unitPrice;
        oli.Quantity = quantity;
        oli.Type__c = type;
        oli.OpportunityId = opportunityId;
        oli.PricebookEntryId = pricebookEntryId;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            oli.put(field, value);
        }

        return oli;
    }
    public OpportunityLineItem generate() {
        OpportunityLineItem oli = build();
        Database.insert(oli);
        return oli;
    }
}
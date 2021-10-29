/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestPricebookEntryBuilder {
    private Id productId;
    private Id pricebookId;
    private Integer unitPrice = 99;
    private Boolean isActive = true;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestPricebookEntryBuilder() {}

    public TestPricebookEntryBuilder setProduct(Id productId) {
        this.productId = productId;

        return this;
    }
    public TestPricebookEntryBuilder setPricebook(Id pricebookId) {
        this.pricebookId = pricebookId;

        return this;
    }
    public TestPricebookEntryBuilder setIsActive(Boolean isActive) {
        this.isActive = isActive;

        return this;
    }
    public TestPricebookEntryBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public PricebookEntry build() {
        PricebookEntry pbookEntry = new PricebookEntry();
        pbookEntry.Pricebook2Id = pricebookId;
        pbookEntry.Product2Id = productId;
        pbookEntry.IsActive = isActive;
        pbookEntry.UnitPrice = unitPrice;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            pbookEntry.put(field, value);
        }
        return pbookEntry;
    }
    public PricebookEntry generate() {
        PricebookEntry pbookEntry = build();
        Database.insert(pbookEntry);
        return pbookEntry;
    }
}
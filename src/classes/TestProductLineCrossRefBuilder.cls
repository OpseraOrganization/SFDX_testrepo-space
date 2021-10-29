/**
 * Created by Satya Mohanty on 4/9/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestProductLineCrossRefBuilder {

    private String name = 'testpl';
    private Id productLineId;
    private Id productLeader;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestProductLineCrossRefBuilder() {}

    public TestProductLineCrossRefBuilder(String name) {
        this.name = name;
    }

    public TestProductLineCrossRefBuilder setProductType(Id productLineId) {
        this.productLineId = productLineId;

        return this;
    }
    public TestProductLineCrossRefBuilder setProductLeader(Id productLeader) {
        this.productLeader = productLeader;

        return this;
    }
    public TestProductLineCrossRefBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Product_Line_Cross_Ref__c build() {
        Product_Line_Cross_Ref__c productLineCrossRef = new Product_Line_Cross_Ref__c();
        productLineCrossRef.Name = name;
        productLineCrossRef.Product_Line__c = productLineId;
        productLineCrossRef.Product_Leader__c = productLeader;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            productLineCrossRef.put(field, value);
        }
        return productLineCrossRef;
    }
    public Product_Line_Cross_Ref__c generate() {
        Product_Line_Cross_Ref__c productLineCrossRef = build();
        Database.insert(productLineCrossRef);
        return productLineCrossRef;
    }
}
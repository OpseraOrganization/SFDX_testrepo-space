/**
 * Created by Satya Mohanty on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestProductTypeBuilder {

    private String name = 'testpl';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestProductTypeBuilder() {}

    public TestProductTypeBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestProductTypeBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Product_Line__c build() {
        Product_Line__c pl = new Product_Line__c();
        pl.name = name;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            pl.put(field, value);
        }
        return pl ;
    }
    public Product_Line__c generate() {
        Product_Line__c pl  = build();
        Database.insert(pl);
        return pl ;
    }
}
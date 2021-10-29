/**
 * Created by Nikolay Kolev on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public with sharing class TestRmuProductBuilder {

    private String name = 'Test Rmu Product';
    private Map<String, Object> fields = new Map<String, Object>();
    private Id rmuValue;

    public TestRmuProductBuilder() {}

    public TestRmuProductBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestRmuProductBuilder setRmuValue(Id rmuValue) {
        this.rmuValue = rmuValue;

        return this;
    }
    public TestRmuProductBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Rmu_Product__c build() {
        Rmu_Product__c rmuProduct = new Rmu_Product__c();
        rmuProduct.Name = name;
        rmuProduct.RMU__c = rmuValue;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            rmuProduct.put(field, value);
        }
        return rmuProduct;
    }
    public Rmu_Product__c generate() {
        Rmu_Product__c rmuProduct = build();
        Database.insert(rmuProduct);
        return rmuProduct;
    }
}
/**
 * Created by Nikolay Kolev on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestRmuValueBuilder {
    private String name = 'Test Rmu Value';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestRmuValueBuilder() {}

    public TestRmuValueBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestRmuValueBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Rmu_Value__c build() {
        Rmu_Value__c rmuValue = new Rmu_Value__c();
        rmuValue.Name = name;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            rmuValue.put(field, value);
        }
        return rmuValue;
    }
    public Rmu_Value__c generate() {
        Rmu_Value__c rmuValue = build();
        Database.insert(rmuValue);
        return rmuValue;
    }
}
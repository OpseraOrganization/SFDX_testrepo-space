/**
 * Created by Nikolay Kolev on 4/17/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestOfferingMapperBuilder {
    private String name = 'Test_Offering_Mapper';
    private Id rmuValue;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestOfferingMapperBuilder() {}

    public TestOfferingMapperBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestOfferingMapperBuilder setRmuValue(Id rmuValue) {
        this.rmuValue = rmuValue;

        return this;
    }
    public TestOfferingMapperBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public OFFERING_MAPPER__c build() {
        OFFERING_MAPPER__c offeringMapper = new OFFERING_MAPPER__c();
        offeringMapper.Name = name;
        offeringMapper.RMU_VALUE__c = rmuValue;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            offeringMapper.put(field, value);
        }
        return offeringMapper;
    }
    public OFFERING_MAPPER__c generate() {
        OFFERING_MAPPER__c offeringMapper = build();
        Database.insert(offeringMapper);
        return offeringMapper;
    }
}
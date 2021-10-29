/*
 * Created by Satya Mohanty on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestPlatformBuilder {

    private String name = 'Test Platform';
    private String model = '36-16A';
    private String make = 'Various OEMS';
    private Boolean sapExternalSystem = true;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestPlatformBuilder() {}

    public TestPlatformBuilder setName(String name){
        this.name= name;

        return this;
    }
    public TestPlatformBuilder setModel(String model){
        this.model = model;

        return this;
    }
    public TestPlatformBuilder setMake(String make){
        this.make = make;

        return this;
    }
    public TestPlatformBuilder setSAPExternalSystem(Boolean sapExternalSystem){
        this.sapExternalSystem = sapExternalSystem;

        return this;
    }
    public TestPlatformBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Platform__c build() {

        Platform__c  platform = new Platform__c  ();
        platform.Name = name ;
        platform.Model__c  = model;
        platform.Make__c  = make;
        platform.SAP_External_System__c  = sapExternalSystem;

        for (String field: fields.keySet()) {
            Object value = fields.get( field);
            platform.put(field, value);
        }

        return platform;
    }
    public Platform__c generate() {
        Platform__c platform = build();
        Database.insert(platform);
        return platform;
    }
}
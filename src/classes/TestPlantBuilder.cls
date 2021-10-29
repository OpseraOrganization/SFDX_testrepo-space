/**
 * Created by Satya Mohanty on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestPlantBuilder {

    private String name = 'Test Plant';
    private String countryName = 'Canada';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestPlantBuilder() {}

    public TestPlantBuilder setName(String name){
        this.name = name;

        return this;
    }
    public TestPlantBuilder setCountryName(String countryName){
        this.countryName = countryName;

        return this;
    }
    public TestPlantBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Plant_Code_Master__c build(){
        Plant_Code_Master__c plant = new Plant_Code_Master__c();
        plant.Name = name ;
        plant.Country_Name__c =countryName;

        for (String field: fields.keySet()) {
            Object value = fields.get( field);
            plant.put(field, value);
        }

        return plant;
    }
    public Plant_Code_Master__c generate() {
        Plant_Code_Master__c plant = build();
        Database.insert(plant);
        return plant;
    }
}
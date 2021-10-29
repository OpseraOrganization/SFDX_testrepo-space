/**
 * Created by Nikolay Kolev on 4/18/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestFleetAssetDetailBuilder {
    private String name = 'Test_Fleet_Asset_Detail';
    private Id platform;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestFleetAssetDetailBuilder() {}

    public TestFleetAssetDetailBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestFleetAssetDetailBuilder setPlatform(Id platform) {
        this.platform = platform;

        return this;
    }
    public TestFleetAssetDetailBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Fleet_Asset_Detail__c build() {
        Fleet_Asset_Detail__c fleetAssetDetail = new Fleet_Asset_Detail__c();
        fleetAssetDetail.Name = name;
        fleetAssetDetail.Platform_Name__c = platform;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            fleetAssetDetail.put(field, value);
        }
        return fleetAssetDetail;
    }
    public Fleet_Asset_Detail__c generate() {
        Fleet_Asset_Detail__c fleetAssetDetail = build();
        Database.insert(fleetAssetDetail);
        return fleetAssetDetail;
    }
}
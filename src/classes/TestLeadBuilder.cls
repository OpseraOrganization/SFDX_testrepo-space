/**
 * Created by Haritha Lekkala on 4/30/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestLeadBuilder {
    private String status = 'Inquiry';
    private String leadMarket = 'Business Aviation';
    private String leadRegion ='Americas';
    private String productInformation = 'Lead Record';
    private String company = 'Honeywell';
    private String lastName = 'LastName';
    private Map<String,Object> fields = new Map<String, Object>();

    public TestLeadBuilder() {}

    public TestLeadBuilder setStatus(String status) {
        this.status = status;

        return this;
    }
    public TestLeadBuilder setLeadMarket(String leadMarket){
        this.leadMarket = leadMarket;

        return this;
    }
    public TestLeadBuilder setLeadRegion(String leadRegion){
        this.leadRegion = leadRegion;

        return this;
    }
    public TestLeadBuilder setProductInformation(String ProductInformation){
        this.productInformation = ProductInformation;

        return this;
    }
    public TestLeadBuilder setCompany(String company){
        this.company = company;

        return this;
    }
    public TestLeadBuilder setLastName(String LastName){
        this.lastName = LastName;

        return this;
    }
    public TestLeadBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }

    public Lead build(){
        Lead lead = new Lead();
        lead.Status = status;
        lead.Lead_Market_Selection__c = leadMarket;
        lead.Lead_Region__c = leadRegion;
        lead.ATR_Product_Information__c = productInformation;
        lead.Company = company;
        lead.LastName = lastName;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            lead.put(field, value);
        }

        return lead;
    }

    public Lead generate() {
        Lead lead = build();
        Database.insert(lead);
        return lead;
    }

}
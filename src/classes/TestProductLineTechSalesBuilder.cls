/**
 * Created by Satya Mohanty on 4/9/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public  class TestProductLineTechSalesBuilder {

    private final String BGA_AFTERMARKET = 'BGA Aftermarket';
    private final String BGA = 'BGA';
    private final String AMERICAS = 'Americas';
    private Id productLine;
    private String cbt = BGA_AFTERMARKET;
    private String sbu = BGA;
    private String region = AMERICAS;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestProductLineTechSalesBuilder() {}

    public TestProductLineTechSalesBuilder setProductLine(Id productLineId){
        this.productLine = productLineId;

        return this;
    }
    public TestProductLineTechSalesBuilder setCBT(String cbt){
        this.cbt = cbt;

        return this;
    }
    public TestProductLineTechSalesBuilder setSBU(String sbu){
        this.sbu = sbu;

        return this;
    }
    public TestProductLineTechSalesBuilder setRegion(String region){
        this.region = region;

        return this;
    }
    public TestProductLineTechSalesBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Product_Line_Tech_Sales__c build() {

        Product_Line_Tech_Sales__c productLineTechSales = new Product_Line_Tech_Sales__c ();
        productLineTechSales.CBT__c = cbt;
        productLineTechSales.SBU__c = sbu;
        productLineTechSales.Region__c = region;
        productLineTechSales.Product_Line__c = productLine;

        for (String field: fields.keySet()) {
            Object value = fields.get( field);
            productLineTechSales.put(field, value);
        }

        return productLineTechSales;
    }
    public Product_Line_Tech_Sales__c generate() {
        Product_Line_Tech_Sales__c productLineTechSales = build();
        Database.insert(productLineTechSales);
        return productLineTechSales;
    }

}
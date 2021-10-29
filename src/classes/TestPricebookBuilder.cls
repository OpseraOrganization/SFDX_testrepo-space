/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestPricebookBuilder {

    private String name = 'Test Pricebook';
    private Boolean isActive = true;
    private Map<String, Object> fields = new Map<String, Object>();

    public TestPricebookBuilder() {}
    public TestPricebookBuilder(String name) {
        this.name = name;
    }
    public TestPricebookBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Pricebook2 build() {
        Pricebook2 pbook = new Pricebook2();
        pbook.Name = name;
        pbook.IsActive = isActive;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            pbook.put(field, value);
        }
        return pbook;
    }
    public Pricebook2 generate() {
        Pricebook2 pbook = build();
        Database.insert(pbook);
        return pbook;
    }
}
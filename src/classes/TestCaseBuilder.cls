/**
 * Created by Satya Mohanty on 5/17/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestCaseBuilder {

    private String origin = 'Email';
    private String status = 'Open';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestCaseBuilder() {}

    public TestCaseBuilder setOrigin(String origin) {
        this.origin = origin;

        return this;
    }
    public TestCaseBuilder setStatus(String status) {
        this.status = status;

        return this;
    }
    public TestCaseBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Case build(){
        Case newCase = new Case();
        newCase.Origin = origin;
        newCase.Status = status;

        for (String field: fields.keySet()) {
            Object value = fields.get( field);
            newCase.put(field, value);
        }

        return newCase;
    }
    public Case generate() {
        Case newCase = build();
        Database.insert(newCase);
        return newCase;
    }
}
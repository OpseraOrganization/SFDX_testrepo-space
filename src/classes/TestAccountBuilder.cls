/**
 * Created by Satya Mohanty on 4/10/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
public class TestAccountBuilder {

    private String name = 'Testaccount';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestAccountBuilder() {}

    public TestAccountBuilder setName(String name) {
        this.name = name;

        return this;
    }
    public TestAccountBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public Account build() {
        Account Acc = new Account();
        Acc.Name = name;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            Acc.put(field, value);
        }
        return Acc;
    }
    public Account generate() {
        Account Acc = build();
        Database.insert(Acc);
        return Acc;
    }
}
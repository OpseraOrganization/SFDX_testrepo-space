/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestContactBuilder {

    private String firstName = 'John';
    private String lastName = 'Doe';
    private String sbu = 'ATR';
    private Map<String, Object> fields = new Map<String, Object>();

    public TestContactBuilder(){}

    public TestContactBuilder(String lastName) {
        this.lastName = lastName;
    }

    public TestContactBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }

    public Contact build() {
        Contact cont = new Contact();
        cont.FirstName = firstName;
        cont.LastName = lastName;
        cont.SBU_Contact__c = sbu;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            cont.put(field, value);
        }
        return cont;
    }
    public Contact generate() {
        Contact cont = build();
        Database.insert(cont);
        return cont;
    }
}
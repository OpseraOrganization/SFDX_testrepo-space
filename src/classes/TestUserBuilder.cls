/**
 * Created by Nikolay Kolev on 4/12/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

public class TestUserBuilder {

    private String firstName = 'John';
    private String lastName = 'Doe';
    private String alias = 'jdoey';
    private String email = getUniqueEmail();
    private Id profileId = getProfileId();
    private Map<String, Object> fields = new Map<String, Object>();

    public TestUserBuilder() {}
    public TestUserBuilder setFirstName(String firstName) {
        this.firstName = firstName;

        return this;
    }
    public TestUserBuilder setLastName(String lastName) {
        this.lastName = lastName;

        return this;
    }
    public TestUserBuilder setAlias(String alias) {
        this.alias = alias;

        return this;
    }
    public TestUserBuilder addField(String field, Object value) {
        fields.put(field, value);

        return this;
    }
    public User build() {
        User user = new User();
        user.FirstName = firstName;
        user.LastName = lastName;
        user.Alias = alias;
        user.Email = email;
        user.UserName = email;
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.LocaleSidKey = 'en_US';
        user.TimezoneSidKey = 'America/Los_Angeles';
        user.ProfileId = profileId;

        for (String field: fields.keySet()) {
            Object value = fields.get(field);
            user.put(field, value);
        }

        return user;
    }
    public User generate() {
        User user = build();
        Database.insert(user);
        return user;
    }
    private Id getProfileId() {
        return [
                SELECT Id
                FROM Profile
                WHERE Name = 'System Administrator'
        ].Id;
    }
    private String getUniqueEmail() {
        return String.valueOf(Math.round(Math.random()*1293)) +
                string.valueOf(System.now().format('ddMMYYYhhmmss')) +
                '@' + URL.getSalesforceBaseUrl().getHost();
    }
}
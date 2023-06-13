global class ConcurUser {

    // Public fields to serialize / deserialize
    public String firstName;
    public String lastName;
    public String employeeId; // docs indicate this is the unique ID but data shows this may be null
    public String loginId;
    public Boolean active = true;
    public String primaryEmail;
    public String password;

    // Constructor for Updates
    public ConcurUser(String firstName, String lastName, String loginId) {
        this(firstName, lastName, loginId, null);
    }

    // Constructor for Creates
    public ConcurUser(String firstName, String lastName, String loginId, String password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.employeeId = loginId;
        this.loginId = loginId;
        this.primaryEmail = loginId;
        this.password = password;
    }

    // Simple JSON deserialization (from Concur's v3.0 API)
    public static ConcurUser parseJSON(String user) {
        return (ConcurUser)System.JSON.deserialize(user, ConcurUser.class);
    }

    // Simple XML serialization (to Concur's v1.0 API)
    public static final String NS_XML = 'http://www.concursolutions.com/api/user/2011/02';
    public String serializeXML() {
        return 
            '<batch xmlns="' + NS_XML + '">' +
                '<UserProfile>' +
                    // constant - only 1 record in the batch
                    '<FeedRecordNumber>1</FeedRecordNumber>' +

                    // defaults - could be made one or more Custom Settings
                    '<LocaleName>en_US</LocaleName>' +
                    '<CrnKey>USD</CrnKey>' +
                    '<Custom21>US</Custom21>' +
                    '<CtryCode>US</CtryCode>' +
                    '<LedgerCode>Default</LedgerCode>' +

                    // profile info - required for both Creates & Updates
                    '<EmpId>' + escapeForXML(primaryEmail) + '</EmpId>' +
                    '<LoginId>' + escapeForXML(primaryEmail) + '</LoginId>' +
                    '<EmailAddress>' + escapeForXML(primaryEmail) + '</EmailAddress>' +
                    '<Active>' + (active ? 'Y' : 'N') + '</Active>' +

                    // serialize the following as ' ' if null to support modifying
                    // User records without supplying these details (e.g. deactivate)
                    '<Password>' + (password == null ? ' ' : escapeForXML(password)) + '</Password>' +

                    // required for both Creates & Updates
                    '<FirstName>' + escapeForXML(firstName) + '</FirstName>' +
                    '<LastName>' + escapeForXML(lastName) + '</LastName>' +
                '</UserProfile>'+ 
            '</batch>';
    }

    private String escapeForXML(String text) {
        return text.replace('&', '&amp;').replace('<', '&lt;');
    }
}
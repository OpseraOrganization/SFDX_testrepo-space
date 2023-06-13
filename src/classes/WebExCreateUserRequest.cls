global class WebExCreateUserRequest {

    // Public fields to serialize / deserialize
    public String firstName;
    public String lastName;
    public String webExId;
    public String active;
    public String email;
    public String password;

    public WebExCreateUserRequest(String firstName, String lastName, String email, String password) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.webExId = email;
        this.email = email;
        this.active = 'ACTIVATED';
        this.password = password;
    }

    // Simple XML serialization
    public String serialize(WebExSecurityContext securityContext) {
        return 
            '<?xml version="1.0" encoding="UTF-8"?>' +
            '<serv:message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ' +
                'xmlns:serv="http://www.webex.com/schemas/2002/06/service">' +
                '<header>' +
                    securityContext.serialize() +
                '</header>' +
                '<body>' +
                    '<bodyContent xsi:type="java:com.webex.service.binding.user.CreateUser">' +
                        '<firstName>' + escapeForXML(firstName) + '</firstName>' +
                        '<lastName>' + escapeForXML(lastName) + '</lastName>' +
                        '<webExId>' + escapeForXML(webExId) + '</webExId>' +
                        '<email>' + escapeForXML(email) + '</email>' +
                        '<password>' + escapeForXML(password) + '</password>' +
                        '<privilege>' +
                            '<host>true</host>' +
                            '<isEnablePMR>FALSE</isEnablePMR>' +
                        '</privilege>' +
                        '<active>' + escapeForXML(active) + '</active>' +
                    '</bodyContent>' +
                '</body>' +
            '</serv:message>';
    }

    private String escapeForXML(String text) {
        return text.replace('&', '&amp;').replace('<', '&lt;');
    }

}
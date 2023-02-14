public class WebExDeleteUserRequest {

    // Public fields to serialize / deserialize
    public String webExId;

    public WebExDeleteUserRequest(String webExId) {
        this.webExId = webExId;
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
                    '<bodyContent xsi:type="java:com.webex.service.binding.user.DelUser">' +
                        '<webExId>' + escapeForXML(webExId) + '</webExId>' +
                    '</bodyContent>' +
                '</body>' +
            '</serv:message>';
    }

    private String escapeForXML(String text) {
        return text.replace('&', '&amp;').replace('<', '&lt;');
    }

}
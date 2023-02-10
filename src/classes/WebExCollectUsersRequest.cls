public class WebExCollectUsersRequest {

    // Public fields to serialize / deserialize
    public Integer startFrom = 1;
    public Integer maximumNum = 100;

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
                    '<bodyContent xsi:type="java:com.webex.service.binding.user.LstsummaryUser">' +
                        '<listControl>' +
                            '<serv:startFrom>' + String.valueOf(startFrom) + '</serv:startFrom>' +
                            '<serv:maximumNum>' + String.valueOf(maximumNum) + '</serv:maximumNum>' +
                        '</listControl>' +
                    '</bodyContent>' +
                '</body>' +
            '</serv:message>';
    }

}
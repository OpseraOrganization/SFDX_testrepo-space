public class WebExSecurityContext {

    public String siteName;
    public String webExId;
    public String password;

    public WebExSecurityContext(String siteName, String webExId, String password) {
        this.siteName = siteName;
        this.webExId = webExId;
        this.password = password;
    }

    public void serializeTo(Dom.XmlNode headerNode) {

        Dom.XmlNode securityContextNode = headerNode.addChildElement('securityContext', null, null);

        Dom.XmlNode siteNameNode = securityContextNode.addChildElement('siteName', null, null);
        siteNameNode.addTextNode(this.siteName);

        Dom.XmlNode webExIDNode = securityContextNode.addChildElement('webExID', null, null);
        webExIDNode.addTextNode(this.webExID);

        Dom.XmlNode passwordNode = securityContextNode.addChildElement('password', null, null);
        passwordNode.addTextNode(this.password);
    }

    // Simple XML serialization
    public String serialize() {
        return 
            '<securityContext>' +
                '<siteName>' + escapeForXML(siteName) + '</siteName>' +
                '<webExID>' + escapeForXML(webExId) + '</webExID>' +
                '<password>' + escapeForXML(password) + '</password>' +
            '</securityContext>';
    }

    private String escapeForXML(String text) {
        return text.replace('&', '&amp;').replace('<', '&lt;');
    }

}
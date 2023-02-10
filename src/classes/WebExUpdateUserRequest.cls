global class WebExUpdateUserRequest {

    // Public fields to serialize / deserialize
    public String webExId;
    public String firstName;
    public String lastName;
    public String email;
    public String active;

    public WebExUpdateUserRequest() {
        this(null);
    }

    public WebExUpdateUserRequest(String webExId) {
        this.webExId = webExId;
    }

    public String serialize(WebExSecurityContext securityContext) {

        Dom.Document doc = new Dom.Document();

        String servNs = 'http://www.webex.com/schemas/2002/06/service';
        String xsiNs = 'http://www.w3.org/2001/XMLSchema-instance';

        Dom.XmlNode envelopeNode = doc.createRootElement('message', servNs, 'serv');
        envelopeNode.setNamespace('xsi', xsiNs);

        Dom.XmlNode headerNode = envelopeNode.addChildElement('header', null, null);

        securityContext.serializeTo(headerNode);
        
        Dom.XmlNode bodyNode = envelopeNode.addChildElement('body', null, null);
        
        Dom.XmlNode bodyContentNode = bodyNode.addChildElement('bodyContent', null, null);
        bodyContentNode.setAttribute('xsi:type', 'java:com.webex.service.binding.user.SetUser');

        if (this.webExId != null) {
            Dom.XmlNode webExIdNode = bodyContentNode.addChildElement('webExId', null, null);
            webExIdNode.addTextNode(this.webExId);
        }
        
        if (this.firstName != null) {
            Dom.XmlNode firstNameNode = bodyContentNode.addChildElement('firstName', null, null);
            firstNameNode.addTextNode(this.firstName);
        }
        
        if (this.lastName != null) {
            Dom.XmlNode lastNameNode = bodyContentNode.addChildElement('lastName', null, null);
            lastNameNode.addTextNode(this.lastName);
        }
        
        if (this.email != null) {
            Dom.XmlNode emailNode = bodyContentNode.addChildElement('email', null, null);
            emailNode.addTextNode(this.email);
        }
        
        if (this.active != null) {
            Dom.XmlNode activeNode = bodyContentNode.addChildElement('active', null, null);
            activeNode.addTextNode(this.active);
        }

        return doc.toXmlString();
    }

}
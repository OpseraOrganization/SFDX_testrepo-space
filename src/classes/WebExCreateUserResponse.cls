public class WebExCreateUserResponse extends WebExResponse {

    // Public fields to serialize / deserialize
    public String userId;

    // Simple XML serialization
    public static WebExCreateUserResponse parse(String xml) {
        WebExCreateUserResponse result = new WebExCreateUserResponse();
        result.apply(xml);
        return result;
    }

    public override void apply(String xml) {
        super.apply(xml);

        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        
        Dom.XMLNode messageNode = doc.getRootElement();

        Dom.XMLNode bodyNode = messageNode.getChildElement('body', NS_SERVICE);
        Dom.XMLNode bodyContentNode = bodyNode.getChildElement('bodyContent', NS_SERVICE);
        Dom.XMLNode userIdNode = bodyContentNode.getChildElement('userId', NS_USER);

        this.userId = userIdNode == null ? null : userIdNode.getText();
    }

}
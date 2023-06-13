public virtual class WebExResponse {

    // Public fields to serialize / deserialize
    public String result;
    public String reason;
    public String gsbStatus;
    public String exceptionID;

    // Simple XML serialization
    public static String NS_SERVICE = 'http://www.webex.com/schemas/2002/06/service';
    public static String NS_USER = 'http://www.webex.com/schemas/2002/06/service/user';

    public static WebExResponse parse(String xml) {
        WebExResponse result = new WebExResponse();
        result.apply(xml);
        return result;
    }

    public virtual void apply(String xml) {
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        
        Dom.XMLNode messageNode = doc.getRootElement();

        Dom.XMLNode headerNode = messageNode.getChildElement('header', NS_SERVICE);
        Dom.XMLNode responseNode = headerNode.getChildElement('response', NS_SERVICE);

        Dom.XMLNode resultNode = responseNode.getChildElement('result', NS_SERVICE);
        Dom.XMLNode reasonNode = responseNode.getChildElement('reason', NS_SERVICE);
        Dom.XMLNode gsbStatusNode = responseNode.getChildElement('gsbStatus', NS_SERVICE);
        Dom.XMLNode exceptionIDNode = responseNode.getChildElement('exceptionID', NS_SERVICE);

        this.result = resultNode == null ? null : resultNode.getText();
        this.reason = reasonNode == null ? null : reasonNode.getText();
        this.gsbStatus = gsbStatusNode == null ? null : gsbStatusNode.getText();
        this.exceptionID = exceptionIDNode == null ? null : exceptionIDNode.getText();
    }
}
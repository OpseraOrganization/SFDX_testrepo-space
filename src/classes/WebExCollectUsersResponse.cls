public class WebExCollectUsersResponse extends WebExResponse {

    public class User {
        public String webExId;
        public String firstName;
        public String lastName;
        public String email;
        public String active;
    }

    // Public fields to serialize / deserialize
    public List<User> users;

    public Integer total_records;
    public Integer returned_records;
    public Integer startFrom_records;

    public WebExCollectUsersResponse() {
        this.users = new List<User>();
    }

    // Simple XML serialization
    public static WebExCollectUsersResponse parse(String xml) {
        WebExCollectUsersResponse result = new WebExCollectUsersResponse();
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
        Dom.XMLNode matchingRecordsNode = bodyContentNode.getChildElement('matchingRecords', NS_USER);

        // May be null if API request was unsuccessful
        if (matchingRecordsNode != null) {
            this.total_records = Integer.valueOf(matchingRecordsNode.getChildElement('total', NS_SERVICE).getText());
            this.returned_records = Integer.valueOf(matchingRecordsNode.getChildElement('returned', NS_SERVICE).getText());
            this.startFrom_records = Integer.valueOf(matchingRecordsNode.getChildElement('startFrom', NS_SERVICE).getText());

            for (Dom.XMLNode contentChild : bodyContentNode.getChildElements()) {
                if (contentChild.getName() == 'user') {
                    User user = new User();

                    user.webExId = contentChild.getChildElement('webExId', NS_USER).getText();

                    Dom.XMLNode firstNameNode = contentChild.getChildElement('firstName', NS_USER);
                    Dom.XMLNode lastNameNode = contentChild.getChildElement('lastName', NS_USER);

                    user.firstName = firstNameNode == null ? null : firstNameNode.getText();
                    user.lastName = lastNameNode == null ? null : lastNameNode.getText();

                    user.email = contentChild.getChildElement('email', NS_USER).getText();
                    user.active = contentChild.getChildElement('active', NS_USER).getText();

                    this.users.add(user);
                }
            }
        }
    }

}
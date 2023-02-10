public class ConcurNativeAuth {

    public class TokenResponse {
        public AccessToken access_Token;
    }

    public class AccessToken {
        public String instance_Url;
        public String token;
        public String expiration_date;
        public String refresh_Token;
    }

    private String namedCredential;
    private String consumerKey;

    public ConcurNativeAuth(String namedCredential, String consumerKey) {
        this.consumerKey = consumerKey;
        this.namedCredential = namedCredential;
    }

    public AccessToken getAccessToken() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.namedCredential);
        req.setHeader('X-ConsumerKey', this.consumerKey);
        req.setHeader('Accept', 'application/json');
        req.setMethod('GET');

        HttpResponse res = http.send(req);
        
        // ensure we got an HTTP 200 response before parsing
        Integer httpStatusCode = res.getStatusCode();
        if (httpStatusCode != 200) {
            throw new CalloutException('Invalid HTTP status code retrieving Access Token: ' + String.valueOf(httpStatusCode));
        }

        String tokenJson = res.getBody();
        TokenResponse result = (TokenResponse)System.JSON.deserialize(tokenJson, TokenResponse.class);

        return result.access_Token;
    }

    public static AccessToken getAccessToken(String namedCredential, String consumerKey) {
        ConcurNativeAuth auth = new ConcurNativeAuth(namedCredential, consumerKey);
        return auth.getAccessToken();
    }

}
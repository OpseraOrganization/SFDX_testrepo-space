public class delegateSigningapiEchosign {

        public String endpoint_x = 'https://secure.echosign.com/services/EchoSignDocumentService19';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        //private String[] ns_map_type_info = new String[]{'http://dto.api.echosign', 'dtoApiEchosign', 'http://dto7.api.echosign', 'dto7ApiEchosign', 'http://dto11.api.echosign', 'dto11ApiEchosign', 'http://dto9.api.echosign', 'dto9ApiEchosign', 'http://dto8.api.echosign', 'dto8ApiEchosign', 'http://api.echosign', 'apiEchosign', 'http://dto10.api.echosign', 'dto10ApiEchosign', 'http://dto12.api.echosign', 'dto12ApiEchosign'};
        private String[] ns_map_type_info = new String[]{'http://dto7.api.echosign', 'dto7ApiEchosign', 'http://dto11.api.echosign', 'dto11ApiEchosign', 'http://dto8.api.echosign', 'dto8ApiEchosign', 'http://api.echosign', 'apiEchosign', 'http://dto10.api.echosign', 'dto10ApiEchosign', 'http://dto18.api.echosign', 'dto18ApiEchosign', 'http://dto19.api.echosign', 'dto19ApiEchosign', 'http://dto14.api.echosign', 'dto14ApiEchosign', 'http://dto13.api.echosign', 'dto13ApiEchosign', 'http://dto17.api.echosign', 'dto17ApiEchosign', 'http://dto.api.echosign', 'dtoApiEchosign', 'http://dto16.api.echosign', 'dto16ApiEchosign', 'http://dto9.api.echosign', 'dto9ApiEchosign', 'http://dto15.api.echosign', 'dto15ApiEchosign', 'http://dto12.api.echosign', 'dto12ApiEchosign', 'http://delegateSigning.api.echosign','delegateSigningapiEchosign'};

  public class delegateSigning_element {
        public String apiKey;
        public dto9ApiEchosign.UserCredentials userCredentials;
        public String documentKey;
        public dto17ApiEchosign.DelegateSigningOptions delegateSigningOptions;
        private String[] apiKey_type_info = new String[]{'apiKey','http://api.echosign',null,'1','1','true'};
        private String[] userCredentials_type_info = new String[]{'userCredentials','http://api.echosign',null,'1','1','true'};
        private String[] documentKey_type_info = new String[]{'documentKey','http://api.echosign',null,'1','1','true'};
        private String[] delegateSigningOptions_type_info = new String[]{'delegateSigningOptions','http://api.echosign',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://api.echosign','true','true'};
        private String[] field_order_type_info = new String[]{'apiKey','userCredentials','documentKey','delegateSigningOptions'};
    }
    public class delegateSigningResponse_element {
        public dto17ApiEchosign.DelegateSigningResult delegateSigningResult;
        private String[] delegateSigningResult_type_info = new String[]{'delegateSigningResult','http://api.echosign',null,'1','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://api.echosign','true','true'};
        private String[] field_order_type_info = new String[]{'delegateSigningResult'};
    }
    
    public dto17ApiEchosign.DelegateSigningResult delegateSigning(String apiKey,dto9ApiEchosign.UserCredentials userCredentials,String documentKey,dto17ApiEchosign.DelegateSigningOptions delegateSigningOptions) {
            delegateSigningapiEchosign.delegateSigning_element request_x = new delegateSigningapiEchosign.delegateSigning_element();
            request_x.apiKey = apiKey;
            request_x.userCredentials = userCredentials;
            request_x.documentKey = documentKey;
            request_x.delegateSigningOptions = delegateSigningOptions;
            delegateSigningapiEchosign.delegateSigningResponse_element response_x;
            Map<String, delegateSigningapiEchosign.delegateSigningResponse_element> response_map_x = new Map<String, delegateSigningapiEchosign.delegateSigningResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              '',
              'http://api.echosign',
              'delegateSigning',
              'http://api.echosign',
              'delegateSigningResponse',
              'delegateSigningapiEchosign.delegateSigningResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.delegateSigningResult;
        }
    }
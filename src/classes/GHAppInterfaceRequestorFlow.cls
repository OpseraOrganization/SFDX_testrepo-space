public class GHAppInterfaceRequestorFlow{
    public void getGHRequest(){
        
    }
    
    public static string getAggregatevalues(GHAppInstanceDetails__c instanceDetails, string email){
        AutheticationResponse authData = new AutheticationResponse();
        if(!Test.isRunningTest()){
            authData = getAuthenticate(instanceDetails);
        }else{
            authData.access_token = '00DS0000003Kbii!ARMAQOU226_uWf9JKRVXjxzUs_dHg8y.G6PIHFrktN5Ot30Lhjj.dMzOa1JQmEgw4dltjhSAdrnGAyEZjN.amMfgCj2_iNbI';
            authData.instance_url = 'https://test.salesforce.com';     


        }
        
        system.debug('authData--->' + authData.access_token);
        system.debug('authData--->' + authData.instance_url);

        
        
        if(authData.access_token != null){
            Http http = new Http();
            
            HttpRequest httpRequest = new HttpRequest();
            //string ghRequestUri = authData.instance_url +'/services/data/v31.0/query?q=select+id,Name,Status__c,Recipient_Name_List__c,CreatedDate,(select+id,Status__c,Name_of_Recipient__c,Elected_Representative__c,GH_Request__c,Gift_Recipient__c,Company__c,Country__c,Gift_Score__c,Meal_Score__c,Gifts__c,Meals_Entertainment__c,Three_Months_Gift_Score__c,Gift_Needs_Approval__c,ME_Needs_Approval__c,Three_Months_Meal_Score__c,ME_Value_of_Meals_Entertainment__c,Gift_Value_of_gift__c,Pro_Gift_Value_of_Gift__c,Pro_ME_Value_of_Meal_Entertainment__c,Gift_Description__c,Gift_Business_Purpose__c,Gift_Additional_Comments__c,ME_Description__c,ME_Business_Purpose__c,ME_Additional_Comments__c,Gift_Occasion_Business_Meeting__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,Gift_Line_Manager_Informed__c,ME_Occasion_Business_Meeting__c,ME_Occasion_Award_Placement__c,ME_Frequency__c,ME_Travel_provided_to_government_officia__c,ME_Travel_offered_to_spouse__c,ME_Line_Manager_Informed__c+from+GH_Request_Recipients__r)+from+Order_Request__c';
            string ghRequestUri = authData.instance_url +'/services/data/v31.0/query?q=SELECT+Id,(select+id,Gift_Value_of_gift__c+from+GH_Request_Recipients__r+where+status__c+=\'Approved\')+FROM+Contact+WHERE+Email+=\''+email+'\'+LIMIT+1';
            httpRequest.setEndpoint(ghRequestUri);
            httpRequest.setMethod('GET');
            httpRequest.setHeader('Authorization', 'OAuth ' + authData.access_token);
            //httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            HttpResponse httpResponse = http.send(httpRequest);
            string responseBody = httpResponse.getBody(); 
            
            system.debug('Aggregate responseBody------------------>' + responseBody);

            
            //string responseBody = '{"totalSize":1,"done":true,"records":[{"attributes":{"type":"Order_Request__c","url":"/services/data/v29.0/sobjects/Order_Request__c/a56e00000000L6FAAU"},"Id":"a56e00000000L6FAAU","Name":"GH Request-0014","Status__c":"Pending","Recipient_Name_List__c":"Shrivaths; Deb;","CreatedDate":"2015-01-12T08:05:32.000+0000","GH_Request_Recipients__r":{"totalSize":2,"done":true,"records":[{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v29.0/sobjects/GH_Request_Recipient__c/a57e000000008HfAAI"},"Id":"a57e000000008HfAAI","Status__c":"Pending","Name_of_Recipient__c":"Shrivaths","Elected_Representative__c":false,"GH_Request__c":"a56e00000000L6FAAU","Gift_Score__c":123.0,"Meal_Score__c":null,"Three_Months_Gift_Score__c":1223.0,"Three_Months_Meal_Score__c":null,"ME_Value_of_Meals_Entertainment__c":null,"Gift_Value_of_gift__c":456.0},{"attributes":{"type":"GH_Request_Recipient__c","url":"/services/data/v29.0/sobjects/GH_Request_Recipient__c/a57e000000008HkAAI"},"Id":"a57e000000008HkAAI","Status__c":"Approved","Name_of_Recipient__c":"Deb","Elected_Representative__c":false,"GH_Request__c":"a56e00000000L6FAAU","Gift_Score__c":34.0,"Meal_Score__c":34.0,"Three_Months_Gift_Score__c":123.0,"Three_Months_Meal_Score__c":345.0,"ME_Value_of_Meals_Entertainment__c":null,"Gift_Value_of_gift__c":200.0}]}}]}';
            if(responseBody != null){
                return responseBody;


            }else{
                return null;
            }
        }
        return null;
    }

    public static string getCurrentAggregatevalues(string email){
       
            Http http = new Http();
            string responseBody = '';
            HttpRequest httpRequest = new HttpRequest();
            //string ghRequestUri = authData.instance_url +'/services/data/v31.0/query?q=select+id,Name,Status__c,Recipient_Name_List__c,CreatedDate,(select+id,Status__c,Name_of_Recipient__c,Elected_Representative__c,GH_Request__c,Gift_Recipient__c,Company__c,Country__c,Gift_Score__c,Meal_Score__c,Gifts__c,Meals_Entertainment__c,Three_Months_Gift_Score__c,Gift_Needs_Approval__c,ME_Needs_Approval__c,Three_Months_Meal_Score__c,ME_Value_of_Meals_Entertainment__c,Gift_Value_of_gift__c,Pro_Gift_Value_of_Gift__c,Pro_ME_Value_of_Meal_Entertainment__c,Gift_Description__c,Gift_Business_Purpose__c,Gift_Additional_Comments__c,ME_Description__c,ME_Business_Purpose__c,ME_Additional_Comments__c,Gift_Occasion_Business_Meeting__c,Gift_Occasion_Award_Placement__c,Gift_Frequency__c,Gift_Gift_given_to_government_official__c,Gift_Gift_offered_to_spouse__c,Gift_Line_Manager_Informed__c,ME_Occasion_Business_Meeting__c,ME_Occasion_Award_Placement__c,ME_Frequency__c,ME_Travel_provided_to_government_officia__c,ME_Travel_offered_to_spouse__c,ME_Line_Manager_Informed__c+from+GH_Request_Recipients__r)+from+Order_Request__c';
            string ghRequestUri = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v31.0/query?q=SELECT+Id,(select+id,Gift_Value_of_gift__c,ME_Value_of_Meals_Entertainment__c+from+GH_Request_Recipients__r+where+status__c+=\'Approved\'+AND+Gift_Recipient__c+=false)+FROM+Contact+WHERE+Email+=\''+email+'\'+LIMIT+1';
            httpRequest.setEndpoint(ghRequestUri);
            httpRequest.setMethod('GET');
            //httpRequest.setHeader('Authorization', 'OAuth ' + authData.access_token);
            httpRequest.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            try{
                HttpResponse httpResponse = http.send(httpRequest);
                responseBody = httpResponse.getBody(); 
                system.debug('responseBody >>>>@@>>>'+ responseBody);
            }
            catch(Exception ex){
                system.debug('Http send Error-->' + ex.getMessage());   
            }
                    
            if(responseBody != null){
               return responseBody;
               
            }else{
                return null;
            }
        
        
    }
    
    public static AutheticationResponse getAuthenticate(GHAppInstanceDetails__c instanceDetails){
        Http http = new Http();
        
        HttpRequest httpRequest = new HttpRequest();
        string bodyString = 'grant_type=password&client_id='+instanceDetails.consumerKey__c+'&client_secret='+instanceDetails.conumerSecret__c+'&username='+instanceDetails.username__c+'&password='+instanceDetails.passwoard__c;
        httpRequest.setBody(bodyString);
        httpRequest.setEndpoint(instanceDetails.EndPoint__c); //Label.GHAppOAuthEndPoint
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type','application/x-www-form-urlencoded');
        system.debug('bodyString-->' + bodyString);
        string accessToken;
        HttpResponse httpResponse;
        if(accessToken == '' || accessToken == null){
            httpResponse = http.send(httpRequest);
            string responseBody = httpResponse.getBody();
            
            
            if(responseBody != null || responseBody != ''){
                System.debug('---------------->' + responseBody);
                
                AutheticationResponse authResponse = new AutheticationResponse();
                JSONParser parser = JSON.createParser(responseBody);
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT){
                        authResponse = (AutheticationResponse)parser.readValueAs(AutheticationResponse.class);
                        system.debug('authResponse--->' + authResponse.access_token);
                        system.debug('authResponse--->' + authResponse.instance_url);
                        return authResponse;
                    }
                }
                
            }
        }
        return null;
        
    }
    
    public class AutheticationResponse{
        public string id;
        public string issued_at;
        public string token_type;
        public string instance_url;
        public string signature;
        public string access_token;
    }
    
   
}
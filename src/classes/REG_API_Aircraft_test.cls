@IsTest
public class REG_API_Aircraft_test {
    
    @TestSetup
    static void fncDataSetup(){
        Reg_TestDataFactory.createTestRecords();
    }
    
    static testMethod void testGetAllAircraftAndModel(){
        
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();
        RestContext.request = request;  
        RestContext.response= response;
        request.requestURI = '/aircrafts/';  //Request URL
        request.httpMethod = 'GET';//HTTP Request Type
        System.assertEquals('GET', request.httpMethod);
        list<Platform__c> aircrafts = [SELECT Make__c, Model__c, Serial_Number_Format__c FROM Platform__c where Make__c = 'testing' and Make_Model__c!=null ORDER BY Make__c ASC, Make_Model__c ASC];
        Map<String,List<String>> makeModelMap = new Map<String,List<String>>();
        List<REG_Aircraft_Wrapper> aircraftWrapperList = new List<REG_Aircraft_Wrapper>();
        test.startTest();
        REG_API_Aircrafts.doGet();
        test.stopTest();
        String result = response.responseBody.toString();
        List<REG_Aircraft_Wrapper> aircraftList = (List<REG_Aircraft_Wrapper>)JSON.deserialize(result, List<REG_Aircraft_Wrapper>.class);
        system.assert(!aircraftList.isEmpty());
        
    }
}
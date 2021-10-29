/***************************************************
 Class Name:LeapContractCreationService
 Test Class Name: LeapContractCreationServiceTest
 Developed By: Nttdata
 Date: 4/13/2020
 Description: This class is used to initiate Contract in Leap
****************************************************/
global without sharing class LeapContractCreationService {
    public LeapContractCreationService() {
        
    }
    public static Object getValue(SObject record, String path) {
        try {
          SObject temp = record;
          String[] parts = path.split('\\.');
          while(parts.size() > 1) {
            temp = record.getSObject(parts.remove(0));
          }
          return temp.get(parts[0]);
        } catch(Exception e) {
          return null;
        }
      }
    @InvocableMethod(Label='Create Contract in Leap')
    public static List<String> syncContractAgain(List<Request> reqs){
        List<String> returnValue= new List<String>();
        for(Request reqPB : reqs){
            string objectName = ((id)reqPB.ContractId).getSObjectType().getDescribe().getName();
            
            
            if(reqPB.source =='PB'){
                //Commented obj
                //createContract(reqPB.ContractId,reqPB.ContractType,'');
                createContract(reqPB.ContractId,objectName);
            }
            else if(reqPB.source =='flow'){
                String conId = reqPB.ContractId;
                /////query = 'SELECT Id,Leap_Contract_ID__c,'+parentApi+',Integration_Status__c,Leap_Contract_Owner__c  from '+objectName+' WHERE Id =:conId';
                //Commented obj
                //query = 'SELECT Id,Leap_Contract_ID__c,Parent_Contract__c,Integration_Status__c,Leap_Contract_Owner__c  from '+objectName+' WHERE Id =:conId';
                String query = 'SELECT Id,Leap_Contract_ID__c,Integration_Status__c,Leap_Contract_Owner__c,Customer_Contact_Name__c,RecordType.DeveloperName  from '+objectName+' WHERE Id =:conId';                
                sObject c = Database.query(query);
                if(c.get('Leap_Contract_ID__c') != null && c.get('Leap_Contract_ID__c') != '' ){
                    returnValue.add('This Contract already exists in LEAP with ID '+ c.get('Leap_Contract_ID__c'));
                }   
                else if(c.get('Integration_Status__c')=='In Progress'){
                    returnValue.add('Already Integration is in progress');
                }
                else if(String.ValueOf(c.get('Leap_Contract_Owner__c'))!= null 
                        && String.ValueOf(c.get('Leap_Contract_Owner__c')) !=''
                        && String.ValueOf(c.get('Customer_Contact_Name__c'))!= null
                        && String.ValueOf(c.get('Customer_Contact_Name__c')) !=''){
                    //Commented obj
                    //string check = searchContractinLeap(reqPB.ContractId,reqPB.ContractType);
                    string check = searchContractinLeap(reqPB.ContractId,objectName);
                    if(check == 'Not Found'){
                        //Commented obj
                        //createContract(reqPB.ContractId,reqPB.ContractType,String.ValueOf(c.get('Parent_Contract__c')));
                        createContract(reqPB.ContractId,objectName);
                        returnValue.add('Contract creation is initiated in Leap.');
                        c.put('Integration_Status__c','In Progress');
                        update c;
                    }
                    else{
                        returnValue.add(check);
                    }
                }
                else{
                    returnValue.add('Fill all the reauired fields o create a contract in Leap.');
                }
                system.debug('returnValue ++'+returnValue);
             }
        }
        
        return returnValue;
    }
    public static string searchContractinLeap(String contractId, string objectName){
        String accessToken = getAccessToken();
        String TableName='';
        //Commented obj
        //String objectName='';
        String returnString='';
        String requestBody ='';
        String projectName = System.Label.ProjectNname;
        //if(ContractType == 'Sales Contract'){
            TableName=  System.Label.LeapSalesTalbleName;
        //Commented obj
            //objectName = 'Contract';
        //}else if(ContractType == 'Service Contract'){
       //     TableName =  System.Label.LeapServiceTalbleName;
        //    objectName = 'Contract';
        //}
        requestBody+='&$login='+System.Label.LeapLogin+'\r\n';//'&$login=restuser4leap\r\n';
        requestBody+='&$password='+System.Label.LeapPwd+'\r\n';//'&$password=@H0n26nav19$\r\n';LeapPwd
        requestBody+='&$lang=en\r\n';
        requestBody+='&query='+System.Label.LeapSearchIdentifier+'='+contractId;
        Http http = new Http();
        System.debug('body@@'+requestBody);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.Leap_Url+'/v1/agiloft/contract/search?$KB='+projectName+'&$table='+TableName);
        request.setHeader('Authorization','Bearer '+accessToken);
        request.setHeader('Content-Type', 'text/plain');
        request.setMethod('POST');
        request.setHeader('Content-Length', String.ValueOf(requestBody.length()));
        request.setBody(requestBody);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            sObject c = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
            //c.put('Id',ContractId);
            wrapperSearchResponse wrapResponse = (wrapperSearchResponse) JSON.deserialize(response.getBody(), wrapperSearchResponse.class);
            System.debug('wrapResponse ' + wrapResponse);
            System.debug('wrapResponse result' + wrapResponse.result);
            if(wrapResponse != null && wrapResponse.result!= null && wrapResponse.result.size()>0 && wrapResponse.result[0].Id!=null){
                c.put('Leap_Contract_ID__c',wrapResponse.result[0].Id);
                c.put('Id',contractId);
                c.put('Integration_Status__c','Completed');
                //c.put('Leap_Contract_Link__c','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb='+projectName+'&State=Edit:contract&record='+wrapResponse.result[0].Id+'&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
                update c;
                returnString = 'Contract exisits in Leap already with Id '+wrapResponse.result[0].Id; 
            }
            else{
                returnString = 'Not Found'; 
            }
        }
        else{
            returnString = 'Error occured with following code  '+ response.getStatusCode();
        }
        return returnString;
    }
    public static string createContractCallInLeap(String accessToken, String body, String tableName, String projectName, String ContractId,String objectName){
        String returnString='';
        Http http = new Http();
        System.debug('body@@'+body);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.Leap_Url+'/v1/agiloft/contract/create?$KB='+projectName+'&$table='+tableName);
        request.setHeader('Authorization','Bearer '+accessToken);
        request.setHeader('Content-Type', 'text/plain');
        request.setMethod('POST');
        request.setHeader('Content-Length', String.ValueOf(body.length()));
        request.setTimeout(100000);
        request.setBody(body);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug(results);
            sObject c = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
            c.put('Id',ContractId);
            if(results.ContainsKey('success') && Boolean.valueOf(results.get('success')) && results.ContainsKey('result')){
                c.put('Leap_Contract_ID__c',String.valueOf(results.get('result')));
                c.put('Integration_Status__c','Completed');
                //c.put('Leap_Contract_Link__c','https://honeywell.agiloft.com/gui2/samlssologin.jsp?kb='+projectName+'&State=Edit:contract&record='+String.valueOf(results.get('result'))+'&record_access=view&exiturl=leaveLoggedIn&cancelurl=leaveLoggedIn');
            }
            else{
                c.put('Leap_Integration_Error__c','Error Occured while sending data to LEAP');
                c.put('Integration_Status__c','Failed');
            }
            update c;
        }
        else{
            returnString = 'Error occured with following code  '+ response.getStatusCode();
        }
        return returnString;
    }
    @future(callout=true)
    public static void createContract(String ContractId, String objectName){
    //Commented obj    
    //public static void createContract(String ContractId, String ContractType, String parentContractId){
        String accessToken = getAccessToken();
        if(accessToken != null && accessToken != ''){
            List<Leap_Field_Mapping__mdt> FieldMappings = new List<Leap_Field_Mapping__mdt>();
            String TableName = '';
            String serviceTableName = '';
            //Commented obj
            //string objectName = '';
            TableName =  System.Label.LeapSalesTalbleName;
            FieldMappings =[SELECT ID,MasterLabel, DeveloperName, Field_Name__c, JSON_String__c, LinkedField__c, Order__c, 
            Receiver__c, Sales_Contract__c, ServiceContract__c, data_type__c, Value__c 
            FROM Leap_Field_Mapping__mdt order WHERE Sales_Contract__c = TRUE AND Receiver__c = FALSE ORDER by Order__c ASC];
            if(FieldMappings.Size()>0){
                Map<String,String> sbuMap = new Map<String,String>();
                String sbuValue='';
                String leapSBUValue='';
                sbuMap.put('Americas AM','Aftermarket Americas');
                sbuMap.put('APAC AM','APAC');
                sbuMap.put('Electronic Solutions OE','Electronic Solutions');
                sbuMap.put('EMEAI AM','EMEAI');
                sbuMap.put('Engines & Power Systems OE','Engines & Power Systems');
                sbuMap.put('Mechanical Systems & Components OE','Mechanical Systems &Components');
                sbuMap.put('Services & Connectivity OE','Services & Connectivity');
                
                //Added by Mahesh to Map SBU in SFDC to Vertcal in LEAP
                Map<String,String> verticalMap = new Map<String,String>();
                String verticalValue='';
                verticalMap.put('ATR','AT&R');
                verticalMap.put('BGA','B&GA');
                verticalMap.put('D&S','D&S');
                
                //Added by Mahesh to Map Product Type GBE in SFDC to GBE in LEAP
                Map<String,String> GBEMap = new Map<String,String>();
                String GBEValue='';
                GBEMap.put('Air & Thermal Systems','Air & Thermal Systems');
                GBEMap.put('BendixKing','BendixKing');
                GBEMap.put('Cockpit Systems','Cockpit Systems');
                GBEMap.put('Engines','Engines');
                GBEMap.put('Mechanical Components','Mechanical Components');
                GBEMap.put('Navigation & Sensors','Navigation & Sensors');
                GBEMap.put('Power Systems','Power Systems');
                GBEMap.put('Safety Systems','Safety Systems');
                GBEMap.put('Space','Space');
                GBEMap.put('Wheels and Braking Systems','Wheels and Braking Systems');
                
               String requestBody = '';
                String query = 'SELECT Id ';
                Set<String> queryFields = new Set<String>();
                Map<String,Leap_Field_Mapping__mdt> FieldJSONMap = new Map<String,Leap_Field_Mapping__mdt>();
                requestBody+='&$login='+System.Label.LeapLogin+'\r\n';//'&$login=restuser4leap\r\n';
                requestBody+='&$password='+System.Label.LeapPwd+'\r\n';//'&$password=@H0n26nav19$\r\n';LeapPwd
                requestBody+='&$lang=en\r\n';
                for(Leap_Field_Mapping__mdt fm : FieldMappings){
                    if(fm.Field_Name__c!=null && fm.Field_Name__c != ''){
                        queryFields.add(fm.Field_Name__c);
                        fieldJSONMap.put(fm.JSON_String__c, fm);
                    }
                }
                queryFields.add('Parent_Contract__r.Leap_Contract_ID__c');
                for(String s : queryFields){
                    query += ','+s;
                }
                query += ', Opportunity__r.Sales_Channel__c';
                query += ', Opportunity__r.SBU__c';
                query += ', Opportunity__r.Product_Line_Product_Group__c';
                query += ', Opportunity__r.CurrencyIsoCode';
                query += ', Opportunity__r.CBT_Tier_2__c';
                query += ', Opportunity__r.Pipeline_Amount__c';
                query += ' FROM '+objectName+' WHERE Id =: ContractId';
                system.debug('query++'+query);
                Sobject contract = Database.Query(query);
                
                
                system.debug('FieldMappings++'+FieldMappings);
                if(contract!= null){
                    Sobject contractSobject = (sObject) contract;
                    for(Leap_Field_Mapping__mdt fm : FieldMappings){
                        requestBody += '&'+fm.JSON_String__c+(fm.LinkedField__c ? '=:':'=') + (fm.value__c != null ? ('"'+fm.value__c+'"'): ('"'+String.ValueOf(getValue(contractSobject,fm.Field_Name__c )))+'"')+'\r\n';
                        //requestBody += '&'+fm.JSON_String__c+'='+ (fm.value__c != null ? fm.value__c: String.ValueOf(getValue(contractSobject,fm.Field_Name__c )))+'\r\n';
                    }
                    sbuValue = String.ValueOf(getValue(contractSobject,'Opportunity__r.Sales_Channel__c'));
                    if(sbuValue != '' && sbuValue != null && sbuMap.containsKey(sbuValue)){
                        requestBody+='&sbus0=:"'+sbuMap.get(sbuValue)+'"\r\n';
                    }
                    
                     verticalValue = String.ValueOf(getValue(contractSobject,'Opportunity__r.SBU__c'));
                    if(verticalValue != '' && verticalValue != null && verticalMap.containsKey(verticalValue)){
                        requestBody+='&vertical=:"'+verticalMap.get(verticalValue)+'"\r\n';
                    } 
                    
                 /*   GBEValue = String.ValueOf(getValue(contractSobject,'Opportunity__r.Product_Line_Product_Group__c'));
                    if(GBEValue != '' && GBEValue != null && GBEMap.containsKey(GBEValue)){
                        requestBody+='&gbes=:"'+GBEMap.get(GBEValue)+'"\r\n';
                    } */
                    
                    String OppCurrencyCode = String.ValueOf(getValue(contractSobject,'Opportunity__r.CurrencyIsoCode'));
                    System.debug(OppCurrencyCode);
                    if( OppCurrencyCode != null && OppCurrencyCode != ''){ 
                        requestBody += '&currency_code=:'+OppCurrencyCode+'\r\n';
                     }
                    
                    String OppCBT = String.ValueOf(getValue(contractSobject,'Opportunity__r.CBT_Tier_2__c'));
                    System.debug(OppCBT);
                    if( OppCBT != null && OppCBT != ''){ 
                        requestBody += '&cbt='+OppCBT+'\r\n';
                     }
                    
                     String OppAmount = String.ValueOf(getValue(contractSobject,'Opportunity__r.Pipeline_Amount__c'));
                    System.debug(OppAmount);
                    if( OppAmount != null && OppAmount != ''){ 
                        requestBody += '&contract_or_amendment_value_non_usd='+OppAmount+'\r\n';
                     }
                    
                    String parentContractId1 = String.ValueOf(getValue(contractSobject,'Parent_Contract__r.Leap_Contract_ID__c'));
                    System.debug(parentContractId1);
                    if( parentContractId1 != null && parentContractId1 != ''){ 
                        requestBody += '&parent_agreement_id=:'+parentContractId1+'\r\n';
                        requestBody+='&record_type=Amendment\r\n';
                    }
                    requestBody+='&'+System.Label.LeapSearchIdentifier+'='+ContractId+'\r\n';
                    requestBody+='&'+System.Label.LeapSObjectType+'=Sales Contract\r\n';
                    createContractCallInLeap(accessToken,requestBody,TableName,System.Label.ProjectNname,ContractId,objectName);
                }
            }
        }  
    }
    public static string getAccessToken(){
        Map<String, Object> results = new Map<String, Object>();
        String base64Encoding = System.Label.LeapClientSecret;//'NN3n0Ib00ArcP1aymFvIFLaJsze1giZP:bVSgoRaM9bZKVBg1';
        String returnValue='';
        Blob beforeblob = Blob.valueOf(base64Encoding);
        string paramvalue = EncodingUtil.base64Encode(beforeblob);
        System.debug(paramvalue);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.Leap_Url+'/v1/oauth/accesstoken?grant_type=client_credentials');
        request.setHeader('Authorization','Basic '+paramvalue);
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setMethod('GET');
        System.debug('request'+ request);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            returnValue =String.ValueOf(results.get('access_token'));
            System.debug('response.getBody()'+response.getBody());
            System.debug(results);
        }
        return returnValue;
    }
    public without sharing class Request {
        @InvocableVariable(label='Id' required=true)
        public String ContractId;
        //@InvocableVariable(label='Contract Type' required=true)
        //public String ContractType;
        @InvocableVariable(label='Source' required=true)
        public String source;
    }
    public class wrapperSearchResponse{
        public Boolean success {get;set;} 
        public String message {get;set;} 
        public List<ResultMessage> result {get;set;}
    }
    public class ResultMessage{
        public string Id{get;set;}
    }
}
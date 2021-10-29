@RestResource(urlMapping='/updateContract/*')
global without sharing class LeapContractUpdateRestService {
    @HttpPost
    global static String doUpdate(){

        system.debug('RestContext.request'+RestContext.request.requestURI);
        String sbg = '';
        String returnMessage='';
        if(RestContext.request.params.containsKey('ManagingUnit')){
            sbg = RestContext.request.params.get('ManagingUnit');
        }
        RestResponse res = RestContext.response;
        if(sbg == 'AERO Sales' ){
            
            String s='';
            String json1 ='';
            Map<String, Object> m = new Map<String,object>();
            try{
                List<Leap_Field_Mapping__mdt> FieldMappings = new List<Leap_Field_Mapping__mdt>();
                RestRequest request = RestContext.request;
                Blob requestBody = request.requestBody;
                json1 = requestBody.toString();
                String objectName ='';
                m =   (Map<String, Object>) JSON.deserializeUntyped(json1);
                if(m.containsKey('SObjectType') && m.containsKey('SFDCContractId')){
                    String SObjectType = String.ValueOf(m.get('SObjectType'));
                    
                    if(SObjectType == 'Sales Contract'){
                        objectName = 'Contract';
                        FieldMappings =[SELECT ID,MasterLabel, DeveloperName, Field_Name__c, JSON_String__c, LinkedField__c, Order__c, 
                        Receiver__c, Sales_Contract__c, ServiceContract__c, data_type__c, Value__c 
                        FROM Leap_Field_Mapping__mdt order WHERE Sales_Contract__c = TRUE AND Receiver__c = TRUE ORDER by Order__c ASC];
                    }
                    if(FieldMappings.size()>0){
                        sObject c = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
                        c.put('Id',String.valueOf( m.get('SFDCContractId')));
                        Boolean updateCounter=false;
                        for(Leap_Field_Mapping__mdt fieldMap:FieldMappings){
                            String startDate = '';
                            String endDate ='';
                            if(m.containsKey(fieldMap.JSON_String__c)){
                                updateCounter=true;
                                if(m.get(fieldMap.JSON_String__c) == null){
                                    c.put(fieldMap.Field_Name__c,null);
                                }
                                else{
                                    if(fieldMap.data_type__c=='Text'){
                                        c.put(fieldMap.Field_Name__c,String.ValueOf(m.get(fieldMap.JSON_String__c)));
                                    }
                                    else if(fieldMap.data_type__c=='Date'){
                                            List<String> dateString = String.ValueOf(m.get(fieldMap.JSON_String__c)).split('/');
                                            if(dateString.size()>2){
                                                date myDate = date.newInstance(Integer.ValueOf(dateString[2]), Integer.ValueOf(dateString[0]), Integer.ValueOf((dateString[1])));
                                                c.put(fieldMap.Field_Name__c,myDate);
                                            }
                                    }
                                    else if(fieldMap.data_type__c=='Number'){
                                        c.put(fieldMap.Field_Name__c,Integer.ValueOf(m.get(fieldMap.JSON_String__c)));
                                    }
                                    else if(fieldMap.data_type__c=='Decimal'){
                                        system.debug(fieldMap.JSON_String__c);
                                        Decimal amount = Decimal.ValueOf(String.ValueOf(m.get(fieldMap.JSON_String__c)));
                                        //The Currency from LEAP system is in USD. This code converts the USD to record currency
                                        if(fieldMap.JSON_String__c == 'Amount'){
                                            String query = 'SELECT currencyISOCode from '+objectName+' WHERE Id =\''+String.valueOf( m.get('SFDCContractId'))+'\'';
                                            system.debug(query);
                                            sobject con = Database.query(query);
                                            system.debug(String.valueOf( con.get('currencyISOCode')));
                                            if(String.valueOf( con.get('currencyISOCode')) != 'USD'){
                                              decimal conversionRate = [select ConversionRate from currencyType where ISOCODE =:String.valueOf( con.get('currencyISOCode'))].ConversionRate;
                                                amount = amount*conversionRate;
                                                system.debug(conversionRate);
                                            }                                      
                                        }                                    
                                        c.put(fieldMap.Field_Name__c,amount);
                                    }
                                }
                            }
                        }

                        if(updateCounter){                 
                            update c;
                            returnMessage = 'Contract updated succesfuly.';
                        }
                        else{
                            returnMessage = 'No updates committed in salesforce.';
                        }

                    }
                    else{
                        returnMessage = 'Please contact your system admin to create field mapping record in custom metadata type.'+ FieldMappings.size();
                    }
                }
                else{
                    returnMessage = 'SObjectType is not available in the request body.';
                }
            }
            Catch(Exception e){
                returnMessage = returnMessage+e.getMessage();
            }
            }else{
                returnMessage = 'Invalid Managing Unit. Expected value is Aero Sales';
            }
            if(returnMessage == 'Contract updated succesfuly.'){
            res.statusCode = 200;
        }
        else if(returnMessage == 'No updates committed in salesforce.'){
            res.statusCode = 304;
        }
        else{
            res.statusCode = 500;
        }

            return returnMessage;

    }
}
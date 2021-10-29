@RestResource(urlMapping = '/ngbss/countries/*')
global without sharing class CountryStateRestResource {
    @HttpGet
    global static void doGetCountrystate() {
        boolean CountryCodeExist = RestContext.request.params.keyset().contains('countryCode');
        boolean fieldsExist = RestContext.request.params.keyset().contains('fields');
        String countryCode = RestContext.request.params.get('countryCode');
        if(CountryCodeExist ){
            countryCode = countryCode.trim();
        }
        String fields = RestContext.request.params.get('fields');
        if(fieldsExist){
            fields  = fields .trim();
        }
        String condition;
        list < stateData > state = new list < stateData > ();
        list < CountryData > data = new list < CountryData > ();
        RestResponse res = RestContext.response;
        RestContext.response.addHeader('Content-Type', 'application/json');
        String query = 'select Name,id,ISO_Country_Code__c,Honeywell_Region_Name__c,Telephonic_Country_Code__c,State_Prov_Code__c,(select Name,StateCode__c  from States_del__r order by Name ASC) FROM Country__c '; // + condition ;
        if (CountryCodeExist && (string.isBlank(countryCode) || !countryCode.isAlpha())) {
            RestContext.response.statusCode = 400;
            // res.setStatuscode(400);  
            res.responseBody = Blob.valueOf('{"message":"invalid input","errorCode":"error"}');
        }else if(fieldsExist && fields!='states'){
            RestContext.response.statusCode = 400;
            res.responseBody = Blob.valueOf('{"message":"invalid input","errorCode":"error"}');
        }  else if ((!fieldsExist) && !CountryCodeExist) {
            //   case 1
            //just return countries
            for (Country__c cs: database.query(query + ' order by Name ASC')) {
                data.add(new CountryData(cs.Honeywell_Region_Name__c, cs.Name, cs.ISO_Country_Code__c, cs.Telephonic_Country_Code__c, null));
            }
            res.responseBody = Blob.valueOf(JSON.serializePretty(new finalData(data)));
        } else if (CountryCodeExist && !fieldsExist) {
            //Case 2
            if(!countryCode.isAlpha()){
                RestContext.response.statusCode = 400;
                res.responseBody = Blob.valueOf('{"status":"error","message":"invalid input"}');  
            }
            else{
                for (Country__c cs: database.query(query + ' where ISO_Country_code__c=:countryCode order by Name ASC')) {
                    state = new list < stateData > ();
                    for (Country_States__c each: cs.States_del__r) {
                        state.add(new stateData(each.Name, each.StateCode__c));
                    }
                    data.add(new CountryData(cs.Honeywell_Region_Name__c, cs.Name, cs.ISO_Country_Code__c, cs.Telephonic_Country_Code__c, state));  
                }
                res.responseBody = Blob.valueOf(JSON.serializePretty(new finalData(data)));
            }
        } else if (fields != null && fields == 'states' && countryCode == null) {
            //Case 3
            for (Country__c cs: Database.query(query + ' order by Name ASC ')) {
                state = new list < stateData > ();
                for (Country_States__c each: cs.States_del__r) {
                    state.add(new stateData(each.Name, each.StateCode__c));
                }
                data.add(new CountryData(cs.Honeywell_Region_Name__c, cs.Name, cs.ISO_Country_Code__c, cs.Telephonic_Country_Code__c, state));
            }
            res.responseBody = Blob.valueOf(JSON.serializePretty(new finalData(data)));   
        } else if (fields != null && fields == 'states' && countryCode != null) {
            //Case 4
            //where StateCode__c=:fields
            String query1 = 'select Name,id,ISO_Country_Code__c,Honeywell_Region_Name__c,Telephonic_Country_Code__c,State_Prov_Code__c,(select Name,StateCode__c  from States_del__r   order by Name ASC) FROM Country__c '; // + condition ;
            for (Country__c cs: database.query(query1 + ' where ISO_Country_code__c=:countryCode order by Name ASC')) {
                state = new list < stateData > ();
                for (Country_States__c each: cs.States_del__r) {
                    state.add(new stateData(each.Name, each.StateCode__c));
                }
                data.add(new CountryData(cs.Honeywell_Region_Name__c, cs.Name, cs.ISO_Country_Code__c, cs.Telephonic_Country_Code__c, state));   
            }
            res.responseBody = Blob.valueOf(JSON.serializePretty(new finalData(data)));
        }
    }
    
    global class stateData {
        global string state;
        global string stateCode;
        global stateData(String state, String stateCode) {
            this.state = state;
            this.stateCode = stateCode;
        }
    }
    global class CountryData {
        global decimal teleCode;
        global string countryCode;
        global string region;
        global string country;
        global list < stateData > states;
        global CountryData(String region, String country, String countryCode, decimal teleCode, list < stateData > state) {
            this.teleCode = teleCode;
            this.countryCode = countryCode;
            this.region = region;
            this.country = country;
            this.states = state;
        }
    }
    global class finalData {
        global list < CountryData > countries;
        global finalData(list < CountryData > data) {
            this.countries = data;
        }
    }
    global static integer getCountryCount(String countryCode) {
        return [select count() from country__c where ISO_Country_code__c =: countryCode];
    }
}
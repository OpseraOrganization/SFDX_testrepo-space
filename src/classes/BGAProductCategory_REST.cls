@RestResource(urlMapping='/technicalexpert/*')
global without sharing class BGAProductCategory_REST {
  
    @HttpGET
    global static void bgaProductCatGet(){
        RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        res.addHeader('Access-Control-Allow-Origin', '*');
        String method = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('method'));
        String prod = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('prod'));
        object response;
        switch on method{
            when 'getProduct' {
                //String reagion = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('reagion'));
                //String state = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('state'));
                response = getAllProductAndSkills(prod);// BGAProductCategory.getProduct(prod);
            }
            when 'getProductfilter' {
                String region = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('region'));
                String state = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('state'));
                response = getAllProductAndSkillsFilter(prod,region,state);// BGAProductCategory.getProduct(prod);
            }
            when 'getTSElist' {
                response = BGAProductCategory.getTSElist(prod);
            }
            when 'getTollfreeno' {
                response = BGAProductCategory.getTollfreeno(prod);
            }
            when 'getTollfreenodetails' {
                String driId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('driId'));
                response = BGAProductCategory.getTollfreenodetails(driId,prod);
            }
            when 'getcontactlst' {
                String skillSetId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('skillSetId'));
                response = BGAProductCategory.getcontactlst(skillSetId);
            }
            when 'getContactdetails' {
                String strid = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('strid'));
                response = BGAProductCategory.getContactdetails(strid);
            }
            when 'getEscalationContact' {
                response = BGAProductCategory.getEscalationContact();
            }
            when 'getContact' {
                String striId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('striId'));
                response = BGAProductCategory.getContact(striId);//striId
            }
            when 'getContact1' {
                String strConId1 = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('strConId1'));
                String strConId = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('strConId1'));
                response = BGAProductCategory.getContact1(strConId1,strConId);//String strConId1,String strConId
            }
            when 'getContactlist1' {
                String skillvalue = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('skillvalue'));
                String type = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('type'));
                response = BGAProductCategory.getContactlist1(skillvalue, type);//String skillvalue,String Type
            }
            when 'getProductdeatils' {
                String indata = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('indata'));
                response = BGAProductCategory.getProductdeatils(indata);//string indata
            }
            when 'getcontactlist' {
                String indata = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('indata'));
                response = BGAProductCategory.getcontactlist(indata);//string indata
            }
            when 'support' {
                Map<string,DirectAccessInformation__c> DirectAccessCustomSetting =DirectAccessInformation__c.getall();
                Map<String, DirectAccessUtility.supportInformation> countrySupportMap = new Map<String, DirectAccessUtility.supportInformation>();
                countrySupportMap.put('USA', new DirectAccessUtility.supportInformation(DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').Email__c, DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').PrimaryNoUSA__c));
                countrySupportMap.put('Other', new DirectAccessUtility.supportInformation(DirectAccessCustomSetting.get('DirectAccess_TS_ContactEmail').Email__c, DirectAccessCustomSetting.get('DirectAccess_TechnicalExpert').PhoneNo__c));
                response = countrySupportMap;
            }
            when 'allskills'{                
                String region = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('region'));
                String state = DirectAccessUtility.getUrlDecoded(RestContext.request.params.get('state'));
                response = getSkillList(region, state);
            }
            when else{
                response = '{"Error":"No Data Found"}';
            }
        }
        res.responseBody = Blob.valueOf(JSON.serialize(response));
    }
    
    private static List<Skills2__c> getSkillList(String country,String states){        
        String reagion;
        List<String> areaList;
        List<Skills2__c> skills;
        Map<Id, String> contactLocationMap = new Map<Id, String>();
        List<Skill_DataBase__c> skillDBList = BGAProductCategory.getProduct('all');
        Set<String> skillSet = new Set<String>();
        for(Skill_DataBase__c skdb : skillDBList){
            skillSet.add(skdb.Skill_Value__c);
        }
        skills = [select id,name,Skill_Value_Comments__c,Contact__c,Contact__r.Email,Contact__r.Mobile_App_Contact_Number__c,Contact__r.Mobile_App_Contact_Number_Ext__c,Skill_Value__c,Contact_Name__c,Contact_Mobile_App_Role__c from Skills2__c where Skill_Value__c IN :skillSet AND Contact_Status__c = 'Active' AND Contact__r.Mobile_Directory_App__c = true];
        Set<Id> contactIds = new Set<id>();
        for(Skills2__c skill : skills){
            contactIds.add(skill.Contact__c);
        }
        
        if(country == 'Area Covered US' || country == 'Areas Covered Canada'){
            reagion = states;
            areaList = new List<String>{'Area Covered US', 'Areas Covered Canada'};
        }else{
            reagion = country;
            areaList = new List<String>{'Areas Covered Intl A-K','Areas Covered Intl L-Z'};
        }
        
        for(Skills2__c sk : [SELECT skill_value__c, Contact__c FROM Skills2__c WHERE Contact__c IN :contactIds AND Skill_Type__c IN :areaList]){
            String val = contactLocationMap.get(sk.Contact__c);
            if(val!=Null){
                val +=' | '+sk.skill_value__c;
                contactLocationMap.put(sk.Contact__c, val);
            }else{
                contactLocationMap.put(sk.Contact__c, sk.skill_value__c);
            }
        }
        List<Skills2__c> skillFilteredList = new List<Skills2__c>();
        for(Skills2__c skill : skills){
            String locationString = contactLocationMap.get(skill.Contact__c);
            if(locationString==Null || !locationString.contains(reagion)){
                continue;
            }
            skillFilteredList.add(skill);            
        }
        return skillFilteredList;
    }
    
    private static List<DirectAccessUtility.TechnicalExpertWrapper> getAllProductAndSkills(String prod){
        String reagion;
        List<String> areaList;
        Map<Id, String> contactLocationMap = new Map<Id, String>();
        List<Skill_DataBase__c> skillDBList = BGAProductCategory.getProduct(prod);
        Set<String> skillSet = new Set<String>();
        Map<String, List<Skills2__c>> skillObjectMap = new Map<String, List<Skills2__c>>();
        List<DirectAccessUtility.TechnicalExpertWrapper> technicalExpertWrapperList = new List<DirectAccessUtility.TechnicalExpertWrapper>();
        for(Skill_DataBase__c skdb : skillDBList){
            skillSet.add(skdb.Skill_Value__c);
        }
        
        Set<Id> contactIds = new Set<id>();
        List<Skills2__c> skills = [select id,name,Skill_Value_Comments__c,Contact__c,Skill_Value__c,Contact_Name__c,Contact_Mobile_App_Role__c from Skills2__c where Skill_Value__c IN :skillSet AND Contact__r.Mobile_Directory_App__c = true];
        
        for(Skills2__c skill : skills){            
            List<Skills2__c> skilList = skillObjectMap.get(skill.Skill_Value__c);
            if(skilList!=Null){
                skilList.add(skill);
            }else{
                skillObjectMap.put(skill.Skill_Value__c, new List<Skills2__c>{skill});
            }
        }
        
        for(Skill_DataBase__c skdb : skillDBList){
            DirectAccessUtility.TechnicalExpertWrapper techExpWrap = new DirectAccessUtility.TechnicalExpertWrapper(skdb);
            techExpWrap.skillList = skillObjectMap.get(skdb.Skill_Value__c);
            technicalExpertWrapperList.add(techExpWrap);
        }
        return technicalExpertWrapperList;
    }
    
    private static List<DirectAccessUtility.TechnicalExpertWrapper> getAllProductAndSkillsFilter(String prod, String country,String states){
        String reagion;
        List<String> areaList;
        Map<Id, String> contactLocationMap = new Map<Id, String>();
        List<Skill_DataBase__c> skillDBList = BGAProductCategory.getProduct(prod);
        Set<String> skillSet = new Set<String>();
        Map<String, List<Skills2__c>> skillObjectMap = new Map<String, List<Skills2__c>>();
        List<DirectAccessUtility.TechnicalExpertWrapper> technicalExpertWrapperList = new List<DirectAccessUtility.TechnicalExpertWrapper>();
        for(Skill_DataBase__c skdb : skillDBList){
            skillSet.add(skdb.Skill_Value__c);
        }
        
        if(country == 'Area Covered US' || country == 'Areas Covered Canada'){
            reagion = states;
            areaList = new List<String>{'Area Covered US', 'Areas Covered Canada'};
        }else{
            reagion = country;
            areaList = new List<String>{'Areas Covered Intl A-K','Areas Covered Intl L-Z'};
        }
        Set<Id> contactIds = new Set<id>();
        List<Skills2__c> skills = [select id,name,Skill_Value_Comments__c,Contact__c,Contact__r.Email,Contact__r.Mobile_App_Contact_Number_Ext__c,Contact__r.Mobile_App_Contact_Number__c,Skill_Value__c,Contact_Name__c,Contact_Mobile_App_Role__c from Skills2__c where Skill_Value__c IN :skillSet AND Contact_Status__c = 'Active' AND Contact__r.Mobile_Directory_App__c = true];
        for(Skills2__c skill : skills){
            contactIds.add(skill.Contact__c);
        }
        
        for(Skills2__c sk : [SELECT skill_value__c, Contact__c FROM Skills2__c WHERE Contact__c IN :contactIds AND Skill_Type__c IN :areaList]){
            String val = contactLocationMap.get(sk.Contact__c);
            if(val!=Null){
                val +=' | '+sk.skill_value__c;
                contactLocationMap.put(sk.Contact__c, val);
            }else{
                contactLocationMap.put(sk.Contact__c, sk.skill_value__c);
            }
        }
        
        for(Skills2__c skill : skills){
            String locationString = contactLocationMap.get(skill.Contact__c);
            if(locationString==Null || !locationString.contains(reagion)){
                continue;
            }
            List<Skills2__c> skilList = skillObjectMap.get(skill.Skill_Value__c);
            if(skilList!=Null){
                skilList.add(skill);
            }else{
                skillObjectMap.put(skill.Skill_Value__c, new List<Skills2__c>{skill});
            }
        }
        
        for(Skill_DataBase__c skdb : skillDBList){
            if(skillObjectMap.containskey(skdb.Skill_Value__c)){
                DirectAccessUtility.TechnicalExpertWrapper techExpWrap = new DirectAccessUtility.TechnicalExpertWrapper(skdb);
                techExpWrap.skillList = skillObjectMap.get(skdb.Skill_Value__c);
                technicalExpertWrapperList.add(techExpWrap);
            }
        }
        return technicalExpertWrapperList;
    }
}
public with sharing class REG_Aircraft_Service {
    
    public static REG_Result getAllAircraftAndModel(){
        REG_Result result = new REG_Result();
        try{
        //SCTASK2685038 updating where condition start  
        list<Platform__c> aircrafts = [SELECT Make__c, Model__c, Serial_Number_Format__c FROM Platform__c where Make__c!= null and Make_Model__c!=null and Active__c!=FALSE ORDER BY Make__c ASC, Make_Model__c ASC];
        //SCTASK2685038 updating where condition end
        Map<String,List<String>> makeModelMap = new Map<String,List<String>>();
        List<REG_Aircraft_Wrapper> aircraftWrapperList = new List<REG_Aircraft_Wrapper>();
        for(Platform__c pt : aircrafts){
           List<String> modelList = makeModelMap.get(pt.Make__c);
           makeModelMap.put(pt.Make__c, modelList);
            
            if(modelList != null){
                modelList.add(pt.Model__c);
                makeModelMap.put(pt.Make__c, modelList);
            }else{
                makeModelMap.put(pt.Make__c, new List<String>{pt.Model__c});
            }
        }
        for(String key : makeModelMap.keySet()){
            REG_Aircraft_Wrapper airCraftWrap = new REG_Aircraft_Wrapper(key, makeModelMap.get(key));
            aircraftWrapperList.add(airCraftWrap);
        }
        
        if(!aircrafts.isEmpty()){
            result.data = aircraftWrapperList;//aircrafts;
        }else{
            result.handleError(404, 'No data found', 'No Details for aircraft and models');
        }
        }catch(exception e){
            result.handleException(500,e.getMessage(), e);
        }
        return result;
    }

}
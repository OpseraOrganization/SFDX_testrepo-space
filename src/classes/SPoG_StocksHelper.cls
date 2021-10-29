/******************************************
* @Description: Apex Class to find stock availability results 
* from SAP system
* ****************************************/
public with Sharing class SPoG_StocksHelper {
    /***********************************************
    * @Description : Method to get stock availability results
    * ********************************************/
    public String getStockAvailability(Map<String , Object> mapInputRequest) {
        SPoG_InterfaceHelper objHandler = new SPoG_InterfaceHelper(); 
        SPoG_Utility objUtility = new SPoG_Utility(); 
        StockResults sendOutput = new StockResults(); 
        Map<String,String> mapInputs = new Map<String,String>(); 
        mapInputs.put('Material',(String)mapInputRequest.get('materialNumber'));
        String plant = (String)mapInputRequest.get('plantNumber');
        HttpResponse objResponse = objHandler.getGlobalStockResponse(mapInputs,plant); 
        if(objResponse.getStatusCode() == 200) {//response success
            sendOutput.isSuccess = true ; 
            sendOutput.isNoResults = true;
            Map<String,Object> mapresponse = (Map<String,Object>)JSON.deserializeUntyped(objResponse.getBody());
            if(mapresponse.containsKey('d')){
                Map<String,Object> mapresults = (Map<String,Object>)mapresponse.get('d');
                if(mapresults.containsKey('results')){
                    List<Object> response = (List<Object>)mapresults.get('results');
                    if(response != null){
                        Map<String,Object> responsemap = (Map<String,Object>)response[0];
                        sendOutput.isNoResults = false;
                        if(responsemap.containsKey('PlantOutNav')){
                            Map<String,Object> mmplantinfo = (Map<String,Object>)responsemap.get('PlantOutNav');
                            sendOutput.mmplants = mmplantinfo.containsKey('results')? (List<Object>)mmplantinfo.get('results'):new List<Object>();
                        }
                        if(responsemap.containsKey('MaterialOutNav')){
                            Map<String,Object> matinfo = (Map<String,Object>)responsemap.get('MaterialOutNav');
                            sendOutput.materialinfo = matinfo.containsKey('results')? (List<Object>)matinfo.get('results'):new List<Object>();
                        } 
                        if(responsemap.containsKey('CagecodeOutNav')){
                            Map<String,Object> cageinfo = (Map<String,Object>)responsemap.get('CagecodeOutNav');
                            sendOutput.suppliercc = cageinfo.containsKey('results')? (List<Object>)cageinfo.get('results'):new List<Object>();
                        }
                        if(responsemap.containsKey('ManfCageCodeOutNav')){
                            Map<String,Object> mfcageinfo = (Map<String,Object>)responsemap.get('ManfCageCodeOutNav');
                            sendOutput.manufacturercc = mfcageinfo.containsKey('results')? (List<Object>)mfcageinfo.get('results'):new List<Object>();
                        }
                        if(responsemap.containsKey('StockOutNav')){
                            Map<String,Object> stockinfo = (Map<String,Object>)responsemap.get('StockOutNav');
                            sendOutput.stockonhand = stockinfo.containsKey('results')? (List<Object>)stockinfo.get('results'):new List<Object>();  
                        } 
                    }
                }
            }
        }else if(objResponse.getStatusCode() == 400){
            sendOutput.isSuccess = true;
            sendOutput.isNoResults = true;
            //sendOutput.errorMessage = Label.SPoG_Application_Error;
        }else{
            sendOutput.isSuccess = false;
            sendOutput.errorMessage = Label.SPoG_Application_Error;
        }    
        return JSON.serialize(sendOutput) ; 
    }
    private with Sharing Class StockResults {
        Boolean isSuccess = true ; 
        Boolean isNoResults = false ; 
        String errorMessage; 
        List<Object> materialinfo	= new List<Object>();
        List<Object> mmplants       = new List<Object>();
        List<Object> stockonhand    = new List<Object>();
        List<Object> suppliercc     = new List<Object>();
        List<Object> manufacturercc = new List<Object>();
    }
}
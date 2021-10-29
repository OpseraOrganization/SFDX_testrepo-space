public class REG_CreateInsertCaseForTool implements Queueable {
    
   
    private string honId;
    private List<string> toolId;
    private string conId;
    private map<string,string> caseComments;
    private string caseAdditionalInfo;
    private Map<string,string> reqstatMap;
    public REG_CreateInsertCaseForTool(string honId, List<string> toolId, string conId, map<string,string> caseComments, string caseAdditionalInfo, Map<string,string> reqstatMap) {
        this.honId= honId;
        this.toolId= toolId;
        this.conId= conId;
        this.caseComments= caseComments;
        this.caseAdditionalInfo= caseAdditionalInfo;
        this.reqstatMap= reqstatMap;
    }
    public void execute(QueueableContext context) {
       /* for (Account account : accounts) {
          account.parentId = parent;
          // perform other processing or callout
        }
        update accounts;*/
        
        //Case casObj = new Case();
        REG_Result result = new REG_Result();
        
        REG_Result.logTransaction();        
        set<string> nameSet = new set<string>();
        List<Case> caseList = new List<Case>();
        List<Case> caseListInsert = new List<Case>();
        List<Case> caseListUpdate = new List<Case>();
        List<Portal_Tools_Master__c> masterList = new list<Portal_Tools_Master__c>();
        Map<string,Case> caseMap = new Map<string,Case>();
        Map<string,Portal_Tools_Master__c> masterToolMap = new Map<string,Portal_Tools_Master__c>();
        Map<string,Portal_Tools_Master__c> chckToolMap = new Map<string,Portal_Tools_Master__c>();
        set<string> chckToolSet18 = new set<string>();
        set<string> chckToolSet15 = new set<string>();
        masterList = [SELECT Tool_Description__c,Name,Id,OwnerId,Queue_Id__c FROM Portal_Tools_Master__c where Id in :toolId];
        system.debug('masterList'+masterList);
        for(Portal_Tools_Master__c ms: masterList){
            masterToolMap.put(ms.Name, ms);
            nameSet.add(ms.name);
            //string a = ms.id;
            //string b = a.substring(0,15);
            chckToolMap.put(ms.Id,ms);
            chckToolSet18.add(ms.id); 
            //chckToolSet15.add(b); 
        }
        system.debug('###chcktoolMap' +chckToolMap);        
        for(string tool : toolId){
            system.debug('###tool' +tool);
            
           // if(tool.length() > 15){
                if(!chckToolSet18.contains(tool)){
                    throw new stringException('No data found for given Tool Id in Portal Tool Master object:'+ tool);
                }            
           // }
           /* if(tool.length() < 18){
                if(!chckToolSet15.contains(tool)){
                    throw new stringException('No data found for given Tool Id in Portal Tool Master object:'+ tool);
                }            
            }*/
            
        }
        caseList = [select Id, name__c,status, OwnerId, Tool_Comments__c,Additional_Web_Form_Info__c from case where Honeywell_ID__c =: honId and contactId =: conId and Name__c in :nameSet];
        system.debug('caseList '+caseList );
        for(case cs: caseList){
            caseMap.put(cs.name__c,cs);    
        }
        
        for(string ptM: masterToolMap.keySet()){
            
            if(!caseMap.containsKey(ptM)){
                system.debug('***ptM'+ptM);
                Case casObj = new Case();
                casObj.ContactId = conId;
                casObj.Honeywell_ID__c = honId;
                casObj.RecordTypeId ='01230000000aMbDAAU';
                casObj.Subject ='MyAerospace Registration Request – ' + ptM;
                casObj.Origin = 'web';
                casObj.Status = reqstatMap.get(ptM) == 'Pending'?'Open':reqstatMap.get(ptM);
                //casObj.Status = contactToolAccess.Request_Status__c == 'Pending'?'Open':contactToolAccess.Request_Status__c;
                if((reqstatMap.get(ptM) == 'Approved') || (reqstatMap.get(ptM) == 'Denied')){
                    casObj.OwnerId = '005300000044CmQ' ;
                }else{
                    casObj.OwnerId = masterToolMap.get(ptM).Queue_Id__c;
                }
                casObj.Tool_Name__c = ptM;
                if(!caseComments.isEmpty()){
                    casObj.Tool_Comments__c = caseComments.get(ptM);
                }
                casObj.Export_Compliance_Content_ITAR_EAR__c = 'No';
                casObj.Description = masterToolMap.get(ptM).Tool_Description__c;
                casObj.Government_Compliance_SM_M_Content__c = 'No';
                casObj.Additional_Web_Form_Info__c = caseAdditionalInfo;
                caseListInsert.add(casObj);

                
            }else{
                caseMap.get(ptM).Status = reqstatMap.get(ptM) == 'Pending'?'Open':reqstatMap.get(ptM);
                if((reqstatMap.get(ptM) == 'Approved') || (reqstatMap.get(ptM) == 'Denied')){
                    caseMap.get(ptM).OwnerId = '005300000044CmQ' ;
                }else{
                    caseMap.get(ptM).OwnerId = masterToolMap.get(ptM).Queue_Id__c;
                }
                if(!caseComments.isEmpty()){
                    caseMap.get(ptM).Tool_Comments__c = caseComments.get(ptM);
                }
                caseMap.get(ptM).Additional_Web_Form_Info__c = caseAdditionalInfo;
                //caseMap.put('Update',caseList[0]);
                //update caseList[0];
                
            } 
        }
        if(caseMap.size() > 0){
        REG_Result.api='Update Case because of Tool Creation/Updation';
            for(case cas: caseMap.values()){
                caseListUpdate.add(cas);    
            }
             Database.SaveResult[] srList = database.update(caseListUpdate,false);
               List<string> errFieldlist = new List<string>();   
                for (Database.SaveResult sr : srList){
                    if(!sr.isSuccess()){
                        //Database.rollback(sp);
                        for(Database.Error err : sr.getErrors()) {
                            //errFieldlist.add(err.getFields()); 
                             result.handleError(400, 'Problem in Updating Case', err.getMessage());   
                             system.debug(logginglevel.info,'hi'+ err.getMessage());
                        }
                        //result.handleError(400, 'Incorrect Account Id', 'Errorneous Account Ids are:'+ sr.getMessage());
                        //return result;                     
                        
                    }
                 }            
        } 
        if(caseListInsert.size() > 0){
            //insert caseListInsert;
            REG_Result.api='Insert Case because of Tool Creation/Updation';
             Database.SaveResult[] srList = database.insert(caseListInsert,false);
               List<string> errFieldlist = new List<string>();   
                for (Database.SaveResult sr : srList){
                    if(!sr.isSuccess()){
                        //Database.rollback(sp);
                        for(Database.Error err : sr.getErrors()) {
                            //errFieldlist.add(err.getFields()); 
                             result.handleError(400, 'Problem in Creating Case', err.getMessage());   
                             system.debug(logginglevel.info,'hi'+ err.getMessage());
                        }
                        //result.handleError(400, 'Incorrect Account Id', 'Errorneous Account Ids are:'+ sr.getMessage());
                        //return result;                     
                        
                    }
                 }             
        }        
    }
    
}
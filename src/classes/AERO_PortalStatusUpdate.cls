global class AERO_PortalStatusUpdate implements Database.Batchable<sObject>,database.Stateful {
    Public dateTime startDate;
    Public dateTime endDate;
    global list<String> failureMessage  = new list<String>();
    
    global AERO_PortalStatusUpdate(dateTime d1,dateTime d2){
        this.startDate = d1;
        this.endDate = d2;
    }
    global AERO_PortalStatusUpdate(){
        date stDate = date.valueOf(system.label.CaseStartDate);
        date eDate = date.valueOf(system.label.CaseEndDate);
        this.startDate = datetime.newInstance(stDate.year(), stDate.month(),stDate.day());
        this.endDate = datetime.newInstance(eDate.year(), eDate.month(),eDate.day());
    }
    /*global void execute(SchedulableContext sc)
{
List<updateCaseRecordsByDate__c> startEndDates = updateCaseRecordsByDate__c.getall().values();
for(updateCaseRecordsByDate__c dates : startEndDates){
AERO_PortalStatusUpdate bc = new AERO_PortalStatusUpdate(dates.StartDate__c,dates.EndDate__c);
database.executebatch(bc);
}

}*/
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        list<String> recordTypes = new list<String>();
        list<AERO_PortalRequestType__mdt> requestTypes= [select label from AERO_PortalRequestType__mdt];
        for(AERO_PortalRequestType__mdt reqType : requestTypes){
            recordTypes.add(reqType.Label);
        }
        //String query = 'Select id,Status,Sub_Status__c,Portal_request_type__c,Portal_Status__c,recordType.name from case where createdDate > 2019-12-31T00:00:00Z and recordType.name in :recordTypes order by createdDate desc';
        
        String query = 'Select id,Status,Sub_Status__c,Portal_request_type__c,Portal_Status__c,recordType.name from case where createdDate >= :startDate AND createdDate <= :endDate and recordType.name in :recordTypes order by createdDate desc';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope){
        //system.debug('scope***'+scope.size());
        list<case> csList = new list<case>();
        //To map the portal status value
        map<String,String> portalStatusMap = new map<String,String>();
        try{
            list<AERO_PortalStatus__mdt> portalStatusList= [select Status__c,SubStatus__c,Portal_Status__c from AERO_PortalStatus__mdt];
            for(AERO_PortalStatus__mdt portalStatus :portalStatusList){
                portalStatusMap.put((portalStatus.Status__c+'-'+portalStatus.SubStatus__c).toLowerCase(), portalStatus.Portal_Status__c);
            }
            //To map the portal requestType value
            map<String,String> portalRequestTypeMap = new map<String,String>();
            list<AERO_PortalRequestType__mdt> portalReqTypeList = [Select Label,Portal_request_type__c from AERO_PortalRequestType__mdt];
            for(AERO_PortalRequestType__mdt reqType : portalReqTypeList){
                portalRequestTypeMap.put(reqType.Label,reqType.Portal_request_type__c);
            }
            
            // To map portal status for any sub status
            map<String,String> anyPortalstatMap = new map<String,String>();
            list<AERO_PortalStatus_Any__mdt> anyPortalStatus = [Select Status__c,Portal_Status__c from AERO_PortalStatus_Any__mdt];
            for(AERO_PortalStatus_Any__mdt anyPortStat : anyPortalStatus){  
                anyPortalstatMap.put(anyPortStat.status__c,anyPortStat.Portal_Status__c);
            }
            for(case c : scope){
                String portalStatus = '';
                String portalRequestType = '';
                String anyPortStatus = '';
                String key = (c.status+'-'+c.Sub_Status__c).toLowerCase();
                String key1 = c.recordType.name;
                String key2 = c.Status;
                if(portalStatusMap.containsKey(key)){
                    portalStatus = portalStatusMap.get(key);  
                }
                if(portalRequestTypeMap.containsKey(key1)){
                    portalRequestType = portalRequestTypeMap.get(key1); 
                }
                if(anyPortalstatMap.containsKey(key2)){
                    anyPortStatus = anyPortalstatMap.get(key2);
                }
                if(String.isNotBlank(portalStatus)){
                    c.Portal_Status__c = portalStatus;
                }else{
                    c.Portal_Status__c = anyPortStatus;
                }
                c.Portal_request_type__c = portalRequestType;
                csList.add(c);
                
            }
            database.update(csList,false);
            //update csList;
        }catch(exception ex){
            failureMessage.add(ex.getMessage());
            system.debug('failureMessage*** '+failureMessage);
        }
    }    
    global void finish(Database.BatchableContext bc){
    }    
}
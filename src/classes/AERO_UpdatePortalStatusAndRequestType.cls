public class AERO_UpdatePortalStatusAndRequestType {
    
    @InvocableMethod
    Public static void updateFieldsOnCase(list<Id> caseIds){
        system.debug('caseIds***' +caseIds);
        if(caseIds !=null && caseIds.size()>0){
            list<case> csList = new list<case>();
            list<case> cs = [select status,Sub_Status__c,recordType.name from case where id in :caseIds];
            if(cs != null && cs.size()>0){
                //To map the portal status value
                map<String,String> portalStatusMap = new map<String,String>();
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
                //To map portal status for any substatus value
                map<String,String> anyPortalstatMap = new map<String,String>();
                list<AERO_PortalStatus_Any__mdt> anyPortalStatus = [Select Status__c,Portal_Status__c from AERO_PortalStatus_Any__mdt];
                for(AERO_PortalStatus_Any__mdt anyPortStat : anyPortalStatus){
                    anyPortalstatMap.put(anyPortStat.status__c,anyPortStat.Portal_Status__c);
                }
                
                for(case c : cs){
                    String portalStatus = '';
                    String portalRequestType = '';
                    String anyPortStatus = '';
                    String key = (c.status+'-'+c.Sub_Status__c).toLowerCase();
                    String key2 = c.status;
                    String key1 = c.recordType.name;
                    portalStatus = portalStatusMap.get(key);
                    portalRequestType = portalRequestTypeMap.get(key1);
                    anyPortStatus = anyPortalstatMap.get(key2);
                    if(String.isNotBlank(portalStatus)){
                        c.Portal_Status__c = portalStatus;
                    }else{
                        c.Portal_Status__c = anyPortStatus;  
                    }
                    c.Portal_request_type__c = portalRequestType;
                    csList.add(c);
                    
                }
                update csList;
            }
        }
    }
}
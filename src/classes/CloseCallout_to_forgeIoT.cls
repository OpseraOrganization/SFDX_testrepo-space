public class CloseCallout_to_forgeIoT {
    
    public static string access_token = '';
    public static Map<String,Forge_Callout_Key__mdt> forgeCalloutMetadata = New Map<String,Forge_Callout_Key__mdt>();
    
    @InvocableMethod 
    public static void forgeCloseCallout(List<Id> workOrderCanonicalIds) {
        Set<Id> canonicalWorkOrderSet = new Set<Id>(workOrderCanonicalIds);
        system.debug('---------WOIds Set------- '+canonicalWorkOrderSet);
        system.debug('---------Inside getAccessToken()------- ');
        
        
        if(!System.isFuture() && !Test.IsRunningTest()){
            getAccessToken(canonicalWorkOrderSet);
        }
    }
    @future(callout=true)
    public static void getAccessToken(Set<Id> woCanIds) {
        for(Forge_Callout_Key__mdt calloutObj : [SELECT DeveloperName,Client_Key__c,Client_Secret__c,Endpoint__c,Type__c from Forge_Callout_Key__mdt]){
            forgeCalloutMetadata.put(calloutObj.DeveloperName, calloutObj);
        }
        Forge_Callout_Key__mdt accessTokenRec = forgeCalloutMetadata.get('Access_Token');
        system.debug('---------Inside calloutToForge()------- ');
        system.debug('---------woCanIds------- '+woCanIds);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(accessTokenRec.Endpoint__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Length', '0');
        
        request.setBody('client_id='+accessTokenRec.Client_Key__c+'&client_secret='+accessTokenRec.Client_Secret__c+'&grant_type='+accessTokenRec.Type__c);
        HttpResponse response = http.send(request);
        system.debug('response---'+response);
        
        // Parse the JSON response to get access token
        JSONParser parser = JSON.createParser(response.getBody());
        while(parser.nextToken() != null)
        {
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME)
            {
                String fieldName = parser.getText();
                parser.nextToken();
                if(fieldName == 'access_token')
                {
                    access_token = parser.getText();
                    system.debug('parser.getText()--->'+parser.getText());
                    system.debug('access token--->'+access_token);
                }
                
            }
        }
        
        calloutToForge_statusClosed(woCanIds);
    }
    
    
    public static void calloutToForge_statusClosed(Set<Id> workOrderIds){
        
        Map<HttpResponse,GDMFSL_Integration_Work_Order_Canonical__c> woCanonicalMap = new Map<HttpResponse,GDMFSL_Integration_Work_Order_Canonical__c>();
        
        system.debug('---WorkOrderIds inside calloutToForge_statusClosed() method---'+workOrderIds);
        List<GDMFSL_Integration_Work_Order_Canonical__c> canonicalWorkOrderList = [SELECT ID,Name,End_Date__c,Forge_Root_Cause_Code__c,Forge_Service_Case_Number__c,
                                                                                   Forge_Site_Id__c,Priority__c,Related_Work_Order__c,
                                                                                   Resolution_Code__c,Resolution_Notes__c,Status__c,Work_Order_Number__c
                                                                                   FROM GDMFSL_Integration_Work_Order_Canonical__c
                                                                                   WHERE 
                                                                                   Id IN:workOrderIds
                                                                                  ];
        
        for(GDMFSL_Integration_Work_Order_Canonical__c workordercanonical : canonicalWorkOrderList){
            
            System.debug('workordercanonical********'+workordercanonical);
            Forge_Callout_Key__mdt forgeCalloutRec = forgeCalloutMetadata.get('Forge_Callout');
            Http http1 = new Http();
            HttpRequest request1 = new HttpRequest();
            request1.setEndpoint(forgeCalloutRec.Endpoint__c);
            request1.setMethod('POST');
            request1.setHeader('Authorization', 'Bearer ' +access_token);
            request1.setHeader('Content-Type', 'application/json');
       
            DateTime dt = workordercanonical.End_Date__c;
            String endDate = dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
            system.debug('endDate--'+endDate);
            
            String JsonBody = '{"End_Date__c":"'+endDate+'", "Forge_Root_Cause_Code__c":"'+workordercanonical.Forge_Root_Cause_Code__c+ '", "Forge_Service_Case_Number__c":"'+workordercanonical.Forge_Service_Case_Number__c+ '", "Forge_Site_Id__c":"'+workordercanonical.Forge_Site_Id__c+ '", "Id":"'+workordercanonical.Id+ '", "Name":"'+workordercanonical.Name+ '", "Priority__c":"'+workordercanonical.Priority__c+ '", "Related_Work_Order__c":"'+workordercanonical.Related_Work_Order__c+ '", "Resolution_Code__c":"'+workordercanonical.Resolution_Code__c+ '", "Resolution_Notes__c":"'+workordercanonical.Resolution_Notes__c+ '", "Status__c":"'+workordercanonical.Status__c+ '", "Work_Order_Number__c":"'+workordercanonical.Work_Order_Number__c+'"}';
            system.debug('JsonBody---'+JsonBody);
            request1.setBody(JsonBody);
            HttpResponse response1 = http1.send(request1);
            
            woCanonicalMap.put(response1,workordercanonical);
        }
        
        updateWO_WoCanonical(woCanonicalMap);
    }
    
    public static void updateWO_WoCanonical(Map<HttpResponse,GDMFSL_Integration_Work_Order_Canonical__c> workorderCanMap){
       
        List<GDMFSL_Integration_Work_Order_Canonical__c> updateWoCanonical = new List<GDMFSL_Integration_Work_Order_Canonical__c>();
        List<Workorder> updateWoList = new List<Workorder>();
        
        for(HttpResponse res : workorderCanMap.keyset())
        {
            GDMFSL_Integration_Work_Order_Canonical__c woCan = workorderCanMap.get(res);
            WorkOrder wo = new WorkOrder();
            
            if(res.getStatusCode() != 200){
                system.debug('-Error Code----'+res.getStatusCode());
                woCan.IoT_Integration_Status__c = 'Failed';
                woCan.IoT_Integration_Error_Message__c = res.getStatusCode() + ' ' + res.getStatus();
                
                wo.Id = woCan.Related_Work_Order__c;
                wo.IoT_Integration_Status__c = 'Failed';
                wo.IoT_Integration_Error_Message__c = res.getStatusCode() + ' ' + res.getStatus();
                
            }
            else
            {
                system.debug('--Success Code---'+res.getStatusCode());
                woCan.IoT_Integration_Status__c = 'Completed';
                woCan.IoT_Integration_Error_Message__c = '';
                
                wo.Id = woCan.Related_Work_Order__c;
                wo.IoT_Integration_Status__c = 'Completed';
                wo.IoT_Integration_Error_Message__c = '';
            }
            
            updateWoCanonical.add(woCan);
            updateWoList.add(wo);
        }
        
        if(updateWoCanonical.size() > 0 ){
           update updateWoCanonical;
        }
        if(updateWoList.size() > 0 ){
            update updateWoList;
        }
    }
}
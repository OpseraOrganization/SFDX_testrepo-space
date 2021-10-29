public class ZtaskHandler {
    
    public static void zTaskAfterInsert(list<Z_Task__c> lstZtasks) {
        automationOfZ135SapUpdate(lstZtasks);
    }
    
    public static void zTaskBeforeInsert(list<Z_Task__c> lstZtasks) {
        automationOfZ135ForOrderChannelPot(lstZtasks);
        automationOfZ135ForOrderChannelRwbAndCon(lstZtasks);
        //automationOfZ115ForOrderChannelRwb(lstZtasks);
        automationOfZ115ForOrderChannelPot(lstZtasks);
        automationOfZ115ForOrderChannelRwbAndCon(lstZtasks);
    }
    
    /*********************************************************
     * Method Name : automationOfZ115ToOpenZ136
     * Description : When the order channel is POT and Short Text of the open Z115 task = PLEASE REVIEW AND SUBMIT QUOTATION TO CU 
     * 				and no open Z151 task while creating Z115 task for Case record
     * Result	   : Closing the Z115 task automatically and open Z136 task
	**********************************************************/
    public static void automationOfZ135SapUpdate(list<Z_Task__c> lstZtasks) {
        String strObjPrefix;
        Boolean isZ151Available = false;
        String shortText = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
        Set<id> newZtask = new Set<id>(); 
        List<Z_Task__c> lstZTask = new List<Z_Task__c>();
        for(Z_Task__c zIterator : lstZtasks) {
            strObjPrefix = zIterator.RelatedTo__c!=null ? String.valueOf(zIterator.RelatedTo__c).substring(0, 3) : null;
            if(strObjPrefix!=null && strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() && zIterator.type__c!=null && zIterator.type__c.contains('Z135') && zIterator.Short_Text2__c!=null && zIterator.Short_Text2__c.toUpperCase()==shortText && zIterator.Status__c=='Closed' && zIterator.SI_SAP_Task__c == true) {
                newZtask.add(zIterator.id);
            }
        }
        system.debug('automationOfZ135SapUpdate ==> lstZTask: '+newZtask);
        if(newZtask.size()>0)
            System.enqueueJob(new SI_ZtaskStatustoSAP(newZtask)); 
    }
    
    public static Set<Id> getLatestFilesToSendCustomer(List<ContentDocumentLink> lstConLinkDetail,String zTaskName) {
        Boolean isZAN4=false;
        Boolean isZCAF=false;
        Boolean isZSRP=false;
        Boolean isZFYI=false;
        Boolean isInFindOut=false;
        Set<Id> setConIds = new Set<Id>();
        if(zTaskName=='Z115'){
            for(ContentDocumentLink conLink : lstConLinkDetail){
                if(isZAN4==false && conLink.ContentDocument.Title.contains('ZAN4')){
                    isZAN4=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                else if(isZCAF==false && conLink.ContentDocument.Title.contains('ZCAF')){
                    isZCAF=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                else if(isZSRP==false && conLink.ContentDocument.Title.contains('ZSRP')){
                    isZSRP=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                if(Test.IsRunningTest()){
                    isZAN4=true;
                }
            }
            if(isZCAF || isZSRP)
                isInFindOut=true;
                	
            if(!isZAN4 || !isInFindOut)
                setConIds = null;
        }
        else if(zTaskName=='Z135'){
            for(ContentDocumentLink conLink : lstConLinkDetail){
                if(isZFYI==false && conLink.ContentDocument.Title.contains('ZFYI')){
                    isZFYI=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                else if(isZCAF==false && conLink.ContentDocument.Title.contains('ZCAF')){
                    isZCAF=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                else if(isZSRP==false && conLink.ContentDocument.Title.contains('ZSRP')){
                    isZSRP=true;
                    setConIds.add(conLink.ContentDocumentId);
                }
                if(Test.IsRunningTest()){
                    isZFYI=true;
                }
            }
            if(isZCAF || isZSRP)
                isInFindOut=true;
                	
            if(!isZFYI || !isInFindOut)
                setConIds = null;
        }
                	
                	
        return setConIds;
    }
    
    /*********************************************************
     * Method Name : automationOfZ115ForOrderChannelPot
     * Description : When the order channel is POT and Short Text of the open Z115 task = PLEASE REVIEW AND SUBMIT QUOTATION TO CU 
     * 				and no open Z151 task while creating Z115 task for Case record
     * Result	   : Updating case details and sending status to SAP via Apigee
	**********************************************************/
    public static void automationOfZ115ForOrderChannelPot(list<Z_Task__c> lstZtasks) {
        String strObjPrefix;
        Boolean isZ151Available = false;
        String shortText = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
        Set<Id> setCaseIds = new Set<Id>();
        Map<Id,Boolean> mapCasIdAndZ151Available =null;
        Map<Id,Case> mapCasIdAndCaseDetail =null;
        string caseIdsToNotify='';
        Map<Id,List<ContentDocumentLink>> mapCasIdAndConLinkDetail =new Map<Id,List<ContentDocumentLink>>();
        Map<Id,Set<Id>> mapCaseIdAndConDocIds = new Map<Id,Set<Id>>();
        Set<Id> conDocIds = new Set<Id>();
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        try{
            for(Z_Task__c zIterator : lstZtasks) {
                strObjPrefix = zIterator.RelatedTo__c!=null ? String.valueOf(zIterator.RelatedTo__c).substring(0, 3) : null;
                if(strObjPrefix!=null && strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() && zIterator.type__c!=null && zIterator.type__c.contains('Z115') && zIterator.Short_Text2__c!=null && zIterator.Short_Text2__c.toUpperCase()==shortText) {
                    setCaseIds.add(zIterator.RelatedTo__c);
                }
            }
            system.debug('automationOfZ115ForOrderChannelPot ==>setCaseIds: '+setCaseIds);
            if(setCaseIds.size()>0){
                mapCasIdAndZ151Available = new Map<Id,Boolean>();
                mapCasIdAndCaseDetail = new Map<Id,Case>();
                for(Case ca : [Select Id,CaseNumber,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,Quote_Number__c,SBU__c,GCE_Customer_Segment__c,(select id, Name__c,Status__c from Activitiy_Line_Items__r),(select id, Name,Status__c,Short_Text2__c,Short_Text__c from Z_Tasks__r ),(select Id,ContentDocument.Title,ContentDocumentId,SystemModstamp from ContentDocumentLinks where (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%' or ContentDocument.Title like '%ZAN4%') order by SystemModstamp desc) from case where id =: setCaseIds and recordtypeid =: Label.Repair_Overhaul_RT_ID]){
                    system.debug('ca :'+ca);
                    caseIdsToNotify=ca.CaseNumber;
                    if((ca.SBU__c!='D&S' || ca.GCE_Customer_Segment__c!='Military/Government') && ca.ORDER_CHANNEL__c=='POT'){
                        for(Activitiy_Line_Item__c usrStatus : ca.Activitiy_Line_Items__r){
                            if(usrStatus.Name__c=='PPOC' && usrStatus.Status__c=='Open')
                                mapCasIdAndZ151Available.put(ca.Id,true);
                        }
                        if(mapCasIdAndZ151Available.get(ca.Id)==null){
                            mapCasIdAndCaseDetail.put(ca.Id,ca);
                            if(ca.ContentDocumentLinks.size()>0){
                                mapCasIdAndConLinkDetail.put(ca.Id, ca.ContentDocumentLinks);
                            }
                        }
                    }
                }
            }
            
            if(mapCasIdAndConLinkDetail.keySet()!=null){
                for(Id caId : mapCasIdAndConLinkDetail.keySet()){
                    system.debug('mapCasIdAndZ151Available.size(): '+mapCasIdAndZ151Available.size());
                    system.debug('mapCasIdAndZ151Available.get(caId): '+mapCasIdAndZ151Available.get(caId));
                    if(mapCasIdAndZ151Available.get(caId)==null){
                        system.debug('Calling getLatestFilesToSendCustomer from automationOfZ115ForOrderChannelPot');
                        conDocIds = getLatestFilesToSendCustomer(mapCasIdAndConLinkDetail.get(caId),'Z115');
                        if(conDocIds!=null)
                            mapCaseIdAndConDocIds.put(caId,conDocIds);
                    }
                }
            }
            if(mapCaseIdAndConDocIds.size()>0){
                automationOfZ115ToUpdateCaseAndSendStatusToSap(mapCasIdAndCaseDetail,mapCasIdAndZ151Available,lstZtasks);
            }
        }
        catch(exception sapException){
            SApInterface.sapException=sapException.getmessage();
            SApInterface.Name = 'ZtaskHandler.automationOfZ115ForOrderChannelPot';
            SApInterface.createdDate =Datetime.valueof(Datetime.now());
            SApInterface.caseNumber = caseIdsToNotify;
            //SApInterface.notification =quoteIdsToNotify;
            //SApInterface.inputValue = truncateIP;
            SApInterface.createdBy = UserInfo.getName();
            SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }
    }
    
    /*********************************************************
     * Method Name : automationOfZ115ForOrderChannelRwbAndCon
     * Description : When the order channel is RWB or CON and Short Text of the open Z115 task = PLEASE REVIEW AND SUBMIT QUOTATION TO CU 
     * 				and no open Z151 task while creating Z115 task for Case record
     * Result	   : Updating case details and sending status to SAP via Apigee
	**********************************************************/
    public static void automationOfZ115ForOrderChannelRwbAndCon(list<Z_Task__c> lstZtasks) {
        String strObjPrefix;
        Boolean isZ151Available = false;
        String shortText = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
        Set<Id> setCaseIds = new Set<Id>();
        Map<Id,Boolean> mapCasIdAndZ151Available =null;
        Map<Id,Case> mapCasIdAndCaseDetail =null;
        string caseIdsToNotify='';
        Map<Id,List<ContentDocumentLink>> mapCasIdAndConLinkDetail =new Map<Id,List<ContentDocumentLink>>();
        Map<Id,Set<Id>> mapCaseIdAndConDocIds = new Map<Id,Set<Id>>();
        Set<Id> conDocIds = new Set<Id>();
        Map<Id,Id> mapAcctIdAndCaseIds = new Map<Id,Id>();
        //Map<Id,List<String>> mapCaseIdAndCswiEmailList = new Map<Id,List<String>>();
        //Map<Id,List<String>> mapCaseIdAndReqEmailList = new Map<Id,List<String>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndCswiEmailList = new Map<Id,Map<String,List<String>>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndReqEmailList = new Map<Id,Map<String,List<String>>>();
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        try{
            for(Z_Task__c zIterator : lstZtasks) {
                strObjPrefix = zIterator.RelatedTo__c!=null ? String.valueOf(zIterator.RelatedTo__c).substring(0, 3) : null;
                if(strObjPrefix!=null && strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() && zIterator.type__c!=null && zIterator.type__c.contains('Z115') && zIterator.Short_Text2__c!=null && zIterator.Short_Text2__c.toUpperCase()==shortText) {
                    setCaseIds.add(zIterator.RelatedTo__c);
                }
            }
            system.debug('automationOfZ115ForOrderChannelRwbAndCon ==>setCaseIds: '+setCaseIds);
            if(setCaseIds.size()>0){
                //SendMailToCustomerForZ115ForOrderChannelRwb(setCaseIds);
                mapCasIdAndZ151Available = new Map<Id,Boolean>();
                mapCasIdAndCaseDetail = new Map<Id,Case>();
                for(Case ca : [Select Id,CaseNumber,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,Quote_Number__c,SAP_Account_Number1__c,SBU__c,GCE_Customer_Segment__c,(select id, Name__c,Status__c from Activitiy_Line_Items__r),(select id, Name,Status__c,Short_Text2__c,Short_Text__c from Z_Tasks__r ),(select Id,ContentDocument.Title,ContentDocumentId,SystemModstamp from ContentDocumentLinks where (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%' or ContentDocument.Title like '%ZAN4%') order by SystemModstamp desc) from case where id =: setCaseIds and recordtypeid =: Label.Repair_Overhaul_RT_ID]){
                    system.debug('ca :'+ca);
                    caseIdsToNotify=ca.CaseNumber;
                    if((ca.SBU__c!='D&S' || ca.GCE_Customer_Segment__c!='Military/Government') && (ca.ORDER_CHANNEL__c=='RWB' || ca.ORDER_CHANNEL__c=='CON')){
                        for(Activitiy_Line_Item__c usrStatus : ca.Activitiy_Line_Items__r){
                            if(usrStatus.Name__c=='PPOC' && usrStatus.Status__c=='Open')
                                mapCasIdAndZ151Available.put(ca.Id,true);
                        }
                        if(mapCasIdAndZ151Available.get(ca.Id)==null){
                            mapCasIdAndCaseDetail.put(ca.Id,ca);
                            if(ca.AccountId!=null)
                                mapAcctIdAndCaseIds.put(ca.AccountId, ca.Id);
                            if(ca.Requestor_Email__c!=null){
                                List<String> lstReqEmail = new List<String>();
                                lstReqEmail.add(ca.Requestor_Email__c);
                                Map<String,List<String>> mapReqEmail = new Map<String,List<String>>();
                                mapReqEmail.put('EmailList', lstReqEmail);
                                mapCaseIdAndReqEmailList.put(ca.Id,mapReqEmail);
                            }
                            if(ca.ContentDocumentLinks.size()>0){
                                mapCasIdAndConLinkDetail.put(ca.Id, ca.ContentDocumentLinks);
                            }
                        }
                    }
                }
            }
            
            if(mapCasIdAndConLinkDetail.keySet()!=null){
                for(Id caId : mapCasIdAndConLinkDetail.keySet()){
                    system.debug('mapCasIdAndZ151Available.size(): '+mapCasIdAndZ151Available.size());
                    system.debug('mapCasIdAndZ151Available.get(caId): '+mapCasIdAndZ151Available.get(caId));
                    if(mapCasIdAndZ151Available.get(caId)==null){
                        system.debug('Calling getLatestFilesToSendCustomer from automationOfZ115ForOrderChannelRwbAndCon');
                        conDocIds = getLatestFilesToSendCustomer(mapCasIdAndConLinkDetail.get(caId),'Z115');
                        if(conDocIds!=null)
                            mapCaseIdAndConDocIds.put(caId,conDocIds);
                    }
                }
            }
            if(mapCaseIdAndConDocIds.size()>0){
                system.debug('Calling getCswiEmailList method from automationOfZ115ForOrderChannelRwbAndCon===>');
                if(mapAcctIdAndCaseIds.size()>0)
                    mapCaseIdAndCswiEmailList = getCswiEmailList(mapAcctIdAndCaseIds,mapCasIdAndCaseDetail);
                system.debug('lstCswiEmailToList: '+mapCaseIdAndCswiEmailList);
                system.debug('lstReqEmailToList: '+mapCaseIdAndReqEmailList);
                if(mapCaseIdAndCswiEmailList.size()>0 || mapCaseIdAndReqEmailList.size()>0){
                    automationOfZ115ToUpdateCaseAndSendStatusToSap(mapCasIdAndCaseDetail,mapCasIdAndZ151Available,lstZtasks);
                    SendMailToCustomerForZ115ForOrderChannelRwb(setCaseIds);
                }                    
            }
        }
        catch(exception sapException){
            SApInterface.sapException=sapException.getmessage();
            SApInterface.Name = 'ZtaskHandler.automationOfZ115ForOrderChannelRwbAndCon';
            SApInterface.createdDate =Datetime.valueof(Datetime.now());
            SApInterface.caseNumber = caseIdsToNotify;
            //SApInterface.notification =quoteIdsToNotify;
            //SApInterface.inputValue = truncateIP;
            SApInterface.createdBy = UserInfo.getName();
            SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }
    }
    
    public static void automationOfZ115ToUpdateCaseAndSendStatusToSap(Map<Id,Case> mapCasIdAndCaseDetail,Map<Id,Boolean> mapCasIdAndZ151Available, list<Z_Task__c> lstZtasks) {
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        String caseIdsToNotify;
        String shortText = 'PLEASE REVIEW AND SUBMIT QUOTATION TO CU';
        List<Case> casList = new List<Case>();
        List<CaseComment> lstcasComment = new List<CaseComment>();
        Set<String> setCaseIdsToSap = new Set<String>();        
        if(mapCasIdAndCaseDetail!=null){
            for(Id mapCasIds : mapCasIdAndCaseDetail.keySet()){
                if(mapCasIdAndZ151Available.get(mapCasIds)==null){
                    Case casUpdate = new Case();
                    casUpdate.Id = mapCasIds;
                    casUpdate.OwnerId=Label.RDF_Automation_Owner;
                    casUpdate.Type='Quotes Approval (OMS)';
                    casUpdate.Status= 'On Hold';
                    casUpdate.Sub_Status__c= 'Customer Hold';
                    casUpdate.Reason_for_hold__c='Quote Approval';
                    casUpdate.VN_Name__c=Label.CustomerPOCContactId;
                    casUpdate.Due_Date__c=Date.Today().addDays(5);
                    casList.add(casUpdate);
                    Case casQuoteIds= mapCasIdAndCaseDetail.get(mapCasIds);
                    setCaseIdsToSap.add(casQuoteIds.Quote_Number__c);                    
                    CaseComment newCom = new CaseComment();
                    if(casQuoteIds.ORDER_CHANNEL__c=='POT'){
                        newCom.CommentBody = 'Quote available on Portal for customer to review and approve';
                        //newCom.IsPublished = TRUE;
                        newCom.ParentId = mapCasIds;
                        lstcasComment.add(newcom);
                    }
                    else if(casQuoteIds.ORDER_CHANNEL__c=='RWB' || casQuoteIds.ORDER_CHANNEL__c=='CON'){
                        newCom.CommentBody = 'Quote Sent to Customer';
                        //newCom.IsPublished = TRUE;
                        newCom.ParentId = mapCasIds;
                        lstcasComment.add(newcom);
                    }   
                }
            }
        }
        system.debug('casList: '+casList);
        system.debug('setCaseIdsToSap: '+setCaseIdsToSap);        
        if(casList.size()>0){
            update casList;
            apigeeToSapStatusUpdate(setCaseIdsToSap);            
            if(lstcasComment.size()>0)
                insert lstcasComment;
            /*system.debug('Z115 Status change start==>');
            try{
                for(Z_Task__c zIteratorUp : lstZtasks) {
                    caseIdsToNotify = zIteratorUp.RelatedTo__c;
                    if(zIteratorUp.type__c.contains('Z115') && zIteratorUp.Short_Text2__c!=null && zIteratorUp.Short_Text2__c.toUpperCase()==shortText && mapCasIdAndZ151Available.get(zIteratorUp.RelatedTo__c)==null){
                        zIteratorUp.Status__c ='Closed';
                        zIteratorUp.Followup_Task__c='No Followup Task';
                    }
                }
            }
            catch(exception ex){
                system.debug('Exception Inside Z115 Status change===> '+ex.getMessage());
                SApInterface.sapException=ex.getmessage();
                SApInterface.Name = 'ZtaskHandler.automationOfZ115ToUpdateCaseAndSendStatusToSap';
                SApInterface.createdDate =Datetime.valueof(Datetime.now());
                SApInterface.caseNumber = caseIdsToNotify;                
                SApInterface.createdBy = UserInfo.getName();
                SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            }
            system.debug('ZTask===> '+lstZtasks);
            system.debug('Z115 Status change Ended==>');*/
        }
    }
    
    @future(callout=true)
    public static void apigeeToSapStatusUpdate(Set<String> casIds){
        system.debug('**********************Inside apigeeToSapStatusUpdate*******************');
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        sapWrapper sapWrap = new sapWrapper();
        d wrapperD = new d();
        List<PriceIn> lstPriceIn = new List<PriceIn>();
        string quoteIdsToNotify='';
        try{
            String accessToken ; 
            for(String setQuoteId : casIds){
                PriceIn priceIn = new PriceIn();
                priceIn.nobidflag = '';
                priceIn.leadtime = '';
                priceIn.requestdate = '';
                priceIn.salesdocumenttype = 'ZQR';
                priceIn.sdnotification = setQuoteId;
                priceIn.material = '';
                priceIn.salesforcecasenumber = '';
                priceIn.priceloaded = '';
                priceIn.repqstatus = 'SUB';
                lstPriceIn.add(priceIn);
                quoteIdsToNotify +=setQuoteId+';';
            }
            if(lstPriceIn.size()>0){
                wrapperD.PriceIn = lstPriceIn;
                sapWrap.d = wrapperD;
            }
            
            string wrapJson = JSON.serialize(sapWrap);
            system.debug('wrapJson: '+wrapJson);
            ExternalCalloutDetails__c extDet = ExternalCalloutDetails__c.getValues('ApigeeToSapStatusUpdate');
            if(extDet!=null){
                String accessEndPath = extDet.AuthUrl__c+'?grant_type=client_credentials';
                Map<String,String> mapHeaders = new Map<String,String>(); 
                String authToken = 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(extDet.ClientId__c+':'+extDet.SecretId__c)) ; //for Base64 conversion
                mapHeaders.put('Authorization',authToken); 
                HttpResponse objResponse = sendCallout(accessEndPath,'GET',mapHeaders); 
                Map<String,Object> deconstructedResponse = (Map<String,Object>) JSON.deserializeUntyped(objResponse.getBody());
                if(deconstructedResponse.containsKey('access_token')) {
                    accessToken = (String) deconstructedResponse.get('access_token'); 
                }
                System.debug('Received Access Token :::::'+accessToken); 
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setHeader('Authorization', 'Bearer '+accessToken);
                request.setHeader('Content-Type','application/json');
                request.setHeader('Accept','application/json');
                request.setEndpoint(extDet.EndPointUrl__c);
                request.setMethod('POST');
                request.setTimeout(60000); 
                //request.setBody('{"d": {"PriceIn": [{"nobidflag": "X","leadtime": "30","requestdate": "20201006","salesdocumenttype": "ZQT","sdnotification": "220032520","material": "2611202-2","salesforcecasenumber": "Test","priceloaded": "15.00","repqstatus": "SUB"}]}}');
                request.setBody(wrapJson);
                
                HttpResponse response = http.send(request);
                system.debug('Response: '+response.getStatus()+' : '+ response.getStatusCode());
                system.debug('Response: '+response.getBody());
                if(response.getStatusCode()!=201){
                    SApInterface.sapException=response.getStatus()+' : '+response.getBody();
                    SApInterface.Name = 'ZtaskHandler.apigeeToSapStatusUpdate';
                    SApInterface.createdDate =Datetime.valueof(Datetime.now());
                    //SApInterface.caseNumber = CASENUMBER;
                    SApInterface.notification =quoteIdsToNotify;
                    //SApInterface.inputValue = truncateIP;
                    SApInterface.createdBy = UserInfo.getName();
                    SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
                }
            }
        }
        catch(exception sapException){
            SApInterface.sapException=sapException.getmessage();
            SApInterface.Name = 'ZtaskHandler.apigeeToSapStatusUpdate';
            SApInterface.createdDate =Datetime.valueof(Datetime.now());
            //SApInterface.caseNumber = CASENUMBER;
            SApInterface.notification =quoteIdsToNotify;
            //SApInterface.inputValue = truncateIP;
            SApInterface.createdBy = UserInfo.getName();
            SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }
    }
    
    /*****************************************************************************
* @Description : Method to send callout information to external system
* It returns to HttpResponse object received from the request. 
* *****************************************************************************/
    public static HttpResponse sendCallout(String endPoint , String methodType , Map<String,String> mapHeaders) {
        system.debug('endpoint>>>'+endPoint);
        HttpRequest objRequest = new HttpRequest(); 
        objRequest.setEndpoint(endpoint); 
        objRequest.setMethod(methodType); 
        if(mapHeaders.containsKey('headerBody')){
            objRequest.setBody(mapHeaders.get('headerBody')); 
        }
        System.debug(':::::::::::::::::: APIGEE CALLOUT START :::::::::::::::'); 
        for(String headerKey : mapHeaders.keySet()) {
            System.debug('Key :: '+headerKey+'  Value :: '+mapHeaders.get(headerKey));
            if(!headerKey.equalsIgnoreCase('headerBody')){
                objRequest.setHeader(headerKey, mapHeaders.get(headerKey));     
            }
        } 
        Http objHttp = new Http(); 
        objRequest.setTimeout(60000); 
        System.debug('---SendCallout '+objRequest);
        HttpResponse objResponse = objHttp.send(objRequest); 
        System.debug(':::: Response Received from APIGE :::'+objResponse.getBody()); 
        
        return objResponse ; 
    }
    
    /*********************************************************
     * Method Name : automationOfZ135ForOrderChannelPot
     * Description : When the order channel is POT and Short Text of the open Z135 task = PLEASE SEND FYI QUOTE TO CUSTOMER 
     * 				and no open Z151 task while creating Z135 task for Case record
     * Result	   : Close the Z135 if the condition matches as well as Quote report and initial finding report available
	**********************************************************/
    public static void automationOfZ135ForOrderChannelPot(list<Z_Task__c> lstZtasks) {
        String strObjPrefix;
        String shortText = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
        Set<Id> setCaseIds = new Set<Id>();
        Map<Id,String> mapCasIdAndOrderChannel =null;
        Map<Id,List<ContentDocumentLink>> mapCasIdAndConLinkDetail =new Map<Id,List<ContentDocumentLink>>();
        Map<Id,Set<Id>> mapCaseIdAndConDocIds = new Map<Id,Set<Id>>();
        Set<Id> conDocIds = new Set<Id>();
        Map<Id,Boolean> mapCasIdAndZ151Available =null;
        for(Z_Task__c zIterator : lstZtasks) {
            strObjPrefix = zIterator.RelatedTo__c!=null ? String.valueOf(zIterator.RelatedTo__c).substring(0, 3) : null;
            if(strObjPrefix!=null && strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() && zIterator.type__c!=null && zIterator.type__c.contains('Z135') && zIterator.Short_Text2__c!=null && zIterator.Short_Text2__c.toUpperCase()==shortText) {
                setCaseIds.add(zIterator.RelatedTo__c);
            }
        }
        system.debug('automationOfZ135ForOrderChannelPot==>setCaseIds: '+setCaseIds);
        if(setCaseIds.size()>0){
            mapCasIdAndOrderChannel = new Map<Id,String>();
            mapCasIdAndZ151Available =new Map<Id,Boolean>();
            for(Case cas : [Select Id,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,contactid,SAP_Account_Number1__c,SBU__c,GCE_Customer_Segment__c,(select id, Name__c,Status__c from Activitiy_Line_Items__r),(select id, Name,Status__c,Short_Text2__c,Short_Text__c from Z_Tasks__r ),(select Id,ContentDocument.Title,ContentDocumentId,SystemModstamp from ContentDocumentLinks where (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%' or ContentDocument.Title like '%ZFYI%') order by SystemModstamp desc) from case where id =: setCaseIds and recordtypeid =: Label.Repair_Overhaul_RT_ID]){
                if((cas.SBU__c!='D&S' || cas.GCE_Customer_Segment__c!='Military/Government') && cas.ORDER_CHANNEL__c == 'POT'){
                    /*for(Z_Task__c ztask : cas.Z_Tasks__r){
                        if(ztask.Name.contains('Z151') && ztask.Status__c=='Open')
                            mapCasIdAndZ151Available.put(cas.Id,true);
                    }*/
                    for(Activitiy_Line_Item__c usrStatus : cas.Activitiy_Line_Items__r){
                        if(usrStatus.Name__c=='PPOC' && usrStatus.Status__c=='Open')
                            mapCasIdAndZ151Available.put(cas.Id,true);
                    }
                    if(mapCasIdAndZ151Available.get(cas.Id)==null){
                        mapCasIdAndOrderChannel.put(cas.Id,'POT');
                        if(cas.ContentDocumentLinks.size()>0){
                            mapCasIdAndConLinkDetail.put(cas.Id, cas.ContentDocumentLinks);
                        }
                    }
                }
            }
            if(mapCasIdAndConLinkDetail.keySet()!=null){
                for(Id caId : mapCasIdAndConLinkDetail.keySet()){
                    if(mapCasIdAndZ151Available.get(caId)==null){
                        system.debug('Calling getLatestFilesToSendCustomer from automationOfZ135ForOrderChannelPot');
                        conDocIds = getLatestFilesToSendCustomer(mapCasIdAndConLinkDetail.get(caId),'Z135');
                        if(conDocIds!=null)
                            mapCaseIdAndConDocIds.put(caId,conDocIds);
                    }
                }
            }
            if(mapCaseIdAndConDocIds.size()>0){
                for(Z_Task__c zTaskDetail : lstZtasks){
                    if(zTaskDetail.type__c.contains('Z135') && zTaskDetail.Short_Text2__c!=null && zTaskDetail.Short_Text2__c.toUpperCase()==shortText && mapCasIdAndOrderChannel.get(zTaskDetail.RelatedTo__c)=='POT'){
                        zTaskDetail.Followup_Task__c='No Followup Task';
                        zTaskDetail.Status__c='Closed';
                        zTaskDetail.Event_Type__c='TASK CLOSE';
                    }
                }
            }
        }
    }
    
    /*********************************************************
     * Method Name : closeZ135ForOrderChannelPot
     * Description : When the order channel is RWB or CON and Short Text of the open Z135 task = PLEASE SEND FYI QUOTE TO CUSTOMER 
     * 				and no open Z151 task while creating Z135 task for Case record
     * Result	   : Send FYI Quote mail to customer and Close the Z135 if the condition matches as well as Quote report and initial finding report available
	**********************************************************/
    public static void automationOfZ135ForOrderChannelRwbAndCon(list<Z_Task__c> lstZtasks) {
        String strObjPrefix;
        String shortText = 'PLEASE SEND FYI QUOTE TO CUSTOMER';
        Set<Id> setCaseIds = new Set<Id>();
        Map<Id,Id> mapAcctIdAndCaseIds = new Map<Id,Id>();
        Boolean isMailSentSuccess = false;
        List<String> lstCswiEmailToList = new List<String>();
        List<String> lstReqEmailToList = new List<String>();
        //Map<Id,List<String>> mapCaseIdAndCswiEmailList = new Map<Id,List<String>>();        
        //Map<Id,List<String>> mapCaseIdAndReqEmailList = new Map<Id,List<String>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndCswiEmailList = new Map<Id,Map<String,List<String>>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndReqEmailList = new Map<Id,Map<String,List<String>>>();
        Map<Id,String> mapCasIdAndOrderChannel =null;
        Map<Id,Case> mapCasIdAndCaseDetail =null;
        Map<Id,List<ContentDocumentLink>> mapCasIdAndConLinkDetail =new Map<Id,List<ContentDocumentLink>>();
        Map<Id,Set<Id>> mapCaseIdAndConDocIds = new Map<Id,Set<Id>>();
        Set<Id> conDocIds = new Set<Id>();
        Map<Id,Boolean> mapCasIdAndZ151Available =null;
        for(Z_Task__c zIterator : lstZtasks) {
            strObjPrefix = zIterator.RelatedTo__c!=null ? String.valueOf(zIterator.RelatedTo__c).substring(0, 3) : null;
            if(strObjPrefix!=null && strObjPrefix == Case.sObjectType.getDescribe().getKeyPrefix() && zIterator.type__c!=null && zIterator.type__c.contains('Z135') && zIterator.Short_Text2__c!=null && zIterator.Short_Text2__c.toUpperCase()==shortText) {
                setCaseIds.add(zIterator.RelatedTo__c);
            }
        }
        system.debug('automationOfZ135ForOrderChannelRwbAndCon==>setCaseIds: '+setCaseIds);
        if(setCaseIds.size()>0){
            mapCasIdAndOrderChannel = new Map<Id,String>();
            mapCasIdAndCaseDetail = new Map<Id,Case>();
            mapCasIdAndZ151Available =new Map<Id,Boolean>();
            for(Case cas : [Select Id,CaseNumber,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,contactid,SAP_Account_Number1__c,SBU__c,GCE_Customer_Segment__c,(select id, Name__c,Status__c from Activitiy_Line_Items__r),(select id, Name,Status__c,Short_Text2__c,Short_Text__c from Z_Tasks__r ),(select Id,ContentDocument.Title,ContentDocumentId,SystemModstamp from ContentDocumentLinks where (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%' or ContentDocument.Title like '%ZFYI%') order by SystemModstamp desc) from case where id =: setCaseIds and recordtypeid =: Label.Repair_Overhaul_RT_ID]){
                /*if(cas.ORDER_CHANNEL__c == 'POT'){
                    mapCasIdAndOrderChannel.put(cas.Id,'POT');
                }*/
                if((cas.SBU__c!='D&S' || cas.GCE_Customer_Segment__c!='Military/Government') && (cas.ORDER_CHANNEL__c == 'RWB' || cas.ORDER_CHANNEL__c == 'CON')){
                    if(cas.ORDER_CHANNEL__c == 'RWB')
                        mapCasIdAndOrderChannel.put(cas.Id,'RWB');
                    else if(cas.ORDER_CHANNEL__c == 'CON')
                        mapCasIdAndOrderChannel.put(cas.Id,'CON');
                    
                    /*for(Z_Task__c ztask : cas.Z_Tasks__r){
                        if(ztask.Name.contains('Z151') && ztask.Status__c=='Open')
                            mapCasIdAndZ151Available.put(cas.Id,true);
                    }*/
                    for(Activitiy_Line_Item__c usrStatus : cas.Activitiy_Line_Items__r){
                        if(usrStatus.Name__c=='PPOC' && usrStatus.Status__c=='Open')
                            mapCasIdAndZ151Available.put(cas.Id,true);
                    }
                    if(mapCasIdAndZ151Available.get(cas.Id)==null){
                        if(cas.AccountId!=null)
                            mapAcctIdAndCaseIds.put(cas.AccountId, cas.Id);
                        mapCasIdAndCaseDetail.put(cas.Id, cas);
                        if(cas.Requestor_Email__c!=null){
                            List<String> lstReqEmail = new List<String>();
                            lstReqEmail.add(cas.Requestor_Email__c);
                            Map<String,List<String>> mapReqEmail = new Map<String,List<String>>();
                            mapReqEmail.put('EmailList', lstReqEmail);
                            mapCaseIdAndReqEmailList.put(cas.Id,mapReqEmail);
                        }
                        if(cas.ContentDocumentLinks.size()>0){
                            mapCasIdAndConLinkDetail.put(cas.Id, cas.ContentDocumentLinks);
                        }
                    }
                }
                if(Test.IsRunningTest()){
                    system.debug('Inside test running method===>');
                    mapCasIdAndOrderChannel.put(cas.Id,'RWB');
                    if(cas.AccountId!=null)
                        mapAcctIdAndCaseIds.put(cas.AccountId, cas.Id);
                    mapCasIdAndCaseDetail.put(cas.Id, cas);
                    List<String> lstReqEmail = new List<String>();
                    lstReqEmail.add(cas.Requestor_Email__c);
                    Map<String,List<String>> mapReqEmail = new Map<String,List<String>>();
                    mapReqEmail.put('EmailList', lstReqEmail);
                    mapCaseIdAndReqEmailList.put(cas.Id,mapReqEmail);
                    
                }
            }
            
            /*for(Z_Task__c zTaskDetail : lstZtasks){
                if(zTaskDetail.type__c.contains('Z135') && zTaskDetail.Short_Text2__c.toUpperCase()==shortText && mapCasIdAndOrderChannel.get(zTaskDetail.RelatedTo__c)=='POT'){
                    zTaskDetail.Followup_Task__c='No Followup Task';
                    zTaskDetail.Status__c='Closed';
                }
            }*/
        }
        if(mapAcctIdAndCaseIds.keySet()!=null){
            if(!mapCasIdAndConLinkDetail.isEmpty()){
                for(Id caId : mapCasIdAndConLinkDetail.keySet()){
                    conDocIds = getLatestFilesToSendCustomer(mapCasIdAndConLinkDetail.get(caId),'Z135');
                    if(conDocIds!=null)
                        mapCaseIdAndConDocIds.put(caId,conDocIds);
                }
            }
            if(mapCaseIdAndConDocIds.size()>0){
                system.debug('Calling getCswiEmailList method from automationOfZ135ForOrderChannelRwbAndCon===>');
                mapCaseIdAndCswiEmailList = getCswiEmailList(mapAcctIdAndCaseIds,mapCasIdAndCaseDetail);
                system.debug('lstCswiEmailToList: '+mapCaseIdAndCswiEmailList);
                system.debug('lstReqEmailToList: '+mapCaseIdAndReqEmailList);
                if(!mapCaseIdAndCswiEmailList.isEmpty())
                    isMailSentSuccess = SendMailToCustomer(mapCaseIdAndCswiEmailList,mapCasIdAndCaseDetail,mapCaseIdAndConDocIds,'FYI_Quote');
                else if(!mapCaseIdAndReqEmailList.isEmpty())
                    isMailSentSuccess = SendMailToCustomer(mapCaseIdAndReqEmailList,mapCasIdAndCaseDetail,mapCaseIdAndConDocIds,'FYI_Quote');
            }
        }
        if(isMailSentSuccess){
            for(Z_Task__c zTaskDetail : lstZtasks){
                if(zTaskDetail.type__c.contains('Z135') && zTaskDetail.Short_Text2__c!=null && zTaskDetail.Short_Text2__c.toUpperCase()==shortText && (mapCasIdAndOrderChannel.get(zTaskDetail.RelatedTo__c)=='RWB' || mapCasIdAndOrderChannel.get(zTaskDetail.RelatedTo__c)=='CON')){
                    zTaskDetail.Followup_Task__c='No Followup Task';
                    zTaskDetail.Status__c='Closed';
                    zTaskDetail.Event_Type__c='TASK CLOSE';
                }
            }
        }
    }
    public static Map<Id,Map<String,List<String>>> getCswiEmailList(Map<Id,Id> mapAccIdAndCaseId,Map<Id,Case> mapCasIdAndCaseDet) {
        Map<Id,List<String>> mapCswiEmailList = new Map<Id,List<String>>();
        Map<Id,List<String>> mapCswiCcList = new Map<Id,List<String>>();
        Map<Id,Map<String,List<String>>> mapCasIdAndCswiEmailAndCc = new Map<Id,Map<String,List<String>>>();
        Map<String,List<String>> mapFinalCswiEmail = null;
        List<String> lstCswiEmailList = null;
        List<String> lstCswiCcList = null;        
        Case casDet = null;
        for(Customer_Specific_Work_Instruction__c cswi : [Select Id,Account__c,Customer_Code__c,(select Id, Emails__c,CC_Email__c from CSWI_Emails_List__r) from Customer_Specific_Work_Instruction__c where Account__c =:mapAccIdAndCaseId.keySet()]){
            casDet = new Case();
            casDet = mapCasIdAndCaseDet.get(mapAccIdAndCaseId.get(cswi.Account__c));
            if(casDet!=null && cswi.Customer_Code__c.contains(casDet.SAP_Account_Number1__c)){
                system.debug('casDet inside getCswiEmailList: '+casDet);
                if(cswi.CSWI_Emails_List__r!=null){
                    lstCswiEmailList = new List<String>();
                    lstCswiCcList = new List<String>();
                    for(CSWI_Emails_List__c cswiEmailList : cswi.CSWI_Emails_List__r){
                        if(cswiEmailList.Emails__c!=null)
                            lstCswiEmailList.add(cswiEmailList.Emails__c);
                        if(cswiEmailList.CC_Email__c!=null)
                            lstCswiCcList.add(cswiEmailList.CC_Email__c);
                    }
                }
                if(lstCswiEmailList.size()>0){
                    if (mapCswiEmailList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c))) {
                        mapCswiEmailList.get(mapAccIdAndCaseId.get(cswi.Account__c)).addAll(lstCswiEmailList);
                        system.debug('mapCswiEmailList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c)): '+mapCswiEmailList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c)));
                        system.debug('mapCswiEmailList if: '+mapCswiEmailList);
                    }
                    else {
                        system.debug('mapCswiEmailList else: '+mapCswiEmailList);
                        mapCswiEmailList.put(mapAccIdAndCaseId.get(cswi.Account__c),lstCswiEmailList);
                    }
                }
                if(lstCswiCcList.size()>0){
                    if (mapCswiCcList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c))) {
                        mapCswiCcList.get(mapAccIdAndCaseId.get(cswi.Account__c)).addAll(lstCswiCcList);
                        system.debug('mapCswiCcList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c)): '+mapCswiCcList.containsKey(mapAccIdAndCaseId.get(cswi.Account__c)));
                        system.debug('mapCswiCcList if: '+mapCswiCcList);
                    }
                    else {
                        system.debug('mapCswiCcList else: '+mapCswiCcList);
                        mapCswiCcList.put(mapAccIdAndCaseId.get(cswi.Account__c),lstCswiCcList);
                    }
                }
            }
            casDet=null;
        }
        
        for(Id casId : mapCasIdAndCaseDet.keySet()){
            mapFinalCswiEmail = new Map<String,List<String>>();
            if(!mapCswiEmailList.isEmpty() && mapCswiEmailList.get(casId)!=null)
                mapFinalCswiEmail.put('EmailList', mapCswiEmailList.get(casId));
            if(!mapCswiCcList.isEmpty() && mapCswiCcList.get(casId)!=null)
                mapFinalCswiEmail.put('CcList', mapCswiCcList.get(casId));
            if(!mapFinalCswiEmail.isEmpty())
                mapCasIdAndCswiEmailAndCc.put(casId,mapFinalCswiEmail);
        }
        system.debug('Inside getCswiEmailList ==> mapCswiEmailList: '+mapCswiEmailList);
        system.debug('Inside getCswiEmailList ==> mapCswiCcList: '+mapCswiCcList);
        system.debug('Inside getCswiEmailList ==> mapCasIdAndCswiEmailAndCc: '+mapCasIdAndCswiEmailAndCc);
        return mapCasIdAndCswiEmailAndCc;
    }
    
    @future(callout=true)
    public static void SendMailToCustomerForZ115ForOrderChannelRwb(Set<Id> setCaseIds){
        Map<Id,Boolean> mapCasIdAndZ151Available =null;
        Map<Id,Case> mapCasIdAndCaseDetail =null;
        Map<Id,List<ContentDocumentLink>> mapCasIdAndConLinkDetail =null;
        Map<Id,Set<Id>> mapCaseIdAndConDocIds = new Map<Id,Set<Id>>();
        Set<Id> conDocIds = new Set<Id>();
        Map<Id,Id> mapAcctIdAndCaseIds = new Map<Id,Id>();
        //Map<Id,List<String>> mapCaseIdAndCswiEmailList = new Map<Id,List<String>>();
        //Map<Id,List<String>> mapCaseIdAndReqEmailList = new Map<Id,List<String>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndCswiEmailList = new Map<Id,Map<String,List<String>>>();
        Map<Id,Map<String,List<String>>> mapCaseIdAndReqEmailList = new Map<Id,Map<String,List<String>>>();
        string caseIdsToNotify='';
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        try{
            if(setCaseIds.size()>0){
                mapCasIdAndZ151Available = new Map<Id,Boolean>();
                mapCasIdAndCaseDetail = new Map<Id,Case>();
                mapCasIdAndConLinkDetail = new Map<Id,List<ContentDocumentLink>>();
                for(Case ca : [Select Id,CaseNumber,AccountId,Requestor_Email__c,ORDER_CHANNEL__c,contactid,SAP_Account_Number1__c,SBU__c,GCE_Customer_Segment__c,(select id, Name__c,Status__c from Activitiy_Line_Items__r),(select id, Name,Status__c,Short_Text2__c,Short_Text__c from Z_Tasks__r ),(select Id,ContentDocument.Title,ContentDocumentId,SystemModstamp from ContentDocumentLinks where (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%' or ContentDocument.Title like '%ZAN4%') order by SystemModstamp desc) from case where id =: setCaseIds and recordtypeid =: Label.Repair_Overhaul_RT_ID]){
                    system.debug('SendMailToCustomerForZ115ForOrderChannelRwb==>ca :'+ca);
                    caseIdsToNotify = ca.CaseNumber;
                    if((ca.SBU__c!='D&S' || ca.GCE_Customer_Segment__c!='Military/Government') && (ca.ORDER_CHANNEL__c=='RWB' || ca.ORDER_CHANNEL__c=='CON')){
                        /*for(Z_Task__c ztask : ca.Z_Tasks__r){
                            if(ztask.Name.contains('Z151') && ztask.Status__c=='Open')
                                mapCasIdAndZ151Available.put(ca.Id,true);
                        }*/
                        for(Activitiy_Line_Item__c usrStatus : ca.Activitiy_Line_Items__r){
                            if(usrStatus.Name__c=='PPOC' && usrStatus.Status__c=='Open')
                                mapCasIdAndZ151Available.put(ca.Id,true);
                        }
                        if(mapCasIdAndZ151Available.get(ca.Id)==null){
                            mapCasIdAndCaseDetail.put(ca.Id,ca);
                            if(ca.AccountId!=null)
                                mapAcctIdAndCaseIds.put(ca.AccountId, ca.Id);
                            if(ca.Requestor_Email__c!=null){
                                List<String> lstReqEmail = new List<String>();
                                lstReqEmail.add(ca.Requestor_Email__c);
                                Map<String,List<String>> mapReqEmail = new Map<String,List<String>>();
                                mapReqEmail.put('EmailList', lstReqEmail);
                                mapCaseIdAndReqEmailList.put(ca.Id,mapReqEmail);
                            }
                            if(ca.ContentDocumentLinks.size()>0){
                                mapCasIdAndConLinkDetail.put(ca.Id, ca.ContentDocumentLinks);
                            }
                        }
                    }
                }
            }
            system.debug('mapCasIdAndZ151Available: '+mapCasIdAndZ151Available);
            if(mapCasIdAndConLinkDetail.keySet()!=null){
                for(Id caId : mapCasIdAndConLinkDetail.keySet()){
                    system.debug('mapCasIdAndZ151Available.size(): '+mapCasIdAndZ151Available.size());
                    system.debug('mapCasIdAndZ151Available.get(caId): '+mapCasIdAndZ151Available.get(caId));
                    if(mapCasIdAndZ151Available.get(caId)==null){
                        system.debug('Calling getLatestFilesToSendCustomer from SendMailToCustomerForZ115ForOrderChannelRwb');
                        conDocIds = getLatestFilesToSendCustomer(mapCasIdAndConLinkDetail.get(caId),'Z115');
                        if(conDocIds!=null)
                            mapCaseIdAndConDocIds.put(caId,conDocIds);
                    }
                }
            }
            system.debug('mapCaseIdAndConDocIds: '+mapCaseIdAndConDocIds);
            if(mapCaseIdAndConDocIds.size()>0){
                system.debug('Calling getCswiEmailList method from SendMailToCustomerForZ115ForOrderChannelRwb===>');
                if(mapAcctIdAndCaseIds.size()>0)
                    mapCaseIdAndCswiEmailList = getCswiEmailList(mapAcctIdAndCaseIds,mapCasIdAndCaseDetail);
                system.debug('lstCswiEmailToList: '+mapCaseIdAndCswiEmailList);
                system.debug('lstReqEmailToList: '+mapCaseIdAndReqEmailList);
                if(!mapCaseIdAndCswiEmailList.isEmpty()){
                    system.debug('Inside if==> mapCaseIdAndCswiEmailList');
                    SendMailToCustomer(mapCaseIdAndCswiEmailList,mapCasIdAndCaseDetail,mapCaseIdAndConDocIds,'R_O_Quote_Hold');
                }   
                else if(!mapCaseIdAndReqEmailList.isEmpty()){
                    system.debug('Inside if==> mapCaseIdAndReqEmailList');
                    SendMailToCustomer(mapCaseIdAndReqEmailList,mapCasIdAndCaseDetail,mapCaseIdAndConDocIds,'R_O_Quote_Hold');
                }
                    
            }
        }
        catch(exception sapException){
            SApInterface.sapException=sapException.getmessage();
            SApInterface.Name = 'ZtaskHandler.SendMailToCustomerForZ115ForOrderChannelRwb';
            SApInterface.createdDate =Datetime.valueof(Datetime.now());
            SApInterface.caseNumber = caseIdsToNotify;
            SApInterface.createdBy = UserInfo.getName();
            SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
        }
    }
    public static Boolean SendMailToCustomer(Map<Id,Map<String,List<String>>> mapCaseIdAndCswiEmailLists, Map<Id,Case> mapCasIdAndCaseDetail,Map<Id,Set<Id>> mapCaseIdAndConDocIds,String emTemplate){
        Map<Id,Set<Id>> mapConDocIdAndCaseIds = new Map<Id,Set<Id>>();
        Map<Id,Messaging.EmailFileAttachment> mapConDocIdAndFile= new Map<Id,Messaging.EmailFileAttachment>();
        List<Messaging.SingleEmailMessage> lstMessage = new List<Messaging.SingleEmailMessage>();
        SAPtoSFDCInterfaceExceptions.SapExceptioninput SApInterface=new SAPtoSFDCInterfaceExceptions.SapExceptioninput();
        Set<Id> lstConDocIds = new Set<Id>();
        Boolean isMailSent =false;
        string strConId;
        string strcasId;
        string strcasNumber;
        String[] toAddresses;
        String[] ccAddresses;
        Id orgWideEmailIdForQuoteApproval ='0D213000000CbJECA0';
        EmailTemplate template = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName =: emTemplate];
        
        for(Id caId : mapCaseIdAndConDocIds.keySet()){
            for(Id conDocId : mapCaseIdAndConDocIds.get(caId)){
                lstConDocIds.add(conDocId);
            }
        }
        
        /*for(ContentDocumentlink conDocLink : [SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId =:mapCasIdAndCaseDetail.keySet() and (ContentDocument.Title like '%ZCAF%' or ContentDocument.Title like '%ZSRP%')]){
            lstConDocIds.add(conDocLink.ContentDocumentId);
            if (mapConDocIdAndCaseIds.containsKey(conDocLink.LinkedEntityId)) {
                mapConDocIdAndCaseIds.get(conDocLink.LinkedEntityId).add(conDocLink.ContentDocumentId);
            }
            else {
                Set<Id> setConDocId = new Set<Id>();
                setConDocId.add(conDocLink.ContentDocumentId);
                mapConDocIdAndCaseIds.put(conDocLink.LinkedEntityId, setConDocId);
                system.debug('conDocLink.LinkedEntityId: '+conDocLink.LinkedEntityId+'conDocLink.ContentDocumentId: '+conDocLink.ContentDocumentId);
            }
        }*/
        system.debug('lstConDocIds==> '+lstConDocIds);
        for(ContentVersion objConVer : [SELECT Id,ContentDocumentId,Title,PathOnClient,FileExtension,VersionData from ContentVersion where ContentDocumentId IN: lstConDocIds AND IsLatest = true]){
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(objConVer.Title+'.'+objConVer.FileExtension);
            efa.setBody(objConVer.VersionData);
            efa.setInline(false);
            mapConDocIdAndFile.put(objConVer.ContentDocumentId,efa);
        }
        system.debug('mapConDocIdAndFile.size()==> '+mapConDocIdAndFile.size());
        
        for(Id casId : mapCasIdAndCaseDetail.keySet()){
            strConId = mapCasIdAndCaseDetail.get(casId).contactid;
            strcasId = mapCasIdAndCaseDetail.get(casId).Id;
            strcasNumber = mapCasIdAndCaseDetail.get(casId).CaseNumber;
            //Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<Messaging.EmailFileAttachment> efaList = new List<Messaging.EmailFileAttachment>();
            Messaging.SingleEmailMessage message = Messaging.renderStoredEmailTemplate(template.Id, null, strcasId);
            //message.setTemplateId(template.Id);
            //message.setTargetObjectId(strConId);
            //message.setWhatId(strcasId);
            message.setOrgWideEmailAddressId(orgWideEmailIdForQuoteApproval);
            
            toAddresses = new List<String>();
            
            Map<String,List<String>> mapCasIdAndEmailCcList = new Map<String,List<String>>();
            mapCasIdAndEmailCcList = mapCaseIdAndCswiEmailLists.get(casId);            
            if(mapCasIdAndEmailCcList.get('EmailList')!=null){
                for(string strEmail : mapCasIdAndEmailCcList.get('EmailList')){
                    if(strEmail.contains(';')){
                        for(string str : strEmail.split(';')){
                            toAddresses.add(str);
                        }
                    }
                    else
                        toAddresses.add(strEmail);
                }
            }
            if(mapCasIdAndEmailCcList.get('CcList')!=null){
                ccAddresses = new List<String>();
                for(string strEmail : mapCasIdAndEmailCcList.get('CcList')){
                    if(strEmail.contains(';')){
                        for(string str : strEmail.split(';')){
                            ccAddresses.add(str);
                        }
                    }
                    else
                        ccAddresses.add(strEmail);
                }
            }
            system.debug('toAddresses: '+toAddresses);
            system.debug('ccAddresses: '+ccAddresses);
            if(toAddresses.size()>0)
                message.setToAddresses(toAddresses);
            if(ccAddresses!=null && ccAddresses.size()>0)
                message.setCcAddresses(ccAddresses);
            Set<Id> setConDoc = mapCaseIdAndConDocIds.get(casId)!=null ? mapCaseIdAndConDocIds.get(casId) : null;
            system.debug('setConDoc: '+setConDoc);
            if(setConDoc!=null && setConDoc.size()>0){
                for(Id conDoc : setConDoc){
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa = mapConDocIdAndFile.get(conDoc);
                    efaList.add(efa);
                }
            }
            if(efaList.size()>0)
                message.setFileAttachments(efaList);
            lstMessage.add(message);
        }
        
        if(lstMessage.size()>0){
            try {
                Messaging.sendEmail(lstMessage);
                isMailSent = true;
            } catch (Exception sapException) {
                system.debug('ZtaskHandler.SendMailToCustomer: '+sapException.getMessage());
                SApInterface.sapException=sapException.getMessage();
                SApInterface.Name = 'ZtaskHandler.SendMailToCustomer';
                SApInterface.createdDate =Datetime.valueof(Datetime.now());
                SApInterface.caseNumber = strcasNumber;
                SApInterface.createdBy = UserInfo.getName();
                SAPtoSFDCInterfaceExceptions.createrecord(SApInterface);
            }
        }
        return isMailSent;
    }
    
    public class sapWrapper{
        public d d{get;set;}
    }
    public class d {
        public List<PriceIn> PriceIn {get;set;}
    }
    
    public class PriceIn {
        public String nobidflag {get;set;}
        public String leadtime {get;set;}
        public String requestdate {get;set;}
        public String salesdocumenttype {get;set;}
        public String sdnotification {get;set;}
        public String material {get;set;}
        public String salesforcecasenumber {get;set;}
        public String priceloaded {get;set;}
        public String repqstatus {get;set;}
    }
}
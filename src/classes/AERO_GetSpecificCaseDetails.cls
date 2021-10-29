@RestResource(urlMapping = '/casenumber/*')
global with sharing class AERO_GetSpecificCaseDetails {
    
    @HTTPGet
    global static void doGet(){
        RestRequest req=RestContext.request;
        RestResponse res=RestContext.response;
        res.addHeader('Content-Type', 'application/json'); 
        string requestURI = req.requestURI;
        String contactId = req.headers.get('contactId');
        String restrictedDate = req.headers.get('restrictedDate');
        String caseNumber = requestURI.substring(requestURI.lastIndexOf('/')+1);
        AERO_Result result = getCaseDetails(caseNumber,contactId,restrictedDate);
        if(json.serialize(result) != '[]'){   
            res.responseBody = Blob.valueOf(json.serialize(result));
        }
        //res.statusCode = result.statusCode;
        /*else if(json.serialize(result) != '[]'){
res.responseBody = Blob.valueOf(json.serialize(result));
}*/
    }
    
    Public static AERO_Result getCaseDetails(String caseNumber,String conId,String restrictedDate){
        system.debug('csId***'+caseNumber);
        AERO_Result result = new AERO_Result();
        list<Id> contentDocumentIds = new list<Id>();
        list<CaseComment> caseComments = new list<CaseComment>();
        list<AERO_CaseDetailsWrapper> WrapperResult = new list<AERO_CaseDetailsWrapper>();
        //map<String,caseComment> csCommentMap = new map<String,caseComment>();
        //map<String,list<List<String>>> csCommentMap = new map<String,list<list<String>>>();
        //list<String> commentBody = new list<String>();
        if(String.isBlank(conId)){
            result.handleError(400,'Contact Id not found','Please provide contact Id');
            return result;
        }
        if(conId.length()<15){
            result.handleError(404,'ContactId length is inappropriate','Contact Id length should be either 15 or 18 digit');
            return result;
        }
        String ConIdFromHeader = conId.substring(0, 15);
        if(String.isBlank(caseNumber)){
            result.handleError(400, 'Case number not provided', 'Please provide case number');
            return result;
        }
        list<case> caseDetails = [select caseNumber,ClosedDate,Description,createdDate,Account_Name__c,(select id,commentBody,createdBy.name,createdDate from caseComments where IsPublished = True order by createdDate desc limit 100),contact.name,
                                  Subject,Status,Sub_Status__c,recordType.name,Aircraft_Type__r.name,Product_Number__r.name,Platform__r.name,Product_Part__c,Part_Number__c,contactId,AOG__c,account.name,account.accountNumber,ATA_Chapter__c,Aircraft_Serial_Number__c,
                                  Amount_of_Claim__c,Quantity_of_Claims__c,Resolution__c,Fault_Messages__c,Customer_Request_Date__c,Additional_Web_Form_Info__c,Sales_Order_Number__c,Repair_Notification_Number__c,Customer_PO_RO_WONumber__c,Product_Part_Number__c,Product_Number__c,Quote_Number__c,Customer_Reference_Number__c,Portal_request_type__c,Portal_Status__c,Emailbox_Origin__c FROM Case where caseNumber =:caseNumber];
        /*String customLinkUrl = '';  // To send custom link URL in response
if(String.isNotBlank(caseDetails[0].Sales_Order_Number__c)){
customLinkUrl = 'https://aerospace2.honeywell.com/wps/myportal/order-status?orderId='+caseDetails[0].Sales_Order_Number__c;
system.debug('customLinkUrl***'+customLinkUrl);
}*/
        //system.debug('caseDetails***' +caseDetails[0]);
        if(caseDetails.size()<1){
            result.handleError(404, 'No record found for given case number', 'Please provide valid case number');
            return result;
        }
        if(caseDetails.size()>0 && String.isNotBlank(conId)){
            String csConId = caseDetails[0].contactId;  // To convert and compare the contactId with header param
            String conIdOnCase = '';
            if(String.isNotBlank(csConId)){
                conIdOnCase = csConId.substring(0, 15);
            }
            if(conIdOnCase != ConIdFromHeader){
                result.handleError(404,'ContactId is not same','Case details cannot be exposed');
                return result;
            }
        }
        //To restrict Emailbox Origin with Email-deferredordersweb value
        String Emailbox = '';
        Emailbox = caseDetails[0].Emailbox_Origin__c;
        if(Emailbox == 'Email-deferredordersweb'){
            result.handleError(404,'Emailbox Origin is \'Email-deferredordersweb\'','Case details cannot be exposed');
            return result;
        }
        if(restrictedDate != null){
            try{
                Date dt = Date.valueOf(restrictedDate);
                dateTime dateFromHeader = datetime.newInstance(dt.year(), dt.month(),dt.day());
                if(dateFromHeader>caseDetails[0].createdDate){
                    result.handleError(404, 'Case is older than restricted date', 'Case details can not be exposed');
                    return result;
                }
            }catch(TypeException ex){
                result.handleError(404,'Wrong restricted date format','Please provide valid date format as YYYY-MM-DD');
                return result;
            }
        }
        if(caseDetails[0].caseComments != null){
            for(caseComment comments : caseDetails[0].caseComments){  
                caseComments.add(comments);
            }
        }
        list<contentDocumentLink> docDetails = new list<contentDocumentLink>();
        docDetails = [select contentDocumentId,contentDocument.title,contentDocument.fileExtension from contentDocumentLink where linkedEntityId =:caseDetails[0].id and Visibility = 'AllUsers'];  //caseDetails[0].id
        /*if(docDetails.size()>0){
for(contentDocumentLink contentDocIds : docDetails){
contentDocumentIds.add(contentDocIds.contentDocumentId);
}
}*/		Decimal leadDays;  //To pass lead days in response
        if(String.isNotBlank(caseDetails[0].recordType.name)){
            list<AERO_PortalRequestType__mdt> portalreqList = [SELECT Lead_Days__c,Label from AERO_PortalRequestType__mdt where Label =:caseDetails[0].recordType.name];
        system.debug('portalreqList***' +portalreqList.size());
            if(portalreqList.size()<1){
            result.handleError(404,'Case record Type is different','Case details cannot be exposed');
            return result;
        }
         if(portalreqList.size()>0){
            leadDays = portalreqList[0].Lead_Days__c;
            system.debug('leadDays' +leadDays);
        }
        }
        /*List<String> recordTypeList = new List<String>();
        List<Decimal> leadDaysList =  new List<Decimal>();
        for(AERO_PortalRequestType__mdt req:portalreqList){
            String recordTypes = req.Label;
            recordTypeList.add(recordTypes);
            Decimal leadDays = req.Lead_Days__c;
            leadDaysList.add(leadDays);
        }
        if(recordTypeList != null && recordTypeList.size()>0 && !recordTypeList.contains(caseDetails[0].recordType.name)){
            Result.handleError(404,'Case record does not match','Case details cannot be exposed.');
            return result;
        }*/
        
        
        
        
        /*******************MetaData table to fetch portal status value*************************/
        list<AERO_PortalStatus__mdt> portalStatusList = [select portal_status__c from AERO_PortalStatus__mdt where status__c =:caseDetails[0].status and SubStatus__c = :caseDetails[0].Sub_Status__c];
        //system.debug('portalStatus***'+portalStatus);
        String portalStatus = '';
        if(portalStatusList.size()>0){
            portalStatus = portalStatusList[0].portal_status__c;
        }
        if(portalStatus == 'Do Not Use' || caseDetails[0].Portal_status__c == 'Do Not Use'){
            result.handleError(404,'Portal status  is \'Do Not Use\'','Case details can not be exposed');
            return result;
        }
        
        AERO_CaseDetailsWrapper caseWrapper = new AERO_CaseDetailsWrapper(caseDetails[0],docDetails,caseComments,portalStatus,leadDays);
        WrapperResult.add(caseWrapper);
        result.Data = WrapperResult;
        return result;
    }
    
}
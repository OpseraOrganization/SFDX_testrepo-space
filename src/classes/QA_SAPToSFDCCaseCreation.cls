@RestResource(urlMapping='/QuoteAutomation/QA_SAPToSFDCCaseCreation/*')
global with sharing class QA_SAPToSFDCCaseCreation {
	// POST Method
    @HttpPost
    global static Void doPost(){
        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;
        res.statusCode = 200;
        CaseCreationResponseDetails response = new CaseCreationResponseDetails();
        try{
            res.addHeader('Content-Type', 'application/json');
            System.debug(':: Payload :: '+req.requestBody.toString());
            CaseCreationRequestDetails reqdetails = (CaseCreationRequestDetails)JSON.deserializeStrict(req.requestBody.toString(),CaseCreationRequestDetails.class);
            System.debug('::Payload after deserialize :: '+reqdetails);
            
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
            
            if(reqdetails.Case_Number != '' && reqdetails.Case_Number != null){
                List<Sales_Order__c> items_toupdate = new List<Sales_Order__c>();
                Case case_info = [SELECT Id,ContactId,Requestor_Email__c,Status,Sub_Status__c,recordTypeId,Resolution__c,(SELECT Id,Product_Number__r.Product_Number__c,Product_Part_Number__c,Line_Item__c,Hold_Type__c FROM Sales_Orders1__r) FROM Case WHERE CaseNumber = :reqdetails.Case_Number LIMIT 1];
                Case case_toupdate = new Case(Id = case_info.Id);
                Boolean skipQuoteUpdateNotification = case_info.Status == 'Done' || reqdetails.Case_Status == 'Done' ? True : False;
                if(reqdetails.Case_Status != '' && reqdetails.Case_Status != null && reqdetails.Case_Status != case_info.Status){
                    case_toupdate.Status = reqdetails.Case_Status;
                    if(reqdetails.Case_Status == 'Done'){
                        case_toupdate.Resolution__c = 'Quote Completed';
                        case_toupdate.Sub_Status__c = '';
                    }
                }
                if(reqdetails.Sub_Status != '' && reqdetails.Sub_Status != null && reqdetails.Sub_Status != case_info.Sub_Status__c){
                    case_toupdate.Sub_Status__c = reqdetails.Sub_Status;
                }
                //added by kayal
                String portalStatus = '';
                String portalRequestType = '';
                String anyPortStatus = ''; 
                String Status = (case_info.Status != case_toupdate.Status ? case_toupdate.Status : case_info.Status);
                String SubStatus = (case_info.Sub_Status__c != case_toupdate.Sub_Status__c ? case_toupdate.Sub_Status__c : case_info.Sub_Status__c);
                String key = (Status+'-'+SubStatus).toLowerCase();
                String key2 = Status;
                String  recTypeId= case_info.recordTypeId;
                String key1 = '';
                if(String.isNotBlank(recTypeId))
                key1 = Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId).getname();
                system.debug('key1***' +key1);
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
                case_toupdate.Portal_Status__c = portalStatus;
                case_toupdate.Portal_request_type__c = portalRequestType;
                system.debug('Portal status***'+case_toupdate.Portal_Status__c);
                system.debug('case_toupdate.Portal_request_type__c'+case_toupdate.Portal_request_type__c);
                //csList.add(c);
                }else{
                case_toupdate.Portal_Status__c = anyPortStatus;  
                case_toupdate.Portal_request_type__c = portalRequestType;
                system.debug('case_toupdate.Portal_request_type__c'+case_toupdate.Portal_request_type__c);
                //csList.add(c);
                } 
                // added by kayal
                if(reqdetails.Line_Items!= null && reqdetails.Line_Items.size()>0 ){
                    Map<String,Sales_Order__c> lineitems_map = new Map<String,Sales_Order__c>();
                    for(Sales_Order__c each : case_info.Sales_Orders1__r){
                        if(each.Product_Number__r.Product_Number__c != null){
                            lineitems_map.put(each.Product_Number__r.Product_Number__c+'-'+each.Line_Item__c,each);
                        }else{
                        	lineitems_map.put(each.Product_Part_Number__c+'-'+each.Line_Item__c,each);
                        }
                    }
                    for(QuoteLineItemDetails each_item : reqdetails.Line_Items){
                        if(lineitems_map.containsKey(each_item.Part_Number+'-'+each_item.Line_Item)){
                            Sales_Order__c item_toupdate = lineitems_map.get(each_item.Part_Number+'-'+each_item.Line_Item);
                            if(each_item.Hold_Type != '' && each_item.Hold_Type != null && item_toupdate.Hold_Type__c != each_item.Hold_Type){
                            	item_toupdate.Hold_Type__c = each_item.Hold_Type;
                                items_toupdate.add(item_toupdate);
                            }
                        }
                    }
                }
                try{
                    Update case_toupdate;
                    response.Case_Number  = reqdetails.Case_Number;
                    response.Quote_Number = reqdetails.Quote_Number;
                    response.Message = 'Case Updated Successfully.';
                    if(items_toupdate.size()>0){
                        try{
                            Update items_toupdate;
                            response.Message = 'Case & Line Items are Updated Successfully.';
                        }catch(Exception ex){
                            res.statusCode = 500;
                            response.Message = 'Exception  '+ex.getMessage();
                        }
                        if(!skipQuoteUpdateNotification)
                        sendEmailNotification(case_info.contactId,case_info.Id,label.QA_Quote_Status_Notification,case_info.Requestor_Email__c);
                	}
                }catch(Exception ex){
                    res.statusCode = 500;
                    response.Message = 'Exception  '+ex.getMessage();
                }
            }else{
                String case_num = '';
                if(reqdetails.Quote_Number != '' && reqdetails.Quote_Number != null){
                    try{
                        case_num = getCaseNumberForQuote(reqdetails.Quote_Number);
                    }catch(Exception ex){
                        System.debug(':: Exception :: '+ex.getMessage());
                    }
                }
                if(case_num != '' && case_num != null){
                    response.Quote_Number = reqdetails.Quote_Number;
                    response.Case_Number = case_num;
                    response.Message = 'Case is available in System for Quote Number';
                }else{
                    String contactId = '';
                    Case new_case = new Case();
                    new_case.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined'; 
                    new_case.Government_Compliance_SM_M_Content__c = 'Undetermined';
                    new_case.Origin = 'Web';
                    new_case.Type = 'Quotes/Availability (OMS)';
                    new_case.Classification__c = 'CSO Spares';
                    new_case.Type_of_Request__c = reqdetails.CommercialQuote_Failure == 'Y'?'Create Quote Manually in SAP':reqdetails.Military_Quote == 'Y'?'Request for ACES Quote':'Request for Quote';
                    new_case.Subject = reqdetails.Military_Quote == 'Y'?'ACES Quote Required':'MyAerospace Request For Quote';
                    List<Group> queues = [SELECT Id,Name,DeveloperName FROM Group WHERE Name = 'Quotes Team'];
                    if(queues.size()>0){
                        new_case.OwnerId = queues[0].Id;
                    }
                    String RecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quotes').getRecordTypeId();
                    new_case.RecordTypeId = RecTypeId;
                    if(reqdetails.Contact_EMail != '' && reqdetails.Contact_EMail != null){
                        new_case.Requestor_Email__c = reqdetails.Contact_EMail;
                        List<Contact> cons = getContacts(reqdetails.Contact_EMail);
                        if(cons.size()>0){
                            new_case.ContactId = cons[0].Id;
                            contactId 		   = cons[0].Id;
                            new_case.AccountId = cons[0].AccountId;
                        }else if(reqdetails.CRMID !='' && reqdetails.CRMID != null){
                            String accid = getAccountId(reqdetails.CRMID);
                            if(accid != ''){
                                new_case.AccountId = accid;
                            }
                        }
                    }
                    if(reqdetails.Customer_PO_RO_WO_Num != '' && reqdetails.Customer_PO_RO_WO_Num != null){
                        new_case.Customer_PO_RO_WONumber__c = reqdetails.Customer_PO_RO_WO_Num;
                    }
                    if(reqdetails.Customer_Request_Dt != '' && reqdetails.Customer_Request_Dt != null){
                        new_case.Customer_Request_Date__c = Date.parse(reqdetails.Customer_Request_Dt);
                    }
                    if(reqdetails.Quote_Entered_Dt != '' && reqdetails.Quote_Entered_Dt != null){
                        new_case.Quote_Entered__c = DateTime.newInstance(Date.parse(reqdetails.Quote_Entered_Dt), DateTime.now().time());
                    }
                    if(reqdetails.Product_Num != '' && reqdetails.Product_Num != null){
                        new_case.Product_Part_Number__c = reqdetails.Product_Num;
                    }
                    if(reqdetails.Product_Serial_Num != '' && reqdetails.Product_Serial_Num != null){
                        new_case.Product_Serial_Number__c = reqdetails.Product_Serial_Num;
                    }
                    if(reqdetails.CommercialQuote_Failure == 'Y'){
                        new_case.Status = 'Open';
                        new_case.Sub_Class__c = 'Deferred Online Quote';
                    }else{
                        if(reqdetails.Case_Status != '' && reqdetails.Case_Status != null){
                            new_case.Status = reqdetails.Case_Status;
                            if(reqdetails.Case_Status == 'Done'){
                                new_case.Resolution__c = 'Quote Completed';
                                new_case.Sub_Status__c = '';
                            }
                        }
                        if(reqdetails.Sub_Class != '' && reqdetails.Sub_Class != null){
                            new_case.Sub_Class__c = reqdetails.Sub_Class;
                        }
                    }
                    if(reqdetails.Quote_Number != '' && reqdetails.Quote_Number != null){
                        new_case.Quote_Number__c = reqdetails.Quote_Number;
                        new_case.Subject += ' - '+reqdetails.Quote_Number;
                    }
                    if(reqdetails.Military_Quote == 'Y' || reqdetails.CommercialQuote_Failure == 'Y'){
                        String dt = '';
                        dt += String.valueOf(Datetime.now().month()).length() == 1?('0'+String.valueOf(Datetime.now().month())):String.valueOf(Datetime.now().month());
                        dt += String.valueOf(Datetime.now().day()).length() == 1?('0'+String.valueOf(Datetime.now().day())):String.valueOf(Datetime.now().day());
                        dt += String.valueOf(Datetime.now().year()).length() == 1?('0'+String.valueOf(Datetime.now().year())):String.valueOf(Datetime.now().year());
                        dt += String.valueOf(Datetime.now().hour()).length() == 1?('0'+String.valueOf(Datetime.now().hour())):String.valueOf(Datetime.now().hour());
                        dt += String.valueOf(Datetime.now().minute()).length() == 1?('0'+String.valueOf(Datetime.now().minute())):String.valueOf(Datetime.now().minute());
                        new_case.Subject += ' - '+dt;
                    }
                    if(reqdetails.Sub_Status != '' && reqdetails.Sub_Status != null){
                        new_case.Sub_Status__c = reqdetails.Sub_Status;
                    }
                    //added by kayal
                    String portalStatus = '';
                    String portalRequestType = '';
                    String anyPortStatus = '';
                    String key = (new_case.status+'-'+new_case.Sub_Status__c).toLowerCase();
                    String key2 = new_case.status;
                    String recTypeId1 = new_case.recordTypeId;
                    String key1 = '';
                    if(String.isNotBlank(recTypeId1))
                    key1 = Schema.SObjectType.case.getRecordTypeInfosById().get(recTypeId1).getname();
                    system.debug('key1***' +key1);
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
                    new_case.Portal_Status__c = portalStatus;
                    new_case.Portal_request_type__c = portalRequestType;
                    system.debug('Portal status***'+new_case.Portal_Status__c);
                    system.debug('new_case.Portal_request_type__c'+new_case.Portal_request_type__c);
                    //csList.add(c);
                    }else{
                    new_case.Portal_Status__c = anyPortStatus;  
                    new_case.Portal_request_type__c = portalRequestType;
                    system.debug('new_case.Portal_request_type__c'+new_case.Portal_request_type__c);
                    //csList.add(c);
                    } 
                    //added by kayal
                    response.Quote_Number = reqdetails.Quote_Number;
                    try{
                        insert new_case;
                        response.Case_Number = getCaseNumber(new_case.Id);
                        response.Message = 'Case Created Successfully.';
                        if(new_case.Id != null && reqdetails.Line_Items!= null && reqdetails.Line_Items.size()>0){
                            List<String> list_parts = new List<String>();
                            for(QuoteLineItemDetails line_item : reqdetails.Line_Items){
                                list_parts.add(line_item.Part_Number);
                            }
                            Map<String,String> map_products = getProducts(list_parts);
                            List<Sales_Order__c> lineitems = new List<Sales_Order__c>();
                            for(QuoteLineItemDetails line_item : reqdetails.Line_Items){
                                lineitems.add(new Sales_Order__c(Case__c = new_case.Id,
                                                                 Product_Number__c = map_products.containsKey(line_item.Part_Number)?map_products.get(line_item.Part_Number):null,
                                                                 Product_Part_Number__c = !map_products.containsKey(line_item.Part_Number)?line_item.Part_Number:'',
                                                                 Line_Item__c = line_item.Line_Item,
                                                                 Sales_Order_Number__c = 'N/A',
                                                                 Bid__c = line_item.NBid_Indicator == 'X'?true:false,
                                                                 Description__c = line_item.Description,
                                                                 Hold_Type__c = line_item.Hold_Type,
                                                                 Quantity__c = line_item.Quantity,
                                                                 Quote_Number__c = reqdetails.Quote_Number,
                                                                 Units_Of_Measure__c = line_item.Units));
                            }
                            try{
                                insert lineitems;
                                response.Message = 'Case & Line Items are Created Successfully.';
                            }catch(Exception ex){
                                response.Message = 'Exception '+ex.getMessage();
                                System.debug(':: Exception:: '+ex.getTypeName()+' :: '+ex.getMessage()+' :: '+ex.getLineNumber());
                            }
                            String tempId = reqdetails.Military_Quote == 'Y'?label.QA_MilitaryQuote_AckTempId:reqdetails.CommercialQuote_Failure == 'Y'?label.QA_Transactional_Error_Quote_TempId:label.QA_CommercialQuote_AckTempId;
                            sendEmailNotification(contactId,new_case.Id,tempId,reqdetails.Contact_EMail);
                        }
                    }catch(Exception ex){
                        response.Message = 'Exception '+ex.getMessage();
                        res.statusCode = 500;
                        System.debug(':: Exception:: '+ex.getTypeName()+' :: '+ex.getMessage()+' :: '+ex.getLineNumber());
                    }
                }
        	}
        }catch(Exception ex){
            response.Message = 'Exception '+ex.getMessage()+ ' ' + ex.getLineNumber();
            res.statusCode = 500;
            System.debug(':: Exception:: '+ex.getTypeName()+' :: '+ex.getMessage()+' :: '+ex.getLineNumber());
        }
        res.responseBody = Blob.valueOf(JSON.serializePretty(response));
    }
    global static void sendEmailNotification(String targetObjectId,String whatId,String templateId,String toAddress){
        try{
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            if(targetObjectId!=null){
                message.setTargetObjectId(targetObjectId);
            }
            if(whatId!=null){
                message.setWhatId(whatId); 
            }                               
            message.setBccSender(false);
            message.setUseSignature(false);
            message.setOrgWideEmailAddressId(label.QA_DonotReplyOrgId);
            message.setSaveAsActivity(false);
            if(templateId!=null){           
                message.setTemplateId(templateId); 
            } 
            EmailMessage emailToCase = new EmailMessage();
            emailToCase.Incoming = false;
            Messaging.SingleEmailMessage mergedmsg = Messaging.renderStoredEmailTemplate(templateId,targetObjectId,whatId);
            emailToCase.HtmlBody 	= mergedmsg.getHtmlBody().length()>=32000?mergedmsg.getHtmlBody().subString(0,32000):mergedmsg.getHtmlBody();
            emailToCase.TextBody 	= mergedmsg.getPlainTextBody().length()>=32000?mergedmsg.getPlainTextBody().subString(0,32000):mergedmsg.getPlainTextBody();
            emailToCase.Subject		= mergedmsg.getSubject();
            emailToCase.FromName 	= label.QA_FromAddress;
            emailToCase.FromAddress = label.QA_FromAddress;
            emailToCase.MessageDate = system.now();
            emailToCase.ParentId = whatId;
            emailToCase.ToAddress = toAddress;
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{message});
            insert emailToCase;
        }catch(Exception ex){
            System.debug('Exception :: '+ex.getMessage());
        }
    }
    global static List<Contact> getContacts(String conemail){
        List<Contact> list_cons = new List<Contact>();
        if(conemail != null){
    		list_cons = [SELECT Id,AccountId FROM Contact WHERE Email=:conemail LIMIT 1];
        }
        return list_cons;
    }
    global static string getAccountId(String crmid){
        String accid = '';
        List<Account> acclist = [SELECT Id,Report_Account_Name__c FROM Account WHERE Sbl_Account_Row_Id__c=:crmid AND (NOT REPORT_ACCOUNT_NAME__c LIKE '%VARIOUS%') LIMIT 1 FOR UPDATE];
        if (acclist.size() > 0)
        {
            accid = acclist[0].Id;
        }
        return accid;  
    }
    global Static String getCaseNumber(String caseid){
        String case_number = '';
        if(caseid != null){
            case_number = [SELECT Id,CaseNumber FROM Case WHERE Id =: caseid].CaseNumber;
        }
        return case_number;
    }
    global Static String getCaseNumberForQuote(String quoteno){
        String case_number = '';
        if(quoteno != null){
            String RecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quotes').getRecordTypeId();
            case_number = [SELECT Id,CaseNumber FROM Case WHERE Type_of_Request__c = 'Request for Quote' AND RecordTypeId = :RecTypeId AND Quote_Number__c =: quoteno Order By CreatedDate DESC LIMIT 1].CaseNumber;
        }
        return case_number;
    }
    global Static Map<String,String> getProducts(List<String> parts){
        Map<String,String> map_products = new Map<String,String>();
        if(parts.size()>0){
            for(Product2 each : [SELECT Id,Name,Product_Number__c FROM Product2 WHERE Product_Number__c IN : parts]){
                map_products.put(each.Product_Number__c,each.Id);
            }
        }
        return map_products;
    }
    global class CaseCreationRequestDetails{
        global String CommercialQuote_Failure;// Y for Commercial Quote Failure Transaction 
        global String Military_Quote;// Y for Military Quote 
        global String Case_Number;
        global String Contact_EMail;
        global String CRMID;
        global String Customer_PO_RO_WO_Num;
        global String Customer_Request_Dt;
        global String Quote_Entered_Dt;
        global String Product_Num;
        global String Product_Serial_Num;
        global String Case_Status;
        global String Sub_Class;
        global String Subject;
        global String Quote_Number;
        global String Sub_Status;
        global String Distribution_Channel;
        global String Plant_Code;
        global String Site_Code;
        global List<QuoteLineItemDetails> Line_Items;
        global CaseCreationRequestDetails(){
            
        }
    }
    global class QuoteLineItemDetails{
        global String Part_Number;
        global String Line_Item;
        global String Description;
        global Decimal Quantity;
        global String NBid_Indicator;
        global String Hold_Type;
        global String Units;
        global String Currency_Type;
        global QuoteLineItemDetails(){
            
        }
    }
    global class CaseCreationResponseDetails{
        global String Case_Number;
        global String Quote_Number;
        global String Message;
        global CaseCreationResponseDetails(){
            
        }
    }
}
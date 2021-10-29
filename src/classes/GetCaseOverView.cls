/*********
*** @@ DESC : This Rest Service Class will expose the service with Case Details Based on different filter.
*** @@ COMPONENTName : GetCaseOverView
*** @@ URL MAPPING : /services/apexrest/GetCaseOverView
*** @@ REST METHOD : POST
*** @@ Request Parameters : HonOrgId,GCESegment,CaseRecordType,CustomerName,GCECSSAssignment,CSSRegion,CSSType,DocType,DocumentNumber,StatusFlag,CaseStatus
*** @@ Response Parameters : CSSOpenCases,CSSOnHoldCases,CSSReOpenedCases,CSSEscalatedCases,CSSAllCases,OpenCaseDetails,HoldCaseDetails,ReOpenedCaseDetails,EscalatedCaseDetails,AllCaseDetails
*** @@ Response Type : JSON Format
**********/
@RestResource(urlMapping='/GetCaseOverView/*')
global with sharing class GetCaseOverView{
    // POST Method
    @HttpPost
    global static Void doPost(){
        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            res.addHeader('Content-Type', 'application/json');
            GCESegmentDetail reqdetails = (GCESegmentDetail)JSON.deserializeStrict(req.requestBody.toString(),GCESegmentDetail.class);
            String ownercondition = '';
            String rectypecondition = '';
            String segmentcondition = '';
            String accountcondition = '';
            String assignmentcondition = '';
            String regioncondition = '';
            String typecondition = '';
            String documentcondition = '';
            String opencasesquery = '';
            String holdcasesquery = '';
            String holdrescasesquery = '';
            String reopenedcasesquery = '';
            String escalatedcasesquery = '';
            String whereclause = '';
            String segments = System.Label.Appian_Case_Segments;
            String limitcondition = ' LIMIT '+ System.Label.Appian_Response_Data_Limit;
            String openstatuscondition = ' AND ( Status =\'Open\' OR Status = \'Open-Rejected\' ) ';
            String holdstatuscondition = ' AND ( Status =\'On Hold\' ) ';
            String holdresstatuscondition = ' AND ( Status = \'On Hold – Response Received\' ) ';
            String reopenedstatuscondition = ' AND ( Status =\'Re-Open\' ) ';
            String escalatedstatuscondition = ' AND ( ( Case_Complexity__c !=\'Normal\' AND Case_Complexity__c !=\'\' ) AND ( Status =\'Open\' OR Status = \'Open-Rejected\' OR Status =\'On Hold\' OR Status = \'On Hold – Response Received\' OR Status =\'Re-Open\' ) ) ';
            String allstatuscondition = ' AND ( Status =\'Open\' OR Status = \'Open-Rejected\' OR Status =\'On Hold\' OR Status = \'On Hold – Response Received\' OR Status =\'Re-Open\' ) ';  
            Map<String,String> mapstatusconditions = new Map<String,String>{'OPEN'=> openstatuscondition ,'ON-HOLD'=> holdstatuscondition , 'ON-HOLD Response'=> holdresstatuscondition ,'REOPEN'=> reopenedstatuscondition ,'ESCALATED'=> escalatedstatuscondition ,'ALLCASE'=> allstatuscondition };
            String countquery = 'SELECT Count() FROM CASE WHERE IsDeleted = False AND Government_Compliance_SM_M_Content__c != \'Yes\' AND Export_Compliance_Content_ITAR_EAR__c != \'Yes\' ';
            String listquery = 'SELECT Id,CaseNumber,Owner.Name,Account.Name,Account_Number_web__c,Part_Number__c,Product_Serial_Number__c,Status,Sub_Status__c,time_on_hold__c,Re_Open_Age__c,Opened_Case_Age__c,Reason_for_hold__c,VN_Name__r.Name,Type,Sub_Class__c,Age__c,Age_in_Hours__c,CreatedDate,RecordType.Name,Due_Date__c,Case_Complexity__c,GCE_CSS_Assignment__c,Account.GCE_CSS_Assignment__r.Name,Plant__c,Plant__r.Name,LastModifiedDate,AgeOfCurrentHoldInHours__c FROM CASE WHERE IsDeleted = False AND Government_Compliance_SM_M_Content__c != \'Yes\' AND Export_Compliance_Content_ITAR_EAR__c != \'Yes\' ';
            if(System.Label.Appian_Case_Owners != '' && System.Label.Appian_Case_Owners != null){  
                ownercondition += ' AND ( ';
                List<String> listowners = System.Label.Appian_Case_Owners.split(',');
                for(Integer i=1; i<= listowners.size(); i++){
                    ownercondition += ' Owner.Name != \''+ listowners[i-1] +'\'';
                    if(i != listowners.size())
                    ownercondition += ' AND ';
                }
                ownercondition += ' ) ';
                whereclause += Test.isRunningTest()?'':ownercondition ;
            }
            if(System.Label.Appian_Case_Record_Types != '' && System.Label.Appian_Case_Record_Types != null){  
                rectypecondition += ' AND ( ';
                List<String> listrecs = System.Label.Appian_Case_Record_Types.split(',');
                for(Integer i=1; i<= listrecs.size(); i++){
                    rectypecondition += ' RecordType.Name = \''+ listrecs[i-1] +'\'';
                    if(i != listrecs.size())
                    rectypecondition += ' OR ';
                }
                rectypecondition += ' ) ';
                whereclause += rectypecondition;
            }
            if(reqdetails.GCESegment == '' || reqdetails.GCESegment == null || reqdetails.GCESegment == 'All'){
                segmentcondition += ' AND ( Account.GCE_Customer_Segment__c = \'\' OR ';
                List<String> listsegments = segments.split(',');
                for(Integer i=1; i<=listsegments.size(); i++){
                    segmentcondition += ' Account.GCE_Customer_Segment__c = \''+listsegments[i-1]+'\' '; 
                    if(i != listsegments.size())
                    segmentcondition += ' OR ';
                }
                segmentcondition += ' ) ';
                whereclause += segmentcondition;
            }else{
                segmentcondition += ' AND ( ';
                if(reqdetails.GCESegment == 'NA'){
                    segmentcondition += ' Account.GCE_Customer_Segment__c = \'\' ';
                }else{
                    List<String> listsegments = reqdetails.GCESegment.split(',');
                    for(Integer i=1; i<=listsegments.size(); i++){
                        segmentcondition += ' Account.GCE_Customer_Segment__c = \''+listsegments[i-1]+'\' '; 
                        if(i != listsegments.size())
                        segmentcondition += ' OR ';
                    }
                }
                segmentcondition += ' ) ';
                whereclause += segmentcondition;
            }
            if(reqdetails.CustomerName != '' && reqdetails.CustomerName != null){
                accountcondition += ' AND ( ';
                List<String> listcusts = reqdetails.CustomerName.split(',');
                for(Integer i=1; i<= listcusts.size(); i++){
                    accountcondition += ' Account.Name Like \''+listcusts[i-1]+'%\'';
                    if(i != listcusts.size())
                    accountcondition += ' OR ';
                }
                accountcondition += ' ) ';
                whereclause += accountcondition;
            }
            if(reqdetails.GCECSSAssignment != '' && reqdetails.GCECSSAssignment != null){
                assignmentcondition += ' AND ( ';
                List<String> listassigns = reqdetails.GCECSSAssignment.split(',');
                for(Integer i=1; i<=listassigns.size(); i++){
                    assignmentcondition += ' Account.GCE_CSS_Assignment__r.Name LIKE \''+listassigns[i-1]+'%\'';
                    if(i != listassigns.size())
                       assignmentcondition += ' OR ';  
                }
                assignmentcondition  += ' ) ';
                whereclause += assignmentcondition;
            }
            if(reqdetails.CSSRegion != '' && reqdetails.CSSRegion != null){
                regioncondition += ' AND ( ';
                if(reqdetails.CSSRegion == 'NA'){
                    regioncondition += ' Account.GCE_CSS__c = \'\' ';
                }else{
                    List<String> listregions = reqdetails.CSSRegion.split(',');
                    for(Integer i=1; i<=listregions.size(); i++){
                        regioncondition += ' Account.GCE_CSS__c = \''+listregions[i-1]+'\'';
                        if(i != listregions.size())
                        regioncondition += ' OR ';
                    }
                }
                regioncondition += ' ) ';
                whereclause += regioncondition;
            }
            if(reqdetails.CSSType != '' && reqdetails.CSSType != null){
                typecondition  += ' AND ( ';
                if(reqdetails.CSSType == 'NA'){
                    typecondition  += ' Account.GCE_CSS_Type__c = \'\' ';
                }else{
                    List<String> listtypes = reqdetails.CSSType.split(',');
                    for(Integer i=1; i<=listtypes.size(); i++){
                        typecondition  += ' Account.GCE_CSS_Type__c = \''+listtypes[i-1]+'\'';
                        if(i != listtypes.size())
                        typecondition  += ' OR ';
                    }
                }
                typecondition  += ' ) ';
                whereclause += typecondition;
            }
            if(reqdetails.DocType != '' && reqdetails.DocType != null){
                if(reqdetails.DocType == 'CASE'){
                    documentcondition  += ' AND ( ';
                    List<String> listids = reqdetails.DocumentNumber.split(',');
                    for(Integer i=1; i<=listids.size(); i++){
                        documentcondition  += ' CaseNumber =\''+listids[i-1]+'\'';
                        if(i != listids.size())
                        documentcondition  += ' OR ';
                    }
                    documentcondition  += ' ) ';
                }
                else if(reqdetails.DocType  == 'PO'){
                    documentcondition  += ' AND ( ';
                    List<String> listpos = reqdetails.DocumentNumber.split(',');
                    for(Integer i=1; i<=listpos.size(); i++){
                        documentcondition  += ' Customer_PO_RO_WONumber__c LIKE \''+listpos[i-1]+'%\'';
                        if(i != listpos.size())
                        documentcondition  += ' OR ';
                    }
                    documentcondition  += ' ) ';
                }
                else if(reqdetails.DocType == 'SO'){
                    documentcondition  += ' AND ( ';
                    List<String> listsos = reqdetails.DocumentNumber.split(',');
                    for(Integer i=1; i<=listsos.size(); i++){
                        documentcondition  += ' Sales_Order_Number__c LIKE \''+listsos[i-1]+'%\'';
                        if(i != listsos.size())
                        documentcondition  += ' OR ';
                    }
                    documentcondition  += ' ) ';
                }
                else{
                    documentcondition  += ' AND ( ';
                    List<String> listrns = reqdetails.DocumentNumber.split(',');
                    for(Integer i=1; i<=listrns.size(); i++){
                        documentcondition  += ' Repair_Notification_Number__c LIKE \''+listrns[i-1]+'%\'';
                        if(i != listrns.size())
                        documentcondition  += ' OR ';
                    }
                    documentcondition  += ' ) ';
                }
                
                whereclause += documentcondition;
            }
            CaseOverViewResponse response;
            if(reqdetails.StatusFlag == 'Y'){
                String status = reqdetails.CaseStatus != null && reqdetails.CaseStatus != '' && mapstatusconditions.containsKey(reqdetails.CaseStatus) ? reqdetails.CaseStatus : 'ALLCASE'; 
                limitcondition = ' LIMIT ';
                limitcondition += reqdetails.PageSize != null && reqdetails.PageSize != '' ? reqdetails.PageSize : ' 200 ';
                String sortcondition = ' ORDER BY CaseNumber DESC ';
                whereclause += reqdetails.NextPageSet != null && reqdetails.NextPageSet != '' ? ' AND CaseNumber < \''+reqdetails.NextPageSet+'\'' : '';
                listquery += whereclause + mapstatusconditions.get(status) + sortcondition  + limitcondition ;
                List<CaseDetail> listcases    = new List<CaseDetail>();
                for(Case each_case : DataBase.query(listquery)){
                    listcases.add(new CaseDetail(    each_case.CaseNumber, each_case.Owner.Name, each_case.Account.Name, each_case.Account_Number_web__c, 
                                                     each_case.Part_Number__c, each_case.Product_Serial_Number__c, each_case.Status, each_case.Sub_Status__c, each_case.Reason_for_hold__c, 
                                                     each_case.VN_Name__r.Name, each_case.Type, each_case.Sub_Class__c,each_case.Age_in_Hours__c,  
                                                     each_case.CreatedDate.format(), each_case.RecordType.Name, each_case.Due_Date__c!=null?each_case.Due_Date__c.format():'', 
                                                     each_case.Case_Complexity__c, each_case.Account.GCE_CSS_Assignment__r.Name, each_case.Plant__r.Name,each_case.LastModifiedDate.format(), 
                                                     each_case.AgeOfCurrentHoldInHours__c
                                                ));
                }
               response = listcases.size()>0 ? new CaseOverViewResponse(  listcases.size()>0 ? listcases[listcases.size()-1].CaseNumber : '',
                                                     status == 'OPEN'?listcases.size():0, 
                                                     status == 'ON-HOLD'?listcases.size():0, 
                                                     status == 'ON-HOLD Response'?listcases.size():0,
                                                     status == 'REOPEN'?listcases.size():0, 
                                                     status == 'ESCALATED'?listcases.size():0, 
                                                     status == 'ALLCASE'?listcases.size():0, 
                                                     status == 'OPEN'?listcases:new List<CaseDetail>(), 
                                                     status == 'ON-HOLD'?listcases:new List<CaseDetail>(), 
                                                     status == 'ON-HOLD Response'?listcases:new List<CaseDetail>(),
                                                     status == 'REOPEN'?listcases:new List<CaseDetail>(), 
                                                     status == 'ESCALATED'?listcases:new List<CaseDetail>(), 
                                                     status == 'ALLCASE'?listcases:new List<CaseDetail>() 
                                                   ) : null ;
            }
            else{
                opencasesquery += countquery + whereclause + openstatuscondition + limitcondition ;
                
                holdcasesquery += countquery + whereclause + holdstatuscondition + limitcondition ;
                
                holdrescasesquery += countquery + whereclause + holdresstatuscondition + limitcondition ;
                
                reopenedcasesquery += countquery + whereclause + reopenedstatuscondition + limitcondition ;
                
                escalatedcasesquery += countquery + whereclause + escalatedstatuscondition + limitcondition ;
                
                Integer opencases        = DataBase.countQuery(opencasesquery);
                Integer holdcases        = DataBase.countQuery(holdcasesquery);
                Integer holdrescases     = DataBase.countQuery(holdrescasesquery);
                Integer reopenedcases    = DataBase.countQuery(reopenedcasesquery);
                Integer escalatedcases   = DataBase.countQuery(escalatedcasesquery);
                Integer allcases         = opencases + holdcases + holdrescases + reopenedcases; 
                
                response = new CaseOverViewResponse('', opencases, holdcases, holdrescases, reopenedcases, escalatedcases, allcases, new List<CaseDetail>(), new List<CaseDetail>(), new List<CaseDetail>(), new List<CaseDetail>(), new List<CaseDetail>(), new List<CaseDetail>());
            }
            res.responseBody = response != null ? Blob.valueOf(JSON.serializePretty(response)) : Blob.valueOf('No Data Found');
            res.statusCode = 200;
        }catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('The following exception has occurred: '+ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
    }
    // Request Parameters
    global class GCESegmentDetail{
        global String HonOrgId;
        global String GCESegment;
        global String CustomerName;
        global String GCECSSAssignment;
        global String CSSRegion;
        global String CSSType;
        global String DocType;
        global String DocumentNumber;
        global String StatusFlag;
        global String CaseStatus;
        global String PageSize;
        global String NextPageSet;
        global GCESegmentDetail(){
        }
    }
    // Response Parameters
    global class CaseOverViewResponse{
        global String  NextRecordsSetData;
        global Integer CSSOpenCases;
        global Integer CSSOnHoldCases;
        global Integer CSSOnHoldResponseCases;
        global Integer CSSReOpenedCases;
        global Integer CSSEscalatedCases;
        global Integer CSSAllCases;
        global List<CaseDetail> OpenCaseDetails;
        global List<CaseDetail> HoldCaseDetails;
        global List<CaseDetail> HoldResponseCaseDetails;
        global List<CaseDetail> ReOpenedCaseDetails;
        global List<CaseDetail> EscalatedCaseDetails;
        global List<CaseDetail> AllCaseDetails;
        
        global CaseOverViewResponse( String NextRecordsSetData, Integer CSSOpenCases, Integer CSSOnHoldCases, Integer CSSOnHoldResponseCases, Integer CSSReOpenedCases, 
                                    Integer CSSEscalatedCases, Integer CSSAllCases, List<CaseDetail> OpenCaseDetails, 
                                    List<CaseDetail> HoldCaseDetails, List<CaseDetail> HoldResponseCaseDetails, List<CaseDetail> ReOpenedCaseDetails, List<CaseDetail> EscalatedCaseDetails, 
                                    List<CaseDetail> AllCaseDetails){
            this.NextRecordsSetData       = NextRecordsSetData;
            this.CSSOpenCases             = CSSOpenCases;
            this.CSSOnHoldCases           = CSSOnHoldCases;
            this.CSSOnHoldResponseCases   = CSSOnHoldResponseCases;
            this.CSSReOpenedCases         = CSSReOpenedCases;
            this.CSSEscalatedCases        = CSSEscalatedCases;
            this.CSSAllCases              = CSSAllCases;
            this.OpenCaseDetails          = OpenCaseDetails; 
            this.HoldCaseDetails          = HoldCaseDetails;
            this.HoldResponseCaseDetails  = HoldResponseCaseDetails;
            this.ReOpenedCaseDetails      = ReOpenedCaseDetails;
            this.EscalatedCaseDetails     = EscalatedCaseDetails;
            this.AllCaseDetails           = AllCaseDetails;                           
        }
    }
    // Response Parameters Case Details
    global class CaseDetail{
        global String CaseNumber;
        global String CaseOwner;
        global String AccountName;
        global String CRMID;
        global String PartNumber;
        global String SerialNumber;
        global String Status;
        global String SubStatus;
        global String ReasonForHold;
        global String EscalatedTo;
        global String Type;
        global String SubClass;
        global Decimal  Age;
        global String DateTimeOpened;
        global String CaseRecordType;
        global String DueDate;
        global String Responsibilities;
        global String GCECSSAssignment;
        global String Plant;
        global String LastModified;
        global Decimal AgeonCurrentHold;
        
        global CaseDetail(String CaseNumber, String CaseOwner, String AccountName, 
                           String CRMID, String PartNumber, String SerialNumber, String Status, 
                           String SubStatus, String ReasonForHold, String EscalatedTo, String Type, 
                           String SubClass, Decimal Age, String DateTimeOpened, String CaseRecordType, 
                           String DueDate, String Responsibilities, String GCECSSAssignment, String Plant, 
                           String LastModified, Decimal AgeonCurrentHold){
            this.CaseNumber         = CaseNumber;
            this.CaseOwner          = CaseOwner;
            this.AccountName        = AccountName;
            this.CRMID              = CRMID;
            this.PartNumber         = PartNumber;
            this.SerialNumber       = SerialNumber;
            this.Status             = Status;
            this.SubStatus          = SubStatus;
            this.ReasonForHold      = ReasonForHold;
            this.EscalatedTo        = EscalatedTo;
            this.Type               = Type;
            this.SubClass           = SubClass;
            this.Age                = Age;
            this.DateTimeOpened     = DateTimeOpened;
            this.CaseRecordType     = CaseRecordType;
            this.DueDate            = DueDate;
            this.Responsibilities   = Responsibilities;
            this.GCECSSAssignment   = GCECSSAssignment;
            this.Plant              = Plant;
            this.LastModified       = LastModified;
            this.AgeonCurrentHold   = AgeonCurrentHold;
        }
    }
}
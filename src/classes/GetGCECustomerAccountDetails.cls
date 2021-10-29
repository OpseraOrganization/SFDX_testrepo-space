/*********
*** @@ DESC : This Rest Service Class will expose the service with Customer Details Based on Customer Segement filter.
*** @@ COMPONENTName : GetGCECustomerAccountDetails
*** @@ URL MAPPING : /services/apexrest/GetGCECustomerAccountDetails
*** @@ REST METHOD : POST
*** @@ Request Parameters : HonOrgId,GCESegment
*** @@ Response Parameters : GCESegment,CustomerName,CRMID,CSSAssignment,CSSRegion,CSSType
*** @@ Response Type : JSON Format
**********/
@RestResource(urlMapping='/GetGCECustomerAccountDetails/*')
global with sharing class GetGCECustomerAccountDetails{
    // POST Method 
    @HttpPost
    global static Void doPost(){
        List<GCECustomerDetails> listcustomerdetails = new List<GCECustomerDetails>();
        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;
        try{
            String segments = System.Label.Appian_Case_Segments;
            res.addHeader('Content-Type', 'application/json');
            GCESegmentDetail reqdetails = (GCESegmentDetail)JSON.deserializeStrict(req.requestBody.toString(),GCESegmentDetail.class);
            String query = 'Select Id,Name,AccountNumber,Sbl_Account_Row_Id__c,GCE_CSS_Assignment__c,GCE_CSS_Assignment__r.Name,GCE_CSS__c,GCE_CSS_Type__c,GCE_Customer_Segment__c,SFDC_Row_Id__c FROM Account Where Customer_Status__c = \'Active\' AND ';
            if(reqdetails.GCESegment == '' || reqdetails.GCESegment == null || reqdetails.GCESegment == 'All'){
                query += ' ( ';
                List<String> listsegments = segments.split(',');
                for(Integer i=1; i<=listsegments.size(); i++){
                    query += ' GCE_Customer_Segment__c = \''+listsegments[i-1]+'\' ';
                    if(i != listsegments.size())
                    query += ' OR ';
                }
                query += ' ) ';
            }else{
                query += ' GCE_Customer_Segment__c =\''+reqdetails.GCESegment+'\'';
            }
            query += ' ORDER BY Sbl_Account_Row_Id__c DESC LIMIT 50000';
            for(Account eachacc : DataBase.query(query)){
                listcustomerdetails.add(new GCECustomerDetails(eachacc.GCE_Customer_Segment__c, eachacc.Name, eachacc.Sbl_Account_Row_Id__c, eachacc.GCE_CSS_Assignment__r.Name, eachacc.GCE_CSS__c, eachacc.GCE_CSS_Type__c )); //, eachacc.SFDC_Row_Id__c
            }
            res.statusCode = 200;
            res.responseBody = listcustomerdetails.size()>0 ? Blob.valueOf(JSON.serializePretty(listcustomerdetails)) : Blob.valueOf('No Data Found');
        }catch(Exception ex){
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('The following exception has occurred: '+ex.getTypeName() + ' - ' + ex.getCause() + ': ' + ex.getMessage());
        }
    }
    // Request Parameters 
    global class GCESegmentDetail{
        global String HonOrgId;
        global String GCESegment;
        global GCESegmentDetail(){
        }
    }
    // Response Parameters
    global class GCECustomerDetails{
        global String GCESegment;
        global String CustomerName;
        global String CRMID;
        global String CSSAssignment;
        global String CSSRegion;
        global String CSSType;
        //global String CustomerAccountNumber;
        global GCECustomerDetails(String GCESegment, String CustomerName, String CRMID, String CSSAssignment, String CSSRegion, String CSSType ){ // , String CustomerAccountNumber
            this.GCESegment             = GCESegment;
            this.CustomerName           = CustomerName;
            this.CRMID                  = CRMID;
            this.CSSAssignment          = CSSAssignment;
            this.CSSRegion              = CSSRegion;
            this.CSSType                = CSSType;
            //this.CustomerAccountNumber  = CustomerAccountNumber;
        }
    }
}
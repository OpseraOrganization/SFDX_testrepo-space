/** * File Name: QuoteupdateWebserviceController
* Description Rest Webservice class to Update Quote from CPQ
* Copyright : NTTDATA Copyright (c) 2019
* * @author : NTTDATA
Ver Date Author v1.0 15/07/2019
* */ 
@RestResource(urlMapping='/AerospaceQuoteService/*')
global without sharing class QuoteupdateWebserviceController {
    @HttpPost
    global static void doPost()
    {
        RestRequest req = RestContext.request;
        RestContext.response.addHeader('Content-Type', 'application/json');
        system.debug('-----------Recieved data--------'+req.requestBody.toString()) ;
        String replaceIllegal= req.requestBody.toString();    
         system.debug('-----------Recieved data--------'+replaceIllegal) ;
        QuoteRecord QuoteDetail = (QuoteRecord)JSON.deserialize(replaceIllegal,QuoteRecord.class);     
        system.debug('----------Opportunity Records List----------'+QuoteDetail);
        string errMessage = ' ';       
       // Update Quote 
        if(QuoteDetail.SFDCQuoteID != null)
        {                
            List<Quote__c> quote=[select id,name,Revenue_Amount__c,Quote_Expiration_Date__c   from Quote__c where id=:QuoteDetail.SFDCQuoteID limit 1];     
            if(quote.size()>0)
            {
                if((QuoteDetail.QuoteRevenueAmount != null && QuoteDetail.QuoteRevenueAmount != ''  ))
                quote[0].Revenue_Amount__c=decimal.valueof(QuoteDetail.QuoteRevenueAmount);
                if (QuoteDetail.QuoteExpirationDate != null && QuoteDetail.QuoteExpirationDate != ''  )
                quote[0].Quote_Expiration_Date__c = QuoteDetail.QuoteExpirationDate;           
                //update quote;             
            }             
            try {
                update quote; 
                system.debug('@@@@update quote@@@@@'+quote);
            }
            catch(Exception e)  // exception handling
            {
                System.debug('The following exception has occurred: '+e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
                errMessage = e.getMessage();
                //return errMessage; 
            }              
            if(errMessage!= null && errMessage!=' '){
                QuoteResponse QuoteResponse = new QuoteResponse('Failure',QuoteDetail.OpportunityID,errMessage,QuoteDetail.QuoteID);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(QuoteResponse));
            }else{   
                QuoteResponse QuoteResponse = new QuoteResponse('Success',QuoteDetail.OpportunityID,null,QuoteDetail.QuoteID);   
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(QuoteResponse));
            }
        }
        else
        {
            errMessage = 'Exception on founding SFDC QuoteID';             
            if(errMessage!= null && errMessage!=' '){
                QuoteResponse QuoteResponse = new QuoteResponse('Failure',QuoteDetail.OpportunityID,errMessage,QuoteDetail.QuoteID);
                RestContext.response.responseBody = Blob.valueOf(JSON.Serialize(QuoteResponse));
            }
        }
    }  
    Public class QuoteResponse
    {
        public String status;
        public String opportunityID;
        public String Quoteid;
        public String error;       
        public QuoteResponse(String statusmsg,String opptyID,String errormsg,String Quoteidval){
            Quoteid = ' ';
            error = ' ';
            system.debug('###'+statusmsg+'@@@'+opptyID);
            status = statusmsg;
            opportunityID = opptyID;
            Quoteid = Quoteidval;
            if(errormsg!= null)
                error = errormsg;
        }
    }  
    public class QuoteRecord   
    {
        public string AccountID ;
        public string OpportunityID ;
        public string SFDCQuoteID;
        public string QuoteID;
        public string QuoteNumber;
        public string QuoteName;
        public string QuoteStatus;
        public string Primary;
        public string QuoteExpirationDate;
        public string QuoteRevenueAmount; 
        public string LastModified;
        public string LastModifiedBy;        
        public QuoteRecord()
        {          
        }
    }
}
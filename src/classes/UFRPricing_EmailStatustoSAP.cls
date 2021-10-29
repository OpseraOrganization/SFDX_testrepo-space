/*******************************************************************************
Name            :   UFRPricing_EmailStatustoSAP
Created By      :   Harikishore V
Company Name    :   NTT Data
Project         :   <Phase-II>, <UFR Pricing> 
Created Date    :   28-August-2015
Usages          :   Sending Case Emails status to SAP PI, this class used in EMAfterInsertHelperClass         
*******************************************************************************/

Public class UFRPricing_EmailStatustoSAP{
    @future(callout=true)
    Public static void SendEmailStatus(String SONum,String CasNum,String Status,Decimal UFRAmt,String Type,String TaskZ100,String TaskZ135,String TaskZ136,String TaskZ144,String UFRSBU){
        try{
            //Preparing SOAP envelope
            string envelope= '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:stat="http://hnwl.com/INFOC00059/UFR/Status">'+
                '<soapenv:Header/>'+
                '<soapenv:Body>'+
                '<stat:MT_Status>'+
                '<Record>'+
                '<PoOrQuoteNum>'+SONum+'</PoOrQuoteNum>'+
                '<CaseNum>'+CasNum+'</CaseNum>'+
                '<Status>'+Status+'</Status>'+
                '<UFRPrice>'+UFRAmt+'</UFRPrice>'+
                '<Type>'+Type+'</Type>'+
                '<TaskZ100>'+TaskZ100+'</TaskZ100>'+
                '<TaskZ135>'+TaskZ135+'</TaskZ135>'+
                '<TaskZ136>'+TaskZ136+'</TaskZ136>'+
                '<TaskZ144>'+TaskZ144+'</TaskZ144>'+
                '<SBU>'+UFRSBU+'</SBU>'+
                '</Record>'+
                '</stat:MT_Status></soapenv:Body></soapenv:Envelope>';
                
            System.debug('envelope--->'+envelope);
            HttpRequest req = new HttpRequest();
            //req.setEndpoint(label.UFR_Pricing_Endpoint); //Service URL
            req.setEndpoint(label.UFR_Endpoint_QA); //Service URL
            req.setMethod('POST');
            Blob headerValue = Blob.valueOf(label.UFR_UserName_and_Pass);
            String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type','application/xml');
            req.setTimeout(120000);
            req.setHeader('SOAPAction', 'http://sap.com/xi/WebService/soap1.1');
            req.setBody(envelope);
            
            Http http = new Http();
            HTTPResponse res = http.send(req);  
        }catch(Exception e){
            system.debug('UFR Pricing - exception occurs while sending data to SAP'+e.getMessage());
        }
    }    
}
@RestResource(urlMapping='/billingservices/*')
global class APIGEE_APTS_BillingService_REST {
    
    @httpPUT
    global static void approveRejectInvoice(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        APTS_InvoiceActionResult invoiceActionRes;
        try{
            String requestBody = req.requestBody.toString();
            InvoiceRequest proposalLineItem = (InvoiceRequest)JSON.deserialize(requestBody, InvoiceRequest.class);
            if(proposalLineItem!=Null){
                if(proposalLineItem.isApprove){
                    invoiceActionRes = APTS_BillingService.approveInvoice(proposalLineItem.invoiceIds);
                }else{
                    invoiceActionRes = APTS_BillingService.cancelInvoice(proposalLineItem.invoiceIds);
                }
            }
            
        }catch(Exception ex){
            res.statusCode = 400;
            invoiceActionRes = new APTS_InvoiceActionResult();
            invoiceActionRes.setSuccess(false);
            invoiceActionRes.setMessage(ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(invoiceActionRes));
    }
    
    public class InvoiceRequest{
        public List<String> invoiceIds;
        public Boolean isApprove;
    }
}
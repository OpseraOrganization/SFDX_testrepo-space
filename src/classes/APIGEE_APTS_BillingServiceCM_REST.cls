@RestResource(urlMapping='/billingservicescm/*') 
global class APIGEE_APTS_BillingServiceCM_REST {
    @httpPUT
    global static void approveRejectCreditMemo(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        APTS_CreditMemoActionResult creditMemoActionRes;
        try{
            String requestBody = req.requestBody.toString();
            CreditMemoRequest proposalLineItem = (CreditMemoRequest)JSON.deserialize(requestBody, CreditMemoRequest.class);
            if(proposalLineItem!=Null){
                if(proposalLineItem.isApprove){
                    creditMemoActionRes = APTS_BillingService.approveCreditMemo(proposalLineItem.creditMemoIds);
                }else{
                    creditMemoActionRes = APTS_BillingService.cancelCreditMemo(proposalLineItem.creditMemoIds);
                }
            }
            
        }catch(Exception ex){
            res.statusCode = 400;
            creditMemoActionRes = new APTS_CreditMemoActionResult();
            creditMemoActionRes.setSuccess(false);
            creditMemoActionRes.setMessage(ex.getMessage());
        }
        res.responseBody = Blob.valueOf(JSON.serialize(creditMemoActionRes));
    }
    
    public class CreditMemoRequest{
        public List<String> creditMemoIds;
        public Boolean isApprove;
    }
}
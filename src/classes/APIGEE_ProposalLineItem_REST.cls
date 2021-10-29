@RestResource(urlMapping='/proposallineitem/*') 
global class APIGEE_ProposalLineItem_REST {
    @HttpGET
    global static void proposalLineItemGET(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        APIGEE_Result result = new APIGEE_Result();
        
        String name = req.params.get('name');
        if(String.isNotBlank(name)){
            result.data = [select Id from Apttus_Proposal__Proposal_Line_Item__c where Name=:name];
        }else{
           res.statusCode = 400;
           result.status = 'FAIL';
           result.StatusCode=400;
           result.error = new APIGEE_Error(400,System.now(),Null,'Please Provide the Proposal Line Item Name');
        }
        res.responseBody = Blob.valueOf(JSON.serialize(result));
    }
}
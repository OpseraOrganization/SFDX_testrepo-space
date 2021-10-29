/*********************************************
    Class Name       : RDF_AutomaticCaseApproval 
    Visualforce Page :
    Test Class       : RDF_AutomaticCaseApprovalController_Test 
    Created On       : August 2018
    Project          : RDF - One - Off Discount process
    Created By       : Suryanarayana Tvvsn
    Purpose          : This approval process is used to submit the record for approval dynamically with Recordtype name = RDF_One-Off
                        Discount Approval and "Escalated To" field in not equal to null.
*********************************************/
Public class RDF_AutomaticCaseApprovalController{

Public Boolean ValidateResult {get; set;}

    public void submitForApproval() 
    {
        Id devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        list<case> caselist = [select id,RecordTypeid,User_VN_Name__c,OwnerId from case where id =: currentRecordId];
        // Create an approval request for the Case
        for(case newcase : caselist){
            if(newcase.RecordTypeId == devRecordTypeId){
                try{ 
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setComments('Submitting request for approval automatically');
                request.setObjectId(newcase.id);
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(request);
                ValidateResult = True;
                }
                Catch(Exception e){}
            }
        }
    }
    
     public void submitForApprovalChilds() 
    {
        //RecordType rec = [SELECT name FROM RecordType WHERE SObjectType = 'case' and name = 'RDF_One-Off Discount Approval'];
        Id devRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId();
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        list<SEA_Approval__c> DiscountApplist = [Select id, Name, Approval_Status__c,Approver_Name__c from SEA_Approval__c where Case__c =: currentRecordId];
        // Create an approval request for the Case
        for(SEA_Approval__c newcase : DiscountApplist){
            if(newcase.Approver_Name__c !=null){
                try{ 
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setComments('Submitting Internal Approval request automatically');
                request.setObjectId(newcase.id);
                //request.setNextApproverIds(new Id[] {newcase.Approver_Name__c});
                
                // Submit the approval request for the Case
                Approval.ProcessResult result = Approval.process(request);
                //ValidateResult = True;
                }
                Catch(Exception e){}
            }
        }
    } 
}
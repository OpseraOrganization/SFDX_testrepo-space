/*********************************************
    Class Name       : RDF_OneOffInternalApprovalPageController
    Visualforce Page : RDF_OneOffInternalApprovalPage
    Test Class       : RDF_OneOffInternalApprovalPageCtrlTest 
    Created On       : August 2018
    Project          : RDF - One - Off Discount process
    Created By       : NTTDATA INC
    Purpose          : This extenstion controller is used to validate the case Records and to submit the record for Internal approval process dynamically.
*********************************************/

public class RDF_OneOffInternalApprovalPageController{

 public Id recId;
  public List<Attachment> CaseAttachments ;
  public Case cs;

    public RDF_OneOffInternalApprovalPageController(ApexPages.StandardController controller) {
         recId = ApexPages.currentPage().getParameters().get('id');
         cs=[Select Id,contact.Id,Priority,Subject,Description,CreatedDate,Sub_Status__c,Classification__c,Show_in_Community_Flag__c,OwnerId,ContactId,
            CaseNumber,Is_Record_Submited_for_Approval__c,Status,VN_Name__c,
            CreatedBy.Name, User_VN_Name__r.name,User_VN_Name__c,User_VN_Name__r.Email,(Select id, Name, Approval_Status__c,Approver_Name__c from SEA_Approvals__r) From Case where id = :recId];
    }
    public PageReference validateandSubmit() {

         if(recId != Null){
            Integer InternalApproverCount = cs.SEA_Approvals__r.size();
            
            if(InternalApproverCount == 0){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'No Internal Approvers has been added to initiate the Internal Approval process. Please add the same if any / click Send To Community button to initiate the External process.'));
                return null;
            }
            else{
            
                CaseAttachments =[Select Id from Attachment Where ParentId = :recId];
                Set<String> contentDocIdSet = new Set<String>();
                for(ContentDocumentLink  lin : [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId = :recId])
                {
                    contentDocIdSet.add(lin.ContentDocumentId);
                }          
                
                if(cs.User_VN_Name__c == null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'External Approver cannot be blank to release for External Approval'));
                    return null;
                }
                if(CaseAttachments.isEmpty() && contentDocIdSet.isEmpty() )
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Please add minimum one quote to release for Internal Approval'));
                    return null;
                }
                if(cs.Is_Record_Submited_for_Approval__c == true && cs.Sub_Status__c =='Approved')
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has been approved already by Internal Approver'));
                    return null;
                }
                else if(cs.Show_in_Community_Flag__c == true && cs.Classification__c == 'Customer Approved'){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has been approved already by External Approver'));
                    return null;
                }
                if(cs.Is_Record_Submited_for_Approval__c == true && (cs.Sub_Status__c == '' || cs.Sub_Status__c == null))
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has been submitted for Internal approval already'));
                    return null;
                }
                else if(cs.Is_Record_Submited_for_Approval__c == true && (cs.Sub_Status__c == 'Rejected'))
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has been rejected. Hence you cannot send the same to Community'));
                    return null;
                }
                else if(cs.Show_in_Community_Flag__c == true && (cs.Classification__c == '' || cs.Classification__c == null))
                {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has been submitted for External approval already'));
                    return null;
                }
                if(cs.Sub_Status__c =='Approved' || cs.Sub_Status__c == 'Rejected'){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has already been processed by Internal Approvers'));
                    return null;
                }
                if(cs.Classification__c =='Customer Approved' || cs.Classification__c == 'Customer Rejected'){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Your quote has already been processed by External Approvers'));
                    return null;
                }
                
                //if(((CaseAttachments.size()>0) || (contentDocIdSet.size()>0)) && ((cs.FSE_Name_1__c != null && cs.FSE_Name_2__c != null && cs.FSE_Name_3__c != null) && cs.Is_Record_Submited_for_Approval__c == false))
                if(((CaseAttachments.size()>0) || (contentDocIdSet.size()>0)) && (InternalApproverCount != 0 && cs.Is_Record_Submited_for_Approval__c == false))
                { 
                    
                    sendEmail(cs,contentDocIdSet,'Internal');
                   
                }
                else if((CaseAttachments.size()>0 || contentDocIdSet.size()>0) && cs.User_VN_Name__c != null && cs.Sub_Status__c == 'Approved' && cs.Show_in_Community_Flag__c == false){
                     //sendEmail(cs,contentDocIdSet,'External');
                     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.WARNING,'Please click Send To Community button to initiate the External Approval.'));
                     return null;
                }
            } 
                   
        }
        return null;
    }
    
    public PageReference back()
    {
        PageReference page = new PageReference('/'+cs.id);
        page.setRedirect(true);
        return page;
    }
    
    public Pagereference sendEmail(Case c,Set<String> contentDocumentIds, String approvalType)
    {
        
        //Send email
        try
        {
           
           if(approvalType =='Internal'){
               
               c.Is_Record_Submited_for_Approval__c = true;
               c.Status ='Awaiting Approval';
               RDF_AutomaticCaseApprovalController autosubmission = new RDF_AutomaticCaseApprovalController();
               autosubmission.submitForApprovalChilds();
               update c;
              //RDF_AutomaticCaseApprovalController autosubmission = new RDF_AutomaticCaseApprovalController();
              //autosubmission.submitForApproval();
           }
           else if(approvalType =='External'){
               RDF_AutomaticCaseApprovalController autosubmission = new RDF_AutomaticCaseApprovalController();
               autosubmission.submitForApproval();
           }
           
           //update c;
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Case record has been submitted for Approval successfully'));   
            return null;
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage())); 
            return null;
        }
        
        
    }

}
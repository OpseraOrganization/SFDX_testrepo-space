/**
 * Created by Satya Mohanty on 6/21/2020.
 * OWNED BY THE CRM SALES TEAM.
 */
public class OfferingsFromCancelOppty{
    String offeringsIds;
    public List<OpportunityLineItem> lineItemLsts{get;set;}
    public offeringsFromCancelOppty(ApexPages.StandardController controller) {
        offeringsIds = ApexPages.CurrentPage().getparameters().get('id');
        getMatchedProduct();
    }
    
    public void getMatchedProduct(){
        Set<Id> oppIds = new Set<Id>();
        lineItemLsts = new List<OpportunityLineItem>();
        for(opportunity oppId : [SELECT Id, Aircraft_Ref__c,Win_Loss_Reason_Code__c FROM Opportunity WHERE Aircraft_Ref__c =: offeringsIds AND StageName = 'Closed Cancelled' AND Win_Loss_Reason_Code__c = 'Parked opportunity']){
            oppIds.add(oppId.Id);
        }
        //List<OpportunityLineItem> lineItemLst = [SELECT ID, Is_RMU__c, Name, OpportunityId, RMU_Platform__c, RMU__c, opportunity.Account.Name FROM OpportunityLineItem WHERE OpportunityId =: oppIds AND Opportunity.sbu__c='BGA'];
        //lineItemLsts = [SELECT ID, Is_RMU__c, Name, opportunity.CloseDate, OpportunityId, RMU_Platform__c, RMU__c, opportunity.Account.Name, Opportunity.LastModifiedBy.Name FROM OpportunityLineItem WHERE OpportunityId =: oppIds AND Opportunity.sbu__c='BGA' AND RMU_Platform__c != NULL];

        for(OpportunityLineItem oli : [SELECT ID, Is_RMU__c, Name, opportunity.CloseDate, OpportunityId,opportunity.Win_Loss_Reason_Code__c, RMU_Platform__c, RMU__c, RMU__r.Name, opportunity.Account.Name, Opportunity.Name, Opportunity.LastModifiedBy.Name FROM OpportunityLineItem WHERE OpportunityId =: oppIds AND Opportunity.sbu__c='BGA' AND RMU__c != NULL]){
            List<OpportunityFieldHistory> ofh = [SELECT CreatedById,CreatedBy.Name,CreatedDate,Field,Id,NewValue,OldValue,OpportunityId FROM OpportunityFieldHistory WHERE Field = 'StageName' and Opportunity.stagename='Closed Cancelled' AND OpportunityId =: oli.OpportunityId];
            OpportunityLineItem oliOBJ = new OpportunityLineItem();
            oliOBJ.RMU__c = oli.RMU__c;
            oliOBJ.Functional_Help_Required__c = oli.RMU__r.Name;
            oliOBJ.OpportunityId = oli.OpportunityId;
            oliOBJ.Closure_Actions__c = oli.Opportunity.Name;
            oliOBJ.Description__c = oli.opportunity.Account.Name;
            oliOBJ.APO_Firming_Date__c = oli.opportunity.CloseDate;
            oliOBJ.Product_Code__c = oli.opportunity.Win_Loss_Reason_Code__c;
            if(ofh.size()>0){
                oliOBJ.Description = ofh[0].CreatedBy.Name;
            }else{
                oliOBJ.Description = '';
            }
            lineItemLsts.add(oliOBJ);
        }
    }
}
/**
 * OWNED BY THE CRM SALES TEAM.
 */
public class DRNewCreationPageController {
    public Discretionary__c DRReq {get;set;}
    public String oppId {get;set;}
    public List<Opportunity_Sales_Team__c> opptSales{get; set;}
    public Integer countv {get;set;}
    public List<Opportunity> opport{get;set;}
    public boolean hasLineProd {get; set;}
     
    public DRNewCreationPageController(ApexPages.StandardController controller){
        hasLineProd = true;
       
        countv =0;
        Id profileId=UserInfo.getProfileId();
        String profileName=[SELECT Id,Name FROM Profile WHERE Id=:profileId].Name;
        oppId = System.currentPageReference().getParameters().get('OppId');
        opport =[SELECT Id, SBU__c, CBT_Tier_2__c, CBT_Team_Tier_3__c, Sales_Channel__c, SC1__c, OwnerId, AccountId, HasOpportunityLineItem,Is_Follow_On_Opportunity__c 
                 FROM Opportunity
                 WHERE Id=:oppId];
        
        if(opport.size()>0 && opport[0].HasOpportunityLineItem == false){
            hasLineProd = false;  
           
        }
        if(opport.size()>0 && opport[0].HasOpportunityLineItem == false && opport[0].Is_Follow_On_Opportunity__c == true){
            hasLineProd = true;
        }
        opptSales = [SELECT Id, User__c
                    FROM Opportunity_Sales_Team__c
                    WHERE User__c =:UserInfo.getUserId()
                    AND Opportunity__c =:oppId];

        if(opptSales.size()<=0 && !profileName.contains('Admin') && opport.size()<=0){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.INFO,'You are ' +
                    'not Authorised to Create DR Please Ensure you are one of the Opportunity Team Member or Owner');
            ApexPages.addMessage(msg);
        }
        
        if(oppId !=null && (opptSales.size()>0  || profileName.contains('Admin') || opport.size()>0 ) ){
            countv = 1;
            DRReq = new Discretionary__c();
            DRReq.Opportunity__c =oppId;
            DRReq.SBU__c = opport[0].SBU__c;
            DRReq.CBT__c = opport[0].CBT_Tier_2__c;
            DRReq.CBT_Team__c = opport[0].CBT_Team_Tier_3__c;
            DRReq.Sales_Channel__c = opport[0].Sales_Channel__c;
            DRReq.SC1__c = opport[0].SC1__c;
            DRReq.OwnerId = UserInfo.getUserId();
            DRReq.Account__c = opport[0].AccountId;
        }
        
        System.debug('Hi I am in constructor after save ==='+DRReq);
    }
    public PageReference cancel()    {
        PageReference newPage = new PageReference('/'+oppId);
        return newPage;
    }
    public PageReference Save(){
        System.debug('I am in save after====='+DRReq);
        Discretionary__c drqv = new Discretionary__c();
        //for(Discretionary__c drq: DRReq){
            if(DRReq.Type__c == 'Bid & Proposal' && hasLineProd == false){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You cannot create a Discretionary Request if the opportunity does not have Opportunity Products attached.Please modify your Opportunity to reflect the appropriate Opportunity Products.'));
                return null;
            }else{
                insert DRReq;
                PageReference newPage = new PageReference('/'+DRReq.Id);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message.'));
                return newPage;
            }
       // }
        //insert DRReq;
        //return null;
    }
}
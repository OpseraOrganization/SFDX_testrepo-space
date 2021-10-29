public class createopportunityDSbutton{
    public id id1;
    public boolean creopp;
    public boolean creopprop=false;
    case cas;
    Set<Id> prodid = New Set<Id>();
    list<DR_Approvers_List__c> Dral = new list<DR_Approvers_List__c>();
    list<opportunitylineitem> insertotl=New list<opportunitylineitem>();
    list<Opportunity_Ship_Set__c> lstoss = new list< Opportunity_Ship_Set__c>();
    public createopportunityDSbutton(ApexPages.StandardController controller){
        id1 = Apexpages.currentPage().getParameters().get('id');     
    }
    public pagereference doinsert(){
        case cs =[select Accountid,Certification_Requirements__c,Contactid,Platform__c,Program__c,Opportunity__c,Opportunity_Type__c,Program_Description__c,Method_received__c,Recevied_by__c,CBT_Team__c ,Contract_Type__c,Customer_issue_date__c, Received_Date__c,Proposal_Response_due_date__c,End_Date__c,Solicitation_Number__c,Contractor_Status__c, Classification__c,Competitive_Name_s_of_Competitor_s__c,SBU__c,CBT__c,Opportunity_Owner__c,New_Proposal_Manager1__c from case where id =:id1];
        list<Case_Line_Item__c> clt=[select id,Product_Number__c,Plant_Code_Master__c,Product_Line__c,Part_Description_Line_Description__c,Quantity__c,If_Yes_Sell_Price_Price__c from Case_Line_Item__c where   Case_Number__c =:id1];
        if(cs.Opportunity__c!=null){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Opportunity has been added already')); 
            creopp=false;
           //return null;
        }else if((cs.Opportunity_Type__c ==Null)||(cs.Opportunity_Type__c =='')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Please Enter Opportunity Type')); 
            return null;
        }else if((cs.Program__c==Null)||(cs.Program__c=='')){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Please Enter Program')); 
            return null;
        }else{
            creopp=true;
        }
        
        if(creopp){
            string recname=cs.Opportunity_Type__c;
            system.debug('**********called successfully**********'+recname);                        
            Id recrdtypid=[select id from recordtype where name=:recname limit 1].Id;
            //Id recrdtypid = '01230000000ZIv2';
            system.debug('**********called successfully**********'+recname);
            Opportunity opp = New opportunity();
            opp.Program__c=cs.Program__c;
            opp.Name=cs.Program__c;
            opp.RecordTypeid=recrdtypid;
            opp.StageName  = 'Prospecting';
            opp.Description=cs.Program_Description__c;
            opp.Platform__c=cs.Platform__c;
            opp.RFP_Sent_Date__c=cs.Customer_issue_date__c;
            opp.RFP_Receipt_Date__c=cs.Received_Date__c;
            opp.Proposal_Due_Date__c=cs.Proposal_Response_due_date__c;
            opp.Accountid=cs.Accountid;
            opp.Certification_Requirements__c=cs.Certification_Requirements__c;
            opp.Proposal_Coordinator_Assigned_Date__c=cs.End_Date__c;
            opp.RFP_Number__c=cs.Solicitation_Number__c;
            opp.Prime_Sub__c=cs.Contractor_Status__c;
            opp.Contract_Type__c=cs.Contract_Type__c;
            opp.CBT_Tier_2__c=cs.CBT__c;
            opp.CBT_Team_Tier_3__c=cs.CBT_Team__c;
            opp.SBU__c=cs.SBU__c;
            opp.Tech_Sales_Product_Area__c='AT';
            opp.CloseDate=system.today()+10;
            insert opp;
             cas = New case(id=id1);
            system.debug('^^^^^^^^^'+opp.Accountid);
            system.debug('^^^^^^^^^'+opp.ownerid);
            system.debug('^^^^^^^^^'+opp.Opportunity_Number__c);
            cas.Opportunity__c=opp.id;
            //cas.Accountid=opp.Accountid;
            opportunity gettingoppnum=[select ownerid,Opportunity_Number__c from opportunity where id=:opp.id];
            cas.Opportunity_Owner__c=gettingoppnum.ownerid;
            cas.Opportunity_Number__c=gettingoppnum.Opportunity_Number__c;
            system.debug('^^^^^^^^^'+cas.Opportunity_Owner__c);
            system.debug('^^^^^^^^^'+cas.Opportunity_Number__c);
            update cas;
            creopprop = True;
            
        }   
            
            
       case c1 = [select id,Opportunity__c,CBT__c,SBU__c,Program_Description__c,Opportunity_Proposal__c,Defined_Due_Date_by__c,Customer_issue_date__c,Solicitation_Number__c,Received_Date_at_Honeywell__c,Proposal_Response_due_date__c,New_Proposal_Manager1__c,Plant__c,Request_Type_Opp__c,Estimated_Proposal_Value__c,Proposal_Content__c from case where id=:id1];
       if((c1.Opportunity_Proposal__c == null)||(c1.Opportunity_Proposal__c != null && creopprop == True)){
                Dral = [ select id,CBT__c,SBU__c,Pricing__c from DR_Approvers_List__c where CBT__c=:c1.CBT__c and SBU__c=:c1.SBU__c limit 1];
                 Opportunity_Proposal__c opprop = new Opportunity_Proposal__c();
                 opprop.Opportunity__c = c1.Opportunity__c;
                 opprop.Description__c = c1.Program_Description__c;
                 opprop.RFP_Receipt_Date__c = c1.Customer_issue_date__c;
                 opprop.Solicitation_Number__c = c1.Solicitation_Number__c;
                 opprop.Proposal_Status__c = 'Backlog (in Queue)';
                 opprop.Proposal_Due_Date__c = c1.Proposal_Response_due_date__c;
                 opprop.Proposal_Coordinator__c = c1.New_Proposal_Manager1__c;
                 opprop.Proposal_Content_Type__c = c1.Proposal_Content__c;
                 opprop.Total_Contract_Value_BAFO__c =  integer.valueof(c1.Estimated_Proposal_Value__c);
                if(Dral.size()>0){
                opprop.Pricing_Analyst__c = Dral[0].Pricing__c;
                opprop.Pricing_Manager__c = Dral[0].Pricing__c;
                }
               opprop.Site__c = c1.Plant__c;
               opprop.Request_Type__c = c1.Request_Type_Opp__c;
               opprop.Defined_Due_Date_by__c = c1.defined_due_date_by__c;
                insert opprop;
            
                c1.Opportunity_Proposal__c = opprop.id;
                update c1;
            }
            
            if(clt.size()>0){
             set<id> ssplst = new set<id>();
             list<Opportunity_Ship_Set__c> osslst = [select id,Ship_Set_Product__c from Opportunity_Ship_Set__c where Opportunity__c=:c1.Opportunity__c ];
             for(Opportunity_Ship_Set__c oss: osslst){
               ssplst.add(oss.Ship_Set_Product__c);
             }
             
             
            
             for(Case_Line_Item__c c:clt){
              if(!ssplst.contains(c.Product_Number__c))
              {
               Opportunity_Ship_Set__c oss = new Opportunity_Ship_Set__c();
               oss.Opportunity__c = c1.Opportunity__c;
               oss.Ship_Set_Product__c = c.Product_Number__c;
               oss.Ship_Set_Source__c = 'Case';
               lstoss.add(oss);
              }
             } 
             if(lstoss.size()>0)
             insert lstoss;
            }
            
          PageReference pageRef = new PageReference('/'+c1.Opportunity__c+'/e?retURL='+c1.Opportunity__c);
          return pageRef ;
    }
}
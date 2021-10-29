@isTest(SeeAllData=true)
private class OpportunityTeamMembersTest {

    

    static testMethod void OpportunityTeamMembersTest(){
        
        List<Opportunity> oppListUpdate= new List<Opportunity>();
        List<Id> oppList= new List<Id>();
        List<Opportunity_Sales_Team__c> oppTeamList= new List<Opportunity_Sales_Team__c>();
        String teamName;
        String tmName;
        
        /*Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';       
        insert acc;*/
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        date testdate = date.parse('03/27/2011');
        
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c=True;
        
        insert p;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Catalog' limit 1].Id;
        opp.RecordTypeId = label.D_S_PrePriced;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Platform__c = p.Id;
        opp.ATR_Aircraft_Quantity__c = 1;
        //opp.Is_Restricted_Opportunity__c = TRUE;
        opp.Active__c = FALSE;
        
        insert opp;
        
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.Opportunity__c = opp.Id;
        ost.User__c = [Select Id,IsActive from User where IsActive=true limit 1].Id;
        insert ost;
        
        oppList.add(ost.Id);
        
        Opportunity_Sales_Team__c ost1 = new Opportunity_Sales_Team__c();
        ost1.Opportunity__c = opp.Id;
        ost1.User__c = [Select Id,IsActive from User where IsActive=true and id<>:ost.User__c limit 1].Id;
        insert ost1;
        
        oppList.add(ost1.Id);
        
        if(oppList.size()>0){
   oppListUpdate=[Select Id,Programme_Manager__c from Opportunity where Id =: opp.Id];
   try{
   oppTeamList=[Select Id,Team_Member_Full_Name__c,Opportunity__c, User__r.Name, User__c  from Opportunity_Sales_Team__c  where Opportunity__c =: opp.Id order by createddate desc];
   }
   catch(Exception e){}              
   }
     try {
     for (integer i=0;i<oppListUpdate.size();i++){
     teamName='';
     tmName='';
        for(integer j=0;j<oppTeamList.size();j++){
          if(oppTeamList[j].User__c != NULL){
          if(oppTeamList[j].User__r.Name != NULL || oppTeamList[j].User__r.Name != ''){
              teamName = teamName + ',' + oppTeamList[j].User__r.Name.substring(oppTeamList[j].User__r.Name.lastIndexOf(' '));
          }// end of if
          }// end of if
        }// end of for
        tmName = teamName.substring(teamName.indexOf(',')+1);
     oppListUpdate[i].TeamMemberLastName__c=tmName;
     
     }// end of for
     }catch(Exception ex){
     }
     try {
     if(oppListUpdate.size()>0)
          update oppListUpdate;
     }catch(Exception ex){}
        
    }
}
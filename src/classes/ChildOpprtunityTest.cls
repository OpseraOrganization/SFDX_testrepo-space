@isTest (seealldata = true)
private class ChildOpprtunityTest {
    testMethod static void ChildOpprtunityTest(){
       
       
    
        date testdate = date.parse('11/23/2017');
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex'].Id;
        opp.SBU__c = 'ATR';
        opp.CBT_Tier_2__c = 'Airbus';       
        opp.Prime_Sub__c = 'Prime';
        opp.StageName = 'Cultivate';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.IC_Scorecard_Opportunity__c = false;
        insert opp;
   
           Test.startTest();
           ChildOpprtunity chil=new ChildOpprtunity();
           string oppid=opp.id;
           String result=ChildOpprtunity.getCloneOpp(oppid);
           //String result1=ChildOpprtunity.deleteOpp(oppid);
           //System.assertEquals(result != null);
          //chil.getCloneOpp(opp.id);
            opp.StageName='Closed Won';
            update opp;
            String result1=ChildOpprtunity.deleteOpp(oppid);

        Test.stopTest();   
        string RecordType = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name like '%D&S Complex' limit 1].Id;
         // opportunity opp = [Select id from opportunity where RecordTypeId =:RecordType limit 1];
     
         OpportunityLineItem oli = new OpportunityLineItem();
         
        ApexPages.currentPage().getParameters().put('id',oli.Id);
        CloneOpportunityProduct co = new CloneOpportunityProduct();
        ApexPages.StandardController con = new ApexPages.StandardController(oli);
        CloneOpportunityProduct cop = new CloneOpportunityProduct(con);
        //ApexPages.StandardController controller1 = new ApexPages.StandardController(cop); 
    
     }
}
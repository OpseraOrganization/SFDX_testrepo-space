@isTest (seealldata = true)
public class ADDChildOpprtunitytest {
    testMethod static void ADDChildOpprtunitytest(){
       
           
    
         Date d1 =Date.newInstance(2009,08,12);
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'D&S Complex'].Id;
        opp.SBU__c = 'BGA';
        opp.CBT_Tier_2__c = 'BGA Other';       
        opp.Prime_Sub__c = 'Prime';
        opp.StageName = 'Cultivate';
        opp.CloseDate =d1;
        opp.Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)';
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Certification_Requirements__c ='Direct Commercial';
        opp.RFP_Expected_Date__c = d1;
        opp.IC_Scorecard_Opportunity__c = false;
      
        insert opp;

   
   Test.startTest();
              ADDChildOpprtunity chil=new ADDChildOpprtunity();
              
              string oppId=opp.id;
              String result= ChildOpprtunity.getCloneOpp(oppid);
            opp.Name= 'Test Oppty1';
           // opp.ATR_Probability__c = 98; 
           // opp.Is_Restricted_Opportunity__c = true; 
           // opp.Is_Follow_On_Opportunity__c = true; 
            opp.StageName='Closed Won';
            update opp;
           
            PageReference pageRef = Page.AddChildOppty;
           Test.setCurrentPage(pageRef);
           pageRef.getParameters().put('id',opp.id);
           ApexPages.StandardController sc = new ApexPages.standardController(opp);
           ADDChildOpprtunity  controller = new ADDChildOpprtunity(sc);
          // System.assertNotEquals(null,controller);

       Test.stopTest();
        
     
     }
     
}
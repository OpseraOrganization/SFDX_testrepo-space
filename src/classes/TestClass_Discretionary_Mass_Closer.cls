@isTest
private class TestClass_Discretionary_Mass_Closer{ 

    static testMethod void Discretionary_Mass_CloserTest(){
		
		Campaign cam = new Campaign();
        cam.Name='test campaign12';
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus';
        cam.Status = 'Planned';
        cam.Type = 'Test';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 645655;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'test';
        insert cam;
    
        
        Discretionary__c dr = new Discretionary__c();
            dr.Program__c = 'Unit Testing Program';
            dr.SBU__c = 'D&S';
            dr.CBT__c = 'Advanced Technology';
            dr.CBT_Team__c = 'ASM: Advanced Sensors & Microsystems';
            dr.CBT_Directorate__c = 'Advanced Sensing Technology';
            dr.Type__c = 'Demo';
        	dr.Campaign__c=cam.id;
            dr.Estimated_Completion_Date__c = system.today();
            dr.Fiscal_Year__c = '2012';
        insert dr;
        
        Test.startTest();
        DateTime tstDateTime = System.now();
        Discretionary_Mass_Closer dmcSchedule= new Discretionary_Mass_Closer();
        String Shdlr=' 0 00 10 * * ?';  
        System.schedule('Test Discretionary Mass Closer',Shdlr,dmcSchedule);
        Test.stoptest(); 
    }
}
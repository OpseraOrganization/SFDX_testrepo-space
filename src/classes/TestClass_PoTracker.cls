/**
 * This class contains unit tests for validating the behavior of PO Tracker Apex classes
 * and triggers.
 *
  */
@isTest
private class TestClass_PoTracker {

    static testMethod void testTriggers() {
    	
    	Id aircraftID = [select Id from  Fleet_Asset_Detail__c LIMIT 1][0].Id;
    	
        BGA_PO_Tracker__c bpt = new BGA_PO_Tracker__c();
        bpt.Name = 'testing record';
        bpt.Fleet_Asset_Aircraft__c = aircraftID;
        bpt.Make_Model__c = 'Test Make Model';
        bpt.SN__c = 'Test123 SN';
        bpt.Status__c = 'Completed';
        
        insert bpt;
        
        BGA_PO_Tracker_Entry__c bpte = new BGA_PO_Tracker_Entry__c();
        bpte.BGA_Purchase_Order__c = bpt.Id;
        bpte.RMU_Date__c = System.today();
        bpte.RMU_Name__c = 'AIS2000';
        bpte.RMU_Config_Detail_Name__c = 'AIS2000';
        
        insert bpte;
     
     	aircraftID = [select Id from  Fleet_Asset_Detail__c where id <> :aircraftID LIMIT 1][0].Id;   
     	
     	bpt.Fleet_Asset_Aircraft__c = aircraftID;
     	
     	update bpt;
     	
     	bpt.Fleet_Asset_Aircraft__c = null;
     	update bpt;
     	
    }
    
    static testMethod void testClasses() {
    	
    	POTracker pot = new POTracker();
    	pot.pageHeaderDetails('EasyII_F900X', 'TOTALPM');
    	pot.getRMUConfigValues();
    	pot.getRMUConfigValuesWithout_Others();
    	//pot.getPoTrackerRecTypeId('DU885');
    	//pot.getPoTrackerRecTypeId(null);
    	pot.getRMUTypeData();
    	pot.getListOfCharts();
    	pot.getNextPage();
    	pot.setLabelNameForRMU();
    	pot.rmuShortNameValue('Baseline');
    	pot.rmuShortNameValue('BaselineTEXT');
    	//pot.stringtoCurrency('1234567890');
    	pot.getMonthsList();
    	pot.getCurrentYear();
    	pot.getCurrentMonth();
    	pot.getLastYear();
    	pot.get3CharMonthName('1');
    	pot.getRegionValues();
    	/*
    	System.debug('*************************************************************************************');
    	
    	POTrackerPerMonthController ptpmc = new POTrackerPerMonthController();
    	ptpmc.pageHeaderDetails('EasyII_F900X', 'TOTALPM');
    	ptpmc.poRecTypeId = 'Easy II';
    	ptpmc.getRMUConfigValues();
    	ptpmc.getCurrentYearDataForAOPVsActual();
    	ptpmc.getCummulativeCurrentYearDataForAOPVsActual();
    	ptpmc.getCurrentYearDataForAPMCount();
    	
    	ptpmc.pageHeaderDetails('DU885', 'REV');
    	ptpmc.initPlatformPageDetails();
    	ptpmc.getCurrentYearDataForAOPVsActual_Platform();
    	ptpmc.getCummulativeCurrentYearDataForAOPVsActual_Platform();
    	    	
    	
    	ptpmc.pageHeaderDetails('EasyII_F900X', 'TOTALPM');
    	ptpmc.poRecTypeId = 'Easy II';
    	ptpmc.initRMUPageDetails();
    	ptpmc.getCurrentYearDataForAOPVsActual();
    	ptpmc.getCummulativeCurrentYearDataForAOPVsActual();
    	ptpmc.getCurrentYearDataForAPMCount();
    	
    	ptpmc.initPlatformPageDetails();
    	ptpmc.getCurrentYearDataForAOPVsActual_Platform();
    	ptpmc.getCummulativeCurrentYearDataForAOPVsActual_Platform();
    	
    	POTrackerScheduleChartController ptscc = new POTrackerScheduleChartController();
    	ptscc.pageHeaderDetails('EasyII_F900X', 'SCHLD');
    	ptscc.getRMUScheduleCount();
    	ptscc.getCurrentYearDataForScheduled();
    	ptscc.pageHeaderDetails('DU885', 'REV');
    	ptscc.getRMUScheduleCount();
    	ptscc.getCurrentYearDataForScheduled();
    	
    	POTrackerRevenueChartsController ptrcc = new POTrackerRevenueChartsController();
    	ptrcc.pageHeaderDetails('EasyII_F900X', 'REV');
    	ptrcc.getRMUYearlyRevenueBarDataCurrentYear();
    	ptrcc.getRevenueBarDataCurrentYearCertF();
    	ptrcc.getRMURevenueBarDataCurrentYearAmericas();
    	ptrcc.getRMURevenueBarDataCurrentYearEMEIA();
    	ptrcc.getRMURevenueBarDataCurrentYearAPAC();
    	
    	ptrcc.pageHeaderDetails('DU885', 'REV');
    	ptrcc.getRMUYearlyRevenueBarDataCurrentYear_pltfrm();
    	ptrcc.getRMURevenueBarDataCurrentYearAmericas_pltfrm();
    	ptrcc.getRMURevenueBarDataCurrentYearEMEIA_pltfrm();
    	ptrcc.getRMURevenueBarDataCurrentYearAPAC_pltfrm();
    	*/
    	//POTrackerRMUPlatformPieChartController ptrpcc = new POTrackerRMUPlatformPieChartController();
    	//ptrpcc.pageHeaderDetails('DU885', 'PIE');
    	//ptrpcc.getGlobalRMUCharts();
    	//ptrpcc.getRmuAmericasCharts();
    	//ptrpcc.getRmuEMEIACharts();
    	//ptrpcc.getRmuAPACCharts();
    	
    	//ptrpcc.pageHeaderDetails('DU885', 'PENETRATION');
    	
		//ptrpcc.getGlobalRMUCharts();
	    //	ptrpcc.getRmuAmericasCharts();
	    //	ptrpcc.getRmuEMEIACharts();
	    //	ptrpcc.getRmuAPACCharts();
    	
    	
    	POTrackerPieChartMaster ptpcm = new POTrackerPieChartMaster();
    	POTrackerPieChartMaster.testIt();
    	
    	
    	POTrackerRMUDetailPieChartController ptrccp = new POTrackerRMUDetailPieChartController();
    	
    	ptrccp.pageHeaderDetails('EasyII_F900X', 'PIE');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();
    	
    	ptrccp.pageHeaderDetails('EasyII_F900X', 'PENETRATION');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();
    	ptrccp.getPrintGlobalCount();
		ptrccp.getPrintAmericasCount();
		ptrccp.getPrintEMEIACount();
		ptrccp.getPrintAPACCount();
	
    	
    	ptrccp.pageHeaderDetails('Cert_F_G', 'PIE');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();    	
    	ptrccp.pageHeaderDetails('Cert_F_G', 'PENETRATION');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();       
    	
    	ptrccp.pageHeaderDetails('GIV_GV', 'PIE');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();   

    	ptrccp.pageHeaderDetails('G_650', 'PIE');
    	ptrccp.getRegionalEasy2Charts();
    	ptrccp.getGlobalEasy2Charts();   
    	
    	        	 	
    	
    }
    
}
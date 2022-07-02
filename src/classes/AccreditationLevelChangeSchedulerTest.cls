@isTest
public class AccreditationLevelChangeSchedulerTest {
	@istest
	public static void scheduleAccreditationChange(){
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(1,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account accountTest = TestDataFactory.createAccount(1)[0];
			accountTest.AccountNumber = '1234'; 
			accountTest.Market__c = 'Market India' ;
			accountTest.GEOLevel1Name__c = 'Region Asia-Pacific' ;
			accountTest.Partner_Program__c = 'GPP 0.0' ;
			accountTest.Shift_Model__c = '8X5' ;
			accountTest.Partner_Type__c = 'Distributor' ;
			insert accountTest;
			
			List<Accreditation__c> accredList = new List<Accreditation__c>();
			
			Accreditation__c accrMan = new Accreditation__c();
			accrMan.RecordTypeId = '01241000000v9mE';
			accrMan.Manual_Accreditation_Level_Update__c = true;
			accrMan.Evaluated_Accreditation__c = true;
			accrMan.Partner__c = accountTest.Id;
			accrMan.Accreditation_Date__c = System.today();	  
			accrMan.Accreditation_Type__c='Product';
			accrMan.Accreditation_Level__c = 'Advanced';
			accrMan.Shift_Model__c='8X5';
			accrMan.Portfolio__c='Airscale Wifi';
			
			Accreditation__c accrAuto = new Accreditation__c();
			accrAuto.RecordTypeId = '01241000000v9mE';
			accrAuto.Evaluated_Accreditation__c = true;
			accrAuto.Partner__c = accountTest.Id;
			accrAuto.Accreditation_Level__c = 'Advanced';
			accrAuto.Accreditation_Date__c = System.today();
			accrAuto.Accreditation_Type__c='Product';	 
			accrAuto.Manual_Accreditation_Level_Update__c = false;
	//  accrAuto.Shift_Model__c='16X5';
	accrAuto.Shift_Model__c='8X5';
			accrAuto.Portfolio__c='Airscale Wifi';
			accrAuto.Administration_Software_Only__c = 11.0;
			accrAuto.Partner_Relationship_Manager__c = 11.0;
			accrAuto.Technical_Support_Level_1__c = 11.0;
			accrAuto.Service_Desk_Clerk__c = 11.0;
			accrAuto.Administration_Software_Only__c = 11.0;
			accrAuto.Technical_Support_Level_2__c = 19.0;
			accrAuto.Partner_Marketing_Manager__c = 19.0; 
			accrAuto.Field_Technician__c = 19.0;
			accrAuto.Sales_Engineer__c = 19.0;
			accrAuto.Sales_Associate__c=19.0;
			
			Accreditation__c accrAuto2 = new Accreditation__c();
			accrAuto2.RecordTypeId = '01241000000v9mE';
			accrAuto2.Evaluated_Accreditation__c = true;
			accrAuto2.Partner__c = accountTest.Id;
			accrAuto2.Accreditation_Level__c = 'Expert';
			accrAuto2.Accreditation_Date__c = System.today();
			accrAuto2.Accreditation_Type__c='Product';	 
			accrAuto2.Manual_Accreditation_Level_Update__c = false;
			accrAuto2.Shift_Model__c='8X5';
			accrAuto2.Portfolio__c='Airscale Wifi';
			accrAuto2.Administration_Software_Only__c = 11.0;
			accrAuto2.Partner_Relationship_Manager__c = 11.0;
			accrAuto2.Technical_Support_Level_1__c = 11.0;
			accrAuto2.Service_Desk_Clerk__c = 11.0;
			accrAuto2.Administration_Software_Only__c = 11.0;
			accrAuto2.Technical_Support_Level_2__c = 11.0;
			accrAuto2.Partner_Marketing_Manager__c = 11.0; 
			accrAuto2.Field_Technician__c = 11.0;
			accrAuto2.Sales_Engineer__c = 11.0;
			accrAuto2.Sales_Associate__c=11.0;
			
			Accreditation__c accrAuto1 = new Accreditation__c();
			accrAuto1.RecordTypeId = '01241000000v9mE';
			accrAuto1.Evaluated_Accreditation__c = true;
			accrAuto1.Partner__c = accountTest.Id;
			accrAuto1.Accreditation_Level__c = 'Expert';
			accrAuto1.Accreditation_Date__c = System.today();
			accrAuto1.Accreditation_Type__c='Product';	 
			accrAuto1.Manual_Accreditation_Level_Update__c = false;
			accrAuto1.Shift_Model__c='8X5';
			accrAuto1.Portfolio__c='Airscale Wifi';
			accrAuto1.Administration_Software_Only__c = 10;
			
			Accreditation__c accrAuto3 = new Accreditation__c();
			accrAuto3.RecordTypeId = '01241000000v9mE';
			accrAuto3.Evaluated_Accreditation__c = true;
			accrAuto3.Partner__c = accountTest.Id;
			accrAuto3.Accreditation_Level__c = 'Authorized';
			accrAuto3.Accreditation_Date__c = System.today();
			accrAuto3.Accreditation_Type__c='Product';	 
			accrAuto3.Manual_Accreditation_Level_Update__c = false;
			accrAuto3.Shift_Model__c='8X5';
			accrAuto3.Portfolio__c='Airscale Wifi';
			accrAuto3.Administration_Software_Only__c = 11.0;
			accrAuto3.Partner_Relationship_Manager__c = 11.0;
			accrAuto3.Technical_Support_Level_1__c = 11.0;
			accrAuto3.Service_Desk_Clerk__c = 11.0;
			accrAuto3.Administration_Software_Only__c = 11.0;
			accrAuto3.Technical_Support_Level_2__c = 11.0;
			accrAuto3.Partner_Marketing_Manager__c = 11.0; 
			accrAuto3.Field_Technician__c = 11.0;
			accrAuto3.Sales_Engineer__c = 11.0;
			accrAuto3.Sales_Associate__c=11.0;
			
			accredList.add(accrMan);
			accredList.add(accrAuto);
			accredList.add(accrAuto1);
			accredList.add(accrAuto2);
			accredList.add(accrAuto3);
			insert accredList;  
			Accreditation__c accredAuto = [Select Id, Market__c, Geo_Level_1_Name__c, Accreditation_Type__c, Shift_Model__c, Portfolio__c, Partner_Program__c, Partner_Type__c,Administration_Software_Only__c,Partner_Relationship_Manager__c,Technical_Support_Level_1__c,Service_Desk_Clerk__c,Technical_Support_Level_2__c,Partner_Marketing_Manager__c from Accreditation__c where Id =: accrAuto.Id];

			List<Accreditation_Level_Rule__c> accrLevelRule = new List<Accreditation_Level_Rule__c>();
			Accreditation_Level_Rule__c accredRule1 = new Accreditation_Level_Rule__c();
			accredRule1.Market__c = accredAuto.Market__c;
			accredRule1.Geo_Level_1_Name__c = accredAuto.Geo_Level_1_Name__c;
			accredRule1.Accreditation_Type__c = accredAuto.Accreditation_Type__c;
			accredRule1.Partner_Program__c = accredAuto.Partner_Program__c;
			accredRule1.Partner_Type__c = accredAuto.Partner_Type__c;
			accredRule1.Shift_Model__c = accredAuto.Shift_Model__c;
			accredRule1.Portfolio__c = accredAuto.Portfolio__c;
			accredRule1.Accreditation_Level__c = 'Expert';
	
			accredRule1.Administration_Software_Only__c = 10.0;
			accredRule1.Partner_Relationship_Manager__c = 10.0;
			accredRule1.Technical_Support_Level_1__c = 10.0;
			accredRule1.Service_Desk_Clerk__c = 10.0;
			accredRule1.Administration_Software_Only__c = 10.0;
			accredRule1.Technical_Support_Level_2__c = 10.0;
			accredRule1.Partner_Marketing_Manager__c = 10.0; 
			accredRule1.Field_Technician__c = 10.0;
			accredRule1.Sales_Engineer__c = 10.0;
			accredRule1.Sales_Associate__c = 10.0;
			accrLevelRule.add(accredRule1);
			insert accrLevelRule;
			
			accredRule1.Accreditation_Level__c = 'Advanced';
			update accrLevelRule;
			
			List<PRM_Accreditation_Level_Ranks__c> accRanks = new List<PRM_Accreditation_Level_Ranks__c>();
			PRM_Accreditation_Level_Ranks__c expert = new PRM_Accreditation_Level_Ranks__c();
			expert.Name = 'Expert';
			expert.Rank__c = 1;
			accRanks.add(expert);
			
			PRM_Accreditation_Level_Ranks__c advanced = new PRM_Accreditation_Level_Ranks__c();
			advanced.Name = 'Advanced';
			advanced.Rank__c = 3;
			accRanks.add(advanced);
			
			PRM_Accreditation_Level_Ranks__c authorized = new PRM_Accreditation_Level_Ranks__c();
			authorized.Name = 'Authorized';
			authorized.Rank__c = 4;
			accRanks.add(authorized);
			insert accRanks;
			
			List<PRM_CertificationToAccreditation_Mapping__c> certToAccred = new List<PRM_CertificationToAccreditation_Mapping__c>();
			PRM_CertificationToAccreditation_Mapping__c map1 = new PRM_CertificationToAccreditation_Mapping__c();
			map1.Name = 'Sales Associate';
			map1.Accreditation_Field_API_Name__c = 'Sales_Associate__c';
			certToAccred.add(map1);
			
			PRM_CertificationToAccreditation_Mapping__c map2 = new PRM_CertificationToAccreditation_Mapping__c();
			map2.Name = 'Service Desk Clerk';
			map2.Accreditation_Field_API_Name__c = 'Service_Desk_Clerk__c';
			certToAccred.add(map2);
			
			PRM_CertificationToAccreditation_Mapping__c map3 = new PRM_CertificationToAccreditation_Mapping__c();
			map3.Name = 'Technical Support Level 2';
			map3.Accreditation_Field_API_Name__c = 'Technical_Support_Level_2__c';
			certToAccred.add(map3);
			
			PRM_CertificationToAccreditation_Mapping__c map4 = new PRM_CertificationToAccreditation_Mapping__c();
			map4.Name = 'Partner Relationship Manager';
			map4.Accreditation_Field_API_Name__c = 'Partner_Relationship_Manager__c';
			certToAccred.add(map4);
			
			PRM_CertificationToAccreditation_Mapping__c map5 = new PRM_CertificationToAccreditation_Mapping__c();
			map5.Name = 'Field Technician';
			map5.Accreditation_Field_API_Name__c = 'Field_Technician__c';
			certToAccred.add(map5);
			
			PRM_CertificationToAccreditation_Mapping__c map6 = new PRM_CertificationToAccreditation_Mapping__c();
			map6.Name = 'Sales Engineer';
			map6.Accreditation_Field_API_Name__c = 'Sales_Engineer__c';
			certToAccred.add(map6);
			
			PRM_CertificationToAccreditation_Mapping__c map7 = new PRM_CertificationToAccreditation_Mapping__c();
			map7.Name = 'Network Integration Engineer';
			map7.Accreditation_Field_API_Name__c = 'Network_Integration_Engineer__c';
			certToAccred.add(map7);
			
			PRM_CertificationToAccreditation_Mapping__c map8 = new PRM_CertificationToAccreditation_Mapping__c();
			map8.Name = 'Partner Marketing Manager';
			map8.Accreditation_Field_API_Name__c = 'Partner_Marketing_Manager__c';
			certToAccred.add(map8);
			
			PRM_CertificationToAccreditation_Mapping__c map9 = new PRM_CertificationToAccreditation_Mapping__c();
			map9.Name = 'Technical Support Level 1';
			map9.Accreditation_Field_API_Name__c = 'Technical_Support_Level_1__c';
			certToAccred.add(map9);
			
			PRM_CertificationToAccreditation_Mapping__c map10 = new PRM_CertificationToAccreditation_Mapping__c();
			map10.Name = 'Administration Software Only';
			map10.Accreditation_Field_API_Name__c = 'Administration_Software_Only__c';
			certToAccred.add(map10);
			insert certToAccred;
	
			List<PRM_Accreditation_Level_Ranks__c> accrLevelRulesetting = new List<PRM_Accreditation_Level_Ranks__c>();
			PRM_Accreditation_Level_Ranks__c accredlevelRule1 = new PRM_Accreditation_Level_Ranks__c();
			accredlevelRule1.Name = 'Authorized';
			accredlevelRule1.Rank__c = 2;
			insert accrLevelRulesetting;
			
			List<Apttus_Proposal__Proposal__c> apptusproposal = new List<Apttus_Proposal__Proposal__c>();
			Apttus_Proposal__Proposal__c apttus1 = new Apttus_Proposal__Proposal__c();
			apttus1.Apttus_Proposal__Proposal_Name__c = 'Test';
			apttus1.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
			apttus1.NokiaCPQ_No_of_Years__c = '1';
			apttus1.Apttus_Proposal__Account__c = accountTest.Id;
			insert apptusproposal;
			
			AccreditationLevelChange.setAccrdRuleLevelRank(accrLevelRule);
			AccreditationLevelChange.quoteRepricing(accredList);
			AccreditationLevelChangeScheduler sc = new AccreditationLevelChangeScheduler();
			String schdl = '0 0 21 ? * *';
			String jobID = System.schedule('Test Schedule',schdl,sc);
			System.debug('JobID'+jobID);
			System.debug('Test Class Ends');
			Test.stopTest();
		}
	}
}
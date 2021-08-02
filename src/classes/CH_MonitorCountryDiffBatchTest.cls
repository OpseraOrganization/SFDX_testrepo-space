/****************************************
* Class Name : CH_MonitorCountryDiffBatchTest 
* Created Date: 18 February 2020
* Created By : Sónia Reis
* Last Modified by: Sónia Reis
* Last Modified Date: 23 April 2020
* Description : Test class for CH_MonitorCountryDiffBatch
************/
@isTest
public class CH_MonitorCountryDiffBatchTest {
	
	@testSetup 
	public static void setup(){
  
			ISO_Country_Codes__c code = new ISO_Country_Codes__c();
			code.country_name__c = 'United States of Americassss';
			code.name='US';
			insert code;
			
			CollaborationGroup chatterGroup = new CollaborationGroup();
			chatterGroup.name = 'Error - Country Alignment Issues2';
			chatterGroup.CollaborationType='Private';
			insert chatterGroup;
	}
	
	@isTest
	public static void testBatch(){
		Id batchJobId = Database.executeBatch(new CH_MonitorCountryDiffBatch('Error - Country Alignment Issues2', 'x@nokia.com'),1000);
		system.assert(batchJobId!=null);
	}
	
	@isTest
	public static void testBatch1(){
		Id batchJobId = Database.executeBatch(new CH_MonitorCountryDiffBatch('Error - Country Alignment Issues3', 'x@nokia.com'),1000);
		system.assert(batchJobId!=null);
	}


}
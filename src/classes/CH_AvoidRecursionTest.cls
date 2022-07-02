/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*
* Unit tests are class methods that verify whether a particular piece
* of code is working properly. Unit test methods take no arguments,
* commit no data to the database, and are flagged with the testMethod
* keyword in the method definition.
*
* All test methods in an organization are executed whenever Apex code is deployed
* to a production organization to confirm correctness, ensure code
* coverage, and prevent regressions. All Apex classes are
* required to have at least 75% code coverage in order to be deployed
* 
* to a production organization. In addition, all triggers must have some code coverage.
* 
* The @isTest class annotation indicates this class only contains test
* methods. Classes defined with the @isTest annotation do not count against
* the organization size limit for all Apex scripts.
*
* See the Apex Language Reference for more information about Testing and Code Coverage.
*/
@isTest
public class CH_AvoidRecursionTest {
	private static testMethod void test() {
		CH_AvoidRecursion.runAfterInsertOnce();
		CH_AvoidRecursion.runAfterUpdateOnce();
		CH_AvoidRecursion.runBeforeInsertOnce();
		CH_AvoidRecursion.runBeforeUpdateOnce();
		CH_AvoidRecursion.runOnce();
		try{
			CH_AvoidRecursion.afterInsert = false;
			CH_AvoidRecursion.runAfterInsertOnce();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			
		}
		
		try{
			CH_AvoidRecursion.afterUpdate = false;
			CH_AvoidRecursion.runAfterUpdateOnce();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			
		}
		
		try{
			CH_AvoidRecursion.beforeInsert = false;
			CH_AvoidRecursion.runBeforeInsertOnce();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			
		}
		
		try{
			CH_AvoidRecursion.beforeUpdate = false;
			CH_AvoidRecursion.runBeforeUpdateOnce();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			
		}
				try{
			CH_AvoidRecursion.run = false;
			CH_AvoidRecursion.runOnce();
			
		}catch(exception e){
			System.debug('The following exception has occurred: ' + e.getMessage());
			
		}
		
		
	}
	
	
}
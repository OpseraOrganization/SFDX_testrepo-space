/***************************************************************** 
Description:Unit test to check scrambling for the entered text fields on case.													   
 
History																														 
DATE		 AUTHOR			   Change 
20/08/2018   Praveenkumar		 Created 
*****************************************************************/

@isTest()
public class CH_CasePersonalInfocheckTest {
	
	static testMethod void ScramblingCheckmethod(){
		list<case> caselst = new list<case>();
		Test.StartTest();
		case caserec=new case();
		Id caseRecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Problem').getRecordTypeId();
		caserec.RecordTypeId = caseRecordtypeid;
		caserec.Allow_admin_login__c=true;
		caserec.Status='Created';
		caserec.Severity__c='major';
		caserec.Subject= 'MySubject 36::83:563::::527';
		caserec.Description= 'Mydesct 36::83:563::::527 68:408:::8:2:28:651.096.953.858';
		caserec.CH_IssueDescription__c='483.937.912.050'; 
		caserec.CH_Outage__c = 'No';
		caserec.Country__c ='India';
		caserec.CH_InitialDiagnosis__c = 'testt';
		caselst.add(caserec);
		Insert caselst;
		Test.StopTest();
		//System.assertEquals('xxx.xxx.xxx.xxx',[select CH_IssueDescription__c from case where id=:caserec.Id].CH_IssueDescription__c); Ips are not scrambled anymore
		
	}
}